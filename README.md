# DB Chef

PostgreSQL schema for an ML experiment tracking platform. Covers organizations, users, access control, datasets with versioning, experiments, compute clusters, run execution, and a tamper-evident audit log.

---

## Requirements

- macOS (tested on macOS 10.15+)
- PostgreSQL client (`psql`) installed — easiest via [Homebrew](https://brew.sh):
  ```bash
  brew install libpq
  echo 'export PATH="/opt/homebrew/opt/libpq/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc
  ```
- A running PostgreSQL server (local or remote)

---

## Running migrations

```bash
./db.sh
```

By default connects to:

| Variable     | Default       |
|--------------|---------------|
| `PGHOST`     | `127.0.0.1`   |
| `PGPORT`     | `6000`        |
| `PGDATABASE` | `unv`         |
| `PGUSER`     | `postgres`    |

Override any of them inline:

```bash
PGHOST=my-server PGPORT=5432 PGDATABASE=mydb ./db.sh
```

The script runs every `.sql` file in `migrations/` in version order (using `sort -V`), stopping immediately on any error.

---

## Migration files

Files are named `<major>.<minor>.<patch>_<description>.sql`. The major version groups related migrations:

| File | What it creates |
|------|----------------|
| `0.0.0_drops.sql` | Dynamically drops all non-system schemas + recreates `public` for a clean slate |
| `0.1.0_schemas.sql` | Creates the `orgs`, `ds`, `exp`, `run` schemas |
| `1.0.0_orgs_users.sql` | Organizations, users, memberships |
| `1.1.0_roles_access.sql` | Org-scoped roles and user↔role assignments |
| `2.0.0_datasets.sql` | Datasets, versions, data points |
| `2.1.0_data_point_payload_validation.sql` | Payload schema validation trigger on `dataset_data_points` |
| `2.2.0_experiments.sql` | Experiments, dataset version refs, parameters |
| `2.3.0_ref_order_trigger.sql` | Ref-order auto-normalization trigger on `experiment_data_ver_refs` |
| `3.0.0_compute_clusters.sql` | Compute clusters |
| `3.1.0_runs.sql` | Runs, logs, output artifacts |
| `4.0.0_audit_log.sql` | Tamper-evident audit log table |
| `4.1.0_audit_triggers.sql` | Audit triggers + append-only guards |
| `5.1.0_v_experiment_dataset_usage.sql` | View: dataset versions used per experiment |
| `5.2.0_v_run_environment.sql` | View: runs with cluster specs and timing |
| `5.3.0_v_version_ancestry_pivot.sql` | Dynamic pivot view: version ancestry arrays |
| `5.4.0_v_dataset_version_ids.sql` | Dynamic pivot view: version IDs per dataset |
| `6.0.0_seed_data.sql` | Sample data for development |

New migrations slot in naturally — e.g. `2.4.0_dataset_tags.sql` extends datasets, `3.1.1_runs_fix.sql` patches runs.

---

## Schema overview

### Orgs & Users (`1.0.x`)
Users and organizations are independent entities joined through `user_org_memberships`. A user can belong to multiple orgs.

### Roles & Access Control (`1.1.x`)
Roles are org-scoped. A user can hold multiple roles within an org, and different roles across orgs.

```
roles  (org-scoped)
  ↑
user_role_assignments
  ↑
users  (can hold multiple roles per org)
```

> Note: org/role consistency (role must belong to the same org as the assignment) is not yet enforced by a trigger — seed data is consistent by construction.

### Datasets (`2.0.x`)
Datasets are org-scoped and identified by `dataset_key`. Each dataset has one or more versions; versions can reference a parent version, forming a lineage chain. Data points are append-only once inserted and validated against the version's `schema_definition` on every insert.

### Experiments (`2.2.x`)
Experiments belong to an org and reference one or more dataset versions (ordered by `ref_order`). Parameters are typed (`int`, `float`, `string`, `boolean`, `json`).

### Compute Clusters (`3.0.x`)
Global pool of clusters with hardware specs (`cpu_cores`, `ram_gb`, `disk_tb`, `network_bandwidth_mbps`) and an `is_active` flag.

### Runs (`3.1.x`)
A run links an experiment to a cluster. Lifecycle: `queued → running → succeeded | failed | cancelled`. Logs are append-only. Each run can produce one output artifact (JSONB payload).

### Audit Log (`4.0.x`)
All writes to `datasets`, `dataset_versions`, `experiments`, `runs`, and `user_role_assignments` are automatically recorded by triggers. The audit log itself is insert-only — rows cannot be updated or deleted.

The application layer identifies the acting user by setting a session variable before each statement:
```sql
SET LOCAL app.current_user_id = '<uuid>';
```

---

## Views

| View | Description |
|------|-------------|
| `v_experiment_dataset_usage` | Which dataset versions each experiment references |
| `v_run_environment` | Runs with full cluster specs and execution timing |
| `v_version_ancestry_pivot` | Dynamic: one column per version ID, value is an array of all ancestor version IDs (oldest first) |
| `v_dataset_version_ids` | Dynamic: one column per dataset ID, rows are version IDs ordered by version number (`-` where no version exists) |

The two dynamic views (`v_version_ancestry_pivot`, `v_dataset_version_ids`) are automatically rebuilt by statement-level triggers whenever `ds.dataset_versions` or `ds.datasets` change.

```sql
SELECT * FROM v_experiment_dataset_usage;
SELECT * FROM v_run_environment;
SELECT * FROM v_version_ancestry_pivot;
SELECT * FROM v_dataset_version_ids;
```

---

## Seed data

`6.0.0_seed_data.sql` is included in the normal migration run and loads a realistic development dataset across three orgs (Acme Research, Bright Labs, Quantum Analytics).

Interesting cases covered:

- Users belonging to multiple orgs (Bob, Carol, Eve)
- Users holding multiple roles in the same org (Alice, Dave)
- Same user with different roles across orgs (Carol: Data Steward at Bright, Admin at Quantum)
- 3-level deep dataset version lineage (`customer-churn-signals` v1 → v2 → v3)
- Multi-dataset experiments (exp 2: 2 datasets, exp 3: 3 datasets, exp 5: 2 datasets)
- Full spread of run statuses: `succeeded`, `failed`, `cancelled`, `running`, `queued`

---

## Sample queries

```sql
-- Every user, their orgs, and their roles
SELECT u.name, o.org_name, r.role_name
FROM public.users u
JOIN orgs.user_org_memberships uom ON u.user_id = uom.user_id
JOIN orgs.organizations o          ON uom.org_id = o.org_id
LEFT JOIN orgs.user_role_assignments ura ON u.user_id = ura.user_id AND ura.org_id = o.org_id
LEFT JOIN orgs.roles r                   ON ura.role_id = r.role_id
ORDER BY u.name, o.org_name;

-- Who created each experiment
SELECT e.experiment_name, o.org_name, u.name AS created_by
FROM exp.experiments e
JOIN orgs.organizations o ON e.org_id = o.org_id
LEFT JOIN public.users u  ON e.created_by = u.user_id;

-- All runs with cluster info and timing
SELECT * FROM v_run_environment;

-- Dataset versions used by each experiment
SELECT * FROM v_experiment_dataset_usage;
```
