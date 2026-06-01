--CREATE THE ROLES IF THEY DONT EXIST
DO
$$
	DECLARE
		role_name text;
	BEGIN
	
		FOR role_name IN 
        WITH REQUIRED_ROLES AS (
          SELECT *
          FROM (
            VALUES
              ('mapaadmin'),
              ('users'),
              ('publicator'),
              ('pilots'),
              ('mivdak'),
              ('keshev'),
              ('hn'),
              ('dapar'),
              ('admins'),
              ('examinees')
          ) AS t(required_role)
        ),
        EXISTING_NON_SYS_ROLES AS (
          SELECT rolname
          FROM pg_roles
          WHERE 
          (
            rolname !~ '^pg_'
            AND
            rolname <> 'postgres'
          )
        )
        
        SELECT required_role
            FROM required_roles
              WHERE required_role NOT IN (SELECT * FROM EXISTING_NON_SYS_ROLES)
      
      LOOP
        EXECUTE format('CREATE ROLE %I WITH
        LOGIN
        NOSUPERUSER
        INHERIT
        NOCREATEDB
        NOCREATEROLE
        NOREPLICATION
        NOBYPASSRLS;', role_name);
        RAISE NOTICE 'Created role: %', role_name;
      END LOOP;
	END;
$$;