-- ============================================================================
-- SECTION A: ORGANIZATION & USER MANAGEMENT
-- ============================================================================

CREATE TABLE public.users (
  user_id    UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  name       VARCHAR(255) NOT NULL,
  email      VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMPTZ    NOT NULL DEFAULT NOW(),

  CONSTRAINT email_format CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE TABLE orgs.organizations (
  org_id     UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  org_name   VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ    NOT NULL DEFAULT NOW(),

  CONSTRAINT org_name_not_empty CHECK (org_name != '')
);

CREATE TABLE orgs.user_org_memberships (
  user_id   UUID      NOT NULL REFERENCES public.users(user_id)          ON DELETE CASCADE,
  org_id    UUID      NOT NULL REFERENCES orgs.organizations(org_id)     ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),

  PRIMARY KEY (user_id, org_id)
);

CREATE INDEX idx_user_org_memberships_org_id  ON orgs.user_org_memberships(org_id);
CREATE INDEX idx_user_org_memberships_user_id ON orgs.user_org_memberships(user_id);
