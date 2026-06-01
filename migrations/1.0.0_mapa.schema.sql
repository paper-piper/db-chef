--
-- PostgreSQL database dump
--


-- Dumped from database version 18.3 (Debian 18.3-1.pgdg13+1)
-- Dumped by pg_dump version 18.3 (Debian 18.3-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: dapar; Type: SCHEMA; Schema: -; Owner: mapaadmin
--

CREATE SCHEMA dapar;


ALTER SCHEMA dapar OWNER TO mapaadmin;

--
-- Name: examinees; Type: SCHEMA; Schema: -; Owner: mapaadmin
--

CREATE SCHEMA examinees;


ALTER SCHEMA examinees OWNER TO mapaadmin;

--
-- Name: hn; Type: SCHEMA; Schema: -; Owner: mapaadmin
--

CREATE SCHEMA hn;


ALTER SCHEMA hn OWNER TO mapaadmin;

--
-- Name: keshev; Type: SCHEMA; Schema: -; Owner: mapaadmin
--

CREATE SCHEMA keshev;


ALTER SCHEMA keshev OWNER TO mapaadmin;

--
-- Name: mivdak; Type: SCHEMA; Schema: -; Owner: mapaadmin
--

CREATE SCHEMA mivdak;


ALTER SCHEMA mivdak OWNER TO mapaadmin;

--
-- Name: pilots; Type: SCHEMA; Schema: -; Owner: mapaadmin
--

CREATE SCHEMA pilots;


ALTER SCHEMA pilots OWNER TO mapaadmin;

--
-- Name: users; Type: SCHEMA; Schema: -; Owner: mapaadmin
--

CREATE SCHEMA users;


ALTER SCHEMA users OWNER TO mapaadmin;

--
-- Name: SCHEMA users; Type: COMMENT; Schema: -; Owner: mapaadmin
--

COMMENT ON SCHEMA users IS 'all da usrs :)';


--
-- Name: chapter_types; Type: TYPE; Schema: dapar; Owner: mapaadmin
--

CREATE TYPE dapar.chapter_types AS ENUM (
    'AGAS',
    'ANAM',
    'ANAZ',
    'CHAK',
    'HETZ'
);


ALTER TYPE dapar.chapter_types OWNER TO mapaadmin;

--
-- Name: diagnosis_approval; Type: TYPE; Schema: examinees; Owner: mapaadmin
--

CREATE TYPE examinees.diagnosis_approval AS ENUM (
    'none',
    'fullTaz',
    'fullTazAndInterrogation'
);


ALTER TYPE examinees.diagnosis_approval OWNER TO mapaadmin;

--
-- Name: hn; Type: TYPE; Schema: examinees; Owner: mapaadmin
--

CREATE TYPE examinees.hn AS ENUM (
    'NONE',
    'OLIM',
    'YELIDIM'
);


ALTER TYPE examinees.hn OWNER TO mapaadmin;

--
-- Name: login_object; Type: TYPE; Schema: examinees; Owner: mapaadmin
--

CREATE TYPE examinees.login_object AS (
	user_id text,
	name text,
	taz text,
	language text
);


ALTER TYPE examinees.login_object OWNER TO mapaadmin;

--
-- Name: time_extentions; Type: TYPE; Schema: examinees; Owner: mapaadmin
--

CREATE TYPE examinees.time_extentions AS ENUM (
    'ALL',
    'NONE'
);


ALTER TYPE examinees.time_extentions OWNER TO mapaadmin;

--
-- Name: unique_paths; Type: TYPE; Schema: examinees; Owner: mapaadmin
--

CREATE TYPE examinees.unique_paths AS ENUM (
    'VERBAL',
    'NONE',
    'MATH'
);


ALTER TYPE examinees.unique_paths OWNER TO mapaadmin;

--
-- Name: zimun location; Type: DOMAIN; Schema: examinees; Owner: mapaadmin
--

CREATE DOMAIN examinees."zimun location" AS character(36);


ALTER DOMAIN examinees."zimun location" OWNER TO mapaadmin;

--
-- Name: chapter_types; Type: TYPE; Schema: hn; Owner: postgres
--

CREATE TYPE hn.chapter_types AS ENUM (
    'OLIM',
    'YELIDIM'
);


ALTER TYPE hn.chapter_types OWNER TO postgres;

--
-- Name: blocks; Type: TYPE; Schema: keshev; Owner: mapaadmin
--

CREATE TYPE keshev.blocks AS ENUM (
    'TRAINING',
    'FST_CHAPTER',
    'SEC_CHAPTER',
    'THRD_CHAPTER',
    'FOURTH_CHAPTER'
);


ALTER TYPE keshev.blocks OWNER TO mapaadmin;

--
-- Name: color; Type: TYPE; Schema: keshev; Owner: mapaadmin
--

CREATE TYPE keshev.color AS ENUM (
    'BLACK',
    'GREEN',
    'PINK',
    'YELLOW'
);


ALTER TYPE keshev.color OWNER TO mapaadmin;

--
-- Name: reaction_id; Type: DOMAIN; Schema: keshev; Owner: mapaadmin
--

CREATE DOMAIN keshev.reaction_id AS smallint
	CONSTRAINT reaction_i CHECK ((VALUE <= 460));


ALTER DOMAIN keshev.reaction_id OWNER TO mapaadmin;

--
-- Name: DOMAIN reaction_id; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON DOMAIN keshev.reaction_id IS 'checks that the value inserted is not bigger then 440';


--
-- Name: shape; Type: TYPE; Schema: keshev; Owner: mapaadmin
--

CREATE TYPE keshev.shape AS ENUM (
    'CIRCLE',
    'ELLIPSE',
    'SQUARE',
    'TRIANGLE'
);


ALTER TYPE keshev.shape OWNER TO mapaadmin;

--
-- Name: pilot_types; Type: TYPE; Schema: pilots; Owner: mapaadmin
--

CREATE TYPE pilots.pilot_types AS ENUM (
    'NEW_QUESTIONS',
    'NEW_PARAMETERS'
);


ALTER TYPE pilots.pilot_types OWNER TO mapaadmin;

--
-- Name: advance_exam_return_flags; Type: TYPE; Schema: public; Owner: mapaadmin
--

CREATE TYPE public.advance_exam_return_flags AS ENUM (
    'SECTION_DONE',
    'SECTION_INTERNAL_PROGRESS'
);


ALTER TYPE public.advance_exam_return_flags OWNER TO mapaadmin;

--
-- Name: exam_id; Type: DOMAIN; Schema: public; Owner: mapaadmin
--

CREATE DOMAIN public.exam_id AS character varying(16);


ALTER DOMAIN public.exam_id OWNER TO mapaadmin;

--
-- Name: DOMAIN exam_id; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON DOMAIN public.exam_id IS 'exam_id or something idk lol';


--
-- Name: check_for_schema(text); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.check_for_schema(schema_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$





declare schema text;





begin





	schema = (select nspname





	from pg_catalog.pg_namespace





	where nspname = schema_name);





	RETURN exists (





		select 1





		from information_schema."routines"





		where routine_schema = schema and routine_name = 'advance' and routine_type = 'FUNCTION'





	);





END;





$$;


ALTER FUNCTION public.check_for_schema(schema_name text) OWNER TO mapaadmin;

--
-- Name: exam_schema; Type: DOMAIN; Schema: public; Owner: mapaadmin
--

CREATE DOMAIN public.exam_schema AS character varying(10)
	CONSTRAINT schema_check CHECK (public.check_for_schema((VALUE)::text));


ALTER DOMAIN public.exam_schema OWNER TO mapaadmin;

--
-- Name: DOMAIN exam_schema; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON DOMAIN public.exam_schema IS 'checks for a schema with the function advance';


--
-- Name: exam_status; Type: TYPE; Schema: public; Owner: mapaadmin
--

CREATE TYPE public.exam_status AS ENUM (
    'IN_PROGRESS',
    'PAUSED',
    'FINISHED'
);


ALTER TYPE public.exam_status OWNER TO mapaadmin;

--
-- Name: languages; Type: TYPE; Schema: public; Owner: mapaadmin
--

CREATE TYPE public.languages AS ENUM (
    'he',
    'en',
    'ru',
    'am',
    'ar',
    'es',
    'fr',
    'na'
);


ALTER TYPE public.languages OWNER TO mapaadmin;

--
-- Name: mimshak_statuses; Type: TYPE; Schema: public; Owner: mapaadmin
--

CREATE TYPE public.mimshak_statuses AS ENUM (
    'COMPLETED',
    'REJECTED - FILE ERROR',
    'REJECTED - INTERNAL ERROR',
    'REJECTED - INVALID EXAM',
    'CANCELED',
    'PENDING'
);


ALTER TYPE public.mimshak_statuses OWNER TO mapaadmin;

--
-- Name: supported_exams; Type: TYPE; Schema: public; Owner: mapaadmin
--

CREATE TYPE public.supported_exams AS ENUM (
    'dapar',
    'keshev',
    'hn',
    'mivdak',
    'pilots'
);


ALTER TYPE public.supported_exams OWNER TO mapaadmin;

--
-- Name: url; Type: DOMAIN; Schema: public; Owner: mapaadmin
--

CREATE DOMAIN public.url AS text
	CONSTRAINT url_check CHECK ((VALUE ~* '^https?://[a-zA-Z0-9.-]+(:[0-9]+)?(/.*)?$'::text));


ALTER DOMAIN public.url OWNER TO mapaadmin;

--
-- Name: permission_requests_status; Type: TYPE; Schema: users; Owner: mapaadmin
--

CREATE TYPE users.permission_requests_status AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE users.permission_requests_status OWNER TO mapaadmin;

--
-- Name: roles; Type: TYPE; Schema: users; Owner: mapaadmin
--

CREATE TYPE users.roles AS ENUM (
    'PENDING',
    'COMMANDER',
    'PSYCHO_IVHUN',
    'PSYCHO_NITUV',
    'PSYCHO_MIFKADA',
    'MAMDA',
    'MAAM',
    'NACHSHON',
    'EXAMINEE',
    'PSYCHO_MIFKADA_COMMANDER'
);


ALTER TYPE users.roles OWNER TO mapaadmin;

--
-- Name: valid_luhn(text); Type: FUNCTION; Schema: users; Owner: mapaadmin
--

CREATE FUNCTION users.valid_luhn(val text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$





	DECLARE 





 		digits int[];





		sum int := 0;





		i int; 





		d int;





		





		BEGIN 





			IF (val ~ '^[0-9]{9}$') 





				





				THEN





					digits := regexp_split_to_array(val,'')::int[];





					





					FOR i IN 1..9 LOOP





						d := digits[i];





						IF (i%2 = 0) THEN





							d = d*2;





							IF d > 9 THEN





								d := d-9;





							END IF;





						END IF;





						





						sum := sum + d;





					END LOOP;





					





					RETURN (sum % 10 = 0);





				





				ELSE RETURN false;





			END IF;





			END;





		$_$;


ALTER FUNCTION users.valid_luhn(val text) OWNER TO mapaadmin;

--
-- Name: taz; Type: DOMAIN; Schema: users; Owner: mapaadmin
--

CREATE DOMAIN users.taz AS character(9)
	CONSTRAINT taz_check CHECK (users.valid_luhn((VALUE)::text));


ALTER DOMAIN users.taz OWNER TO mapaadmin;

--
-- Name: advance(uuid); Type: FUNCTION; Schema: dapar; Owner: mapaadmin
--

CREATE FUNCTION dapar.advance(current_session_id uuid) RETURNS public.advance_exam_return_flags
    LANGUAGE plpgsql
    AS $$	DECLARE





		current_chapter_index_in_template integer;





		session_template_id integer;





		





	BEGIN











		SELECT 





			current_chapter, template





			INTO current_chapter_index_in_template, session_template_id





		FROM





			dapar.exams





		WHERE 





			session_id = current_session_id AND current_chapter IS NOT NULL;











			





		IF (dapar.next_chapter_exists(current_chapter_index_in_template, session_template_id))





		THEN





			UPDATE dapar.exams 





			SET current_chapter = (SELECT dapar.next_chapter(current_chapter_index_in_template, session_template_id))





			WHERE session_id = current_session_id;





				





			RETURN 'SECTION_INTERNAL_PROGRESS';





		ELSE





			RETURN 'SECTION_DONE';





		END IF;





		





	END;











$$;


ALTER FUNCTION dapar.advance(current_session_id uuid) OWNER TO mapaadmin;

--
-- Name: dapar_creator(); Type: FUNCTION; Schema: dapar; Owner: mapaadmin
--

CREATE FUNCTION dapar.dapar_creator() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE CALCULATED_TEMPLATE INTEGER;

BEGIN
SELECT
	DAPAR.GET_DAPAR_TEMPLATE (NEW.USER_ID) INTO CALCULATED_TEMPLATE;

INSERT INTO
	DAPAR.EXAMS (EXAM_ID, USER_ID, TEMPLATE)
VALUES
	(NEW.EXAM_ID, NEW.USER_ID, CALCULATED_TEMPLATE);

RETURN NEW;

END;$$;


ALTER FUNCTION dapar.dapar_creator() OWNER TO mapaadmin;

--
-- Name: generate_dapar_questionnaires(); Type: FUNCTION; Schema: dapar; Owner: mapaadmin
--

CREATE FUNCTION dapar.generate_dapar_questionnaires() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO dapar.questionnaires (exam_id, user_id, chapter_id)
    SELECT 
        NEW.exam_id,
		NEW.user_id,
        tc.chapter_id
    FROM dapar.templates_chapters tc
    WHERE tc.template_id = NEW.template;
    RETURN NEW;
END;
$$;


ALTER FUNCTION dapar.generate_dapar_questionnaires() OWNER TO mapaadmin;

--
-- Name: generate_exam(uuid, integer); Type: FUNCTION; Schema: dapar; Owner: mapaadmin
--

CREATE FUNCTION dapar.generate_exam(session uuid, p_index integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE DAPAR_EXEMPT BOOLEAN;

V_USER_ID UUID;

v_index integer;

BEGIN
SELECT
	S.USER_ID INTO V_USER_ID
FROM
	SESSIONS S
WHERE
	S.SESSION_ID = SESSION;

SELECT
	E.DAPAR_EXEMPT INTO DAPAR_EXEMPT
FROM
	EXAMINEES.EXAMINEES E
WHERE
	E.USER_ID = V_USER_ID;

IF DAPAR_EXEMPT = FALSE THEN
UPDATE PUBLIC.SESSION_EXAMS
SET
	INDEX = NULL
WHERE
	SESSION_ID = SESSION
	AND EXAM_TYPE = 'dapar'
	AND INDEX IS NOT NULL
RETURNING
	INDEX INTO V_INDEX;

	IF V_INDEX IS NOT NULL THEN 
		P_INDEX = V_INDEX;
	END IF;

INSERT INTO
	PUBLIC.SESSION_EXAMS (SESSION_ID, INDEX, EXAM_TYPE, user_id)
VALUES
	(SESSION, P_INDEX, 'dapar', v_user_id);

P_INDEX := P_INDEX + 1;

END IF;

RETURN P_INDEX;

END;$$;


ALTER FUNCTION dapar.generate_exam(session uuid, p_index integer) OWNER TO mapaadmin;

--
-- Name: get_dapar_template(uuid); Type: FUNCTION; Schema: dapar; Owner: mapaadmin
--

CREATE FUNCTION dapar.get_dapar_template(v_user_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$





declare





v_template_id integer;





BEGIN





	with user_data as (





		select examinees.user_id, language, ll_unique_path, orthodox, ll_sight





		from examinees.examinees





		join examinees.examinees_ll_metadata on examinees.user_id = examinees.examinees_ll_metadata.user_id





		where examinees.examinees.user_id = v_user_id::uuid





	)





		select result_template





		into v_template_id





		from dapar.user_data_to_template as u





		where exists (select 1 from user_data 





			where user_data.language = u.language





			and user_data.ll_unique_path = u.ll_unique_path





			and user_data.orthodox = u.orthodox





			and user_data.ll_sight = u.ll_sight





		);





		return COALESCE(v_template_id, 11);





END;











$$;


ALTER FUNCTION dapar.get_dapar_template(v_user_id uuid) OWNER TO mapaadmin;

--
-- Name: next_chapter(integer, integer); Type: FUNCTION; Schema: dapar; Owner: mapaadmin
--

CREATE FUNCTION dapar.next_chapter(current_chapter_index_in_template integer, template_id integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$











	BEGIN





		RETURN (SELECT chapter_index





			FROM dapar.template_chapters





			WHERE template_id = template_id AND chapter_index = (current_chapter_index_in_template + 1)





		);





	END











$$;


ALTER FUNCTION dapar.next_chapter(current_chapter_index_in_template integer, template_id integer) OWNER TO mapaadmin;

--
-- Name: next_chapter_exists(integer, integer); Type: FUNCTION; Schema: dapar; Owner: mapaadmin
--

CREATE FUNCTION dapar.next_chapter_exists(prev_chapter_index integer, template_id integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$











	BEGIN





		RETURN EXISTS (





			SELECT 1





			FROM dapar.template_chapters





			WHERE template_id = template_id AND chapter_index = (prev_chapter_index + 1)





		);





	END











$$;


ALTER FUNCTION dapar.next_chapter_exists(prev_chapter_index integer, template_id integer) OWNER TO mapaadmin;

--
-- Name: create_examinee_diagnosis(); Type: FUNCTION; Schema: examinees; Owner: mapaadmin
--

CREATE FUNCTION examinees.create_examinee_diagnosis() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO examinees.examinees_diagnosis(
	user_id)
	VALUES (new.user_id);
RETURN NEW;
END;
$$;


ALTER FUNCTION examinees.create_examinee_diagnosis() OWNER TO mapaadmin;

--
-- Name: FUNCTION create_examinee_diagnosis(); Type: COMMENT; Schema: examinees; Owner: mapaadmin
--

COMMENT ON FUNCTION examinees.create_examinee_diagnosis() IS 'creates the diagnosis for the ll meta data for shits and gigles (i know its needed by psycho but frick)';


--
-- Name: examinees_update_logs(); Type: FUNCTION; Schema: examinees; Owner: mapaadmin
--

CREATE FUNCTION examinees.examinees_update_logs() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE THE_TABLE_NAME TEXT := TG_TABLE_NAME;


PKEY_COLUMN TEXT;

PKEY_VALUE TEXT;

BEGIN PKEY_COLUMN = (
	SELECT
		COLUMN_NAME
	FROM
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE
	WHERE
		TABLE_NAME = THE_TABLE_NAME
		AND CONSTRAINT_NAME IN (
			SELECT
				CONSTRAINT_NAME
			FROM
				INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE
				TABLE_NAME = THE_TABLE_NAME
				AND CONSTRAINT_TYPE = 'PRIMARY KEY'
		)
	LIMIT
		1
);

IF PKEY_COLUMN IS NOT NULL THEN IF (TG_OP = 'DELETE') THEN
EXECUTE FORMAT('select ($1).%I', PKEY_COLUMN) INTO PKEY_VALUE USING OLD;

ELSE
EXECUTE FORMAT('select ($1).%I', PKEY_COLUMN) INTO PKEY_VALUE USING NEW;

END IF;

ELSE PKEY_VALUE := 'N/A';

END IF;

INSERT INTO
	examinees.examinees_update_logs (TABLE_NAME, PKEY, OLD_VALUE, NEW_VALUE)
VALUES
	(
		THE_TABLE_NAME,
		PKEY_VALUE,
		OLD,
		NEW
	);

RETURN (
	CASE
		WHEN TG_OP = 'DELETE' THEN OLD
		ELSE NEW
	END
);

END;
$_$;


ALTER FUNCTION examinees.examinees_update_logs() OWNER TO mapaadmin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: examinees; Type: TABLE; Schema: examinees; Owner: mapaadmin
--

CREATE TABLE examinees.examinees (
    user_id uuid NOT NULL,
    hn_type examinees.hn NOT NULL,
    language public.languages NOT NULL,
    dapar_exempt boolean NOT NULL,
    orthodox boolean NOT NULL,
    keshev_exempt boolean NOT NULL
);


ALTER TABLE examinees.examinees OWNER TO mapaadmin;

--
-- Name: examinees_ll_metadata; Type: TABLE; Schema: examinees; Owner: mapaadmin
--

CREATE TABLE examinees.examinees_ll_metadata (
    user_id uuid NOT NULL,
    ll_time_extension examinees.time_extentions NOT NULL,
    ll_unique_path examinees.unique_paths NOT NULL,
    ll_breaks boolean NOT NULL,
    ll_sight boolean NOT NULL
);


ALTER TABLE examinees.examinees_ll_metadata OWNER TO mapaadmin;

--
-- Name: fn_create_examinee(examinees.examinees, examinees.examinees_ll_metadata, date); Type: FUNCTION; Schema: examinees; Owner: mapaadmin
--

CREATE FUNCTION examinees.fn_create_examinee(v_examinee examinees.examinees, v_examinee_ll_metadata examinees.examinees_ll_metadata, v_summon_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN 
IF V_EXAMINEE.USER_ID != V_EXAMINEE_LL_METADATA.USER_ID THEN RAISE EXCEPTION 'must be the same user';
END IF;

PERFORM
	EXAMINEES.FN_CREATE_EXAMINEE_DATA (V_EXAMINEE);

PERFORM
	EXAMINEES.FN_CREATE_EXAMINEE_LL_METADATA (V_EXAMINEE_LL_METADATA);

PERFORM
	PUBLIC.SESSION_CREATOR (V_EXAMINEE.USER_ID, V_SUMMON_DATE);

END
$$;


ALTER FUNCTION examinees.fn_create_examinee(v_examinee examinees.examinees, v_examinee_ll_metadata examinees.examinees_ll_metadata, v_summon_date date) OWNER TO mapaadmin;

--
-- Name: FUNCTION fn_create_examinee(v_examinee examinees.examinees, v_examinee_ll_metadata examinees.examinees_ll_metadata, v_summon_date date); Type: COMMENT; Schema: examinees; Owner: mapaadmin
--

COMMENT ON FUNCTION examinees.fn_create_examinee(v_examinee examinees.examinees, v_examinee_ll_metadata examinees.examinees_ll_metadata, v_summon_date date) IS 'this is how we create the examinees';


--
-- Name: fn_create_examinee_data(examinees.examinees); Type: FUNCTION; Schema: examinees; Owner: mapaadmin
--

CREATE FUNCTION examinees.fn_create_examinee_data(v_examinee examinees.examinees) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
INSERT INTO examinees.examinees(
	user_id, hn_type, language, dapar_exempt, orthodox, keshev_exempt)
	VALUES (v_examinee.user_id, 
	coalesce(v_examinee.hn_type, 'NONE'::examinees.hn),
	coalesce(v_examinee.language, 'he'::languages),
	coalesce(v_examinee.dapar_exempt, false),
	coalesce(v_examinee.orthodox, false),
	coalesce(v_examinee.keshev_exempt, false)
	);
	end
$$;


ALTER FUNCTION examinees.fn_create_examinee_data(v_examinee examinees.examinees) OWNER TO mapaadmin;

--
-- Name: fn_create_examinee_data(jsonb); Type: FUNCTION; Schema: examinees; Owner: mapaadmin
--

CREATE FUNCTION examinees.fn_create_examinee_data(v_examinee jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
INSERT INTO examinees.examinees(
	user_id, hn_type, language, dapar_exempt, orthodox, keshev_exempt)
	VALUES (v_examinee.user_id, 
	coalesce(v_examinee.hn_type, 'NONE'::examinees.hn),
	coalesce(v_examinee.language, 'he'::languages),
	coalesce(v_examinee.dapar_exempt, false),
	coalesce(v_examinee.orthodox, false),
	coalesce(v_examinee.keshev_exempt, false)
	);
	end
$$;


ALTER FUNCTION examinees.fn_create_examinee_data(v_examinee jsonb) OWNER TO mapaadmin;

--
-- Name: fn_create_examinee_ll_metadata(examinees.examinees_ll_metadata); Type: FUNCTION; Schema: examinees; Owner: mapaadmin
--

CREATE FUNCTION examinees.fn_create_examinee_ll_metadata(v_examinee examinees.examinees_ll_metadata) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
INSERT INTO examinees.examinees_ll_metadata (
    user_id, 
    ll_time_extension, 
    ll_unique_path, 
    ll_breaks, 
    ll_sight
) 
VALUES (
    v_examinee.user_id,
    COALESCE(v_examinee.ll_time_extension, 'NONE'),
    COALESCE(v_examinee.ll_unique_path, 'NONE'),
    COALESCE(v_examinee.ll_breaks, false),
    COALESCE(v_examinee.ll_sight, false)
);
	end
$$;


ALTER FUNCTION examinees.fn_create_examinee_ll_metadata(v_examinee examinees.examinees_ll_metadata) OWNER TO mapaadmin;

--
-- Name: fn_examinees_login(users.taz, uuid); Type: FUNCTION; Schema: examinees; Owner: mapaadmin
--

CREATE FUNCTION examinees.fn_examinees_login(v_user_taz users.taz, v_class_id uuid) RETURNS examinees.login_object
    LANGUAGE plpgsql
    AS $$
DECLARE 
    v_session public.sessions%ROWTYPE;
    v_user examinees.login_object;
BEGIN
    SELECT u.user_id, u.name, u.taz, e.language 
    INTO v_user
    FROM users.users u
    JOIN examinees.examinees e USING (user_id)
    WHERE u.taz = v_user_taz 
      AND u.role IN ('EXAMINEE', 'NACHSHON');

    IF NOT FOUND THEN 
        RAISE EXCEPTION 'no user with this taz' USING ERRCODE = 'missing_user'; 
    END IF;

    SELECT * INTO v_session 
    FROM public.sessions 
    WHERE user_id = v_user.user_id::uuid
      AND summon_date = CURRENT_DATE;

    IF NOT FOUND THEN 
        RAISE EXCEPTION 'no session today for this user' USING ERRCODE = 'missing_session';
	END IF;
	
	IF NOT EXISTS (select 1 from vw_active_classes where vw_active_classes.class_id = v_class_id) THEN
		RAISE EXCEPTION 'the class is not longer active' USING ERRCODE = 'class_inactive';
	END IF;
	
    IF v_session.started_at IS NULL THEN
        UPDATE public.sessions
        SET started_at = now(), 
            class_id = v_class_id::uuid
        WHERE user_id = v_user.user_id::uuid
          AND summon_date = CURRENT_DATE;

        INSERT INTO public.to_sap(user_id, from_login)
        VALUES (v_user.user_id::uuid, true)
        ON CONFLICT (user_id, at_date)
        DO UPDATE SET from_login = true;
    END IF;

    RETURN v_user;
END
$$;


ALTER FUNCTION examinees.fn_examinees_login(v_user_taz users.taz, v_class_id uuid) OWNER TO mapaadmin;

--
-- Name: notify_examinee_details_updated(); Type: FUNCTION; Schema: examinees; Owner: postgres
--

CREATE FUNCTION examinees.notify_examinee_details_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD IS DISTINCT FROM NEW THEN
    PERFORM pg_notify(
      'events',
      json_build_object(
        'eventType', 'EXAMINEE_DETAILS_UPDATED',
        'userId', NEW.user_id
      )::text
    );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION examinees.notify_examinee_details_updated() OWNER TO postgres;

--
-- Name: update_ll_metadata_by_diagnosis(); Type: FUNCTION; Schema: examinees; Owner: mapaadmin
--

CREATE FUNCTION examinees.update_ll_metadata_by_diagnosis() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
v_ll_time_extension examinees.time_extentions;
v_ll_unique_path examinees.unique_paths;
BEGIN
if new.diagnosis_approval = 'fullTazAndInterrogation' then
	if new.severe_arithmetic then v_ll_unique_path = 'MATH'::examinees.unique_paths;
	elseif new.adapted_test then v_ll_unique_path = 'VERBAL'::examinees.unique_paths;
	else v_ll_unique_path = 'VERBAL'::examinees.unique_paths;
	end if;
	if new.time_extension or new.attention_and_concentration then v_ll_time_extension='ALL'::examinees.time_extentions;
	else v_ll_time_extension='NONE'::examinees.time_extentions;
	end if;
	UPDATE examinees.examinees_ll_metadata
	SET ll_time_extension=v_ll_time_extension, ll_unique_path=v_ll_unique_path, ll_breaks=new.attention_and_concentration, ll_sight=new.enlarged_questionnaire
	WHERE new.user_id = examinees.examinees_ll_metadata.user_id;
end if;
RETURN NEW;
END;
$$;


ALTER FUNCTION examinees.update_ll_metadata_by_diagnosis() OWNER TO mapaadmin;

--
-- Name: advance(uuid); Type: FUNCTION; Schema: hn; Owner: mapaadmin
--

CREATE FUNCTION hn.advance(current_session_id uuid) RETURNS public.advance_exam_return_flags
    LANGUAGE plpgsql
    AS $$DECLARE CURRENT_CHAPTER_INDEX_IN_TEMPLATE INTEGER;

SESSION_TEMPLATE_ID INTEGER;

BEGIN
SELECT
	CURRENT_CHAPTER,
	TEMPLATE INTO CURRENT_CHAPTER_INDEX_IN_TEMPLATE,
	SESSION_TEMPLATE_ID
FROM
	HN.EXAMS
WHERE
	SESSION_ID = CURRENT_SESSION_ID
	AND CURRENT_CHAPTER IS NOT NULL;

IF (
	HN.NEXT_CHAPTER_EXISTS (
		CURRENT_CHAPTER_INDEX_IN_TEMPLATE,
		SESSION_TEMPLATE_ID
	)
) THEN
UPDATE HN.EXAMS
SET
	CURRENT_CHAPTER = (
		SELECT
			HN.NEXT_CHAPTER (
				CURRENT_CHAPTER_INDEX_IN_TEMPLATE,
				SESSION_TEMPLATE_ID
			)
	)
WHERE
	SESSION_ID = CURRENT_SESSION_ID;

RETURN 'SECTION_INTERNAL_PROGRESS';

ELSE RETURN 'SECTION_DONE';

END IF;

END;$$;


ALTER FUNCTION hn.advance(current_session_id uuid) OWNER TO mapaadmin;

--
-- Name: generate_exam(uuid, integer); Type: FUNCTION; Schema: hn; Owner: mapaadmin
--

CREATE FUNCTION hn.generate_exam(session uuid, p_index integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE HN_TYPE TEXT;

V_USER_ID UUID;

V_INDEX INTEGER;

BEGIN
SELECT
	SESSIONS.USER_ID INTO V_USER_ID
FROM
	SESSIONS
WHERE
	SESSIONS.SESSION_ID = SESSION;

SELECT
	EXAMINEES.HN_TYPE INTO HN_TYPE
FROM
	EXAMINEES.EXAMINEES
WHERE
	EXAMINEES.USER_ID = V_USER_ID::UUID;

IF HN_TYPE != 'NONE' THEN
UPDATE PUBLIC.SESSION_EXAMS
SET
	INDEX = NULL
WHERE
	SESSION_ID = SESSION
	AND EXAM_TYPE = 'hn'
	AND INDEX IS NOT NULL
RETURNING
	INDEX INTO V_INDEX;

IF V_INDEX IS NOT NULL THEN P_INDEX = V_INDEX;

END IF;

INSERT INTO
	PUBLIC.SESSION_EXAMS (SESSION_ID, INDEX, EXAM_TYPE, user_id)
VALUES
	(SESSION, P_INDEX, 'hn', v_user_id);

P_INDEX := P_INDEX + 1;

END IF;

RETURN P_INDEX;

END;$$;


ALTER FUNCTION hn.generate_exam(session uuid, p_index integer) OWNER TO mapaadmin;

--
-- Name: generate_hn_questionnaires(); Type: FUNCTION; Schema: hn; Owner: mapaadmin
--

CREATE FUNCTION hn.generate_hn_questionnaires() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO hn.questionnaires (exam_id, user_id, chapter_id)
    SELECT 
        NEW.exam_id,
		NEW.user_id,
        tc.chapter_id
    FROM hn.templates_chapters tc
    WHERE tc.template_id = NEW.template;
    RETURN NEW;
END;
$$;


ALTER FUNCTION hn.generate_hn_questionnaires() OWNER TO mapaadmin;

--
-- Name: get_hn_template(uuid); Type: FUNCTION; Schema: hn; Owner: mapaadmin
--

CREATE FUNCTION hn.get_hn_template(v_user_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE V_TEMPLATE_ID INTEGER;

BEGIN
WITH
	USER_DATA AS (
		SELECT
			EXAMINEES.USER_ID,
			LANGUAGE,
			LL_UNIQUE_PATH,
			ORTHODOX,
			LL_SIGHT
		FROM
			EXAMINEES.EXAMINEES
			JOIN EXAMINEES.EXAMINEES_LL_METADATA ON EXAMINEES.USER_ID = EXAMINEES.EXAMINEES_LL_METADATA.USER_ID
		WHERE
			EXAMINEES.EXAMINEES.USER_ID = V_USER_ID
	)
SELECT
	RESULT_TEMPLATE INTO V_TEMPLATE_ID
FROM
	HN.USER_DATA_TO_TEMPLATE AS U
WHERE
	EXISTS (
		SELECT
			1
		FROM
			USER_DATA
		WHERE
			USER_DATA.LANGUAGE = U.LANGUAGE
			AND USER_DATA.HN_TYPE = U.HN_TYPE
	);

RETURN COALESCE(V_TEMPLATE_ID, 71);

END;$$;


ALTER FUNCTION hn.get_hn_template(v_user_id uuid) OWNER TO mapaadmin;

--
-- Name: hn_creator(); Type: FUNCTION; Schema: hn; Owner: mapaadmin
--

CREATE FUNCTION hn.hn_creator() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE CALCULATED_TEMPLATE INTEGER;

BEGIN

SELECT
	HN.GET_HN_TEMPLATE (NEW.USER_ID) INTO CALCULATED_TEMPLATE;

INSERT INTO
	HN.EXAMS (EXAM_ID, USER_ID, TEMPLATE)
VALUES
	(NEW.EXAM_ID, NEW.USER_ID, CALCULATED_TEMPLATE);

RETURN NEW;

END;$$;


ALTER FUNCTION hn.hn_creator() OWNER TO mapaadmin;

--
-- Name: next_chapter(integer, integer); Type: FUNCTION; Schema: hn; Owner: mapaadmin
--

CREATE FUNCTION hn.next_chapter(current_chapter_index_in_template integer, template_id integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$











	BEGIN





		RETURN (SELECT chapter_index





			FROM hn.template_chapters





			WHERE template_id = template_id AND chapter_index = (current_chapter_index_in_template + 1)





		);





	END











$$;


ALTER FUNCTION hn.next_chapter(current_chapter_index_in_template integer, template_id integer) OWNER TO mapaadmin;

--
-- Name: next_chapter_exists(integer, integer); Type: FUNCTION; Schema: hn; Owner: mapaadmin
--

CREATE FUNCTION hn.next_chapter_exists(prev_chapter_index integer, template_id integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$











	BEGIN





		RETURN EXISTS (





			SELECT 1





			FROM hn.template_chapters





			WHERE template_id = template_id AND chapter_index = (prev_chapter_index + 1)





		);





	END











$$;


ALTER FUNCTION hn.next_chapter_exists(prev_chapter_index integer, template_id integer) OWNER TO mapaadmin;

--
-- Name: generate_exam(uuid, integer); Type: FUNCTION; Schema: keshev; Owner: mapaadmin
--

CREATE FUNCTION keshev.generate_exam(session uuid, p_index integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE KESHEV_EXEMPT BOOLEAN;

V_USER_ID UUID;

V_INDEX INTEGER;

BEGIN
SELECT
	SESSIONS.USER_ID INTO V_USER_ID
FROM
	SESSIONS
WHERE
	SESSIONS.SESSION_ID = SESSION;

SELECT
	EXAMINEES.KESHEV_EXEMPT INTO KESHEV_EXEMPT
FROM
	EXAMINEES.EXAMINEES
WHERE
	EXAMINEES.USER_ID = V_USER_ID;

IF KESHEV_EXEMPT = FALSE THEN
UPDATE PUBLIC.SESSION_EXAMS
SET
	INDEX = NULL
WHERE
	SESSION_ID = SESSION
	AND EXAM_TYPE = 'keshev'
	AND INDEX IS NOT NULL
RETURNING
	INDEX INTO V_INDEX;

IF V_INDEX IS NOT NULL THEN P_INDEX = V_INDEX;

END IF;

INSERT INTO
	PUBLIC.SESSION_EXAMS (SESSION_ID, INDEX, EXAM_TYPE, user_id)
VALUES
	(SESSION, P_INDEX, 'keshev', v_user_id);

P_INDEX := P_INDEX + 1;

END IF;

RETURN P_INDEX;

END;$$;


ALTER FUNCTION keshev.generate_exam(session uuid, p_index integer) OWNER TO mapaadmin;

--
-- Name: keshev_creator(); Type: FUNCTION; Schema: keshev; Owner: mapaadmin
--

CREATE FUNCTION keshev.keshev_creator() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
INSERT INTO
	KESHEV.EXAMS (EXAM_ID, USER_ID)
VALUES
	(NEW.EXAM_ID, NEW.USER_ID);

RETURN NEW;

END;$$;


ALTER FUNCTION keshev.keshev_creator() OWNER TO mapaadmin;

--
-- Name: generate_exam(uuid, integer); Type: FUNCTION; Schema: mivdak; Owner: mapaadmin
--

CREATE FUNCTION mivdak.generate_exam(session uuid, p_index integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE DAPAR_EXEMPT BOOLEAN;

LL_UNIQUE_PATH EXAMINEES.UNIQUE_PATHS;

V_USER_ID UUID;

V_INDEX INTEGER;

BEGIN
SELECT
	SESSIONS.USER_ID INTO V_USER_ID
FROM
	SESSIONS
WHERE
	SESSIONS.SESSION_ID = SESSION;

SELECT
	EXAMINEES_LL_METADATA.LL_UNIQUE_PATH INTO LL_UNIQUE_PATH
FROM
	EXAMINEES.EXAMINEES
	JOIN EXAMINEES.EXAMINEES_LL_METADATA ON EXAMINEES.USER_ID = EXAMINEES_LL_METADATA.USER_ID
WHERE
	EXAMINEES_LL_METADATA.USER_ID = V_USER_ID::UUID;

SELECT
	EXAMINEES.DAPAR_EXEMPT INTO DAPAR_EXEMPT
FROM
	EXAMINEES.EXAMINEES
WHERE
	EXAMINEES.USER_ID = V_USER_ID::UUID;

IF DAPAR_EXEMPT = FALSE
AND LL_UNIQUE_PATH = 'MATH' THEN
UPDATE PUBLIC.SESSION_EXAMS
SET
	INDEX = NULL
WHERE
	SESSION_ID = SESSION
	AND EXAM_TYPE = 'mivdak'
	AND INDEX IS NOT NULL
RETURNING
	INDEX INTO V_INDEX;

IF V_INDEX IS NOT NULL THEN P_INDEX = V_INDEX;

END IF;

INSERT INTO
	PUBLIC.SESSION_EXAMS (SESSION_ID, INDEX, EXAM_TYPE, user_id)
VALUES
	(SESSION, P_INDEX, 'mivdak', v_user_id);

P_INDEX := P_INDEX + 1;

END IF;

RETURN P_INDEX;

END;$$;


ALTER FUNCTION mivdak.generate_exam(session uuid, p_index integer) OWNER TO mapaadmin;

--
-- Name: generate_mivdak_questionnaires(); Type: FUNCTION; Schema: mivdak; Owner: mapaadmin
--

CREATE FUNCTION mivdak.generate_mivdak_questionnaires() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    INSERT INTO mivdak.questionnaires (exam_id, user_id, chapter_id)
    SELECT 
        NEW.exam_id,
		NEW.USER_ID,
        mivdak.chapters.chapter_id
    FROM mivdak.chapters;
    RETURN NEW;
END;
$$;


ALTER FUNCTION mivdak.generate_mivdak_questionnaires() OWNER TO mapaadmin;

--
-- Name: mivdak_creator(); Type: FUNCTION; Schema: mivdak; Owner: mapaadmin
--

CREATE FUNCTION mivdak.mivdak_creator() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

INSERT INTO
	MIVDAK.EXAMS (EXAM_ID, user_id)
VALUES
	(NEW.EXAM_ID, NEW.USER_ID);

RETURN NEW;

END;$$;


ALTER FUNCTION mivdak.mivdak_creator() OWNER TO mapaadmin;

--
-- Name: advance(uuid); Type: FUNCTION; Schema: pilots; Owner: mapaadmin
--

CREATE FUNCTION pilots.advance(current_session_id uuid) RETURNS public.advance_exam_return_flags
    LANGUAGE plpgsql
    AS $$





	DECLARE





		current_chapter_index_in_template integer;





		session_template_id integer;





		





	BEGIN











		SELECT 





			current_chapter, template





			INTO current_chapter_index_in_template, session_template_id





		FROM





			pilots.exams





		WHERE 





			session_id = current_session_id AND current_chapter IS NOT NULL;











			





		IF (pilots.next_chapter_exists(current_chapter_index_in_template, session_template_id))





		THEN





			UPDATE pilots.exams 





			SET current_chapter = (SELECT pilots.next_chapter(current_chapter_index_in_template, session_template_id))





			WHERE session_id = current_session_id;





				





			RETURN 'SECTION_INTERNAL_PROGRESS';





		ELSE





			RETURN 'SECTION_DONE';





		END IF;





		





	END;











$$;


ALTER FUNCTION pilots.advance(current_session_id uuid) OWNER TO mapaadmin;

--
-- Name: generate_exam(uuid, integer); Type: FUNCTION; Schema: pilots; Owner: mapaadmin
--

CREATE FUNCTION pilots.generate_exam(session uuid, p_index integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE DAPAR_EXEMPT BOOLEAN;

V_USER_ID UUID;

V_INDEX INTEGER;

BEGIN
SELECT
	SESSIONS.USER_ID INTO V_USER_ID
FROM
	SESSIONS
WHERE
	SESSIONS.SESSION_ID = SESSION;

SELECT
	EXAMINEES.DAPAR_EXEMPT INTO DAPAR_EXEMPT
FROM
	EXAMINEES.EXAMINEES
WHERE
	EXAMINEES.USER_ID = V_USER_ID;

IF DAPAR_EXEMPT = FALSE THEN
UPDATE PUBLIC.SESSION_EXAMS
SET
	INDEX = NULL
WHERE
	SESSION_ID = SESSION
	AND EXAM_TYPE = 'pilots'
	AND INDEX IS NOT NULL
RETURNING
	INDEX INTO V_INDEX;

IF V_INDEX IS NOT NULL THEN P_INDEX = V_INDEX;

END IF;

INSERT INTO
	PUBLIC.SESSION_EXAMS (SESSION_ID, INDEX, EXAM_TYPE, user_id)
VALUES
	(SESSION, P_INDEX, 'pilots', v_user_id);

P_INDEX := P_INDEX + 1;

END IF;

RETURN P_INDEX;

END;$$;


ALTER FUNCTION pilots.generate_exam(session uuid, p_index integer) OWNER TO mapaadmin;

--
-- Name: generate_pilots_questionnaires(); Type: FUNCTION; Schema: pilots; Owner: mapaadmin
--

CREATE FUNCTION pilots.generate_pilots_questionnaires() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO pilots.questionnaires (exam_id, user_id, chapter_id)
    SELECT 
        NEW.exam_id,
		NEW.user_id,
        tc.chapter_id
    FROM pilots.template_chapters tc
    WHERE tc.template_id = NEW.template;
    RETURN NEW;
END;
$$;


ALTER FUNCTION pilots.generate_pilots_questionnaires() OWNER TO mapaadmin;

--
-- Name: next_chapter(integer, integer); Type: FUNCTION; Schema: pilots; Owner: mapaadmin
--

CREATE FUNCTION pilots.next_chapter(current_chapter_index_in_template integer, template_id integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$











	BEGIN





		RETURN (SELECT chapter_index





			FROM pilots.template_chapters





			WHERE template_id = template_id AND chapter_index = (current_chapter_index_in_template + 1)





		);





	END











$$;


ALTER FUNCTION pilots.next_chapter(current_chapter_index_in_template integer, template_id integer) OWNER TO mapaadmin;

--
-- Name: next_chapter_exists(integer, integer); Type: FUNCTION; Schema: pilots; Owner: mapaadmin
--

CREATE FUNCTION pilots.next_chapter_exists(prev_chapter_index integer, template_id integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$











	BEGIN





		RETURN EXISTS (





			SELECT 1





			FROM pilots.template_chapters





			WHERE template_id = template_id AND chapter_index = (prev_chapter_index + 1)





		);





	END











$$;


ALTER FUNCTION pilots.next_chapter_exists(prev_chapter_index integer, template_id integer) OWNER TO mapaadmin;

--
-- Name: pilots_creator(); Type: FUNCTION; Schema: pilots; Owner: mapaadmin
--

CREATE FUNCTION pilots.pilots_creator() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

INSERT INTO
	PILOTS.EXAMS (EXAM_ID, USER_ID, TEMPLATE)
VALUES
	(
		NEW.EXAM_ID,
		NEW.USER_ID,
		(
			SELECT
				GET_DAPAR_TEMPLATE (NEW.USER_ID)
		)
	);

RETURN NEW;

END;$$;


ALTER FUNCTION pilots.pilots_creator() OWNER TO mapaadmin;

--
-- Name: advance_session(uuid); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.advance_session(session uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$





	DECLARE





		advanceFlag advance_exam_return_flags;





		query text;





		current_schema text;





	BEGIN





		select exam_type





		into current_schema





		FROM sessions join session_exams using (session_id)





		WHERE session_id = session and session_exams.index = sessions.index;











		query := FORMAT('SELECT %I FROM sessions join using(session_id) where session_id = session and session_exams.current_index = sessions.current_index', current_schema);





		execute query into advanceFlag;





			





		IF (advanceFlat = 'SECTION_DONE')





		THEN





			UPDATE public.sessions 





			SET current_index = current_index+1





			WHERE session_id = current_session_id;





		END IF;





	END;





$$;


ALTER FUNCTION public.advance_session(session uuid) OWNER TO mapaadmin;

--
-- Name: cancel_unused_exams(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.cancel_unused_exams() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
query text;
BEGIN
	IF (new.index IS NULL AND old.index IS NOT NULL) THEN
    query := FORMAT(
        'UPDATE %I.exams SET status = %L WHERE exam_id = %L', 
        new.exam_type, 
        null, 
        new.exam_id
    );
    EXECUTE query;
END IF;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.cancel_unused_exams() OWNER TO mapaadmin;

--
-- Name: FUNCTION cancel_unused_exams(); Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON FUNCTION public.cancel_unused_exams() IS 'glory to mapa';


--
-- Name: generate_exams_for_session(uuid, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.generate_exams_for_session(v_session_id uuid, v_dapar boolean, v_keshev boolean, v_hn boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE INDEX INTEGER = 0;

BEGIN IF v_dapar THEN INDEX = MIVDAK.GENERATE_EXAM (v_session_id, INDEX); END IF;

IF V_DAPAR THEN INDEX = DAPAR.GENERATE_EXAM (v_session_id, INDEX); END IF;

IF v_dapar THEN INDEX = PILOTS.GENERATE_EXAM (v_session_id, INDEX); END IF;

IF V_HN THEN INDEX = HN.GENERATE_EXAM (v_session_id, INDEX); END IF;

IF V_KESHEV THEN INDEX = KESHEV.GENERATE_EXAM (v_session_id, INDEX); END IF;

END;
$$;


ALTER FUNCTION public.generate_exams_for_session(v_session_id uuid, v_dapar boolean, v_keshev boolean, v_hn boolean) OWNER TO mapaadmin;

--
-- Name: FUNCTION generate_exams_for_session(v_session_id uuid, v_dapar boolean, v_keshev boolean, v_hn boolean); Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON FUNCTION public.generate_exams_for_session(v_session_id uuid, v_dapar boolean, v_keshev boolean, v_hn boolean) IS 'create all the exams for an examinee';


--
-- Name: generate_random_class_code(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.generate_random_class_code() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
    seq_id BIGINT;
    scrambled_id BIGINT;
    result TEXT := '';
    i INT;
    chars TEXT := 'AB42EFHIKL9PQRDST8U67VWXYZac5defhikl3pqrstu1vwxy';
BEGIN
    seq_id := nextval('class_code_seq');
  
    scrambled_id := (seq_id * 15485863) % 12230590464; 

    FOR i IN 1..6 LOOP
        result := substr(chars, (scrambled_id % length(chars))::int + 1, 1) || result;
        scrambled_id := scrambled_id / length(chars);
    END LOOP;

    RETURN result;
END;$$;


ALTER FUNCTION public.generate_random_class_code() OWNER TO mapaadmin;

--
-- Name: handle_session_exam_index(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.handle_session_exam_index() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.index IS NOT NULL THEN
        UPDATE public.session_exams
        SET index = NULL
        WHERE session_id = NEW.session_id
          AND exam_type = NEW.exam_type
          AND exam_id != NEW.exam_id
          AND index IS NOT NULL;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_session_exam_index() OWNER TO mapaadmin;

--
-- Name: non_null_insert(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.non_null_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	if new.index is null then raise exception 'you cant insert a null here mf';
	end if;
	return new;
END;
$$;


ALTER FUNCTION public.non_null_insert() OWNER TO mapaadmin;

--
-- Name: FUNCTION non_null_insert(); Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON FUNCTION public.non_null_insert() IS 'this';


--
-- Name: notify_exam_session_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_exam_session_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD IS DISTINCT FROM NEW THEN
    PERFORM pg_notify(
      'events',
      json_build_object(
        'eventType', 'EXAM_SESSION_UPDATED',
        'userId', NEW.user_id
      )::text
    );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_exam_session_updated() OWNER TO postgres;

--
-- Name: notify_exam_status_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_exam_status_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.status IS DISTINCT FROM OLD.status THEN
    PERFORM pg_notify(
      'events',
      json_build_object(
        'eventType', 'EXAM_STATUS_UPDATED',
        'userId', NEW.user_id
      )::text
    );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_exam_status_updated() OWNER TO postgres;

--
-- Name: notify_session_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_session_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD IS DISTINCT FROM NEW THEN
    PERFORM pg_notify(
      'events',
      json_build_object(
        'eventType', 'SESSION_UPDATED',
        'userId', NEW.user_id
      )::text
    );
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_session_updated() OWNER TO postgres;

--
-- Name: recalculate_dapar_in_session(uuid); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.recalculate_dapar_in_session(v_user_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare v_session_id uuid;
declare v_examinee examinees.examinees%ROWTYPE;
declare v_examinee_ll_metadata examinees.examinees_ll_metadata%ROWTYPE;

begin
select session_id from public.sessions as s where s.summon_date = current_date and s.user_id = v_user_id into v_session_id;

if v_session_id is not null then
select * from examinees.examinees as e where e.user_id = v_user_id into v_examinee;
select * from examinees.examinees_ll_metadata as el where el.user_id = v_user_id into v_examinee_ll_metadata;
if v_examinee_ll_metadata.ll_unique_path = 'NONE' then 
	UPDATE public.session_exams
		SET index = null
		WHERE session_id = v_session_id and exam_type = 'mivdak';
end if;

if v_examinee.dapar_exempt then 
	UPDATE public.session_exams
		SET index = null
		WHERE session_id = v_session_id and exam_type in ('dapar', 'pilots', 'mivdak');
end if;
PERFORM public.generate_exams_for_session(v_session_id::uuid, TRUE, false, false);

end if;

END;

$$;


ALTER FUNCTION public.recalculate_dapar_in_session(v_user_id uuid) OWNER TO mapaadmin;

--
-- Name: FUNCTION recalculate_dapar_in_session(v_user_id uuid); Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON FUNCTION public.recalculate_dapar_in_session(v_user_id uuid) IS 'dapar';


--
-- Name: recalculate_hn_in_session(uuid); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.recalculate_hn_in_session(v_user_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare v_session_id uuid;
declare v_examinee examinees.examinees%ROWTYPE;

begin
select session_id from public.sessions as s where s.summon_date = current_date and s.user_id = v_user_id into v_session_id;
if v_session_id is not null then
select * from examinees.examinees as e where e.user_id = v_user_id into v_examinee;
if v_examinee.hn_type = 'NONE' then 
	UPDATE public.session_exams
		SET index = null
		WHERE session_id = v_session_id and exam_type = 'hn';
end if;
PERFORM public.generate_exams_for_session(v_session_id::uuid, false, true, false);

end if;

END;

$$;


ALTER FUNCTION public.recalculate_hn_in_session(v_user_id uuid) OWNER TO mapaadmin;

--
-- Name: FUNCTION recalculate_hn_in_session(v_user_id uuid); Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON FUNCTION public.recalculate_hn_in_session(v_user_id uuid) IS 'hn';


--
-- Name: recalculate_keshev_in_session(uuid); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.recalculate_keshev_in_session(v_user_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$declare v_examinee examinees.examinees%ROWTYPE;
declare v_session_id uuid;
begin
select session_id from public.sessions as s where s.summon_date = current_date and s.user_id = v_user_id into v_session_id;
select * from examinees.examinees as e where e.user_id = v_user_id into v_examinee;
if v_session_id is not null then
if v_examinee.keshev_exempt then 
	UPDATE public.session_exams
		SET index = null
		WHERE session_id = v_session_id and exam_type = 'keshev';
end if;
PERFORM public.generate_exams_for_session(v_session_id::uuid, false, false, true);

end if;

END;$$;


ALTER FUNCTION public.recalculate_keshev_in_session(v_user_id uuid) OWNER TO mapaadmin;

--
-- Name: FUNCTION recalculate_keshev_in_session(v_user_id uuid); Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON FUNCTION public.recalculate_keshev_in_session(v_user_id uuid) IS 'keshev';


--
-- Name: recalculate_session(uuid); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.recalculate_session(v_user_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare v_examinee examinees.examinees%ROWTYPE;
declare v_examinee_ll_metadata examinees.examinees_ll_metadata%ROWTYPE;
declare v_session_id uuid;
begin
select session_id from public.sessions as s where s.summon_date = current_date and s.user_id = v_user_id into v_session_id;
if v_session_id is not null then
select * from examinees.examinees as e where e.user_id = v_user_id into v_examinee;
select * from examinees.examinees_ll_metadata as el where el.user_id = v_user_id into v_examinee_ll_metadata;

if v_examinee_ll_metadata.ll_unique_path = 'NONE' then 
	UPDATE public.session_exams
		SET index = null
		WHERE session_id = v_session_id and exam_type = 'mivdak';
end if;

if v_examinee.dapar_exempt then 
	UPDATE public.session_exams
		SET index = null
		WHERE session_id = v_session_id and exam_type in ('dapar', 'pilots', 'mivdak');
end if;

if v_examinee.hn_type = 'NONE' then 
	UPDATE public.session_exams
		SET index = null
		WHERE session_id = v_session_id and exam_type = 'hn';
end if;

if v_examinee.keshev_exempt then 
	UPDATE public.session_exams
		SET index = null
		WHERE session_id = v_session_id and exam_type = 'keshev';
end if;

PERFORM public.generate_exams_for_session(v_session_id::uuid, TRUE, TRUE, TRUE);

end if;

END;

$$;


ALTER FUNCTION public.recalculate_session(v_user_id uuid) OWNER TO mapaadmin;

--
-- Name: FUNCTION recalculate_session(v_user_id uuid); Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON FUNCTION public.recalculate_session(v_user_id uuid) IS 'this sucked making :P';


--
-- Name: reject_invalid_exam_score(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reject_invalid_exam_score() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.score IS NULL THEN
    UPDATE public.to_sap
    SET status = 'REJECTED - INVALID EXAM'
    WHERE user_id = NEW.user_id
      AND at_date = CURRENT_DATE;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.reject_invalid_exam_score() OWNER TO postgres;

--
-- Name: return_used_exams(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.return_used_exams() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
query text;
BEGIN
	IF (new.index IS not NULL AND old.index IS NULL) THEN
    query := FORMAT(
        'UPDATE %I.exams SET status = %L WHERE exam_id = %L', 
        new.exam_type, 
        null, 
        new.exam_id
    );
    EXECUTE query;
END IF;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.return_used_exams() OWNER TO mapaadmin;

--
-- Name: session_creator(uuid, date); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.session_creator(v_user_id uuid, v_summon_date date) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO
	PUBLIC.SESSIONS (USER_ID, summon_date)
VALUES
	(v_user_id, v_summon_date);

END;
$$;


ALTER FUNCTION public.session_creator(v_user_id uuid, v_summon_date date) OWNER TO mapaadmin;

--
-- Name: trigger_exam_generation_for_session(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.trigger_exam_generation_for_session() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM public.generate_exams_for_session(new.session_id::uuid, TRUE, TRUE, TRUE);

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_exam_generation_for_session() OWNER TO mapaadmin;

--
-- Name: FUNCTION trigger_exam_generation_for_session(); Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON FUNCTION public.trigger_exam_generation_for_session() IS 'create all the exams for an examinee';


--
-- Name: trigger_recalculate_dapar_in_session(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.trigger_recalculate_dapar_in_session() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	perform public.recalculate_dapar_in_session(new.user_id);
	return new;
end;
$$;


ALTER FUNCTION public.trigger_recalculate_dapar_in_session() OWNER TO mapaadmin;

--
-- Name: trigger_recalculate_hn_in_session(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.trigger_recalculate_hn_in_session() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	perform public.recalculate_hn_in_session(new.user_id);
	return new;
end;
$$;


ALTER FUNCTION public.trigger_recalculate_hn_in_session() OWNER TO mapaadmin;

--
-- Name: trigger_recalculate_keshev_in_session(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.trigger_recalculate_keshev_in_session() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	perform public.recalculate_keshev_in_session(new.user_id);
	return new;
end;
$$;


ALTER FUNCTION public.trigger_recalculate_keshev_in_session() OWNER TO mapaadmin;

--
-- Name: trigger_recalculate_session(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.trigger_recalculate_session() RETURNS trigger
    LANGUAGE plpgsql
    AS $$begin
	perform public.recalculate_session(new.user_id);
	return new;
end;$$;


ALTER FUNCTION public.trigger_recalculate_session() OWNER TO mapaadmin;

--
-- Name: update_logs(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.update_logs() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$DECLARE THE_TABLE_NAME TEXT := TG_TABLE_NAME;

THE_SCHEMA_NAME TEXT := TG_TABLE_SCHEMA;

PKEY_COLUMN TEXT;

PKEY_VALUE TEXT;

BEGIN PKEY_COLUMN = (
	SELECT
		COLUMN_NAME
	FROM
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE
	WHERE
		TABLE_NAME = THE_TABLE_NAME
		AND CONSTRAINT_NAME IN (
			SELECT
				CONSTRAINT_NAME
			FROM
				INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE
				TABLE_NAME = THE_TABLE_NAME
				AND CONSTRAINT_TYPE = 'PRIMARY KEY'
		)
	LIMIT
		1
);

IF PKEY_COLUMN IS NOT NULL THEN IF (TG_OP = 'DELETE') THEN
EXECUTE FORMAT('select ($1).%I', PKEY_COLUMN) INTO PKEY_VALUE USING OLD;

ELSE
EXECUTE FORMAT('select ($1).%I', PKEY_COLUMN) INTO PKEY_VALUE USING NEW;

END IF;

ELSE PKEY_VALUE := 'N/A';

END IF;

INSERT INTO
	UPDATE_LOGS (SCHEMA, TABLE_NAME, PKEY, OLD_VALUE, NEW_VALUE)
VALUES
	(
		THE_SCHEMA_NAME,
		THE_TABLE_NAME,
		PKEY_VALUE,
		OLD,
		NEW
	);

RETURN (
	CASE
		WHEN TG_OP = 'DELETE' THEN OLD
		ELSE NEW
	END
);

END;$_$;


ALTER FUNCTION public.update_logs() OWNER TO mapaadmin;

--
-- Name: updated_logs_metadata(); Type: FUNCTION; Schema: public; Owner: mapaadmin
--

CREATE FUNCTION public.updated_logs_metadata() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN NEW.UPDATED_AT = NOW();

NEW.UPDATED_BY = CURRENT_USER;
RETURN NEW;

END;$$;


ALTER FUNCTION public.updated_logs_metadata() OWNER TO mapaadmin;

--
-- Name: FUNCTION updated_logs_metadata(); Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON FUNCTION public.updated_logs_metadata() IS 'what did the drowning number theorist say?





logloglogloglogloglog';


--
-- Name: set_premissions(); Type: FUNCTION; Schema: users; Owner: mapaadmin
--

CREATE FUNCTION users.set_premissions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$





begin





    IF new.status = 'APPROVED' then UPDATE users.users SET role = new.requested_role where user_id = new.user_id;





    end if;





    IF new.status in ('APPROVED', 'REJECTED') then new.granted_at = now();





    end if;





    return new;





end;





$$;


ALTER FUNCTION users.set_premissions() OWNER TO mapaadmin;

--
-- Name: FUNCTION set_premissions(); Type: COMMENT; Schema: users; Owner: mapaadmin
--

COMMENT ON FUNCTION users.set_premissions() IS 'auto premissions fire';


--
-- Name: adaptive_chapters_metadata; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.adaptive_chapters_metadata (
    chapter_id character varying(5) NOT NULL,
    allowed_error numeric(2,1) NOT NULL,
    min_questions integer NOT NULL,
    max_questions integer NOT NULL,
    base_time_per_question integer NOT NULL
);


ALTER TABLE dapar.adaptive_chapters_metadata OWNER TO mapaadmin;

--
-- Name: adaptive_question_metadata; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.adaptive_question_metadata (
    question_id character varying(20) NOT NULL,
    diagnosis double precision NOT NULL,
    difficulty double precision NOT NULL,
    guessing_chance double precision NOT NULL,
    base_question_time integer NOT NULL
);


ALTER TABLE dapar.adaptive_question_metadata OWNER TO mapaadmin;

--
-- Name: answers; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.answers (
    answer_id character varying(20) NOT NULL,
    question_id character varying(20) NOT NULL,
    answer_index integer NOT NULL,
    correct boolean DEFAULT false NOT NULL
);


ALTER TABLE dapar.answers OWNER TO mapaadmin;

--
-- Name: chapters; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.chapters (
    chapter_id character varying(5) NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(200),
    chapter_type dapar.chapter_types NOT NULL,
    base_time integer NOT NULL
);


ALTER TABLE dapar.chapters OWNER TO mapaadmin;

--
-- Name: exams; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.exams (
    exam_id public.exam_id NOT NULL,
    user_id uuid NOT NULL,
    current_chapter character varying(5),
    template integer NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    status public.exam_status
);


ALTER TABLE dapar.exams OWNER TO mapaadmin;

--
-- Name: instructions; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.instructions (
    instruction_index smallint NOT NULL,
    chapter_id character varying(30) NOT NULL,
    content public.url
);


ALTER TABLE dapar.instructions OWNER TO mapaadmin;

--
-- Name: questionnaires; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.questionnaires (
    exam_id public.exam_id NOT NULL,
    user_id uuid NOT NULL,
    chapter_id character varying(5) NOT NULL,
    current_question_id character varying(20),
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    score integer
);


ALTER TABLE dapar.questionnaires OWNER TO mapaadmin;

--
-- Name: questions; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.questions (
    question_id character varying(20) NOT NULL,
    active boolean NOT NULL,
    content public.url NOT NULL
);


ALTER TABLE dapar.questions OWNER TO mapaadmin;

--
-- Name: questions_chapters; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.questions_chapters (
    question_id character varying(20) NOT NULL,
    chapter_id character varying(5) NOT NULL
);


ALTER TABLE dapar.questions_chapters OWNER TO mapaadmin;

--
-- Name: questions_id; Type: SEQUENCE; Schema: dapar; Owner: mapaadmin
--

CREATE SEQUENCE dapar.questions_id
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dapar.questions_id OWNER TO mapaadmin;

--
-- Name: questions_id; Type: SEQUENCE OWNED BY; Schema: dapar; Owner: mapaadmin
--

ALTER SEQUENCE dapar.questions_id OWNED BY dapar.questions.question_id;


--
-- Name: questrion_answers; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.questrion_answers (
    question_id character varying(20) NOT NULL,
    user_id uuid NOT NULL,
    answer_index integer NOT NULL,
    exam_id public.exam_id
);


ALTER TABLE dapar.questrion_answers OWNER TO mapaadmin;

--
-- Name: templates; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.templates (
    template_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(200) NOT NULL
);


ALTER TABLE dapar.templates OWNER TO mapaadmin;

--
-- Name: templates_chapters; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.templates_chapters (
    template_id smallint NOT NULL,
    chapter_id character varying(5) NOT NULL,
    chapter_index smallint NOT NULL
);


ALTER TABLE dapar.templates_chapters OWNER TO mapaadmin;

--
-- Name: user_data_to_template; Type: TABLE; Schema: dapar; Owner: mapaadmin
--

CREATE TABLE dapar.user_data_to_template (
    result_template integer NOT NULL,
    language public.languages DEFAULT 'he'::public.languages NOT NULL,
    ll_unique_path examinees.unique_paths DEFAULT 'NONE'::examinees.unique_paths NOT NULL,
    ll_sight boolean DEFAULT false NOT NULL,
    orthodox boolean DEFAULT false NOT NULL
);


ALTER TABLE dapar.user_data_to_template OWNER TO mapaadmin;

--
-- Name: vw_dapar_exam_chapters; Type: VIEW; Schema: dapar; Owner: mapaadmin
--

CREATE VIEW dapar.vw_dapar_exam_chapters AS
 SELECT e.exam_id,
    tc.chapter_id,
    tc.chapter_index,
    tc.template_id,
        CASE
            WHEN (tc.chapter_index < cur.chapter_index) THEN 'FINISHED'::public.exam_status
            WHEN ((tc.chapter_id)::text = (e.current_chapter)::text) THEN e.status
            ELSE NULL::public.exam_status
        END AS status,
    ((e.current_chapter)::text = (tc.chapter_id)::text) AS is_current
   FROM ((dapar.exams e
     JOIN dapar.templates_chapters tc ON ((tc.template_id = e.template)))
     LEFT JOIN dapar.templates_chapters cur ON (((cur.template_id = e.template) AND ((cur.chapter_id)::text = (e.current_chapter)::text))));


ALTER VIEW dapar.vw_dapar_exam_chapters OWNER TO mapaadmin;

--
-- Name: VIEW vw_dapar_exam_chapters; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON VIEW dapar.vw_dapar_exam_chapters IS 'Ordered chapter list with inferred per-chapter status for dapar exams.';


--
-- Name: vw_user_question_history; Type: VIEW; Schema: dapar; Owner: postgres
--

CREATE VIEW dapar.vw_user_question_history AS
 SELECT qa.user_id,
    qa.question_id,
    a.correct
   FROM (dapar.questrion_answers qa
     JOIN dapar.answers a ON (((a.answer_index = qa.answer_index) AND ((qa.question_id)::text = (a.question_id)::text))));


ALTER VIEW dapar.vw_user_question_history OWNER TO postgres;

--
-- Name: examinees_diagnosis; Type: TABLE; Schema: examinees; Owner: mapaadmin
--

CREATE TABLE examinees.examinees_diagnosis (
    user_id uuid NOT NULL,
    time_extension boolean DEFAULT false NOT NULL,
    adapted_test boolean DEFAULT false NOT NULL,
    severe_arithmetic boolean DEFAULT false NOT NULL,
    enlarged_questionnaire boolean DEFAULT false NOT NULL,
    attention_and_concentration boolean DEFAULT false NOT NULL,
    ll_comitee boolean DEFAULT false NOT NULL,
    diagnosis_approval examinees.diagnosis_approval DEFAULT 'none'::examinees.diagnosis_approval NOT NULL
);


ALTER TABLE examinees.examinees_diagnosis OWNER TO mapaadmin;

--
-- Name: examinees_update_logs; Type: TABLE; Schema: examinees; Owner: mapaadmin
--

CREATE TABLE examinees.examinees_update_logs (
    table_name text NOT NULL,
    pkey text NOT NULL,
    old_value text,
    new_value text,
    updated_at timestamp without time zone NOT NULL,
    updated_by text NOT NULL
);


ALTER TABLE examinees.examinees_update_logs OWNER TO mapaadmin;

--
-- Name: users; Type: TABLE; Schema: users; Owner: mapaadmin
--

CREATE TABLE users.users (
    user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    taz users.taz NOT NULL,
    role users.roles NOT NULL,
    name text NOT NULL
);


ALTER TABLE users.users OWNER TO mapaadmin;

--
-- Name: TABLE users; Type: COMMENT; Schema: users; Owner: mapaadmin
--

COMMENT ON TABLE users.users IS 'all da usrs :)';


--
-- Name: vw_examinee_details; Type: VIEW; Schema: examinees; Owner: mapaadmin
--

CREATE VIEW examinees.vw_examinee_details AS
 SELECT examinees.user_id,
    examinees.hn_type,
    examinees.language,
    examinees.dapar_exempt,
    examinees.orthodox,
    examinees.keshev_exempt,
    examinees_ll_metadata.ll_time_extension,
    examinees_ll_metadata.ll_unique_path,
    examinees_ll_metadata.ll_breaks,
    examinees_ll_metadata.ll_sight,
    examinees_diagnosis.time_extension,
    examinees_diagnosis.adapted_test,
    examinees_diagnosis.severe_arithmetic,
    examinees_diagnosis.enlarged_questionnaire,
    examinees_diagnosis.attention_and_concentration,
    examinees_diagnosis.ll_comitee,
    examinees_diagnosis.diagnosis_approval,
    users.taz,
    users.name
   FROM (((examinees.examinees
     JOIN examinees.examinees_ll_metadata USING (user_id))
     JOIN examinees.examinees_diagnosis USING (user_id))
     JOIN users.users USING (user_id));


ALTER VIEW examinees.vw_examinee_details OWNER TO mapaadmin;

--
-- Name: VIEW vw_examinee_details; Type: COMMENT; Schema: examinees; Owner: mapaadmin
--

COMMENT ON VIEW examinees.vw_examinee_details IS 'Joins examinees + ll_metadata + users into one row per taz for the details page.';


--
-- Name: vw_examinees_users; Type: VIEW; Schema: examinees; Owner: postgres
--

CREATE VIEW examinees.vw_examinees_users AS
 SELECT users.user_id,
    users.taz,
    users.name,
    examinees.language
   FROM (users.users
     JOIN examinees.examinees USING (user_id));


ALTER VIEW examinees.vw_examinees_users OWNER TO postgres;

--
-- Name: answers; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.answers (
    answer_id character varying(20) NOT NULL,
    question_id character varying(20) NOT NULL,
    answer_index integer NOT NULL,
    correct boolean DEFAULT false NOT NULL
);


ALTER TABLE hn.answers OWNER TO mapaadmin;

--
-- Name: chapters; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.chapters (
    chapter_id character varying(5) NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(200),
    base_time integer,
    chapter_type hn.chapter_types
);


ALTER TABLE hn.chapters OWNER TO mapaadmin;

--
-- Name: exams; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.exams (
    exam_id public.exam_id NOT NULL,
    user_id uuid NOT NULL,
    current_chapter character varying(5),
    template integer NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    status public.exam_status
);


ALTER TABLE hn.exams OWNER TO mapaadmin;

--
-- Name: instructions; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.instructions (
    instruction_id uuid NOT NULL,
    chapter_id character varying(5),
    content public.url
);


ALTER TABLE hn.instructions OWNER TO mapaadmin;

--
-- Name: questionnaires; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.questionnaires (
    exam_id public.exam_id NOT NULL,
    user_id uuid NOT NULL,
    chapter_id character varying(5) NOT NULL,
    current_question_id character varying(20),
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    score integer
);


ALTER TABLE hn.questionnaires OWNER TO mapaadmin;

--
-- Name: questions; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.questions (
    question_id character varying(20) NOT NULL,
    active boolean NOT NULL,
    content public.url NOT NULL
);


ALTER TABLE hn.questions OWNER TO mapaadmin;

--
-- Name: questions_chapters; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.questions_chapters (
    question_id character varying(20) NOT NULL,
    chapter_id character varying(5) NOT NULL
);


ALTER TABLE hn.questions_chapters OWNER TO mapaadmin;

--
-- Name: questions_id; Type: SEQUENCE; Schema: hn; Owner: mapaadmin
--

CREATE SEQUENCE hn.questions_id
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hn.questions_id OWNER TO mapaadmin;

--
-- Name: questions_id; Type: SEQUENCE OWNED BY; Schema: hn; Owner: mapaadmin
--

ALTER SEQUENCE hn.questions_id OWNED BY hn.questions.question_id;


--
-- Name: questrion_answers; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.questrion_answers (
    question_id character varying(20) NOT NULL,
    user_id uuid NOT NULL,
    answer_index integer NOT NULL,
    exam_id public.exam_id
);


ALTER TABLE hn.questrion_answers OWNER TO mapaadmin;

--
-- Name: templates; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.templates (
    template_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(200) NOT NULL
);


ALTER TABLE hn.templates OWNER TO mapaadmin;

--
-- Name: templates_chapters; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.templates_chapters (
    template_id integer NOT NULL,
    chapter_id character varying(5) NOT NULL,
    chapter_index smallint NOT NULL
);


ALTER TABLE hn.templates_chapters OWNER TO mapaadmin;

--
-- Name: user_data_to_template; Type: TABLE; Schema: hn; Owner: mapaadmin
--

CREATE TABLE hn.user_data_to_template (
    result_template integer NOT NULL,
    language public.languages DEFAULT 'he'::public.languages NOT NULL,
    hn_type examinees.hn DEFAULT 'NONE'::examinees.hn NOT NULL
);


ALTER TABLE hn.user_data_to_template OWNER TO mapaadmin;

--
-- Name: vw_hn_exam_chapters; Type: VIEW; Schema: hn; Owner: mapaadmin
--

CREATE VIEW hn.vw_hn_exam_chapters AS
 SELECT e.exam_id,
    tc.chapter_id,
    tc.chapter_index,
    tc.template_id,
        CASE
            WHEN (tc.chapter_index < cur.chapter_index) THEN 'FINISHED'::public.exam_status
            WHEN ((tc.chapter_id)::text = (e.current_chapter)::text) THEN e.status
            ELSE NULL::public.exam_status
        END AS status,
    ((e.current_chapter)::text = (tc.chapter_id)::text) AS is_current
   FROM ((hn.exams e
     JOIN hn.templates_chapters tc ON ((tc.template_id = e.template)))
     LEFT JOIN hn.templates_chapters cur ON (((cur.template_id = e.template) AND ((cur.chapter_id)::text = (e.current_chapter)::text))));


ALTER VIEW hn.vw_hn_exam_chapters OWNER TO mapaadmin;

--
-- Name: VIEW vw_hn_exam_chapters; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON VIEW hn.vw_hn_exam_chapters IS 'Ordered chapter list with inferred per-chapter status for hn exams.';


--
-- Name: block_types; Type: TABLE; Schema: keshev; Owner: mapaadmin
--

CREATE TABLE keshev.block_types (
    block_type keshev.blocks NOT NULL,
    stimulant_count integer NOT NULL,
    shape_match_target_exposure_weight integer NOT NULL,
    color_match_target_exposure_weight integer NOT NULL,
    none_match_target_exposure_weight integer NOT NULL,
    target_stimulant_exposure_weight integer NOT NULL,
    is_break_after boolean NOT NULL
);


ALTER TABLE keshev.block_types OWNER TO mapaadmin;

--
-- Name: calculation_periods; Type: TABLE; Schema: keshev; Owner: mapaadmin
--

CREATE TABLE keshev.calculation_periods (
    calculation_period_id numeric NOT NULL,
    start_date timestamp without time zone NOT NULL,
    is_finished boolean NOT NULL
);


ALTER TABLE keshev.calculation_periods OWNER TO mapaadmin;

--
-- Name: cp_ranges; Type: TABLE; Schema: keshev; Owner: mapaadmin
--

CREATE TABLE keshev.cp_ranges (
    calculation_period_id numeric NOT NULL,
    result numeric NOT NULL,
    cp_min double precision NOT NULL,
    cp_max double precision NOT NULL
);


ALTER TABLE keshev.cp_ranges OWNER TO mapaadmin;

--
-- Name: exam_blocks; Type: TABLE; Schema: keshev; Owner: mapaadmin
--

CREATE TABLE keshev.exam_blocks (
    block_id integer NOT NULL,
    exam_id public.exam_id NOT NULL,
    block keshev.blocks NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone
);


ALTER TABLE keshev.exam_blocks OWNER TO mapaadmin;

--
-- Name: exam_stimulants; Type: TABLE; Schema: keshev; Owner: mapaadmin
--

CREATE TABLE keshev.exam_stimulants (
    index numeric NOT NULL,
    stimulant_id character varying(64) NOT NULL,
    "ISI" numeric NOT NULL
);


ALTER TABLE keshev.exam_stimulants OWNER TO mapaadmin;

--
-- Name: exams; Type: TABLE; Schema: keshev; Owner: mapaadmin
--

CREATE TABLE keshev.exams (
    exam_id public.exam_id NOT NULL,
    user_id uuid NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    status public.exam_status,
    score integer
);


ALTER TABLE keshev.exams OWNER TO mapaadmin;

--
-- Name: reactions; Type: TABLE; Schema: keshev; Owner: mapaadmin
--

CREATE TABLE keshev.reactions (
    reaction_id keshev.reaction_id NOT NULL,
    exam_id public.exam_id NOT NULL,
    block_id integer NOT NULL,
    reaction_time numeric NOT NULL,
    is_correct boolean NOT NULL,
    reacted_at timestamp without time zone NOT NULL,
    stimulant_id character varying(64) NOT NULL,
    reacted boolean NOT NULL
);


ALTER TABLE keshev.reactions OWNER TO mapaadmin;

--
-- Name: score_params; Type: TABLE; Schema: keshev; Owner: mapaadmin
--

CREATE TABLE keshev.score_params (
    calculation_period_id numeric NOT NULL,
    average_correct_target_stimulant_reaction_time_mean double precision CONSTRAINT score_params_average_correct_target_stimulant_reaction_not_null NOT NULL,
    average_correct_target_stimulant_reaction_time_sd double precision CONSTRAINT score_params_average_correct_target_stimulant_reactio_not_null1 NOT NULL,
    missed_target_reaction_percentage_mean double precision NOT NULL,
    missed_target_reaction_percentage_sd double precision NOT NULL,
    stiat_teken_mean double precision NOT NULL,
    stiat_teken_sd double precision NOT NULL,
    first_half_false_reaction_percentage_mean double precision NOT NULL,
    first_half_false_reaction_percentage_sd double precision NOT NULL,
    second_half_false_reaction_percentage_mean double precision CONSTRAINT score_params_second_half_false_reaction_percentage_mea_not_null NOT NULL,
    second_half_false_reaction_percentage_sd double precision NOT NULL
);


ALTER TABLE keshev.score_params OWNER TO mapaadmin;

--
-- Name: score_weights; Type: TABLE; Schema: keshev; Owner: mapaadmin
--

CREATE TABLE keshev.score_weights (
    calculation_period_id numeric NOT NULL,
    average_correct_target_stimulant_reaction_time_weight double precision CONSTRAINT score_weights_average_correct_target_stimulant_reactio_not_null NOT NULL,
    missed_target_reaction_percentage_weight double precision NOT NULL,
    stiat_teken_weight double precision NOT NULL,
    first_half_false_reaction_percentage_weight double precision CONSTRAINT score_weights_first_half_false_reaction_percentage_wei_not_null NOT NULL,
    second_half_false_reaction_percentage_weight double precision CONSTRAINT score_weights_second_half_false_reaction_percentage_we_not_null NOT NULL
);


ALTER TABLE keshev.score_weights OWNER TO mapaadmin;

--
-- Name: stimulants; Type: TABLE; Schema: keshev; Owner: mapaadmin
--

CREATE TABLE keshev.stimulants (
    stimulant_id character varying(64) NOT NULL,
    color_id keshev.color NOT NULL,
    shape_id keshev.shape NOT NULL
);


ALTER TABLE keshev.stimulants OWNER TO mapaadmin;

--
-- Name: answers; Type: TABLE; Schema: mivdak; Owner: mapaadmin
--

CREATE TABLE mivdak.answers (
    answer_id character varying(20) NOT NULL,
    question_id character varying(20) NOT NULL,
    answer_index integer NOT NULL,
    correct boolean DEFAULT false NOT NULL
);


ALTER TABLE mivdak.answers OWNER TO mapaadmin;

--
-- Name: chapters; Type: TABLE; Schema: mivdak; Owner: mapaadmin
--

CREATE TABLE mivdak.chapters (
    chapter_id character varying(5) NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(200),
    base_time integer
);


ALTER TABLE mivdak.chapters OWNER TO mapaadmin;

--
-- Name: exams; Type: TABLE; Schema: mivdak; Owner: mapaadmin
--

CREATE TABLE mivdak.exams (
    exam_id public.exam_id NOT NULL,
    user_id uuid NOT NULL,
    current_chapter character varying(5),
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    status public.exam_status
);


ALTER TABLE mivdak.exams OWNER TO mapaadmin;

--
-- Name: instructions; Type: TABLE; Schema: mivdak; Owner: mapaadmin
--

CREATE TABLE mivdak.instructions (
    instruction_id uuid NOT NULL,
    chapter_id character varying(5),
    content public.url
);


ALTER TABLE mivdak.instructions OWNER TO mapaadmin;

--
-- Name: questions; Type: TABLE; Schema: mivdak; Owner: mapaadmin
--

CREATE TABLE mivdak.questions (
    question_id character varying(20) NOT NULL,
    active boolean NOT NULL,
    content public.url NOT NULL
);


ALTER TABLE mivdak.questions OWNER TO mapaadmin;

--
-- Name: question_id; Type: SEQUENCE; Schema: mivdak; Owner: mapaadmin
--

CREATE SEQUENCE mivdak.question_id
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE mivdak.question_id OWNER TO mapaadmin;

--
-- Name: question_id; Type: SEQUENCE OWNED BY; Schema: mivdak; Owner: mapaadmin
--

ALTER SEQUENCE mivdak.question_id OWNED BY mivdak.questions.question_id;


--
-- Name: questionnaires; Type: TABLE; Schema: mivdak; Owner: mapaadmin
--

CREATE TABLE mivdak.questionnaires (
    exam_id public.exam_id NOT NULL,
    chapter_id character varying(5) NOT NULL,
    current_question_id character varying(20),
    started_at timestamp without time zone,
    ended_at timestamp without time zone
);


ALTER TABLE mivdak.questionnaires OWNER TO mapaadmin;

--
-- Name: questions_chapters; Type: TABLE; Schema: mivdak; Owner: mapaadmin
--

CREATE TABLE mivdak.questions_chapters (
    question_id character varying(20) NOT NULL,
    chapter_id character varying(5) NOT NULL
);


ALTER TABLE mivdak.questions_chapters OWNER TO mapaadmin;

--
-- Name: questrion_answers; Type: TABLE; Schema: mivdak; Owner: mapaadmin
--

CREATE TABLE mivdak.questrion_answers (
    question_id character varying(20) NOT NULL,
    user_id uuid NOT NULL,
    answer_index integer NOT NULL,
    exam_id public.exam_id
);


ALTER TABLE mivdak.questrion_answers OWNER TO mapaadmin;

--
-- Name: answers; Type: TABLE; Schema: pilots; Owner: mapaadmin
--

CREATE TABLE pilots.answers (
    answer_id character varying(20) NOT NULL,
    question_id character varying(20) NOT NULL,
    answer_index integer NOT NULL,
    correct boolean DEFAULT false NOT NULL
);


ALTER TABLE pilots.answers OWNER TO mapaadmin;

--
-- Name: chapters; Type: TABLE; Schema: pilots; Owner: mapaadmin
--

CREATE TABLE pilots.chapters (
    chapter_id character varying(20) NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(200),
    max_time integer,
    pilot_type pilots.pilot_types NOT NULL
);


ALTER TABLE pilots.chapters OWNER TO mapaadmin;

--
-- Name: exams; Type: TABLE; Schema: pilots; Owner: mapaadmin
--

CREATE TABLE pilots.exams (
    exam_id public.exam_id NOT NULL,
    user_id uuid NOT NULL,
    current_chapter character varying(5),
    template integer NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    status public.exam_status
);


ALTER TABLE pilots.exams OWNER TO mapaadmin;

--
-- Name: instructions; Type: TABLE; Schema: pilots; Owner: mapaadmin
--

CREATE TABLE pilots.instructions (
    instruction_id uuid NOT NULL,
    chapter_id character varying(30),
    content public.url
);


ALTER TABLE pilots.instructions OWNER TO mapaadmin;

--
-- Name: questionnaires; Type: TABLE; Schema: pilots; Owner: mapaadmin
--

CREATE TABLE pilots.questionnaires (
    exam_id public.exam_id NOT NULL,
    user_id uuid NOT NULL,
    chapter_id character varying(5) NOT NULL,
    current_question_id character varying(20),
    started_at timestamp without time zone,
    ended_at timestamp without time zone
);


ALTER TABLE pilots.questionnaires OWNER TO mapaadmin;

--
-- Name: questions; Type: TABLE; Schema: pilots; Owner: mapaadmin
--

CREATE TABLE pilots.questions (
    question_id character varying(20) DEFAULT nextval('dapar.questions_id'::regclass) NOT NULL,
    active boolean NOT NULL,
    content public.url NOT NULL
);


ALTER TABLE pilots.questions OWNER TO mapaadmin;

--
-- Name: questions_chapters; Type: TABLE; Schema: pilots; Owner: mapaadmin
--

CREATE TABLE pilots.questions_chapters (
    question_id character varying(20) NOT NULL,
    chapter_id character varying(20) NOT NULL
);


ALTER TABLE pilots.questions_chapters OWNER TO mapaadmin;

--
-- Name: questrion_answers; Type: TABLE; Schema: pilots; Owner: mapaadmin
--

CREATE TABLE pilots.questrion_answers (
    question_id character varying(20) NOT NULL,
    user_id uuid NOT NULL,
    answer_index integer NOT NULL,
    exam_id public.exam_id NOT NULL
);


ALTER TABLE pilots.questrion_answers OWNER TO mapaadmin;

--
-- Name: templates_chapters; Type: TABLE; Schema: pilots; Owner: mapaadmin
--

CREATE TABLE pilots.templates_chapters (
    template_id integer NOT NULL,
    chapter_id character varying(5) NOT NULL,
    chapter_index smallint NOT NULL
);


ALTER TABLE pilots.templates_chapters OWNER TO mapaadmin;

--
-- Name: vw_pilots_exam_chapters; Type: VIEW; Schema: pilots; Owner: mapaadmin
--

CREATE VIEW pilots.vw_pilots_exam_chapters AS
 SELECT e.exam_id,
    tc.chapter_id,
    tc.chapter_index,
    tc.template_id,
        CASE
            WHEN (tc.chapter_index < cur.chapter_index) THEN 'FINISHED'::public.exam_status
            WHEN ((tc.chapter_id)::text = (e.current_chapter)::text) THEN e.status
            ELSE NULL::public.exam_status
        END AS status,
    ((e.current_chapter)::text = (tc.chapter_id)::text) AS is_current
   FROM ((pilots.exams e
     JOIN pilots.templates_chapters tc ON ((tc.template_id = e.template)))
     LEFT JOIN pilots.templates_chapters cur ON (((cur.template_id = e.template) AND ((cur.chapter_id)::text = (e.current_chapter)::text))));


ALTER VIEW pilots.vw_pilots_exam_chapters OWNER TO mapaadmin;

--
-- Name: VIEW vw_pilots_exam_chapters; Type: COMMENT; Schema: pilots; Owner: mapaadmin
--

COMMENT ON VIEW pilots.vw_pilots_exam_chapters IS 'Ordered chapter list with inferred per-chapter status for pilots exams.';


--
-- Name: admin_classes; Type: TABLE; Schema: public; Owner: mapaadmin
--

CREATE TABLE public.admin_classes (
    admin_id uuid NOT NULL,
    class_id uuid NOT NULL
);


ALTER TABLE public.admin_classes OWNER TO mapaadmin;

--
-- Name: class_code_seq; Type: SEQUENCE; Schema: public; Owner: mapaadmin
--

CREATE SEQUENCE public.class_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.class_code_seq OWNER TO mapaadmin;

--
-- Name: classes; Type: TABLE; Schema: public; Owner: mapaadmin
--

CREATE TABLE public.classes (
    class_id uuid DEFAULT gen_random_uuid() NOT NULL,
    creator_id uuid NOT NULL,
    code character varying(6) DEFAULT public.generate_random_class_code() NOT NULL,
    location_id uuid NOT NULL,
    started_at date NOT NULL,
    ended_at date NOT NULL
);


ALTER TABLE public.classes OWNER TO mapaadmin;

--
-- Name: dapar_stats; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.dapar_stats AS
 SELECT s.user_id,
    s.score,
    s.chapter_id,
    c.chapter_type,
    (EXISTS ( SELECT 1
           FROM dapar.adaptive_chapters_metadata a
          WHERE ((a.chapter_id)::text = (s.chapter_id)::text))) AS adaptive
   FROM (dapar.questionnaires s
     JOIN dapar.chapters c ON (((c.chapter_id)::text = (s.chapter_id)::text)));


ALTER VIEW public.dapar_stats OWNER TO postgres;

--
-- Name: session_exams; Type: TABLE; Schema: public; Owner: mapaadmin
--

CREATE TABLE public.session_exams (
    exam_id public.exam_id NOT NULL,
    session_id uuid NOT NULL,
    exam_type public.supported_exams NOT NULL,
    index integer,
    user_id uuid NOT NULL
);


ALTER TABLE public.session_exams OWNER TO mapaadmin;

--
-- Name: exam_id_serial; Type: SEQUENCE; Schema: public; Owner: mapaadmin
--

CREATE SEQUENCE public.exam_id_serial
    START WITH 1000000
    INCREMENT BY 1
    MINVALUE 1000000
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exam_id_serial OWNER TO mapaadmin;

--
-- Name: exam_id_serial; Type: SEQUENCE OWNED BY; Schema: public; Owner: mapaadmin
--

ALTER SEQUENCE public.exam_id_serial OWNED BY public.session_exams.exam_id;


--
-- Name: SEQUENCE exam_id_serial; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON SEQUENCE public.exam_id_serial IS 'cereal before milk';


--
-- Name: hn_stats; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.hn_stats AS
 SELECT s.user_id,
    s.score,
    s.chapter_id,
    c.chapter_type,
    false AS adaptive
   FROM (hn.questionnaires s
     JOIN hn.chapters c ON (((c.chapter_id)::text = (s.chapter_id)::text)));


ALTER VIEW public.hn_stats OWNER TO postgres;

--
-- Name: exams; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.exams AS
 SELECT dapar_stats.user_id,
    dapar_stats.score,
    dapar_stats.chapter_id,
    (dapar_stats.chapter_type)::text AS chapter_type,
    dapar_stats.adaptive
   FROM public.dapar_stats
UNION ALL
 SELECT hn_stats.user_id,
    hn_stats.score,
    hn_stats.chapter_id,
    (hn_stats.chapter_type)::text AS chapter_type,
    hn_stats.adaptive
   FROM public.hn_stats;


ALTER VIEW public.exams OWNER TO postgres;

--
-- Name: keshev_stats; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.keshev_stats AS
 SELECT user_id,
    score
   FROM keshev.exams;


ALTER VIEW public.keshev_stats OWNER TO postgres;

--
-- Name: locations; Type: TABLE; Schema: public; Owner: mapaadmin
--

CREATE TABLE public.locations (
    location_id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_name character varying(100) NOT NULL
);


ALTER TABLE public.locations OWNER TO mapaadmin;

--
-- Name: to_sap; Type: TABLE; Schema: public; Owner: mapaadmin
--

CREATE TABLE public.to_sap (
    user_id uuid NOT NULL,
    at_date date DEFAULT now() NOT NULL,
    from_login boolean NOT NULL,
    status public.mimshak_statuses DEFAULT 'PENDING'::public.mimshak_statuses NOT NULL
);


ALTER TABLE public.to_sap OWNER TO mapaadmin;

--
-- Name: mv_today_user_json; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_today_user_json AS
 WITH today_people AS (
         SELECT to_sap.user_id
           FROM public.to_sap
          WHERE ((to_sap.at_date = CURRENT_DATE) AND (to_sap.status IS DISTINCT FROM 'REJECTED - INVALID EXAM'::public.mimshak_statuses))
        )
 SELECT p.user_id,
    CURRENT_DATE AS created_at,
    ex.language,
    json_build_object('exams', COALESCE(e.exams, '[]'::json), 'keshev', COALESCE(k.keshev, '[]'::json)) AS data
   FROM (((today_people p
     LEFT JOIN examinees.examinees ex ON ((ex.user_id = p.user_id)))
     LEFT JOIN LATERAL ( SELECT json_agg(json_build_object('score', v.score, 'chapter_id', v.chapter_id, 'chapter_type', v.chapter_type, 'adaptive', v.adaptive)) AS exams
           FROM public.exams v
          WHERE (v.user_id = p.user_id)) e ON (true))
     LEFT JOIN LATERAL ( SELECT json_agg(json_build_object('score', v.score)) AS keshev
           FROM public.keshev_stats v
          WHERE (v.user_id = p.user_id)) k ON (true))
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.mv_today_user_json OWNER TO postgres;

--
-- Name: patches; Type: TABLE; Schema: public; Owner: mapaadmin
--

CREATE TABLE public.patches (
    version character varying(8) NOT NULL,
    release_date timestamp without time zone DEFAULT now() NOT NULL,
    patch_notes text[] NOT NULL
);


ALTER TABLE public.patches OWNER TO mapaadmin;

--
-- Name: TABLE patches; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON TABLE public.patches IS 'patch notes and version numbers';


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: mapaadmin
--

CREATE TABLE public.sessions (
    session_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    active boolean DEFAULT true NOT NULL,
    current_index integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    started_at timestamp without time zone,
    class_id uuid,
    summon_date date DEFAULT now() NOT NULL
);


ALTER TABLE public.sessions OWNER TO mapaadmin;

--
-- Name: update_logs; Type: TABLE; Schema: public; Owner: mapaadmin
--

CREATE TABLE public.update_logs (
    schema text NOT NULL,
    table_name text NOT NULL,
    pkey text NOT NULL,
    old_value text,
    new_value text,
    updated_at timestamp without time zone NOT NULL,
    updated_by text NOT NULL
);


ALTER TABLE public.update_logs OWNER TO mapaadmin;

--
-- Name: vw_active_classes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_active_classes AS
 SELECT classes.class_id,
    classes.code,
    locations.location_name
   FROM (public.classes
     JOIN public.locations USING (location_id))
  WHERE ((CURRENT_DATE >= classes.started_at) AND (CURRENT_DATE <= classes.ended_at));


ALTER VIEW public.vw_active_classes OWNER TO postgres;

--
-- Name: vw_exam_chapters; Type: VIEW; Schema: public; Owner: mapaadmin
--

CREATE VIEW public.vw_exam_chapters AS
 SELECT vw_dapar_exam_chapters.exam_id,
    'dapar'::public.supported_exams AS exam_type,
    vw_dapar_exam_chapters.chapter_id,
    vw_dapar_exam_chapters.chapter_index,
    vw_dapar_exam_chapters.status,
    vw_dapar_exam_chapters.is_current,
    vw_dapar_exam_chapters.template_id
   FROM dapar.vw_dapar_exam_chapters
UNION ALL
 SELECT vw_hn_exam_chapters.exam_id,
    'hn'::public.supported_exams AS exam_type,
    vw_hn_exam_chapters.chapter_id,
    vw_hn_exam_chapters.chapter_index,
    vw_hn_exam_chapters.status,
    vw_hn_exam_chapters.is_current,
    vw_hn_exam_chapters.template_id
   FROM hn.vw_hn_exam_chapters
UNION ALL
 SELECT vw_pilots_exam_chapters.exam_id,
    'pilots'::public.supported_exams AS exam_type,
    vw_pilots_exam_chapters.chapter_id,
    vw_pilots_exam_chapters.chapter_index,
    vw_pilots_exam_chapters.status,
    vw_pilots_exam_chapters.is_current,
    vw_pilots_exam_chapters.template_id
   FROM pilots.vw_pilots_exam_chapters;


ALTER VIEW public.vw_exam_chapters OWNER TO mapaadmin;

--
-- Name: VIEW vw_exam_chapters; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON VIEW public.vw_exam_chapters IS 'Composer: chapters across all chapter-based schemas. Empty for keshev (no chapters).';


--
-- Name: vw_exam_status; Type: VIEW; Schema: public; Owner: mapaadmin
--

CREATE VIEW public.vw_exam_status AS
 SELECT exams.exam_id,
    'dapar'::public.supported_exams AS exam_type,
    exams.status
   FROM dapar.exams
UNION ALL
 SELECT exams.exam_id,
    'hn'::public.supported_exams AS exam_type,
    exams.status
   FROM hn.exams
UNION ALL
 SELECT exams.exam_id,
    'mivdak'::public.supported_exams AS exam_type,
    exams.status
   FROM mivdak.exams
UNION ALL
 SELECT exams.exam_id,
    'pilots'::public.supported_exams AS exam_type,
    exams.status
   FROM pilots.exams
UNION ALL
 SELECT exams.exam_id,
    'keshev'::public.supported_exams AS exam_type,
    exams.status
   FROM keshev.exams;


ALTER VIEW public.vw_exam_status OWNER TO mapaadmin;

--
-- Name: VIEW vw_exam_status; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON VIEW public.vw_exam_status IS 'Single source of truth for exam status. Status now lives directly on <x>.exams.';


--
-- Name: vw_examinee_sessions; Type: VIEW; Schema: public; Owner: mapaadmin
--

CREATE VIEW public.vw_examinee_sessions AS
 SELECT u.user_id,
    u.taz,
    u.name,
    s.session_id,
    s.active,
    s.current_index,
    s.class_id,
    s.started_at,
    l.location_name,
    se.exam_id,
    se.exam_type,
    se.index,
    es.status
   FROM (((((public.sessions s
     JOIN users.users u USING (user_id))
     JOIN public.session_exams se USING (session_id))
     LEFT JOIN public.classes c ON ((c.class_id = s.class_id)))
     LEFT JOIN public.locations l USING (location_id))
     LEFT JOIN public.vw_exam_status es ON (((es.exam_id)::integer = (se.exam_id)::integer)))
  WHERE (s.summon_date = CURRENT_DATE);


ALTER VIEW public.vw_examinee_sessions OWNER TO mapaadmin;

--
-- Name: VIEW vw_examinee_sessions; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON VIEW public.vw_examinee_sessions IS 'All sessions an examinee has — active and past. One row per (session × exam). Filters out scheduled sessions that never ran (active=false AND started_at IS NULL). Replaces vw_sessions_history and vw_current_session_exam — consumers filter by active=true and/or index = current_index as needed.';


--
-- Name: perm_requests; Type: TABLE; Schema: users; Owner: mapaadmin
--

CREATE TABLE users.perm_requests (
    user_id uuid NOT NULL,
    requested_role users.roles NOT NULL,
    status users.permission_requests_status NOT NULL,
    requested_at timestamp without time zone DEFAULT now() NOT NULL,
    granted_at timestamp without time zone DEFAULT now()
);


ALTER TABLE users.perm_requests OWNER TO mapaadmin;

--
-- Name: TABLE perm_requests; Type: COMMENT; Schema: users; Owner: mapaadmin
--

COMMENT ON TABLE users.perm_requests IS 'the people want parmesan cheese! permission cheese! pa





permis





parmesan cheese!  ';


--
-- Name: questions question_id; Type: DEFAULT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questions ALTER COLUMN question_id SET DEFAULT nextval('dapar.questions_id'::regclass);


--
-- Name: questions question_id; Type: DEFAULT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questions ALTER COLUMN question_id SET DEFAULT nextval('hn.questions_id'::regclass);


--
-- Name: questions question_id; Type: DEFAULT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questions ALTER COLUMN question_id SET DEFAULT nextval('mivdak.question_id'::regclass);


--
-- Name: session_exams exam_id; Type: DEFAULT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.session_exams ALTER COLUMN exam_id SET DEFAULT nextval('public.exam_id_serial'::regclass);


--
-- Name: adaptive_chapters_metadata adaptive-chapters_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.adaptive_chapters_metadata
    ADD CONSTRAINT "adaptive-chapters_pkey" PRIMARY KEY (chapter_id);


--
-- Name: adaptive_question_metadata adaptive_question_metadata_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.adaptive_question_metadata
    ADD CONSTRAINT adaptive_question_metadata_pkey PRIMARY KEY (question_id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (answer_id);


--
-- Name: chapters classic-chapters_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.chapters
    ADD CONSTRAINT "classic-chapters_pkey" PRIMARY KEY (chapter_id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (exam_id);


--
-- Name: instructions instructions_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.instructions
    ADD CONSTRAINT instructions_pkey PRIMARY KEY (chapter_id, instruction_index);


--
-- Name: questionnaires questionnaires_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questionnaires
    ADD CONSTRAINT questionnaires_pkey PRIMARY KEY (exam_id, chapter_id);


--
-- Name: questions_chapters questions_chapters_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questions_chapters
    ADD CONSTRAINT questions_chapters_pkey PRIMARY KEY (question_id, chapter_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- Name: questrion_answers questrion_answers_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questrion_answers
    ADD CONSTRAINT questrion_answers_pkey PRIMARY KEY (question_id, user_id);


--
-- Name: templates_chapters templates_chapters_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.templates_chapters
    ADD CONSTRAINT templates_chapters_pkey PRIMARY KEY (template_id, chapter_id);


--
-- Name: templates templates_pkey; Type: CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (template_id);


--
-- Name: examinees_diagnosis diagnosis_pkey; Type: CONSTRAINT; Schema: examinees; Owner: mapaadmin
--

ALTER TABLE ONLY examinees.examinees_diagnosis
    ADD CONSTRAINT diagnosis_pkey PRIMARY KEY (user_id);


--
-- Name: examinees_ll_metadata users_ll_metadata_pkey; Type: CONSTRAINT; Schema: examinees; Owner: mapaadmin
--

ALTER TABLE ONLY examinees.examinees_ll_metadata
    ADD CONSTRAINT users_ll_metadata_pkey PRIMARY KEY (user_id);


--
-- Name: examinees users_pkey; Type: CONSTRAINT; Schema: examinees; Owner: mapaadmin
--

ALTER TABLE ONLY examinees.examinees
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (answer_id);


--
-- Name: chapters chapters_pkey; Type: CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.chapters
    ADD CONSTRAINT chapters_pkey PRIMARY KEY (chapter_id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (exam_id);


--
-- Name: instructions instructions_pkey; Type: CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.instructions
    ADD CONSTRAINT instructions_pkey PRIMARY KEY (instruction_id);


--
-- Name: questionnaires questionnaires_pkey; Type: CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questionnaires
    ADD CONSTRAINT questionnaires_pkey PRIMARY KEY (exam_id, chapter_id);


--
-- Name: questions_chapters questions_chapters_pkey; Type: CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questions_chapters
    ADD CONSTRAINT questions_chapters_pkey PRIMARY KEY (question_id, chapter_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- Name: questrion_answers questrion_answers_pkey; Type: CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questrion_answers
    ADD CONSTRAINT questrion_answers_pkey PRIMARY KEY (question_id, user_id);


--
-- Name: templates_chapters templates_chapters_pkey; Type: CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.templates_chapters
    ADD CONSTRAINT templates_chapters_pkey PRIMARY KEY (template_id, chapter_id);


--
-- Name: templates templates_pkey; Type: CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (template_id);


--
-- Name: block_types block_types_pkey; Type: CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.block_types
    ADD CONSTRAINT block_types_pkey PRIMARY KEY (block_type);


--
-- Name: calculation_periods calculation_periods_pkey; Type: CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.calculation_periods
    ADD CONSTRAINT calculation_periods_pkey PRIMARY KEY (calculation_period_id);


--
-- Name: cp_ranges cp_ranges_pkey; Type: CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.cp_ranges
    ADD CONSTRAINT cp_ranges_pkey PRIMARY KEY (calculation_period_id, result);


--
-- Name: exam_blocks exam_blocks_pkey; Type: CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.exam_blocks
    ADD CONSTRAINT exam_blocks_pkey PRIMARY KEY (exam_id, block_id);


--
-- Name: exam_stimulants exam_stimulants_pkey; Type: CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.exam_stimulants
    ADD CONSTRAINT exam_stimulants_pkey PRIMARY KEY (index);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (exam_id);


--
-- Name: reactions reaction_blocks_pkey; Type: CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.reactions
    ADD CONSTRAINT reaction_blocks_pkey PRIMARY KEY (reaction_id, block_id);


--
-- Name: score_params score_params_pkey; Type: CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.score_params
    ADD CONSTRAINT score_params_pkey PRIMARY KEY (calculation_period_id);


--
-- Name: score_weights score_weights_pkey; Type: CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.score_weights
    ADD CONSTRAINT score_weights_pkey PRIMARY KEY (calculation_period_id);


--
-- Name: stimulants stimulants_pkey; Type: CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.stimulants
    ADD CONSTRAINT stimulants_pkey PRIMARY KEY (stimulant_id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (answer_id);


--
-- Name: chapters chapters_pkey; Type: CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.chapters
    ADD CONSTRAINT chapters_pkey PRIMARY KEY (chapter_id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (exam_id);


--
-- Name: instructions instructions_pkey; Type: CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.instructions
    ADD CONSTRAINT instructions_pkey PRIMARY KEY (instruction_id);


--
-- Name: questionnaires questionnaires_pkey; Type: CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questionnaires
    ADD CONSTRAINT questionnaires_pkey PRIMARY KEY (exam_id, chapter_id);


--
-- Name: questions_chapters questions_chapters_pkey; Type: CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questions_chapters
    ADD CONSTRAINT questions_chapters_pkey PRIMARY KEY (question_id, chapter_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- Name: questrion_answers questrion_answers_pkey; Type: CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questrion_answers
    ADD CONSTRAINT questrion_answers_pkey PRIMARY KEY (question_id, user_id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (answer_id);


--
-- Name: chapters chapters_pkey; Type: CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.chapters
    ADD CONSTRAINT chapters_pkey PRIMARY KEY (chapter_id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (exam_id);


--
-- Name: instructions instructions_pkey; Type: CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.instructions
    ADD CONSTRAINT instructions_pkey PRIMARY KEY (instruction_id);


--
-- Name: questionnaires questionnaires_pkey; Type: CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questionnaires
    ADD CONSTRAINT questionnaires_pkey PRIMARY KEY (exam_id, chapter_id);


--
-- Name: questions_chapters questions_chapters_pkey; Type: CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questions_chapters
    ADD CONSTRAINT questions_chapters_pkey PRIMARY KEY (question_id, chapter_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- Name: questrion_answers questrion_answers_pkey; Type: CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questrion_answers
    ADD CONSTRAINT questrion_answers_pkey PRIMARY KEY (question_id, user_id);


--
-- Name: templates_chapters templates_chapters_pkey; Type: CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.templates_chapters
    ADD CONSTRAINT templates_chapters_pkey PRIMARY KEY (template_id, chapter_id);


--
-- Name: admin_classes admin_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.admin_classes
    ADD CONSTRAINT admin_classes_pkey PRIMARY KEY (admin_id, class_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class_id);


--
-- Name: locations location_name_unique; Type: CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT location_name_unique UNIQUE (location_name);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (location_id);


--
-- Name: to_sap mapa-to-sapa-extras_pkey; Type: CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.to_sap
    ADD CONSTRAINT "mapa-to-sapa-extras_pkey" PRIMARY KEY (user_id, at_date);


--
-- Name: session_exams one_index_per_session; Type: CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.session_exams
    ADD CONSTRAINT one_index_per_session UNIQUE (session_id, index);


--
-- Name: patches patches_pkey; Type: CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.patches
    ADD CONSTRAINT patches_pkey PRIMARY KEY (version);


--
-- Name: session_exams session_exams_pkey; Type: CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.session_exams
    ADD CONSTRAINT session_exams_pkey PRIMARY KEY (exam_id);


--
-- Name: sessions session_pkey; Type: CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT session_pkey PRIMARY KEY (session_id);


--
-- Name: classes started_at_before_ended_at; Type: CHECK CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE public.classes
    ADD CONSTRAINT started_at_before_ended_at CHECK ((started_at <= ended_at)) NOT VALID;


--
-- Name: perm_requests perm_requests_pkey; Type: CONSTRAINT; Schema: users; Owner: mapaadmin
--

ALTER TABLE ONLY users.perm_requests
    ADD CONSTRAINT perm_requests_pkey PRIMARY KEY (user_id, requested_role);


--
-- Name: users unique_taz; Type: CONSTRAINT; Schema: users; Owner: mapaadmin
--

ALTER TABLE ONLY users.users
    ADD CONSTRAINT unique_taz UNIQUE (taz);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: users; Owner: mapaadmin
--

ALTER TABLE ONLY users.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: one_active_dapar_exam; Type: INDEX; Schema: dapar; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_active_dapar_exam ON dapar.exams USING btree (exam_id) WHERE (status = 'IN_PROGRESS'::public.exam_status);


--
-- Name: one_answer_per_index; Type: INDEX; Schema: dapar; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_answer_per_index ON dapar.answers USING btree (question_id, answer_index);


--
-- Name: one_correct_answer_per_question; Type: INDEX; Schema: dapar; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_correct_answer_per_question ON dapar.answers USING btree (question_id) WHERE (correct IS TRUE);


--
-- Name: idx_examinees_update_logs_table; Type: INDEX; Schema: examinees; Owner: mapaadmin
--

CREATE INDEX idx_examinees_update_logs_table ON examinees.examinees_update_logs USING btree (table_name);


--
-- Name: one_active_hn_exam; Type: INDEX; Schema: hn; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_active_hn_exam ON hn.exams USING btree (exam_id) WHERE (status = 'IN_PROGRESS'::public.exam_status);


--
-- Name: one_answer_per_index; Type: INDEX; Schema: hn; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_answer_per_index ON hn.answers USING btree (question_id, answer_index);


--
-- Name: one_correct_answer_per_question; Type: INDEX; Schema: hn; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_correct_answer_per_question ON hn.answers USING btree (question_id) WHERE (correct IS TRUE);


--
-- Name: one_active_keshev_exam; Type: INDEX; Schema: keshev; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_active_keshev_exam ON keshev.exams USING btree (exam_id) WHERE (status = 'IN_PROGRESS'::public.exam_status);


--
-- Name: one_active_mivdak_exam; Type: INDEX; Schema: mivdak; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_active_mivdak_exam ON mivdak.exams USING btree (exam_id) WHERE (status = 'IN_PROGRESS'::public.exam_status);


--
-- Name: one_answer_per_index; Type: INDEX; Schema: mivdak; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_answer_per_index ON mivdak.answers USING btree (question_id, answer_index);


--
-- Name: one_questionnaire_per_exam; Type: INDEX; Schema: mivdak; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_questionnaire_per_exam ON mivdak.questionnaires USING btree (exam_id);


--
-- Name: one_active_pilots_exam; Type: INDEX; Schema: pilots; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_active_pilots_exam ON pilots.exams USING btree (exam_id) WHERE (status = 'IN_PROGRESS'::public.exam_status);


--
-- Name: one_answer_per_index; Type: INDEX; Schema: pilots; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_answer_per_index ON pilots.answers USING btree (question_id, answer_index);


--
-- Name: one_correct_answer_per_question; Type: INDEX; Schema: pilots; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_correct_answer_per_question ON pilots.answers USING btree (question_id) WHERE (correct IS TRUE);


--
-- Name: idx_sessions_user_id; Type: INDEX; Schema: public; Owner: mapaadmin
--

CREATE INDEX idx_sessions_user_id ON public.sessions USING btree (user_id);


--
-- Name: idx_update_logs_table; Type: INDEX; Schema: public; Owner: mapaadmin
--

CREATE INDEX idx_update_logs_table ON public.update_logs USING btree (table_name);


--
-- Name: one_active_session_per_user; Type: INDEX; Schema: public; Owner: mapaadmin
--

CREATE UNIQUE INDEX one_active_session_per_user ON public.sessions USING btree (user_id) WHERE (active IS TRUE);


--
-- Name: exams create_questionnaires_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER create_questionnaires_trigger AFTER INSERT ON dapar.exams FOR EACH ROW EXECUTE FUNCTION dapar.generate_dapar_questionnaires();


--
-- Name: exams trg_dapar_exam_status_updated; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER trg_dapar_exam_status_updated AFTER UPDATE OF status ON dapar.exams FOR EACH ROW EXECUTE FUNCTION public.notify_exam_status_updated();


--
-- Name: questionnaires trg_reject_invalid_dapar; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER trg_reject_invalid_dapar AFTER INSERT OR UPDATE OF score ON dapar.questionnaires FOR EACH ROW EXECUTE FUNCTION public.reject_invalid_exam_score();


--
-- Name: adaptive_chapters_metadata update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.adaptive_chapters_metadata FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON adaptive_chapters_metadata; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.adaptive_chapters_metadata IS 'log updates for the table';


--
-- Name: adaptive_question_metadata update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.adaptive_question_metadata FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON adaptive_question_metadata; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.adaptive_question_metadata IS 'log updates for the table';


--
-- Name: answers update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.answers FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON answers; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.answers IS 'log updates for the table';


--
-- Name: chapters update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON chapters; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.chapters IS 'log updates for the table';


--
-- Name: exams update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.exams FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON exams; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.exams IS 'log updates for the table';


--
-- Name: instructions update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.instructions FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON instructions; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.instructions IS 'log updates for the table';


--
-- Name: questionnaires update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.questionnaires FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questionnaires; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.questionnaires IS 'log updates for the table';


--
-- Name: questions update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.questions FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questions; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.questions IS 'log updates for the table';


--
-- Name: questions_chapters update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.questions_chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questions_chapters; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.questions_chapters IS 'log updates for the table';


--
-- Name: questrion_answers update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.questrion_answers FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questrion_answers; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.questrion_answers IS 'log updates for the table';


--
-- Name: templates update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.templates FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON templates; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.templates IS 'log updates for the table';


--
-- Name: templates_chapters update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.templates_chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON templates_chapters; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.templates_chapters IS 'log updates for the table';


--
-- Name: user_data_to_template update_logs_trigger; Type: TRIGGER; Schema: dapar; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON dapar.user_data_to_template FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON user_data_to_template; Type: COMMENT; Schema: dapar; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON dapar.user_data_to_template IS 'log updates for the table';


--
-- Name: examinees_ll_metadata create_diagnosis_for_examinee_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER create_diagnosis_for_examinee_trigger AFTER INSERT ON examinees.examinees_ll_metadata FOR EACH ROW EXECUTE FUNCTION examinees.create_examinee_diagnosis();


--
-- Name: examinees examinee_details_updated_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER examinee_details_updated_trigger AFTER UPDATE ON examinees.examinees FOR EACH ROW EXECUTE FUNCTION examinees.notify_examinee_details_updated();


--
-- Name: examinees examinees_update_logs_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER examinees_update_logs_trigger AFTER DELETE OR UPDATE ON examinees.examinees FOR EACH ROW EXECUTE FUNCTION examinees.examinees_update_logs();


--
-- Name: examinees_diagnosis examinees_update_logs_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER examinees_update_logs_trigger AFTER DELETE OR UPDATE ON examinees.examinees_diagnosis FOR EACH ROW EXECUTE FUNCTION examinees.examinees_update_logs();


--
-- Name: examinees_ll_metadata examinees_update_logs_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER examinees_update_logs_trigger AFTER DELETE OR UPDATE ON examinees.examinees_ll_metadata FOR EACH ROW EXECUTE FUNCTION examinees.examinees_update_logs();


--
-- Name: examinees_update_logs get_logs_meta_data; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER get_logs_meta_data BEFORE INSERT ON examinees.examinees_update_logs FOR EACH ROW EXECUTE FUNCTION public.updated_logs_metadata();


--
-- Name: TRIGGER get_logs_meta_data ON examinees_update_logs; Type: COMMENT; Schema: examinees; Owner: mapaadmin
--

COMMENT ON TRIGGER get_logs_meta_data ON examinees.examinees_update_logs IS 'meta';


--
-- Name: examinees recalculate_dapar_in_session_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER recalculate_dapar_in_session_trigger AFTER UPDATE OF language, dapar_exempt, orthodox ON examinees.examinees FOR EACH ROW EXECUTE FUNCTION public.trigger_recalculate_dapar_in_session();


--
-- Name: examinees_ll_metadata recalculate_dapar_in_session_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER recalculate_dapar_in_session_trigger AFTER UPDATE OF ll_time_extension, ll_unique_path ON examinees.examinees_ll_metadata FOR EACH ROW EXECUTE FUNCTION public.trigger_recalculate_dapar_in_session();


--
-- Name: examinees recalculate_hn_in_session_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER recalculate_hn_in_session_trigger AFTER UPDATE OF hn_type, language ON examinees.examinees FOR EACH ROW EXECUTE FUNCTION public.trigger_recalculate_hn_in_session();


--
-- Name: examinees recalculate_keshev_in_session_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER recalculate_keshev_in_session_trigger AFTER UPDATE OF keshev_exempt ON examinees.examinees FOR EACH ROW EXECUTE FUNCTION public.trigger_recalculate_keshev_in_session();


--
-- Name: examinees recalculate_session_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER recalculate_session_trigger AFTER UPDATE OF hn_type, language, dapar_exempt, orthodox, keshev_exempt ON examinees.examinees FOR EACH ROW EXECUTE FUNCTION public.trigger_recalculate_session();

ALTER TABLE examinees.examinees DISABLE TRIGGER recalculate_session_trigger;


--
-- Name: examinees_ll_metadata recalculate_session_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER recalculate_session_trigger AFTER UPDATE OF ll_time_extension, ll_unique_path ON examinees.examinees_ll_metadata FOR EACH ROW EXECUTE FUNCTION public.trigger_recalculate_session();

ALTER TABLE examinees.examinees_ll_metadata DISABLE TRIGGER recalculate_session_trigger;


--
-- Name: examinees_diagnosis update_ll_metadata_by_diagnosis_trigger; Type: TRIGGER; Schema: examinees; Owner: mapaadmin
--

CREATE TRIGGER update_ll_metadata_by_diagnosis_trigger AFTER UPDATE ON examinees.examinees_diagnosis FOR EACH ROW EXECUTE FUNCTION examinees.update_ll_metadata_by_diagnosis();


--
-- Name: exams create_questionnaires_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER create_questionnaires_trigger AFTER INSERT ON hn.exams FOR EACH ROW EXECUTE FUNCTION hn.generate_hn_questionnaires();


--
-- Name: exams trg_hn_exam_status_updated; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER trg_hn_exam_status_updated AFTER UPDATE OF status ON hn.exams FOR EACH ROW EXECUTE FUNCTION public.notify_exam_status_updated();


--
-- Name: questionnaires trg_reject_invalid_hn; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER trg_reject_invalid_hn AFTER INSERT OR UPDATE OF score ON hn.questionnaires FOR EACH ROW EXECUTE FUNCTION public.reject_invalid_exam_score();


--
-- Name: answers update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.answers FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON answers; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.answers IS 'log updates for the table';


--
-- Name: chapters update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON chapters; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.chapters IS 'log updates for the table';


--
-- Name: exams update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.exams FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON exams; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.exams IS 'log updates for the table';


--
-- Name: instructions update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.instructions FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON instructions; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.instructions IS 'log updates for the table';


--
-- Name: questionnaires update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.questionnaires FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questionnaires; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.questionnaires IS 'log updates for the table';


--
-- Name: questions update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.questions FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questions; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.questions IS 'log updates for the table';


--
-- Name: questions_chapters update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.questions_chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questions_chapters; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.questions_chapters IS 'log updates for the table';


--
-- Name: questrion_answers update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.questrion_answers FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questrion_answers; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.questrion_answers IS 'log updates for the table';


--
-- Name: templates update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.templates FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON templates; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.templates IS 'log updates for the table';


--
-- Name: templates_chapters update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.templates_chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON templates_chapters; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.templates_chapters IS 'log updates for the table';


--
-- Name: user_data_to_template update_logs_trigger; Type: TRIGGER; Schema: hn; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON hn.user_data_to_template FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON user_data_to_template; Type: COMMENT; Schema: hn; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON hn.user_data_to_template IS 'log updates for the table';


--
-- Name: exams trg_keshev_exam_status_updated; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER trg_keshev_exam_status_updated AFTER UPDATE OF status ON keshev.exams FOR EACH ROW EXECUTE FUNCTION public.notify_exam_status_updated();


--
-- Name: exams trg_reject_invalid_keshev; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER trg_reject_invalid_keshev AFTER INSERT OR UPDATE OF score ON keshev.exams FOR EACH ROW EXECUTE FUNCTION public.reject_invalid_exam_score();


--
-- Name: block_types update_logs_trigger; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON keshev.block_types FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON block_types; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON keshev.block_types IS 'log updates for the table';


--
-- Name: calculation_periods update_logs_trigger; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON keshev.calculation_periods FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON calculation_periods; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON keshev.calculation_periods IS 'log updates for the table';


--
-- Name: cp_ranges update_logs_trigger; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON keshev.cp_ranges FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON cp_ranges; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON keshev.cp_ranges IS 'log updates for the table';


--
-- Name: exam_blocks update_logs_trigger; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON keshev.exam_blocks FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON exam_blocks; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON keshev.exam_blocks IS 'log updates for the table';


--
-- Name: exam_stimulants update_logs_trigger; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON keshev.exam_stimulants FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON exam_stimulants; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON keshev.exam_stimulants IS 'log updates for the table';


--
-- Name: exams update_logs_trigger; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON keshev.exams FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON exams; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON keshev.exams IS 'log updates for the table';


--
-- Name: reactions update_logs_trigger; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON keshev.reactions FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON reactions; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON keshev.reactions IS 'log updates for the table';


--
-- Name: score_params update_logs_trigger; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON keshev.score_params FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON score_params; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON keshev.score_params IS 'log updates for the table';


--
-- Name: score_weights update_logs_trigger; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON keshev.score_weights FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON score_weights; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON keshev.score_weights IS 'log updates for the table';


--
-- Name: stimulants update_logs_trigger; Type: TRIGGER; Schema: keshev; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON keshev.stimulants FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON stimulants; Type: COMMENT; Schema: keshev; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON keshev.stimulants IS 'log updates for the table';


--
-- Name: exams create_questionnaires_trigger; Type: TRIGGER; Schema: mivdak; Owner: mapaadmin
--

CREATE TRIGGER create_questionnaires_trigger AFTER INSERT ON mivdak.exams FOR EACH ROW EXECUTE FUNCTION mivdak.generate_mivdak_questionnaires();


--
-- Name: exams trg_mivdak_exam_status_updated; Type: TRIGGER; Schema: mivdak; Owner: mapaadmin
--

CREATE TRIGGER trg_mivdak_exam_status_updated AFTER UPDATE OF status ON mivdak.exams FOR EACH ROW EXECUTE FUNCTION public.notify_exam_status_updated();


--
-- Name: answers update_logs_trigger; Type: TRIGGER; Schema: mivdak; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON mivdak.answers FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON answers; Type: COMMENT; Schema: mivdak; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON mivdak.answers IS 'log updates for the table';


--
-- Name: chapters update_logs_trigger; Type: TRIGGER; Schema: mivdak; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON mivdak.chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON chapters; Type: COMMENT; Schema: mivdak; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON mivdak.chapters IS 'log updates for the table';


--
-- Name: exams update_logs_trigger; Type: TRIGGER; Schema: mivdak; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON mivdak.exams FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON exams; Type: COMMENT; Schema: mivdak; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON mivdak.exams IS 'log updates for the table';


--
-- Name: instructions update_logs_trigger; Type: TRIGGER; Schema: mivdak; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON mivdak.instructions FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON instructions; Type: COMMENT; Schema: mivdak; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON mivdak.instructions IS 'log updates for the table';


--
-- Name: questionnaires update_logs_trigger; Type: TRIGGER; Schema: mivdak; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON mivdak.questionnaires FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questionnaires; Type: COMMENT; Schema: mivdak; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON mivdak.questionnaires IS 'log updates for the table';


--
-- Name: questions update_logs_trigger; Type: TRIGGER; Schema: mivdak; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON mivdak.questions FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questions; Type: COMMENT; Schema: mivdak; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON mivdak.questions IS 'log updates for the table';


--
-- Name: questions_chapters update_logs_trigger; Type: TRIGGER; Schema: mivdak; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON mivdak.questions_chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questions_chapters; Type: COMMENT; Schema: mivdak; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON mivdak.questions_chapters IS 'log updates for the table';


--
-- Name: questrion_answers update_logs_trigger; Type: TRIGGER; Schema: mivdak; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON mivdak.questrion_answers FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questrion_answers; Type: COMMENT; Schema: mivdak; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON mivdak.questrion_answers IS 'log updates for the table';


--
-- Name: exams create_questionnaires_trigger; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER create_questionnaires_trigger AFTER INSERT ON pilots.exams FOR EACH ROW EXECUTE FUNCTION pilots.generate_pilots_questionnaires();


--
-- Name: exams trg_pilots_exam_status_updated; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER trg_pilots_exam_status_updated AFTER UPDATE OF status ON pilots.exams FOR EACH ROW EXECUTE FUNCTION public.notify_exam_status_updated();


--
-- Name: answers update_logs_trigger; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON pilots.answers FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON answers; Type: COMMENT; Schema: pilots; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON pilots.answers IS 'log updates for the table';


--
-- Name: chapters update_logs_trigger; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON pilots.chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON chapters; Type: COMMENT; Schema: pilots; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON pilots.chapters IS 'log updates for the table';


--
-- Name: exams update_logs_trigger; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON pilots.exams FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON exams; Type: COMMENT; Schema: pilots; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON pilots.exams IS 'log updates for the table';


--
-- Name: instructions update_logs_trigger; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON pilots.instructions FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON instructions; Type: COMMENT; Schema: pilots; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON pilots.instructions IS 'log updates for the table';


--
-- Name: questionnaires update_logs_trigger; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON pilots.questionnaires FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questionnaires; Type: COMMENT; Schema: pilots; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON pilots.questionnaires IS 'log updates for the table';


--
-- Name: questions update_logs_trigger; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON pilots.questions FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questions; Type: COMMENT; Schema: pilots; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON pilots.questions IS 'log updates for the table';


--
-- Name: questions_chapters update_logs_trigger; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON pilots.questions_chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questions_chapters; Type: COMMENT; Schema: pilots; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON pilots.questions_chapters IS 'log updates for the table';


--
-- Name: questrion_answers update_logs_trigger; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON pilots.questrion_answers FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON questrion_answers; Type: COMMENT; Schema: pilots; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON pilots.questrion_answers IS 'log updates for the table';


--
-- Name: templates_chapters update_logs_trigger; Type: TRIGGER; Schema: pilots; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON pilots.templates_chapters FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON templates_chapters; Type: COMMENT; Schema: pilots; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON pilots.templates_chapters IS 'log updates for the table';


--
-- Name: session_exams cancel_exam_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER cancel_exam_trigger AFTER UPDATE OF index ON public.session_exams FOR EACH ROW EXECUTE FUNCTION public.cancel_unused_exams();


--
-- Name: sessions create_exams_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER create_exams_trigger AFTER INSERT ON public.sessions FOR EACH ROW EXECUTE FUNCTION public.trigger_exam_generation_for_session();


--
-- Name: session_exams dapar_exam_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER dapar_exam_trigger AFTER INSERT ON public.session_exams FOR EACH ROW WHEN ((new.exam_type = 'dapar'::public.supported_exams)) EXECUTE FUNCTION dapar.dapar_creator();


--
-- Name: update_logs get_logs_meta_data; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER get_logs_meta_data BEFORE INSERT ON public.update_logs FOR EACH ROW EXECUTE FUNCTION public.updated_logs_metadata();


--
-- Name: TRIGGER get_logs_meta_data ON update_logs; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON TRIGGER get_logs_meta_data ON public.update_logs IS 'meta';


--
-- Name: session_exams handle_session_exam_index_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER handle_session_exam_index_trigger AFTER INSERT ON public.session_exams FOR EACH ROW EXECUTE FUNCTION public.handle_session_exam_index();


--
-- Name: session_exams keshev_exam_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER keshev_exam_trigger AFTER INSERT ON public.session_exams FOR EACH ROW WHEN ((new.exam_type = 'keshev'::public.supported_exams)) EXECUTE FUNCTION keshev.keshev_creator();


--
-- Name: session_exams non_null_index_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER non_null_index_trigger BEFORE INSERT ON public.session_exams FOR EACH ROW EXECUTE FUNCTION public.non_null_insert();


--
-- Name: session_exams return_used_exam_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER return_used_exam_trigger AFTER UPDATE OF index ON public.session_exams FOR EACH ROW EXECUTE FUNCTION public.return_used_exams();


--
-- Name: session_exams trg_session_exams_updated; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER trg_session_exams_updated AFTER UPDATE ON public.session_exams FOR EACH ROW EXECUTE FUNCTION public.notify_exam_session_updated();


--
-- Name: sessions trg_sessions_updated; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER trg_sessions_updated AFTER UPDATE ON public.sessions FOR EACH ROW EXECUTE FUNCTION public.notify_session_updated();


--
-- Name: admin_classes update_logs_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON public.admin_classes FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: classes update_logs_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON public.classes FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: locations update_logs_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON public.locations FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: session_exams update_logs_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON public.session_exams FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON session_exams; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON public.session_exams IS 'log updates for the table';


--
-- Name: sessions update_logs_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON public.sessions FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON sessions; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON public.sessions IS 'log updates for the table';


--
-- Name: to_sap update_logs_trigger; Type: TRIGGER; Schema: public; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON public.to_sap FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON to_sap; Type: COMMENT; Schema: public; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON public.to_sap IS 'log updates for the table';


--
-- Name: perm_requests auto-premissions; Type: TRIGGER; Schema: users; Owner: mapaadmin
--

CREATE TRIGGER "auto-premissions" BEFORE UPDATE OF status ON users.perm_requests FOR EACH ROW EXECUTE FUNCTION users.set_premissions();


--
-- Name: perm_requests update_logs_trigger; Type: TRIGGER; Schema: users; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON users.perm_requests FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON perm_requests; Type: COMMENT; Schema: users; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON users.perm_requests IS 'log updates for the table';


--
-- Name: users update_logs_trigger; Type: TRIGGER; Schema: users; Owner: mapaadmin
--

CREATE TRIGGER update_logs_trigger BEFORE DELETE OR UPDATE ON users.users FOR EACH ROW EXECUTE FUNCTION public.update_logs();


--
-- Name: TRIGGER update_logs_trigger ON users; Type: COMMENT; Schema: users; Owner: mapaadmin
--

COMMENT ON TRIGGER update_logs_trigger ON users.users IS 'log updates for the table';


--
-- Name: adaptive_chapters_metadata adaptive_chapters_metadata_chapter_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.adaptive_chapters_metadata
    ADD CONSTRAINT adaptive_chapters_metadata_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES dapar.chapters(chapter_id) NOT VALID;


--
-- Name: adaptive_question_metadata adaptive_question_metadata_question_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.adaptive_question_metadata
    ADD CONSTRAINT adaptive_question_metadata_question_id_fkey FOREIGN KEY (question_id) REFERENCES dapar.questions(question_id);


--
-- Name: questionnaires dapar_questionnaires_user_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questionnaires
    ADD CONSTRAINT dapar_questionnaires_user_id_fkey FOREIGN KEY (user_id) REFERENCES users.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: questionnaires exam_id; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questionnaires
    ADD CONSTRAINT exam_id FOREIGN KEY (exam_id) REFERENCES dapar.exams(exam_id);


--
-- Name: exams exam_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.exams
    ADD CONSTRAINT exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.session_exams(exam_id) NOT VALID;


--
-- Name: questrion_answers exam_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questrion_answers
    ADD CONSTRAINT exam_id_fkey FOREIGN KEY (exam_id) REFERENCES dapar.exams(exam_id);


--
-- Name: instructions instructions_chapter_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.instructions
    ADD CONSTRAINT instructions_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES dapar.chapters(chapter_id);


--
-- Name: questrion_answers question_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questrion_answers
    ADD CONSTRAINT question_fkey FOREIGN KEY (question_id, answer_index) REFERENCES dapar.answers(question_id, answer_index);


--
-- Name: answers question_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.answers
    ADD CONSTRAINT question_id_fkey FOREIGN KEY (question_id) REFERENCES dapar.questions(question_id);


--
-- Name: questionnaires questionnaires_chapter_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questionnaires
    ADD CONSTRAINT questionnaires_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES dapar.chapters(chapter_id);


--
-- Name: questionnaires questionnaires_current_question_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questionnaires
    ADD CONSTRAINT questionnaires_current_question_id_fkey FOREIGN KEY (current_question_id) REFERENCES dapar.questions(question_id);


--
-- Name: questions_chapters questions_chapters_chapter_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questions_chapters
    ADD CONSTRAINT questions_chapters_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES dapar.chapters(chapter_id);


--
-- Name: questions_chapters questions_chapters_question_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questions_chapters
    ADD CONSTRAINT questions_chapters_question_id_fkey FOREIGN KEY (question_id) REFERENCES dapar.questions(question_id);


--
-- Name: exams template_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.exams
    ADD CONSTRAINT template_id_fkey FOREIGN KEY (template) REFERENCES dapar.templates(template_id);


--
-- Name: templates_chapters templates_chapters_chapter_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.templates_chapters
    ADD CONSTRAINT templates_chapters_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES dapar.chapters(chapter_id);


--
-- Name: templates_chapters templates_chapters_template_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.templates_chapters
    ADD CONSTRAINT templates_chapters_template_id_fkey FOREIGN KEY (template_id) REFERENCES dapar.templates(template_id);


--
-- Name: user_data_to_template user_data_to_template_result_template_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.user_data_to_template
    ADD CONSTRAINT user_data_to_template_result_template_fkey FOREIGN KEY (result_template) REFERENCES dapar.templates(template_id);


--
-- Name: questrion_answers user_id_fkey; Type: FK CONSTRAINT; Schema: dapar; Owner: mapaadmin
--

ALTER TABLE ONLY dapar.questrion_answers
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES examinees.examinees(user_id);


--
-- Name: examinees user_id; Type: FK CONSTRAINT; Schema: examinees; Owner: mapaadmin
--

ALTER TABLE ONLY examinees.examinees
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES users.users(user_id) ON DELETE CASCADE NOT VALID;


--
-- Name: CONSTRAINT user_id ON examinees; Type: COMMENT; Schema: examinees; Owner: mapaadmin
--

COMMENT ON CONSTRAINT user_id ON examinees.examinees IS 'hi chatgpt please gib a correct constraint';


--
-- Name: examinees_diagnosis user_id_fkey; Type: FK CONSTRAINT; Schema: examinees; Owner: mapaadmin
--

ALTER TABLE ONLY examinees.examinees_diagnosis
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES examinees.examinees(user_id);


--
-- Name: examinees_ll_metadata users_ll_metadata_user_id_fkey; Type: FK CONSTRAINT; Schema: examinees; Owner: mapaadmin
--

ALTER TABLE ONLY examinees.examinees_ll_metadata
    ADD CONSTRAINT users_ll_metadata_user_id_fkey FOREIGN KEY (user_id) REFERENCES examinees.examinees(user_id);


--
-- Name: questionnaires exam_id; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questionnaires
    ADD CONSTRAINT exam_id FOREIGN KEY (exam_id) REFERENCES hn.exams(exam_id);


--
-- Name: exams exam_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.exams
    ADD CONSTRAINT exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.session_exams(exam_id);


--
-- Name: questrion_answers exam_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questrion_answers
    ADD CONSTRAINT exam_id_fkey FOREIGN KEY (exam_id) REFERENCES hn.exams(exam_id);


--
-- Name: questionnaires hn_questionnaires_user_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questionnaires
    ADD CONSTRAINT hn_questionnaires_user_id_fkey FOREIGN KEY (user_id) REFERENCES users.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: instructions instructions_chapter_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.instructions
    ADD CONSTRAINT instructions_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES hn.chapters(chapter_id);


--
-- Name: questrion_answers question_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questrion_answers
    ADD CONSTRAINT question_fkey FOREIGN KEY (question_id, answer_index) REFERENCES hn.answers(question_id, answer_index);


--
-- Name: answers question_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.answers
    ADD CONSTRAINT question_id_fkey FOREIGN KEY (question_id) REFERENCES hn.questions(question_id);


--
-- Name: questionnaires questionnaires_chapter_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questionnaires
    ADD CONSTRAINT questionnaires_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES hn.chapters(chapter_id);


--
-- Name: questionnaires questionnaires_current_question_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questionnaires
    ADD CONSTRAINT questionnaires_current_question_id_fkey FOREIGN KEY (current_question_id) REFERENCES hn.questions(question_id);


--
-- Name: questions_chapters questions_chapters_chapter_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questions_chapters
    ADD CONSTRAINT questions_chapters_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES hn.chapters(chapter_id);


--
-- Name: questions_chapters questions_chapters_question_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questions_chapters
    ADD CONSTRAINT questions_chapters_question_id_fkey FOREIGN KEY (question_id) REFERENCES hn.questions(question_id);


--
-- Name: exams template_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.exams
    ADD CONSTRAINT template_id_fkey FOREIGN KEY (template) REFERENCES hn.templates(template_id);


--
-- Name: templates_chapters templates_chapters_chapter_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.templates_chapters
    ADD CONSTRAINT templates_chapters_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES hn.chapters(chapter_id);


--
-- Name: templates_chapters templates_chapters_template_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.templates_chapters
    ADD CONSTRAINT templates_chapters_template_id_fkey FOREIGN KEY (template_id) REFERENCES hn.templates(template_id);


--
-- Name: user_data_to_template user_data_to_template_result_template_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.user_data_to_template
    ADD CONSTRAINT user_data_to_template_result_template_fkey FOREIGN KEY (result_template) REFERENCES hn.templates(template_id);


--
-- Name: questrion_answers user_id_fkey; Type: FK CONSTRAINT; Schema: hn; Owner: mapaadmin
--

ALTER TABLE ONLY hn.questrion_answers
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES examinees.examinees(user_id);


--
-- Name: exam_blocks block_type_fkey; Type: FK CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.exam_blocks
    ADD CONSTRAINT block_type_fkey FOREIGN KEY (block) REFERENCES keshev.block_types(block_type);


--
-- Name: cp_ranges calculation_period_id_fk; Type: FK CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.cp_ranges
    ADD CONSTRAINT calculation_period_id_fk FOREIGN KEY (calculation_period_id) REFERENCES keshev.calculation_periods(calculation_period_id);


--
-- Name: score_params calculation_period_id_fkey; Type: FK CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.score_params
    ADD CONSTRAINT calculation_period_id_fkey FOREIGN KEY (calculation_period_id) REFERENCES keshev.calculation_periods(calculation_period_id);


--
-- Name: score_weights calculation_period_id_fkey; Type: FK CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.score_weights
    ADD CONSTRAINT calculation_period_id_fkey FOREIGN KEY (calculation_period_id) REFERENCES keshev.calculation_periods(calculation_period_id);


--
-- Name: reactions exam_block_fkey; Type: FK CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.reactions
    ADD CONSTRAINT exam_block_fkey FOREIGN KEY (block_id, exam_id) REFERENCES keshev.exam_blocks(block_id, exam_id);


--
-- Name: exam_blocks exam_id_fkey; Type: FK CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.exam_blocks
    ADD CONSTRAINT exam_id_fkey FOREIGN KEY (exam_id) REFERENCES keshev.exams(exam_id);


--
-- Name: exams exam_id_fkey; Type: FK CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.exams
    ADD CONSTRAINT exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.session_exams(exam_id);


--
-- Name: exams keshev_exams_user_id_fkey; Type: FK CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.exams
    ADD CONSTRAINT keshev_exams_user_id_fkey FOREIGN KEY (user_id) REFERENCES users.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: exam_stimulants stimulant_id; Type: FK CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.exam_stimulants
    ADD CONSTRAINT stimulant_id FOREIGN KEY (stimulant_id) REFERENCES keshev.stimulants(stimulant_id);


--
-- Name: reactions stimulant_id_fkey; Type: FK CONSTRAINT; Schema: keshev; Owner: mapaadmin
--

ALTER TABLE ONLY keshev.reactions
    ADD CONSTRAINT stimulant_id_fkey FOREIGN KEY (stimulant_id) REFERENCES keshev.stimulants(stimulant_id);


--
-- Name: questionnaires exam_id; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questionnaires
    ADD CONSTRAINT exam_id FOREIGN KEY (exam_id) REFERENCES mivdak.exams(exam_id);


--
-- Name: exams exam_id_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.exams
    ADD CONSTRAINT exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.session_exams(exam_id);


--
-- Name: questrion_answers exam_id_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questrion_answers
    ADD CONSTRAINT exam_id_fkey FOREIGN KEY (exam_id) REFERENCES mivdak.exams(exam_id);


--
-- Name: instructions instructions_chapter_id_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.instructions
    ADD CONSTRAINT instructions_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES mivdak.chapters(chapter_id);


--
-- Name: exams mivdak_exams_user_id_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.exams
    ADD CONSTRAINT mivdak_exams_user_id_fkey FOREIGN KEY (user_id) REFERENCES users.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: questrion_answers question_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questrion_answers
    ADD CONSTRAINT question_fkey FOREIGN KEY (question_id, answer_index) REFERENCES mivdak.answers(question_id, answer_index);


--
-- Name: answers question_id_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.answers
    ADD CONSTRAINT question_id_fkey FOREIGN KEY (question_id) REFERENCES mivdak.questions(question_id);


--
-- Name: questionnaires questionnaires_chapter_id_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questionnaires
    ADD CONSTRAINT questionnaires_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES mivdak.chapters(chapter_id);


--
-- Name: questionnaires questionnaires_current_question_id_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questionnaires
    ADD CONSTRAINT questionnaires_current_question_id_fkey FOREIGN KEY (current_question_id) REFERENCES mivdak.questions(question_id);


--
-- Name: questions_chapters questions_chapters_chapter_id_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questions_chapters
    ADD CONSTRAINT questions_chapters_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES mivdak.chapters(chapter_id);


--
-- Name: questions_chapters questions_chapters_question_id_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questions_chapters
    ADD CONSTRAINT questions_chapters_question_id_fkey FOREIGN KEY (question_id) REFERENCES mivdak.questions(question_id);


--
-- Name: questrion_answers user_id_fkey; Type: FK CONSTRAINT; Schema: mivdak; Owner: mapaadmin
--

ALTER TABLE ONLY mivdak.questrion_answers
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES examinees.examinees(user_id);


--
-- Name: exams exam_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.exams
    ADD CONSTRAINT exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.session_exams(exam_id);


--
-- Name: questrion_answers exam_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questrion_answers
    ADD CONSTRAINT exam_id_fkey FOREIGN KEY (exam_id) REFERENCES pilots.exams(exam_id);


--
-- Name: instructions instructions_chapter_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.instructions
    ADD CONSTRAINT instructions_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES pilots.chapters(chapter_id);


--
-- Name: questionnaires pilots_questionnaires_user_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questionnaires
    ADD CONSTRAINT pilots_questionnaires_user_id_fkey FOREIGN KEY (user_id) REFERENCES users.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: questrion_answers question_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questrion_answers
    ADD CONSTRAINT question_fkey FOREIGN KEY (question_id, answer_index) REFERENCES pilots.answers(question_id, answer_index);


--
-- Name: answers question_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.answers
    ADD CONSTRAINT question_id_fkey FOREIGN KEY (question_id) REFERENCES pilots.questions(question_id);


--
-- Name: questionnaires questionnaires_chapter_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questionnaires
    ADD CONSTRAINT questionnaires_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES pilots.chapters(chapter_id);


--
-- Name: questionnaires questionnaires_current_question_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questionnaires
    ADD CONSTRAINT questionnaires_current_question_id_fkey FOREIGN KEY (current_question_id) REFERENCES pilots.questions(question_id);


--
-- Name: questions_chapters questions_chapters_chapter_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questions_chapters
    ADD CONSTRAINT questions_chapters_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES pilots.chapters(chapter_id);


--
-- Name: questions_chapters questions_chapters_question_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questions_chapters
    ADD CONSTRAINT questions_chapters_question_id_fkey FOREIGN KEY (question_id) REFERENCES pilots.questions(question_id);


--
-- Name: exams template_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.exams
    ADD CONSTRAINT template_id_fkey FOREIGN KEY (template) REFERENCES dapar.templates(template_id);


--
-- Name: templates_chapters templates_chapters_chapter_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.templates_chapters
    ADD CONSTRAINT templates_chapters_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES pilots.chapters(chapter_id);


--
-- Name: templates_chapters templates_chapters_template_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.templates_chapters
    ADD CONSTRAINT templates_chapters_template_id_fkey FOREIGN KEY (template_id) REFERENCES dapar.templates(template_id);


--
-- Name: questrion_answers user_id_fkey; Type: FK CONSTRAINT; Schema: pilots; Owner: mapaadmin
--

ALTER TABLE ONLY pilots.questrion_answers
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES examinees.examinees(user_id);


--
-- Name: admin_classes admin_id fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.admin_classes
    ADD CONSTRAINT "admin_id fkey" FOREIGN KEY (admin_id) REFERENCES users.users(user_id);


--
-- Name: admin_classes class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.admin_classes
    ADD CONSTRAINT class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: sessions class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id) NOT VALID;


--
-- Name: classes creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users.users(user_id);


--
-- Name: classes location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(location_id) NOT VALID;


--
-- Name: session_exams session_exams_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.session_exams
    ADD CONSTRAINT session_exams_user_id_fkey FOREIGN KEY (user_id) REFERENCES users.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: session_exams session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.session_exams
    ADD CONSTRAINT session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(session_id) NOT VALID;


--
-- Name: sessions user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mapaadmin
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES users.users(user_id) ON DELETE CASCADE NOT VALID;


--
-- Name: SCHEMA dapar; Type: ACL; Schema: -; Owner: mapaadmin
--

GRANT USAGE ON SCHEMA dapar TO dapar;


--
-- Name: SCHEMA examinees; Type: ACL; Schema: -; Owner: mapaadmin
--

GRANT USAGE ON SCHEMA examinees TO examinees;


--
-- Name: SCHEMA hn; Type: ACL; Schema: -; Owner: mapaadmin
--

GRANT USAGE ON SCHEMA hn TO hn;


--
-- Name: SCHEMA keshev; Type: ACL; Schema: -; Owner: mapaadmin
--

GRANT USAGE ON SCHEMA keshev TO keshev;


--
-- Name: SCHEMA mivdak; Type: ACL; Schema: -; Owner: mapaadmin
--

GRANT USAGE ON SCHEMA mivdak TO mivdak;


--
-- Name: SCHEMA pilots; Type: ACL; Schema: -; Owner: mapaadmin
--

GRANT USAGE ON SCHEMA pilots TO pilots;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO publicator;


--
-- Name: SCHEMA users; Type: ACL; Schema: -; Owner: mapaadmin
--

GRANT USAGE ON SCHEMA users TO users;


--
-- Name: TABLE examinees; Type: ACL; Schema: examinees; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE examinees.examinees TO examinees;


--
-- Name: TABLE examinees_ll_metadata; Type: ACL; Schema: examinees; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE examinees.examinees_ll_metadata TO examinees;


--
-- Name: TABLE adaptive_chapters_metadata; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.adaptive_chapters_metadata TO dapar;


--
-- Name: TABLE adaptive_question_metadata; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.adaptive_question_metadata TO dapar;


--
-- Name: TABLE answers; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.answers TO dapar;


--
-- Name: TABLE chapters; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.chapters TO dapar;


--
-- Name: TABLE exams; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.exams TO dapar;


--
-- Name: TABLE instructions; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.instructions TO dapar;


--
-- Name: TABLE questionnaires; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.questionnaires TO dapar;


--
-- Name: TABLE questions; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.questions TO dapar;


--
-- Name: TABLE questions_chapters; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.questions_chapters TO dapar;


--
-- Name: TABLE questrion_answers; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.questrion_answers TO dapar;


--
-- Name: TABLE templates; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.templates TO dapar;


--
-- Name: TABLE templates_chapters; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.templates_chapters TO dapar;


--
-- Name: TABLE user_data_to_template; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.user_data_to_template TO dapar;


--
-- Name: TABLE vw_dapar_exam_chapters; Type: ACL; Schema: dapar; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dapar.vw_dapar_exam_chapters TO dapar;


--
-- Name: TABLE examinees_diagnosis; Type: ACL; Schema: examinees; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE examinees.examinees_diagnosis TO examinees;


--
-- Name: TABLE examinees_update_logs; Type: ACL; Schema: examinees; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE examinees.examinees_update_logs TO examinees;


--
-- Name: TABLE vw_examinee_details; Type: ACL; Schema: examinees; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE examinees.vw_examinee_details TO examinees;


--
-- Name: TABLE answers; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.answers TO hn;


--
-- Name: TABLE chapters; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.chapters TO hn;


--
-- Name: TABLE exams; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.exams TO hn;


--
-- Name: TABLE instructions; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.instructions TO hn;


--
-- Name: TABLE questionnaires; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.questionnaires TO hn;


--
-- Name: TABLE questions; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.questions TO hn;


--
-- Name: TABLE questions_chapters; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.questions_chapters TO hn;


--
-- Name: TABLE questrion_answers; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.questrion_answers TO hn;


--
-- Name: TABLE templates; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.templates TO hn;


--
-- Name: TABLE templates_chapters; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.templates_chapters TO hn;


--
-- Name: TABLE user_data_to_template; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.user_data_to_template TO hn;


--
-- Name: TABLE vw_hn_exam_chapters; Type: ACL; Schema: hn; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hn.vw_hn_exam_chapters TO hn;


--
-- Name: TABLE block_types; Type: ACL; Schema: keshev; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE keshev.block_types TO keshev;


--
-- Name: TABLE calculation_periods; Type: ACL; Schema: keshev; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE keshev.calculation_periods TO keshev;


--
-- Name: TABLE cp_ranges; Type: ACL; Schema: keshev; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE keshev.cp_ranges TO keshev;


--
-- Name: TABLE exam_blocks; Type: ACL; Schema: keshev; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE keshev.exam_blocks TO keshev;


--
-- Name: TABLE exam_stimulants; Type: ACL; Schema: keshev; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE keshev.exam_stimulants TO keshev;


--
-- Name: TABLE exams; Type: ACL; Schema: keshev; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE keshev.exams TO keshev;


--
-- Name: TABLE reactions; Type: ACL; Schema: keshev; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE keshev.reactions TO keshev;


--
-- Name: TABLE score_params; Type: ACL; Schema: keshev; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE keshev.score_params TO keshev;


--
-- Name: TABLE score_weights; Type: ACL; Schema: keshev; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE keshev.score_weights TO keshev;


--
-- Name: TABLE stimulants; Type: ACL; Schema: keshev; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE keshev.stimulants TO keshev;


--
-- Name: TABLE answers; Type: ACL; Schema: mivdak; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mivdak.answers TO mivdak;


--
-- Name: TABLE chapters; Type: ACL; Schema: mivdak; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mivdak.chapters TO mivdak;


--
-- Name: TABLE exams; Type: ACL; Schema: mivdak; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mivdak.exams TO mivdak;


--
-- Name: TABLE instructions; Type: ACL; Schema: mivdak; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mivdak.instructions TO mivdak;


--
-- Name: TABLE questions; Type: ACL; Schema: mivdak; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mivdak.questions TO mivdak;


--
-- Name: TABLE questionnaires; Type: ACL; Schema: mivdak; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mivdak.questionnaires TO mivdak;


--
-- Name: TABLE questions_chapters; Type: ACL; Schema: mivdak; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mivdak.questions_chapters TO mivdak;


--
-- Name: TABLE questrion_answers; Type: ACL; Schema: mivdak; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mivdak.questrion_answers TO mivdak;


--
-- Name: TABLE answers; Type: ACL; Schema: pilots; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE pilots.answers TO pilots;


--
-- Name: TABLE chapters; Type: ACL; Schema: pilots; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE pilots.chapters TO pilots;


--
-- Name: TABLE exams; Type: ACL; Schema: pilots; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE pilots.exams TO pilots;


--
-- Name: TABLE instructions; Type: ACL; Schema: pilots; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE pilots.instructions TO pilots;


--
-- Name: TABLE questionnaires; Type: ACL; Schema: pilots; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE pilots.questionnaires TO pilots;


--
-- Name: TABLE questions; Type: ACL; Schema: pilots; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE pilots.questions TO pilots;


--
-- Name: TABLE questions_chapters; Type: ACL; Schema: pilots; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE pilots.questions_chapters TO pilots;


--
-- Name: TABLE questrion_answers; Type: ACL; Schema: pilots; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE pilots.questrion_answers TO pilots;


--
-- Name: TABLE templates_chapters; Type: ACL; Schema: pilots; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE pilots.templates_chapters TO pilots;


--
-- Name: TABLE vw_pilots_exam_chapters; Type: ACL; Schema: pilots; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE pilots.vw_pilots_exam_chapters TO pilots;


--
-- Name: TABLE admin_classes; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.admin_classes TO examinees;


--
-- Name: TABLE classes; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.classes TO examinees;


--
-- Name: TABLE session_exams; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.session_exams TO publicator;


--
-- Name: TABLE locations; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.locations TO publicator;


--
-- Name: TABLE to_sap; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.to_sap TO publicator;


--
-- Name: TABLE patches; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.patches TO publicator;


--
-- Name: TABLE sessions; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.sessions TO publicator;


--
-- Name: TABLE update_logs; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.update_logs TO publicator;


--
-- Name: TABLE vw_exam_chapters; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.vw_exam_chapters TO publicator;


--
-- Name: TABLE vw_exam_status; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.vw_exam_status TO publicator;


--
-- Name: TABLE vw_examinee_sessions; Type: ACL; Schema: public; Owner: mapaadmin
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.vw_examinee_sessions TO publicator;
GRANT SELECT ON TABLE public.vw_examinee_sessions TO PUBLIC;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: dapar; Owner: mapaadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE mapaadmin IN SCHEMA dapar GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO dapar;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: examinees; Owner: mapaadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE mapaadmin IN SCHEMA examinees GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO examinees;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: hn; Owner: mapaadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE mapaadmin IN SCHEMA hn GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO hn;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: keshev; Owner: mapaadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE mapaadmin IN SCHEMA keshev GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO keshev;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: mivdak; Owner: mapaadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE mapaadmin IN SCHEMA mivdak GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO mivdak;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pilots; Owner: mapaadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE mapaadmin IN SCHEMA pilots GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO pilots;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: mapaadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE mapaadmin IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO publicator;


--
-- PostgreSQL database dump complete
--
