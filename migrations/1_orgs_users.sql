-- ============================================================================
-- SECTION A: ORGANIZATION & USER MANAGEMENT
-- ============================================================================

CREATE TABLE organizations (
  org_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  metadata JSONB DEFAULT '{}'::jsonb,

  CONSTRAINT org_name_not_empty CHECK (org_name != '')
);

CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),

  CONSTRAINT email_format CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

CREATE TABLE user_org_memberships (
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  org_id UUID NOT NULL REFERENCES organizations(org_id) ON DELETE CASCADE,
  joined_at TIMESTAMP DEFAULT NOW(),

  PRIMARY KEY (user_id, org_id)
);

CREATE INDEX idx_user_org_memberships_org_id ON user_org_memberships(org_id);
CREATE INDEX idx_user_org_memberships_user_id ON user_org_memberships(user_id);