CREATE OR REPLACE FUNCTION public.org_roles(org_id UUID)
RETURNS TABLE(id uuid, name varchar)
LANGUAGE sql AS $$
    SELECT
        r.id,
        r.role_name
    FROM
        organizations.roles r
    WHERE
        r.org_id = org_id
$$;
