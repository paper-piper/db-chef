-- 1. For each user: which orgs they belong to and what roles they have
SELECT
  u.name,
  u.email,
  o.org_name,
  r.role_name
FROM users u
JOIN user_org_memberships uom ON u.user_id = uom.user_id
JOIN organizations o          ON uom.org_id = o.org_id
LEFT JOIN user_role_assignments ura ON u.user_id = ura.user_id AND ura.org_id = o.org_id
LEFT JOIN roles r                   ON ura.role_id = r.role_id
ORDER BY u.name, o.org_name;


-- 2. For each experiment: who created it
SELECT
  e.experiment_name,
  o.org_name,
  u.name  AS created_by,
  u.email AS created_by_email,
  e.created_at
FROM experiments e
JOIN organizations o ON e.org_id = o.org_id
LEFT JOIN users u    ON e.created_by = u.user_id
ORDER BY e.created_at;
