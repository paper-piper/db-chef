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
./migrate.sh
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
PGHOST=my-server PGPORT=5432 PGDATABASE=mydb ./migrate.sh
```

The script runs every `.sql` file in `migrations/` in version order (using `sort -V`), stopping immediately on any error.

---

## Migration files

Files are named `<major>.<minor>.<patch>_<description>.sql`. The major version groups related migrations:

| File | What it creates |
|------|----------------|
| `0.0.0_drops.sql` | Drops all tables for a clean slate |
| `1.0.0_orgs_users.sql` | Organizations, users, memberships |
| `1.1.0_roles_access.sql` | Access policies, roles, role↔policy and user↔role assignments |
| `2.0.0_datasets.sql` | Datasets, versions, data points |
| `2.1.0_data_point_payload_validation.sql` | Payload schema validation trigger on dataset_data_points |
| `2.2.0_experiments.sql` | Experiments, dataset refs, parameters |
| `2.3.0_ref_order_trigger.sql` | Ref-order auto-normalization trigger on experiment_data_ver_refs |
| `3.0.0_compute_clusters.sql` | Compute clusters |
| `3.1.0_runs.sql` | Runs, logs, output artifacts |
| `4.0.0_audit_log.sql` | Tamper-evident audit log table |
| `4.1.0_audit_triggers.sql` | Audit triggers + append-only guards |
| `5.x.0_v_*.sql` | Analytical views |
| `6.0.0_seed_data.sql` | Sample data for development |

New migrations slot in naturally — e.g. `2.4.0_dataset_tags.sql` extends datasets, `3.1.1_runs_fix.sql` patches runs.

---

## Schema overview

### Orgs & Users (`1.0.x`)
Users and organizations are independent entities joined through `user_org_memberships`. A user can belong to multiple orgs.

### Roles & Access Control (`1.1.x`)
Three-layer permission model:

```
access_policies  →  atomic permissions (dataset:read, experiment:run, …)
      ↑
role_policy_assignments
      ↑
    roles        →  org-scoped (Admin, Experiment Runner, Dataset Editor, Analyst)
      ↑
user_role_assignments
      ↑
    users        →  can hold multiple roles per org
```

Available policies:

| Policy | Description |
|--------|-------------|
| `dataset:read` | View datasets and their contents |
| `dataset:write` | Create and edit datasets and versions |
| `dataset:delete` | Delete dataset versions |
| `experiment:read` | View experiments and their results |
| `experiment:run` | Create and execute experiment runs |
| `analytics:view` | View analytics, reports, and audit logs |
| `user:manage` | Manage org members and role assignments |

### Datasets (`2.0.x`)
Datasets are org-scoped and versioned. Each version can reference a parent version, forming a lineage chain queryable via `v_dataset_lineage`. Data points are append-only once inserted.

### Experiments (`2.1.x`)
Experiments belong to an org and can reference multiple dataset versions. Parameters are typed (`int`, `float`, `string`, `boolean`, `json`).

### Compute Clusters (`3.0.x`)
Global pool of clusters with hardware specs and an `is_active` flag.

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
| `v_dataset_lineage` | Recursive parent chain for every dataset version |
| `v_dataset_versions_matrix` | All versions with their full lineage as text |
| `v_datasets_with_versions` | Datasets LEFT JOINed with their versions |
| `v_experiment_dataset_usage` | Which dataset versions each experiment references |
| `v_run_environment` | Runs with full cluster specs and execution timing |

```sql
SELECT * FROM v_run_environment;
SELECT * FROM v_dataset_lineage;
```

---

## Seed data

`6.0.0_seed_data.sql` is included in the normal migration run and loads a realistic development dataset across three orgs (Acme Research, Bright Labs, Quantum Analytics).

Interesting cases covered:

- Users belonging to multiple orgs (Bob, Carol, Eve)
- Users holding multiple roles in the same org (Alice, Dave)
- Same role held at different privilege levels across orgs (Carol: Dataset Editor at Bright, Admin at Quantum)
- Roles sharing policies across orgs
- 3-level deep dataset version lineage (`customer-churn-signals` v1 → v2 → v3)
- Multi-dataset experiments (up to 3 dataset versions per experiment)
- Full spread of run statuses: `succeeded`, `failed`, `cancelled`, `running`, `queued`

---

## Sample queries

See [`queries.sql`](queries.sql) for starter queries. Quick examples:

```sql
-- Every user, their orgs, and their roles
SELECT u.name, o.org_name, r.role_name
FROM users u
JOIN user_org_memberships uom ON u.user_id = uom.user_id
JOIN organizations o          ON uom.org_id = o.org_id
LEFT JOIN user_role_assignments ura ON u.user_id = ura.user_id AND ura.org_id = o.org_id
LEFT JOIN roles r                   ON ura.role_id = r.role_id
ORDER BY u.name, o.org_name;

-- Who created each experiment
SELECT e.experiment_name, o.org_name, u.name AS created_by
FROM experiments e
JOIN organizations o ON e.org_id = o.org_id
LEFT JOIN users u    ON e.created_by = u.user_id;
```
