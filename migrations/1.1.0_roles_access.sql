-- ============================================================================
-- SECTION B: ROLES & ACCESS CONTROL
-- ============================================================================

CREATE TABLE access_policies (
  policy_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  policy_name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT NOW(),

  CONSTRAINT policy_name_not_empty CHECK (policy_name != '')
);
-- TODO: should't those policies be roles? policies should be more specific than 'full administrative access'.
INSERT INTO access_policies (policy_name, description) VALUES
  ('dataset_editor', 'Can create, edit, and manage datasets'),
  ('experiment_runner', 'Can create and run experiments'),
  ('admin', 'Full administrative access to organization'),
  ('analytics_team', 'Can view analytics and reports');

CREATE TABLE roles (
  role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(org_id) ON DELETE CASCADE,
  role_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),

  UNIQUE (org_id, role_name),
  CONSTRAINT role_name_not_empty CHECK (role_name != '')
);

CREATE INDEX idx_roles_org_id ON roles(org_id);

CREATE TABLE role_policy_assignments (
  role_id UUID NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
  policy_id UUID NOT NULL REFERENCES access_policies(policy_id) ON DELETE RESTRICT,

  PRIMARY KEY (role_id, policy_id)
);

CREATE INDEX idx_role_policy_assignments_role_id ON role_policy_assignments(role_id);

CREATE TABLE user_role_assignments (
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  role_id UUID NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
  org_id UUID NOT NULL REFERENCES organizations(org_id) ON DELETE CASCADE,
  assigned_at TIMESTAMP DEFAULT NOW(),

  -- org/role consistency is enforced via trigger, not a CHECK constraint
  PRIMARY KEY (user_id, role_id, org_id)
);

CREATE INDEX idx_user_role_assignments_user_id ON user_role_assignments(user_id);
CREATE INDEX idx_user_role_assignments_role_id ON user_role_assignments(role_id);
CREATE INDEX idx_user_role_assignments_org_id ON user_role_assignments(org_id);
