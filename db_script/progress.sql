--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: account_role(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION account_role(account_name_arg text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 role TEXT;

BEGIN

 SELECT INTO role type FROM person INNER JOIN account ON (account.id = person.account_id) WHERE account.name = account_name_arg;

 RETURN role;

END;$$;


ALTER FUNCTION public.account_role(account_name_arg text) OWNER TO postgres;

--
-- Name: FUNCTION account_role(account_name_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION account_role(account_name_arg text) IS 'input: account name


returns text; the role of the account user';


--
-- Name: account_role_id(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION account_role_id(account_name_arg text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 role_id TEXT;

 role    TEXT;

 account_id_arg INTEGER;

BEGIN

 SELECT INTO role_id person.id FROM person INNER JOIN account ON (account.id = person.account_id) WHERE account.name = account_name_arg;

 RETURN role_id;

END;$$;


ALTER FUNCTION public.account_role_id(account_name_arg text) OWNER TO postgres;

--
-- Name: FUNCTION account_role_id(account_name_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION account_role_id(account_name_arg text) IS 'input: account name


returns text; the role id of the account user';


--
-- Name: add_attendance(integer, text, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_attendance(session_id_arg integer, student_id_arg text, time_arg timestamp without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE

     status_var TEXT;

BEGIN

     SELECT INTO status_var status FROM class_session WHERE id = session_id_arg;

     IF (status_var = 'ONGOING' AND (student_id_arg NOT IN (SELECT student_id FROM attendance WHERE session_id = session_id_arg))) THEN

      INSERT INTO attendance (session_id, time, student_id) VALUES(session_id_arg, time_arg, student_id_arg);

      return TRUE;

     ELSE

      return FALSE;

     END IF;

END;$$;


ALTER FUNCTION public.add_attendance(session_id_arg integer, student_id_arg text, time_arg timestamp without time zone) OWNER TO postgres;

--
-- Name: FUNCTION add_attendance(session_id_arg integer, student_id_arg text, time_arg timestamp without time zone); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION add_attendance(session_id_arg integer, student_id_arg text, time_arg timestamp without time zone) IS 'input: session id, student id, time


returns boolean; TRUE if the attendance if successfully added and FALSE otherwise';


--
-- Name: add_class_session(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_class_session(section_id_arg integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$BEGIN

 IF section_id_arg IN (SELECT id FROM section) THEN

  INSERT INTO class_session(section_id) VALUES(section_id_arg);

  RETURN TRUE;

 ELSE

  RETURN FALSE;

 END IF;

END;$$;


ALTER FUNCTION public.add_class_session(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION add_class_session(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION add_class_session(section_id_arg integer) IS 'input: section id


returns boolean; TRUE if class session was successfully added and FALSE otherwise';


--
-- Name: add_grade_item(text, integer, double precision, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_grade_item(name_arg text, grading_system_id_arg integer, total_score_arg double precision, timestamp_arg timestamp without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE

 grade_item_id INTEGER;

 student_id_var TEXT;

BEGIN

 SELECT INTO grade_item_id id FROM grade_item WHERE name = name_arg and grading_system_id = grading_system_id_arg;

 IF grade_item_id ISNULL THEN

  INSERT INTO grade_item(grading_system_id, name, total_score, date) VALUES(grading_system_id_arg, name_arg, total_score_arg, timestamp_arg);

  SELECT INTO grade_item_id id FROM grade_item WHERE name = name_arg and grading_system_id = grading_system_id_arg;

  FOR student_id_var IN SELECT enrolled(get_grading_system_section_id(grading_system_id_arg)) LOOP

   INSERT INTO grade_item_entry(grade_item_id, score, student_id) VALUES(grade_item_id, 0, student_id_var);

  END LOOP;

  RETURN TRUE;

 ELSE

  RETURN FALSE;

 END IF;

END;$$;


ALTER FUNCTION public.add_grade_item(name_arg text, grading_system_id_arg integer, total_score_arg double precision, timestamp_arg timestamp without time zone) OWNER TO postgres;

--
-- Name: FUNCTION add_grade_item(name_arg text, grading_system_id_arg integer, total_score_arg double precision, timestamp_arg timestamp without time zone); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION add_grade_item(name_arg text, grading_system_id_arg integer, total_score_arg double precision, timestamp_arg timestamp without time zone) IS 'input: grade item name, grading system id, total score


returns boolean; TRUE if grade item was successfully added and FALSE otherwise';


--
-- Name: add_grade_item_entry(integer, double precision, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_grade_item_entry(grade_item_id_arg integer, score_arg double precision, student_id_arg text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE

 grade_item_entry_id INTEGER;

BEGIN

 SELECT INTO grade_item_entry_id id FROM grade_item_entry WHERE student_id = student_id_arg AND grade_item_id = grade_item_id_arg;

 IF grade_item_entry_id ISNULL THEN

  RETURN FALSE;

 ELSE

  UPDATE grade_item_entry SET score = score_arg WHERE student_id = student_id_arg AND grade_item_id = grade_item_id_arg;

  RETURN TRUE;

 END IF;

END;$$;


ALTER FUNCTION public.add_grade_item_entry(grade_item_id_arg integer, score_arg double precision, student_id_arg text) OWNER TO postgres;

--
-- Name: FUNCTION add_grade_item_entry(grade_item_id_arg integer, score_arg double precision, student_id_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION add_grade_item_entry(grade_item_id_arg integer, score_arg double precision, student_id_arg text) IS 'input: grade item id, score of this entry, id of the student


returns boolean; TRUE if grade item entry was successfully updated and FALSE otherwise';


--
-- Name: class_session_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION class_session_information(session_id_arg integer) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
 session_information TEXT;
BEGIN
 SELECT INTO session_information id || '#' || date || '#' || status FROM class_session WHERE id = session_id_arg;
 RETURN session_information;
END;$$;


ALTER FUNCTION public.class_session_information(session_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION class_session_information(session_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION class_session_information(session_id_arg integer) IS 'input: session id


returns text; informations of the session format; id - date - status';


--
-- Name: confirm_attendance(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION confirm_attendance(attendance_id_arg integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$BEGIN

     IF attendance_id_arg IN (SELECT id FROM attendance WHERE confirmed = FALSE) THEN

      UPDATE attendance SET confirmed = TRUE WHERE id = attendance_id_arg;

      RETURN TRUE;

     ELSE

      RETURN FALSE;

     END IF;

END;$$;


ALTER FUNCTION public.confirm_attendance(attendance_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION confirm_attendance(attendance_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION confirm_attendance(attendance_id_arg integer) IS 'input: grade item id, score of this entry, id of the student


returns boolean; TRUE if attendance was successfully confirmed and FALSE otherwise';


--
-- Name: count_student_enrolled(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION count_student_enrolled(section_id_arg integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

 result INTEGER;

BEGIN

 SELECT INTO result count(id) FROM enroll WHERE section_id = section_id_arg;

 IF result ISNULL THEN

  RETURN 0;

 ELSE

  RETURN result;

 END IF;

END;$$;


ALTER FUNCTION public.count_student_enrolled(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION count_student_enrolled(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION count_student_enrolled(section_id_arg integer) IS 'input: section id


returns integer; number of student enrolled in the given section';


--
-- Name: current_term(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION current_term() RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

 term_id_output INTEGER;

BEGIN

 SELECT INTO term_id_output max(id) FROM term;

 RETURN term_id_output;

END;$$;


ALTER FUNCTION public.current_term() OWNER TO postgres;

--
-- Name: FUNCTION current_term(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION current_term() IS 'input: section id


returns integer; id of the current term';


--
-- Name: delete_class_session(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delete_class_session(class_session_id_arg integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$BEGIN

 IF class_session_id_arg IN (SELECT id FROM class_session) THEN

  DELETE FROM class_session WHERE id = class_session_id_arg;

  DELETE FROM attendance WHERE session_id = class_session_id_arg;

  RETURN TRUE;

 ELSE

  RETURN FALSE;

 END IF;

END;$$;


ALTER FUNCTION public.delete_class_session(class_session_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION delete_class_session(class_session_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION delete_class_session(class_session_id_arg integer) IS 'input: class session id


returns boolean; TRUE if class session was successfully deleted and FALSE otherwise';


--
-- Name: delete_grade_item(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delete_grade_item(grade_item_id_arg integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$BEGIN

     IF grade_item_id_arg IN (SELECT id FROM grade_item) THEN

      DELETE FROM grade_item WHERE id = grade_item_id_arg;

      DELETE FROM grade_item_entry WHERE grade_item_id = grade_item_id_arg;

      RETURN TRUE;

     ELSE

      RETURN FALSE;

     END IF;

END;$$;


ALTER FUNCTION public.delete_grade_item(grade_item_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION delete_grade_item(grade_item_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION delete_grade_item(grade_item_id_arg integer) IS 'input: grade item id


returns boolean; TRUE if grade item was successfully deleted and FALSE otherwise';


--
-- Name: dismiss_class_session(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dismiss_class_session(class_session_id_arg integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$BEGIN

 IF class_session_id_arg IN (SELECT id FROM class_session) THEN

  UPDATE class_session SET status = 'DISMISSED' WHERE id = class_session_id_arg;

  RETURN TRUE;

 ELSE

  RETURN FALSE;

 END IF;

END;$$;


ALTER FUNCTION public.dismiss_class_session(class_session_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION dismiss_class_session(class_session_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION dismiss_class_session(class_session_id_arg integer) IS 'input: class session id


returns boolean; TRUE if grade item was successfully updated and FALSE otherwise';


--
-- Name: edit_grading_system_weight(integer, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION edit_grading_system_weight(grading_system_id_arg integer, new_weight_arg double precision) RETURNS boolean
    LANGUAGE plpgsql
    AS $$BEGIN

     IF grading_system_id_arg IN (SELECT id FROM grading_system) THEN

      UPDATE grading_system SET weight = new_weight_arg WHERE id = grading_system_id_arg;

      RETURN TRUE;

     ELSE

      RETURN FALSE;

     END IF;

END;$$;


ALTER FUNCTION public.edit_grading_system_weight(grading_system_id_arg integer, new_weight_arg double precision) OWNER TO postgres;

--
-- Name: FUNCTION edit_grading_system_weight(grading_system_id_arg integer, new_weight_arg double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION edit_grading_system_weight(grading_system_id_arg integer, new_weight_arg double precision) IS 'input: grading system id, new weight


returns boolean; TRUE if grading system was successfully updated and FALSE otherwise';


--
-- Name: enrolled(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION enrolled(section_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql STRICT
    AS $$DECLARE

student_id_output TEXT;

BEGIN

 FOR student_id_output in SELECT student_id FROM enroll WHERE section_id = section_id_arg LOOP	

 RETURN NEXT student_id_output;	

  END LOOP;

  RETURN;

END;$$;


ALTER FUNCTION public.enrolled(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION enrolled(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION enrolled(section_id_arg integer) IS 'input: section id


returns setof text; id number of the student enrolled in that section';


--
-- Name: enrolled_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION enrolled_information(section_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 informations TEXT;
 id TEXT;
BEGIN
 FOR id IN (SELECT enrolled(section_id_arg)) LOOP
  informations = student_information(id);
 RETURN NEXT informations;
 END LOOP;
 RETURN;
END;$$;


ALTER FUNCTION public.enrolled_information(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION enrolled_information(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION enrolled_information(section_id_arg integer) IS 'input: section id


returns setof text; informations of the students enrolled in the section';


--
-- Name: faculty_information(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION faculty_information(faculty_id_arg text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 first_name_output TEXT;

 middle_name_output TEXT;

 last_name_output TEXT;

 department_name_output TEXT;

 email_output TEXT;

BEGIN

 SELECT INTO first_name_output, middle_name_output, last_name_output, department_name_output, email_output person.first_name, person.middle_name, person.last_name, department.name, person.email FROM person INNER JOIN faculty_department ON (person.id = faculty_department.faculty_id) INNER JOIN department ON (faculty_department.department_id = department.id) WHERE person.id = faculty_id_arg AND person.type = 'FACULTY';

 RETURN faculty_id_arg || '#' || first_name_output || '#' || middle_name_output || '#' || last_name_output || '#' || department_name_output || '#' || email_output;

END;$$;


ALTER FUNCTION public.faculty_information(faculty_id_arg text) OWNER TO postgres;

--
-- Name: FUNCTION faculty_information(faculty_id_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION faculty_information(faculty_id_arg text) IS 'input: section id


returns text; faculty information, format; id - first name - middle name - last name - department name - email';


--
-- Name: faculty_load(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION faculty_load(faculty_id_arg text, term_id_arg integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE

sections INTEGER;

BEGIN

    FOR sections IN SELECT section_id FROM assignation WHERE faculty_id = faculty_id_arg AND term_id = term_id_arg LOOP

       RETURN NEXT sections;

    END LOOP;

    RETURN;

END;$$;


ALTER FUNCTION public.faculty_load(faculty_id_arg text, term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION faculty_load(faculty_id_arg text, term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION faculty_load(faculty_id_arg text, term_id_arg integer) IS 'input: faculty id, term id


returns setof integer; id of the section that the faculty handle';


--
-- Name: faculty_load_information(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION faculty_load_information(faculty_id_arg text, term_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 informations TEXT;
 section_id INTEGER;
BEGIN
 FOR section_id IN (SELECT faculty_load(faculty_id_arg, term_id_arg)) LOOP
  informations = section_information(section_id);
  RETURN NEXT informations;
 END LOOP;
 RETURN;
END;$$;


ALTER FUNCTION public.faculty_load_information(faculty_id_arg text, term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION faculty_load_information(faculty_id_arg text, term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION faculty_load_information(faculty_id_arg text, term_id_arg integer) IS 'input: faculty id, term id


returns setof text; informations of the section that the faculty handle';


--
-- Name: get_children(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_children(parent_id_arg text) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE

 children TEXT;

BEGIN

 FOR children in SELECT student_id FROM linked_account WHERE parent_id = parent_id_arg and verified = true LOOP

 RETURN NEXT children;	

 END LOOP;

 RETURN;

END;$$;


ALTER FUNCTION public.get_children(parent_id_arg text) OWNER TO postgres;

--
-- Name: FUNCTION get_children(parent_id_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_children(parent_id_arg text) IS 'input: parent id


returns setof text; id of the children of the parent';


--
-- Name: get_children_information(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_children_information(parent_id_arg text) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 informations TEXT;
 child_id TEXT;
BEGIN
 FOR child_id IN (SELECT get_children(parent_id_arg)) LOOP
  informations = student_information(child_id);
  RETURN NEXT informations;
 END LOOP;
 RETURN;
END;$$;


ALTER FUNCTION public.get_children_information(parent_id_arg text) OWNER TO postgres;

--
-- Name: FUNCTION get_children_information(parent_id_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_children_information(parent_id_arg text) IS 'input: parent id


returns setof text; informations of the children of the parent';


--
-- Name: get_class_session(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_class_session(section_id_arg integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE

section_id_output INTEGER;

BEGIN

 FOR section_id_output in SELECT id FROM class_session WHERE section_id = section_id_arg LOOP

  RETURN NEXT section_id_output;

  END LOOP;

  RETURN;

END;$$;


ALTER FUNCTION public.get_class_session(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_class_session(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_class_session(section_id_arg integer) IS 'input: section id


returns setof integer; id of the session that the section have';


--
-- Name: get_class_session_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_class_session_information(section_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 informations TEXT;
 session_id INTEGER;
BEGIN
 FOR session_id IN (SELECT get_class_session(section_id_arg)) LOOP
  informations = class_session_information(session_id);
  RETURN NEXT informations;
 END LOOP;
 RETURN;
END;
$$;


ALTER FUNCTION public.get_class_session_information(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_class_session_information(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_class_session_information(section_id_arg integer) IS 'input: section id


returns setof text; informations of the session that the section have';


--
-- Name: get_email(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_email(id_arg text, role_arg text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 email_output TEXT;

BEGIN

 SELECT INTO email_output email FROM person WHERE id = id_arg AND type = role_arg;

 IF email_output ISNULL THEN

  RETURN 'ID NOT FOUND UNDER ' || role;

 ELSE

  RETURN email_output;

 END IF;

END;$$;


ALTER FUNCTION public.get_email(id_arg text, role_arg text) OWNER TO postgres;

--
-- Name: FUNCTION get_email(id_arg text, role_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_email(id_arg text, role_arg text) IS 'input: id, role


returns text; email';


--
-- Name: get_grade_item(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_grade_item(grading_system_id_arg integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE

 grade_item_id INTEGER;

BEGIN

 FOR grade_item_id IN SELECT id FROM grade_item WHERE grading_system_id = grading_system_id_arg LOOP

  RETURN NEXT grade_item_id;

 END LOOP;

 RETURN;

END;$$;


ALTER FUNCTION public.get_grade_item(grading_system_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_grade_item(grading_system_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_grade_item(grading_system_id_arg integer) IS 'input: grading system id


returns setof integer; id of the grade item that the grade system have';


--
-- Name: get_grade_item_entry(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_grade_item_entry(grade_item_id_arg integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE

 grade_item_entry_id INTEGER;

BEGIN

 FOR grade_item_entry_id IN SELECT id FROM grade_item_entry WHERE grade_item_id = grade_item_id_arg LOOP

  RETURN NEXT grade_item_entry_id;

 END LOOP;

 RETURN;

END;$$;


ALTER FUNCTION public.get_grade_item_entry(grade_item_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_grade_item_entry(grade_item_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_grade_item_entry(grade_item_id_arg integer) IS 'input: grade item id


returns setof integer; id of the grade item entry id that the grade item have';


--
-- Name: get_grade_item_entry_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_grade_item_entry_information(grade_item_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 informations TEXT;
 grade_item_entry_id INTEGER;
BEGIN
 FOR grade_item_entry_id IN (SELECT get_grade_item_entry(grade_item_id_arg)) LOOP
  informations = grade_item_entry_information(grade_item_entry_id);
  RETURN NEXT informations;
 END LOOP;
 RETURN;
END;$$;


ALTER FUNCTION public.get_grade_item_entry_information(grade_item_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_grade_item_entry_information(grade_item_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_grade_item_entry_information(grade_item_id_arg integer) IS 'input: grade item id


returns setof text; information of the grade item entry id that the grade item have';


--
-- Name: get_grade_item_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_grade_item_information(grading_system_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 informations TEXT;
 grade_item_id INTEGER;
BEGIN
 FOR grade_item_id IN (SELECT get_grade_item(grading_system_id_arg)) LOOP
  informations = grade_item_information(grade_item_id);
  RETURN NEXT informations;
 END LOOP;
 RETURN;
END;$$;


ALTER FUNCTION public.get_grade_item_information(grading_system_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_grade_item_information(grading_system_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_grade_item_information(grading_system_id_arg integer) IS 'input: grading system id


returns setof text; information of the grade item that the grade system have';


--
-- Name: get_grading_system(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_grading_system(section_id_arg integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE

 grade_item_id INTEGER;

BEGIN

 FOR grade_item_id IN SELECT id FROM grading_system WHERE section_id = section_id_arg LOOP

  RETURN NEXT grade_item_id;

 END LOOP;

 RETURN;

END;$$;


ALTER FUNCTION public.get_grading_system(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_grading_system(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_grading_system(section_id_arg integer) IS 'input: scetion id


returns setof integer; id of the grading system that the section have';


--
-- Name: get_grading_system_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_grading_system_information(section_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 informations TEXT;
 grading_system_id INTEGER;
BEGIN
 FOR grading_system_id IN (SELECT get_grading_system(section_id_arg)) LOOP
  informations = grading_system_information(grading_system_id);
  RETURN NEXT informations;
 END LOOP;
 RETURN;
END;$$;


ALTER FUNCTION public.get_grading_system_information(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_grading_system_information(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_grading_system_information(section_id_arg integer) IS 'input: section id


returns setof text; information of the grading system that the section have';


--
-- Name: get_grading_system_section_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_grading_system_section_id(grading_system_id_arg integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

 section_id_output INTEGER;

BEGIN

 SELECT INTO section_id_output section_id FROM grading_system WHERE id = grading_system_id_arg;

 RETURN section_id_output;

END;$$;


ALTER FUNCTION public.get_grading_system_section_id(grading_system_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_grading_system_section_id(grading_system_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_grading_system_section_id(grading_system_id_arg integer) IS 'input: grading system id


returns integer; id of the section that the grading system belong';


--
-- Name: get_image_location(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_image_location(id_arg text, role text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 image_location TEXT;

BEGIN

 SELECT INTO image_location image_source FROM person WHERE id = id_arg AND type = role;

 IF image_location ISNULL THEN

  RETURN 'ID NOT FOUND UNDER ' || role;

 ELSE

  RETURN image_location;

 END IF;

END;$$;


ALTER FUNCTION public.get_image_location(id_arg text, role text) OWNER TO postgres;

--
-- Name: FUNCTION get_image_location(id_arg text, role text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_image_location(id_arg text, role text) IS 'input: id, role


returns text; image location';


--
-- Name: get_section_attendance(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_section_attendance(section_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE

 student_id_output TEXT;

 session_id_output INTEGER;

BEGIN

 FOR session_id_output IN SELECT id FROM class_session WHERE section_id = section_id_arg LOOP

  FOR student_id_output IN SELECT student_id || '#' || time FROM attendance WHERE session_id = session_id_output LOOP

   RETURN NEXT student_id_output;

  END LOOP;

 END LOOP;

 RETURN;

END;$$;


ALTER FUNCTION public.get_section_attendance(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_section_attendance(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_section_attendance(section_id_arg integer) IS 'input: section id


returns setof text; id of the student and time it arrive format; student id - time';


--
-- Name: get_session_date(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_session_date(session_id_arg integer) RETURNS date
    LANGUAGE plpgsql
    AS $$DECLARE

 date_output DATE;

BEGIN

 SELECT INTO date_output date FROM class_session WHERE id = session_id_arg;

 RETURN date_output;

END;$$;


ALTER FUNCTION public.get_session_date(session_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION get_session_date(session_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_session_date(session_id_arg integer) IS 'input: session id


returns date; date that the class session happen';


--
-- Name: getsalt(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getsalt(username_ text) RETURNS text
    LANGUAGE plpgsql
    AS $$declare 

     salt_ text;

begin 

     SELECT INTO salt_ salt from account where name = username_;

     IF salt_ isnull then

          return 'false';

     else 

          return salt_;

    end if;

end;$$;


ALTER FUNCTION public.getsalt(username_ text) OWNER TO postgres;

--
-- Name: FUNCTION getsalt(username_ text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getsalt(username_ text) IS 'input: user name


returns text; the username''s salt, FALSE if user does not exist';


--
-- Name: grade_item_entry_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION grade_item_entry_information(grade_item_entry_id_arg integer) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 student_id_output TEXT;

 score_output DOUBLE PRECISION;

BEGIN

 SELECT INTO student_id_output, score_output student_id, score FROM grade_item_entry WHERE id = grade_item_entry_id_arg;

 RETURN grade_item_entry_id_arg || '#' || student_id_output || '#' || score_output;

END;$$;


ALTER FUNCTION public.grade_item_entry_information(grade_item_entry_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION grade_item_entry_information(grade_item_entry_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION grade_item_entry_information(grade_item_entry_id_arg integer) IS 'input: grade item entry id


returns text; entry information, format; id - student id - score';


--
-- Name: grade_item_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION grade_item_information(grade_item_id_arg integer) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 name_output TEXT;

 total_score_output DOUBLE PRECISION;

 date_output TIMESTAMP;

BEGIN

 SELECT INTO name_output, total_score_output, date_output name, total_score, date FROM grade_item WHERE id = grade_item_id_arg;

 RETURN grade_item_id_arg || '#' || name_output || '#' || total_score_output || '#' || date_output;

END;$$;


ALTER FUNCTION public.grade_item_information(grade_item_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION grade_item_information(grade_item_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION grade_item_information(grade_item_id_arg integer) IS 'input: grade item id


returns text; grade item information, format; id - name - total score - date';


--
-- Name: grading_system_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION grading_system_information(grading_system_id_arg integer) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 name_output TEXT;

 weight_output DOUBLE PRECISION;

BEGIN

 SELECT INTO name_output, weight_output name, weight FROM grading_system WHERE id = grading_system_id_arg;

 RETURN grading_system_id_arg || '#' || name_output || '#' || weight_output;

END;$$;


ALTER FUNCTION public.grading_system_information(grading_system_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION grading_system_information(grading_system_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION grading_system_information(grading_system_id_arg integer) IS 'input: grading system id


returns text; grading system information, format; id - name - weight';


--
-- Name: login(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION login(name_arg text, password_arg text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 result TEXT;

BEGIN

 SELECT INTO result id FROM account WHERE name = name_arg and hashed_password = password_arg;

 IF result ISNULL THEN

  RETURN 'FALSE';

 ELSE

  RETURN 'TRUE';

 END IF;

END;$$;


ALTER FUNCTION public.login(name_arg text, password_arg text) OWNER TO postgres;

--
-- Name: FUNCTION login(name_arg text, password_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION login(name_arg text, password_arg text) IS 'input: name, password


returns text; ''TRUE'' if the data match, ''FALSE'' otherwise';


--
-- Name: parent_information(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION parent_information(parent_id_arg text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 first_name_output TEXT;

 middle_name_output TEXT;

 last_name_output TEXT;

 email_output TEXT;

BEGIN

 SELECT INTO first_name_output, middle_name_output, last_name_output, email_output first_name, middle_name, last_name, email FROM person WHERE id = parent_id_arg AND type = 'PARENT';

 RETURN parent_id_arg || '#' || first_name_output || '#' || middle_name_output || '#' || last_name_output || '#' || email_output;

END;$$;


ALTER FUNCTION public.parent_information(parent_id_arg text) OWNER TO postgres;

--
-- Name: FUNCTION parent_information(parent_id_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION parent_information(parent_id_arg text) IS 'input: parent id


returns text; parent information, format; id - first name - middle name - last name - email';


--
-- Name: section_faculty(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION section_faculty(section_id_arg integer) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 faculty_id_output TEXT;

BEGIN

 SELECT INTO faculty_id_output faculty_id FROM assignation WHERE section_id = section_id_arg;

 IF faculty_id_output ISNULL THEN

  RETURN 'NOT FOUND';

 ELSE

  RETURN faculty_id_output;

 END IF;

END;$$;


ALTER FUNCTION public.section_faculty(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION section_faculty(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION section_faculty(section_id_arg integer) IS 'input: section id


returns text; id of the faculty and ''NOT FOUND'' if it fail';


--
-- Name: section_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION section_information(section_id_arg integer) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 section_name_output TEXT;

 subject_type_output TEXT;

 section_time_output TEXT;

 section_day_output TEXT;

 room_name_output TEXT;

 subject_name_output TEXT;

 subject_unit_output TEXT;

 subject_description_output TEXT;

BEGIN

 SELECT INTO section_name_output, subject_name_output, subject_type_output, subject_description_output, section_time_output, section_day_output, room_name_output, subject_unit_output section.name, subject.name, subject.type, subject.description, section.time, section.day, section.room, subject.units FROM section INNER JOIN subject ON (section.subject_id = subject.id) WHERE section.id = section_id_arg;

 RETURN section_id_arg || '#' || subject_name_output || '#' || section_name_output || '#' || subject_description_output || '#' || section_day_output || '#' || section_time_output || '#' || room_name_output || '#' || subject_unit_output || '#' || subject_type_output;

END;$$;


ALTER FUNCTION public.section_information(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION section_information(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION section_information(section_id_arg integer) IS 'input: grading system id, new weight


returns text; information of the section, format: id - subject code - section code - subject description - section day - section time - section room - subject units - subject type';


--
-- Name: student_absence_count(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_absence_count(student_id_arg text, section_id_arg integer, term_id_arg integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

 count INTEGER;

BEGIN

 SELECT INTO count count(*) FROM student_sessions_absented (student_id_arg, section_id_arg, term_id_arg);

 IF count ISNULL THEN

  RETURN 0;

 ELSE

  RETURN count;

 END IF;

END;$$;


ALTER FUNCTION public.student_absence_count(student_id_arg text, section_id_arg integer, term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_absence_count(student_id_arg text, section_id_arg integer, term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_absence_count(student_id_arg text, section_id_arg integer, term_id_arg integer) IS 'input: student id, scetion id, term id


returns integer; count the row of the absences';


--
-- Name: student_attendance_count(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_attendance_count(student_id_arg text, section_id_arg integer, term_id_arg integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

 count INTEGER;

BEGIN

 SELECT INTO count count(*) FROM student_sessions_attended (student_id_arg, section_id_arg, term_id_arg);

 IF count ISNULL THEN

  RETURN 0;

 ELSE

  RETURN count;

 END IF;

END;$$;


ALTER FUNCTION public.student_attendance_count(student_id_arg text, section_id_arg integer, term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_attendance_count(student_id_arg text, section_id_arg integer, term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_attendance_count(student_id_arg text, section_id_arg integer, term_id_arg integer) IS 'input: student id, section id, term id


returns integer; number of times the student attend';


--
-- Name: student_information(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_information(student_id_arg text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 first_name_output TEXT;

 middle_name_output TEXT;

 last_name_output TEXT;

 course_name_output TEXT;

 course_code_output TEXT;

 year_output INTEGER;

 email_output TEXT;

BEGIN

 SELECT INTO first_name_output, middle_name_output, last_name_output, course_name_output,  course_code_output, year_output, email_output person.first_name, person.middle_name, person.last_name, course.name, course.code, person.year, person.email FROM person INNER JOIN student_course ON (person.id = student_course.student_id) INNER JOIN course ON (student_course.course_id = course.id) WHERE person.id = student_id_arg AND person.type = 'STUDENT';

 RETURN student_id_arg || '#' || first_name_output || '#' || middle_name_output || '#' || last_name_output || '#' ||  course_code_output || '#' || course_name_output || '#' || year_output || '#' || email_output;

END;$$;


ALTER FUNCTION public.student_information(student_id_arg text) OWNER TO postgres;

--
-- Name: FUNCTION student_information(student_id_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_information(student_id_arg text) IS 'input: grading system id, new weight


returns text; informatin of the student format: id - first name - middle name - last name - course - year - email';


--
-- Name: student_last_attended(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_last_attended(student_id_arg text, section_id_arg integer) RETURNS date
    LANGUAGE plpgsql
    AS $$DECLARE

 session_id_output INTEGER;

BEGIN

 SELECT INTO session_id_output MAX(session_id) FROM attendance INNER JOIN class_session ON (attendance.session_id = class_session.id) WHERE student_id = student_id_arg;

 RETURN get_session_date(session_id_output);

END;$$;


ALTER FUNCTION public.student_last_attended(student_id_arg text, section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_last_attended(student_id_arg text, section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_last_attended(student_id_arg text, section_id_arg integer) IS 'input: student id, section id


returns text; session date';


--
-- Name: student_load(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_load(student_id_arg text, term_id_arg integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE

sections INTEGER;

BEGIN

 FOR sections in SELECT section_id FROM enroll WHERE student_id = student_id_arg and term_id = term_id_arg LOOP	

 RETURN NEXT sections;	

  END LOOP;

  RETURN;

END;$$;


ALTER FUNCTION public.student_load(student_id_arg text, term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_load(student_id_arg text, term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_load(student_id_arg text, term_id_arg integer) IS 'input: student id, term id


returns setof integer; setof section id that the student have';


--
-- Name: student_load_information(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_load_information(student_id_arg text, term_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 informations TEXT;
 section_id INTEGER;
BEGIN
 FOR section_id IN (SELECT student_load(student_id_arg, term_id_arg)) LOOP
  informations = section_information(section_id);
  RETURN NEXT informations;
 END LOOP;
 RETURN;
END;$$;


ALTER FUNCTION public.student_load_information(student_id_arg text, term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_load_information(student_id_arg text, term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_load_information(student_id_arg text, term_id_arg integer) IS 'input: student id, term id


returns setof text; section information that the student have';


--
-- Name: student_sessions_absented(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_sessions_absented(student_id_arg text, section_id_arg integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE

session_id_output INTEGER;

BEGIN

 FOR session_id_output in SELECT id FROM class_session  WHERE section_id = section_id_arg LOOP

  IF session_id_output NOT IN (SELECT session_id FROM attendance WHERE student_id = student_id_arg) THEN

   RETURN NEXT session_id_output;

  END IF;

 END LOOP;

  RETURN;

END;$$;


ALTER FUNCTION public.student_sessions_absented(student_id_arg text, section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_sessions_absented(student_id_arg text, section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_sessions_absented(student_id_arg text, section_id_arg integer) IS 'input: student id, section id


returns setof integer; id of the student absent sessions';


--
-- Name: student_sessions_absented_information(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_sessions_absented_information(student_id_arg text, section_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 informations TEXT;
 session_id INTEGER;
BEGIN
 FOR session_id IN (SELECT student_sessions_absented(student_id_arg, section_id_arg)) LOOP
  informations = class_session_information(session_id);
  RETURN NEXT informations;
 END LOOP;
 RETURN;
END;$$;


ALTER FUNCTION public.student_sessions_absented_information(student_id_arg text, section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_sessions_absented_information(student_id_arg text, section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_sessions_absented_information(student_id_arg text, section_id_arg integer) IS 'input: student id, section id


returns setof integer; id of the student absent sessions';


--
-- Name: student_sessions_attended(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_sessions_attended(student_id_arg text, section_id_arg integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$DECLARE

session_id_output INTEGER;

BEGIN

 FOR session_id_output in SELECT id FROM class_session  WHERE section_id = section_id_arg LOOP

  IF session_id_output IN (SELECT session_id FROM attendance WHERE student_id = student_id_arg) THEN

   RETURN NEXT session_id_output;

  END IF;

 END LOOP;

  RETURN;

END;$$;


ALTER FUNCTION public.student_sessions_attended(student_id_arg text, section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_sessions_attended(student_id_arg text, section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_sessions_attended(student_id_arg text, section_id_arg integer) IS 'input: student id, section id


returns setof integer; id of the student attended sessions';


--
-- Name: student_sessions_attended_information(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_sessions_attended_information(student_id_arg text, section_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 informations TEXT;
 session_id INTEGER;
BEGIN
 FOR session_id IN (SELECT student_sessions_attended(student_id_arg, section_id_arg)) LOOP
  informations = class_session_information(session_id);
  RETURN NEXT informations;
 END LOOP;
 RETURN;
END;$$;


ALTER FUNCTION public.student_sessions_attended_information(student_id_arg text, section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_sessions_attended_information(student_id_arg text, section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_sessions_attended_information(student_id_arg text, section_id_arg integer) IS 'input: student id, section id


returns setof text; information of the student attended sessions';


--
-- Name: term_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION term_information(term_id_arg integer) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

 school_year TEXT;

 semester_output TEXT;

BEGIN

 SELECT INTO semester_output, school_year semester, school_year.school_year FROM term INNER JOIN school_year ON (term.school_year_id = school_year.id) WHERE term.id = term_id_arg;

 RETURN term_id_arg || '#' || school_year || '#' || semester_output;

END;$$;


ALTER FUNCTION public.term_information(term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION term_information(term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION term_information(term_id_arg integer) IS 'input: grading system id, new weight


returns text; term information of format, id - school year - semester';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE account (
    name text NOT NULL,
    hashed_password text NOT NULL,
    salt text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.account OWNER TO postgres;

--
-- Name: COLUMN account.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN account.name IS 'account name';


--
-- Name: COLUMN account.hashed_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN account.hashed_password IS 'hashed password';


--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_id_seq OWNER TO postgres;

--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE account_id_seq OWNED BY account.id;


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('account_id_seq', 5, true);


--
-- Name: assignation; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE assignation (
    section_id integer NOT NULL,
    faculty_id text NOT NULL,
    id integer NOT NULL,
    term_id integer
);


ALTER TABLE public.assignation OWNER TO postgres;

--
-- Name: assignation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE assignation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assignation_id_seq OWNER TO postgres;

--
-- Name: assignation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE assignation_id_seq OWNED BY assignation.id;


--
-- Name: assignation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('assignation_id_seq', 5, true);


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attendance (
    "time" time without time zone NOT NULL,
    confirmed boolean DEFAULT false NOT NULL,
    id integer NOT NULL,
    student_id text NOT NULL,
    session_id integer
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE attendance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendance_id_seq OWNER TO postgres;

--
-- Name: attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE attendance_id_seq OWNED BY attendance.id;


--
-- Name: attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('attendance_id_seq', 17, true);


--
-- Name: class_session; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE class_session (
    id integer NOT NULL,
    section_id integer NOT NULL,
    status text DEFAULT 'ONGOING'::text NOT NULL,
    date date DEFAULT now() NOT NULL
);


ALTER TABLE public.class_session OWNER TO postgres;

--
-- Name: class_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE class_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_session_id_seq OWNER TO postgres;

--
-- Name: class_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE class_session_id_seq OWNED BY class_session.id;


--
-- Name: class_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('class_session_id_seq', 6, true);


--
-- Name: course; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE course (
    name text NOT NULL,
    id integer NOT NULL,
    code text NOT NULL
);


ALTER TABLE public.course OWNER TO postgres;

--
-- Name: course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE course_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_id_seq OWNER TO postgres;

--
-- Name: course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE course_id_seq OWNED BY course.id;


--
-- Name: course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('course_id_seq', 4, true);


--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE department (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.department_id_seq OWNER TO postgres;

--
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE department_id_seq OWNED BY department.id;


--
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('department_id_seq', 5, true);


--
-- Name: department_name_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE department_name_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.department_name_seq OWNER TO postgres;

--
-- Name: department_name_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE department_name_seq OWNED BY department.name;


--
-- Name: department_name_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('department_name_seq', 1, false);


--
-- Name: enroll; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE enroll (
    student_id text NOT NULL,
    term_id integer NOT NULL,
    section_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.enroll OWNER TO postgres;

--
-- Name: enroll_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE enroll_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enroll_id_seq OWNER TO postgres;

--
-- Name: enroll_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE enroll_id_seq OWNED BY enroll.id;


--
-- Name: enroll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('enroll_id_seq', 7, true);


--
-- Name: faculty_department; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE faculty_department (
    id integer NOT NULL,
    faculty_id text NOT NULL,
    department_id integer NOT NULL
);


ALTER TABLE public.faculty_department OWNER TO postgres;

--
-- Name: faculty_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE faculty_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_department_id_seq OWNER TO postgres;

--
-- Name: faculty_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE faculty_department_id_seq OWNED BY faculty_department.id;


--
-- Name: faculty_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('faculty_department_id_seq', 1, true);


--
-- Name: grade_item; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grade_item (
    id integer NOT NULL,
    grading_system_id integer NOT NULL,
    name text NOT NULL,
    total_score double precision NOT NULL,
    date timestamp without time zone NOT NULL
);


ALTER TABLE public.grade_item OWNER TO postgres;

--
-- Name: grade_item_entry; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grade_item_entry (
    id integer NOT NULL,
    grade_item_id integer NOT NULL,
    score double precision NOT NULL,
    student_id text NOT NULL
);


ALTER TABLE public.grade_item_entry OWNER TO postgres;

--
-- Name: grade_item_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE grade_item_entry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grade_item_entry_id_seq OWNER TO postgres;

--
-- Name: grade_item_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE grade_item_entry_id_seq OWNED BY grade_item_entry.id;


--
-- Name: grade_item_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('grade_item_entry_id_seq', 16, true);


--
-- Name: grade_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE grade_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grade_item_id_seq OWNER TO postgres;

--
-- Name: grade_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE grade_item_id_seq OWNED BY grade_item.id;


--
-- Name: grade_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('grade_item_id_seq', 6, true);


--
-- Name: grading_system; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grading_system (
    weight double precision NOT NULL,
    id integer NOT NULL,
    name text,
    section_id integer
);


ALTER TABLE public.grading_system OWNER TO postgres;

--
-- Name: grading_system_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE grading_system_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grading_system_id_seq OWNER TO postgres;

--
-- Name: grading_system_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE grading_system_id_seq OWNED BY grading_system.id;


--
-- Name: grading_system_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('grading_system_id_seq', 48, true);


--
-- Name: linked_account; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linked_account (
    student_id text NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    id integer NOT NULL,
    parent_id text NOT NULL
);


ALTER TABLE public.linked_account OWNER TO postgres;

--
-- Name: linked_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linked_account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.linked_account_id_seq OWNER TO postgres;

--
-- Name: linked_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linked_account_id_seq OWNED BY linked_account.id;


--
-- Name: linked_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linked_account_id_seq', 2, true);


--
-- Name: person; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE person (
    id text NOT NULL,
    type text NOT NULL,
    first_name text NOT NULL,
    middle_name text NOT NULL,
    last_name text NOT NULL,
    account_id integer NOT NULL,
    image_source text NOT NULL,
    email text,
    year integer
);


ALTER TABLE public.person OWNER TO postgres;

--
-- Name: school_year; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE school_year (
    school_year text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.school_year OWNER TO postgres;

--
-- Name: school_year_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE school_year_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.school_year_id_seq OWNER TO postgres;

--
-- Name: school_year_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE school_year_id_seq OWNED BY school_year.id;


--
-- Name: school_year_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('school_year_id_seq', 4, true);


--
-- Name: section; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE section (
    name text NOT NULL,
    subject_id integer NOT NULL,
    "time" text NOT NULL,
    id integer NOT NULL,
    day text,
    room text,
    term_id integer NOT NULL
);


ALTER TABLE public.section OWNER TO postgres;

--
-- Name: COLUMN section.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN section.name IS 'section code';


--
-- Name: section_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.section_id_seq OWNER TO postgres;

--
-- Name: section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE section_id_seq OWNED BY section.id;


--
-- Name: section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('section_id_seq', 3, true);


--
-- Name: student_course; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE student_course (
    id integer NOT NULL,
    student_id text NOT NULL,
    course_id integer NOT NULL
);


ALTER TABLE public.student_course OWNER TO postgres;

--
-- Name: student_course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE student_course_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_course_id_seq OWNER TO postgres;

--
-- Name: student_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE student_course_id_seq OWNED BY student_course.id;


--
-- Name: student_course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('student_course_id_seq', 2, true);


--
-- Name: subject; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE subject (
    name text NOT NULL,
    description text NOT NULL,
    id integer NOT NULL,
    units integer,
    type text
);


ALTER TABLE public.subject OWNER TO postgres;

--
-- Name: subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subject_id_seq OWNER TO postgres;

--
-- Name: subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE subject_id_seq OWNED BY subject.id;


--
-- Name: subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('subject_id_seq', 5, true);


--
-- Name: term; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE term (
    school_year_id integer NOT NULL,
    id integer NOT NULL,
    semester text
);


ALTER TABLE public.term OWNER TO postgres;

--
-- Name: term_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE term_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.term_id_seq OWNER TO postgres;

--
-- Name: term_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE term_id_seq OWNED BY term.id;


--
-- Name: term_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('term_id_seq', 6, true);


--
-- Name: user_account_salt_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_account_salt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_account_salt_seq OWNER TO postgres;

--
-- Name: user_account_salt_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_account_salt_seq OWNED BY account.salt;


--
-- Name: user_account_salt_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_account_salt_seq', 1, false);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY account ALTER COLUMN id SET DEFAULT nextval('account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assignation ALTER COLUMN id SET DEFAULT nextval('assignation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendance ALTER COLUMN id SET DEFAULT nextval('attendance_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY class_session ALTER COLUMN id SET DEFAULT nextval('class_session_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY course ALTER COLUMN id SET DEFAULT nextval('course_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY department ALTER COLUMN id SET DEFAULT nextval('department_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enroll ALTER COLUMN id SET DEFAULT nextval('enroll_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY faculty_department ALTER COLUMN id SET DEFAULT nextval('faculty_department_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grade_item ALTER COLUMN id SET DEFAULT nextval('grade_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grade_item_entry ALTER COLUMN id SET DEFAULT nextval('grade_item_entry_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grading_system ALTER COLUMN id SET DEFAULT nextval('grading_system_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linked_account ALTER COLUMN id SET DEFAULT nextval('linked_account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY school_year ALTER COLUMN id SET DEFAULT nextval('school_year_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY section ALTER COLUMN id SET DEFAULT nextval('section_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY student_course ALTER COLUMN id SET DEFAULT nextval('student_course_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subject ALTER COLUMN id SET DEFAULT nextval('subject_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY term ALTER COLUMN id SET DEFAULT nextval('term_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO account VALUES ('razor0512', 'a8e52a4c08639ff544bc259334cd262c8abf8f81705116ad1f38ff6c14bcb1f5fc51e4f7688d99793be703d8189c33015d40baec9d6006f7b75577a5ec8444ba', 'c42501e4552b4f72b8512abc72e2c18d', 3);
INSERT INTO account VALUES ('encuberevenant', 'encube', 'w832749urwer8oq734', 1);
INSERT INTO account VALUES ('ADMIN', '0733aa6ce6ff49a35b5dd7eacfe5ca1e8d683e7b8f49845d245aa244d940ea98ac4cfaed16cbe09a0b05e57968dc60478360ab1ffcfb12d331d6aebc155bd61c', '3e8ea203c99a41beb1ecb016c100a307', 5);
INSERT INTO account VALUES ('mama', 'MAMA', 'sdkjflasidf93ur93urowtjuowierlas', 4);
INSERT INTO account VALUES ('encube', 'sandrevenant', '0457dea5c1cd443ca6692282c0780f72', 2);


--
-- Data for Name: assignation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO assignation VALUES (3, '1998-9999', 5, 6);
INSERT INTO assignation VALUES (1, '1998-9999', 4, 6);
INSERT INTO assignation VALUES (2, '1998-9999', 2, 6);


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO attendance VALUES ('17:43:49', true, 6, '2010-7171', NULL);
INSERT INTO attendance VALUES ('19:41:31', true, 9, '2010-7171', NULL);
INSERT INTO attendance VALUES ('19:41:54', true, 10, '2010-7171', NULL);
INSERT INTO attendance VALUES ('19:56:18', true, 12, '2010-7171', NULL);
INSERT INTO attendance VALUES ('17:09:19', true, 4, '2010-7171', 2);
INSERT INTO attendance VALUES ('08:58:30', true, 14, '2010-7171', 3);
INSERT INTO attendance VALUES ('22:18:26', true, 13, '2010-7171', 4);
INSERT INTO attendance VALUES ('19:42:45', true, 11, '2010-7171', 5);
INSERT INTO attendance VALUES ('12:23:00', false, 17, '2009-1625', 4);
INSERT INTO attendance VALUES ('02:09:00', true, 16, '2009-1625', 2);


--
-- Data for Name: class_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO class_session VALUES (5, 1, 'ONGOING', '2012-09-28');
INSERT INTO class_session VALUES (2, 1, 'DISMISSED', '2012-09-28');
INSERT INTO class_session VALUES (3, 2, 'DISMISSED', '2012-09-28');
INSERT INTO class_session VALUES (4, 2, 'DISMISSED', '2012-09-28');


--
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO course VALUES ('Bachelor of Science in Computer Science', 1, 'BSCS');
INSERT INTO course VALUES ('Bachelor of Science in Information Technology', 2, 'BSIT');
INSERT INTO course VALUES ('Bachelor of Science in Electrical Engineering', 3, 'BSEE');
INSERT INTO course VALUES ('Bachelor of Science in Computer Engineering', 4, 'BSEC');


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO department VALUES (1, 'Computer Science');
INSERT INTO department VALUES (2, 'Information Technology');
INSERT INTO department VALUES (3, 'Business Administration');
INSERT INTO department VALUES (4, 'Electrical Engineering');
INSERT INTO department VALUES (5, 'Chemical Engineering');


--
-- Data for Name: enroll; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO enroll VALUES ('2010-7171', 6, 1, 4);
INSERT INTO enroll VALUES ('2010-7171', 6, 2, 5);
INSERT INTO enroll VALUES ('2009-1625', 6, 1, 6);
INSERT INTO enroll VALUES ('2009-1625', 6, 2, 7);


--
-- Data for Name: faculty_department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO faculty_department VALUES (1, '1998-9999', 1);


--
-- Data for Name: grade_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grade_item VALUES (1, 41, 'preliminary', 50, '2012-09-26 00:55:48.419224');
INSERT INTO grade_item VALUES (2, 42, 'Quiz, about algorithm', 20, '2012-09-26 00:56:47.595565');
INSERT INTO grade_item VALUES (3, 42, 'quiz', 35, '2012-09-26 19:15:56.924893');
INSERT INTO grade_item VALUES (5, 41, 'quiz', 40, '2012-09-26 23:32:28.603076');
INSERT INTO grade_item VALUES (6, 42, 'preliminary', 80, '2012-09-29 08:09:00');


--
-- Data for Name: grade_item_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grade_item_entry VALUES (8, 1, 33, '2009-1625');
INSERT INTO grade_item_entry VALUES (9, 3, 33, '2009-1625');
INSERT INTO grade_item_entry VALUES (11, 5, 33, '2009-1625');
INSERT INTO grade_item_entry VALUES (2, 1, 33, '2010-7171');
INSERT INTO grade_item_entry VALUES (3, 2, 33, '2010-7171');
INSERT INTO grade_item_entry VALUES (10, 5, 20, '2010-7171');
INSERT INTO grade_item_entry VALUES (12, 3, 1, '2010-7171');
INSERT INTO grade_item_entry VALUES (15, 6, 0, '2010-7171');
INSERT INTO grade_item_entry VALUES (4, 2, 15, '2009-1625');
INSERT INTO grade_item_entry VALUES (16, 6, 15, '2009-1625');


--
-- Data for Name: grading_system; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grading_system VALUES (15, 22, 'Prelim', 1);
INSERT INTO grading_system VALUES (20, 44, 'Midterm', 1);
INSERT INTO grading_system VALUES (20, 23, 'Prelim', 3);
INSERT INTO grading_system VALUES (20, 15, 'Assignment', 1);
INSERT INTO grading_system VALUES (15, 26, 'Finals', 3);
INSERT INTO grading_system VALUES (10, 47, 'Midterm', 2);
INSERT INTO grading_system VALUES (10, 42, 'Quiz', 2);
INSERT INTO grading_system VALUES (25, 48, 'quiz', 3);
INSERT INTO grading_system VALUES (24, 41, 'Prelim', 2);


--
-- Data for Name: linked_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO linked_account VALUES ('2009-1625', true, 1, 'P-2373');
INSERT INTO linked_account VALUES ('2010-7171', true, 2, 'P-2373');


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO person VALUES ('1998-9999', 'FACULTY', 'eddei', 'eh', 'pasa', 2, 'NO IMAGE', 'yolo@gmail.com', NULL);
INSERT INTO person VALUES ('P-2373', 'PARENT', 'uno', 'unta', 'dong', 4, 'NO IMAGE', 'uno@gmail.com', NULL);
INSERT INTO person VALUES ('2009-1625', 'FACULTY', 'novo', 'cubero', 'dimaporo', 1, 'NO IMAGE', 'hun@gmail.com', NULL);
INSERT INTO person VALUES ('2010-7171', 'STUDENT', 'shadow', 'strider', 'dawn', 3, 'NO IMAGE', 'shadow@gmail.com', 4);
INSERT INTO person VALUES ('2009-1625', 'STUDENT', 'novo', 'cubero', 'dimaporo', 1, 'NO IMAGE', 'encube@gmail.com', 3);


--
-- Data for Name: school_year; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO school_year VALUES ('2009-2010', 1);
INSERT INTO school_year VALUES ('2010-2011', 2);
INSERT INTO school_year VALUES ('2011-2012', 3);
INSERT INTO school_year VALUES ('2012-2013', 4);


--
-- Data for Name: section; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO section VALUES ('C2S', 2, '7:30 - 9:00', 1, 'TTH', 'LR1', 6);
INSERT INTO section VALUES ('CS24', 1, '10:30 - 12:00', 2, 'MS', 'LR3', 6);
INSERT INTO section VALUES ('C3S2', 4, '4:30-6:00', 3, 'TTh', 'SR', 6);


--
-- Data for Name: student_course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO student_course VALUES (1, '2009-1625', 1);
INSERT INTO student_course VALUES (2, '2010-7171', 1);


--
-- Data for Name: subject; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO subject VALUES ('CSC 101', 'Basic Programming', 2, 3, 'LEC');
INSERT INTO subject VALUES ('CSC 155', 'Introduction To Operating System', 4, 3, 'LEC');
INSERT INTO subject VALUES ('CSC 100', 'Intoduction To Computer Science', 1, 3, 'LEC');
INSERT INTO subject VALUES ('CSC 102', 'Advance Programming', 3, 3, 'LEC');
INSERT INTO subject VALUES ('CSC 181', 'Introduction To Software Engineering', 5, 3, 'LEC');


--
-- Data for Name: term; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO term VALUES (4, 6, '2');


--
-- Name: account_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_name_key UNIQUE (name);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: assignation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY assignation
    ADD CONSTRAINT assignation_pkey PRIMARY KEY (id);


--
-- Name: attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: class_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY class_session
    ADD CONSTRAINT class_session_pkey PRIMARY KEY (id);


--
-- Name: course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY course
    ADD CONSTRAINT course_pkey PRIMARY KEY (id);


--
-- Name: department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- Name: enroll_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY enroll
    ADD CONSTRAINT enroll_pkey PRIMARY KEY (id);


--
-- Name: faculty_department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY faculty_department
    ADD CONSTRAINT faculty_department_pkey PRIMARY KEY (id);


--
-- Name: grade_item_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grade_item_entry
    ADD CONSTRAINT grade_item_entry_pkey PRIMARY KEY (id);


--
-- Name: grade_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grade_item
    ADD CONSTRAINT grade_item_pkey PRIMARY KEY (id);


--
-- Name: grading_system_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grading_system
    ADD CONSTRAINT grading_system_pkey PRIMARY KEY (id);


--
-- Name: linked_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linked_account
    ADD CONSTRAINT linked_account_pkey PRIMARY KEY (id);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id, type);


--
-- Name: school_year_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY school_year
    ADD CONSTRAINT school_year_pkey PRIMARY KEY (id);


--
-- Name: section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY section
    ADD CONSTRAINT section_pkey PRIMARY KEY (id);


--
-- Name: student_course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY student_course
    ADD CONSTRAINT student_course_pkey PRIMARY KEY (id);


--
-- Name: subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id);


--
-- Name: term_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY term
    ADD CONSTRAINT term_pkey PRIMARY KEY (id);


--
-- Name: assignation_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assignation
    ADD CONSTRAINT assignation_section_id_fkey FOREIGN KEY (section_id) REFERENCES section(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: assignation_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assignation
    ADD CONSTRAINT assignation_term_id_fkey FOREIGN KEY (term_id) REFERENCES term(id);


--
-- Name: attendance_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_session_id_fkey FOREIGN KEY (session_id) REFERENCES class_session(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: class_session_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY class_session
    ADD CONSTRAINT class_session_section_id_fkey FOREIGN KEY (section_id) REFERENCES section(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: enroll_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enroll
    ADD CONSTRAINT enroll_section_id_fkey FOREIGN KEY (section_id) REFERENCES section(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: enroll_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enroll
    ADD CONSTRAINT enroll_term_id_fkey FOREIGN KEY (term_id) REFERENCES term(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: faculty_department_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY faculty_department
    ADD CONSTRAINT faculty_department_department_id_fkey FOREIGN KEY (department_id) REFERENCES department(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: grade_item_entry_grade_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grade_item_entry
    ADD CONSTRAINT grade_item_entry_grade_item_id_fkey FOREIGN KEY (grade_item_id) REFERENCES grade_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: grade_item_grading_system_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grade_item
    ADD CONSTRAINT grade_item_grading_system_id_fkey FOREIGN KEY (grading_system_id) REFERENCES grading_system(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: grading_system_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grading_system
    ADD CONSTRAINT grading_system_section_id_fkey FOREIGN KEY (section_id) REFERENCES section(id);


--
-- Name: person_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: section_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY section
    ADD CONSTRAINT section_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: student_course_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY student_course
    ADD CONSTRAINT student_course_course_id_fkey FOREIGN KEY (course_id) REFERENCES course(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: term_school_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY term
    ADD CONSTRAINT term_school_year_id_fkey FOREIGN KEY (school_year_id) REFERENCES school_year(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

drop table faculty_department;
create table person_department (
       id text,
       type text,
       dep_id int,
       constraint pd_pk primary key (id, type, dep_id),
       constraint pd_prsn foreign key (id, type) references
          person (id, type),
       constraint pd_dept foreign key (dep_id) references 
          department (id)
);

delete from attendance;
alter table attendance drop column session_id;
alter table attendance add column session_id integer not null;
alter table attendance drop constraint attendance_pkey;
alter table attendance drop column id;
alter table attendance add column person_id text;
alter table attendance add column type text;
alter table attendance add constraint attendance_pkey
  primary key (person_id, type, session_id, time);
alter table attendance add constraint attendance_person_fk
  foreign key (person_id, type) references
  person (id, type);
