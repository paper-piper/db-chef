CREATE TABLE organizations.roles (
  id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id     UUID         NOT NULL REFERENCES organizations.organizations(id) ON DELETE CASCADE,
  role_name  VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

  UNIQUE (org_id, role_name),
  CONSTRAINT role_name_not_empty CHECK (role_name != '')
);

CREATE INDEX idx_roles_org_id ON organizations.roles(org_id);

CREATE TABLE organizations.user_role_assignments (
  user_id     UUID        NOT NULL REFERENCES public.users(id)               ON DELETE CASCADE,
  role_id     UUID        NOT NULL REFERENCES organizations.roles(id)        ON DELETE CASCADE,
  org_id      UUID        NOT NULL REFERENCES organizations.organizations(id) ON DELETE CASCADE,
  assigned_at TIMESTAMPTZ DEFAULT NOW(),

  -- org/role consistency is enforced via trigger, not a CHECK constraint
  PRIMARY KEY (user_id, role_id, org_id)
);

CREATE INDEX idx_user_role_assignments_user_id ON organizations.user_role_assignments(user_id);
CREATE INDEX idx_user_role_assignments_role_id ON organizations.user_role_assignments(role_id);
CREATE INDEX idx_user_role_assignments_org_id  ON organizations.user_role_assignments(org_id);
