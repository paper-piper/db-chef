CREATE OR REPLACE FUNCTION examinees.has_time_extension(p_user_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
AS $$

    SELECT COALESCE(
        (
            SELECT ll_time_extension = 'ALL'
            FROM examinees.examinees_ll_metadata
            WHERE user_id = p_user_id
        ),
        false --no nulls exist there but its better safe than sorry xoxoxo
    );
$$;