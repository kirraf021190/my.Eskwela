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

     IF (status_var = 'ONGOING' AND (student_id_arg NOT IN (SELECT person_id FROM attendance WHERE session_id = session_id_arg AND person_type = 'STUDENT'))) THEN

      INSERT INTO attendance (session_id, time, person_id) VALUES(session_id_arg, time_arg, student_id_arg);

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

 IF (section_id_arg IN (SELECT id FROM section) AND 'ONGOING' NOT IN (SELECT status FROM class_session WHERE section_id = section_id_arg)) THEN

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

   INSERT INTO grade_item_entry(grade_item_id, score, person_id) VALUES(grade_item_id, 0, student_id_var);

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

 SELECT INTO grade_item_entry_id id FROM grade_item_entry WHERE person_id = student_id_arg AND grade_item_id = grade_item_id_arg AND person_type = 'STUDENT';

 IF grade_item_entry_id ISNULL THEN

  RETURN FALSE;

 ELSE

  UPDATE grade_item_entry SET score = score_arg WHERE person_id = student_id_arg AND grade_item_id = grade_item_id_arg;

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
-- Name: add_grading_system(text, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_grading_system(name_arg text, weight_arg double precision, section_id_arg integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$BEGIN
 IF name_arg NOT IN (SELECT name FROM grading_system WHERE section_id = section_id_arg) THEN
  INSERT INTO grading_system(name,weight,section_id) VALUES(name_arg,weight_arg,section_id_arg);
  RETURN TRUE;
 ELSE
  RETURN FALSE;
 END IF;
END;$$;


ALTER FUNCTION public.add_grading_system(name_arg text, weight_arg double precision, section_id_arg integer) OWNER TO postgres;

--
-- Name: autola_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION autola_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

 begin

    new.la_id = new.student_id || new.parent_id;

    return new;

 end;

$$;


ALTER FUNCTION public.autola_id() OWNER TO postgres;

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

COMMENT ON FUNCTION confirm_attendance(attendance_id_arg integer) IS 'OLD';


--
-- Name: confirm_attendance(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION confirm_attendance(session_id_arg integer, student_id_arg text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$BEGIN

     IF NOT (SELECT confirmed FROM attendance WHERE session_id = session_id_arg AND person_id = student_id_arg AND person_type = 'STUDENT') THEN

      UPDATE attendance SET confirmed = TRUE WHERE session_id = session_id_arg and person_id = student_id_arg AND person_type = 'STUDENT';

      RETURN TRUE;

     ELSE

      RETURN FALSE;

     END IF;

END;$$;


ALTER FUNCTION public.confirm_attendance(session_id_arg integer, student_id_arg text) OWNER TO postgres;

--
-- Name: FUNCTION confirm_attendance(session_id_arg integer, student_id_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION confirm_attendance(session_id_arg integer, student_id_arg text) IS 'input: session id, student_id

returns TRUE if successful to confirm attendance, false otherwise';


--
-- Name: count_student_enrolled(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION count_student_enrolled(section_id_arg integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

 result INTEGER;

BEGIN

 SELECT INTO result count(person_id) FROM person_load WHERE section_id = section_id_arg AND person_type = 'STUDENT';

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
-- Name: delete_grade_system_entry(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delete_grade_system_entry(grade_system_id_arg integer, section_id_arg integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$BEGIN

     DELETE FROM grading_system WHERE id = grade_system_id_arg AND section_id = section_id_arg;

     return TRUE;

END;$$;


ALTER FUNCTION public.delete_grade_system_entry(grade_system_id_arg integer, section_id_arg integer) OWNER TO postgres;

--
-- Name: delete_grading_system(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delete_grading_system(grading_system_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$BEGIN
 IF grading_system_id IN (SELECT id FROM grading_system) THEN
  DELETE FROM grading_system WHERE id = grading_system_id;
  RETURN TRUE;
 ELSE
  RETURN FALSE;
 END IF;
END$$;


ALTER FUNCTION public.delete_grading_system(grading_system_id integer) OWNER TO postgres;

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

 FOR student_id_output in SELECT person_id FROM person_load WHERE section_id = section_id_arg AND person_type = 'STUDENT' LOOP

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

 image_source_output TEXT;

BEGIN

 SELECT INTO first_name_output, middle_name_output, last_name_output, department_name_output, email_output, image_source_output person.first_name, person.middle_name, person.last_name, department.name, person.email, person.image_source FROM person INNER JOIN faculty_department ON (person.id = faculty_department.person_id) INNER JOIN department ON (faculty_department.department_id = department.id) WHERE person.id = faculty_id_arg AND person.type = 'FACULTY';

 RETURN faculty_id_arg || '#' || first_name_output || ' ' || middle_name_output || ' '|| last_name_output || '#' || department_name_output || '#' || email_output || '#' || image_source_output;

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

    FOR sections IN SELECT section_id FROM person_load WHERE person_id = faculty_id_arg AND term_id = term_id_arg AND person_type = 'FACULTY' LOOP

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
-- Name: get_grade_item_entry_in_section(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_grade_item_entry_in_section(student_id_arg text, section_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE
 grading_system_id_var INTEGER;
 grade_item_id_var INTEGER;
 grade_item_entry_output TEXT;

BEGIN
 FOR grading_system_id_var IN SELECT id FROM grading_system WHERE section_id = section_id_arg LOOP
  FOR grade_item_id_var IN SELECT id FROM grade_item WHERE grading_system_id = grading_system_id_var LOOP
   FOR grade_item_entry_output IN SELECT grading_system.name || '#' || grade_item.name || '#' || grade_item_entry.score || '#' || grade_item.total_score || '#' || grade_item.date FROM grading_system INNER JOIN grade_item ON (grading_system.id = grade_item.grading_system_id) INNER JOIN grade_item_entry ON (grade_item_entry.grade_item_id = grade_item.id) WHERE grade_item_id = grade_item_id_var AND person_id = student_id_arg AND person_type = 'STUDENT' LOOP
    RETURN NEXT grade_item_entry_output;
   END LOOP;
  END LOOP;
 END LOOP;
 RETURN;
END;$$;


ALTER FUNCTION public.get_grade_item_entry_in_section(student_id_arg text, section_id_arg integer) OWNER TO postgres;

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

 FOR grade_item_id IN SELECT id FROM grading_system WHERE section_id = section_id_arg ORDER BY weight desc LOOP

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
-- Name: get_ongoing_session(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_ongoing_session(section_id_arg integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

     id_output integer;

BEGIN 

     SELECT INTO id_output id FROM class_session WHERE section_id = section_id_arg AND status = 'ONGOING';

     if id_output isnull then

     return 0;

     else

    return id_output;

    end if;

END;$$;


ALTER FUNCTION public.get_ongoing_session(section_id_arg integer) OWNER TO postgres;

--
-- Name: get_section_attendance(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_section_attendance(session_id_arg integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$DECLARE

    student_id_output TEXT;

BEGIN

  FOR student_id_output IN SELECT person_id || '#' || person.last_name || ', ' || person.first_name || ' ' || person.middle_name || '#' || time || '#' || confirmed FROM attendance,person WHERE attendance.session_id = session_id_arg AND attendance.person_id = person.id ORDER BY time DESC LOOP

   RETURN NEXT student_id_output;

  END LOOP;

 RETURN;

END;$$;


ALTER FUNCTION public.get_section_attendance(session_id_arg integer) OWNER TO postgres;

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

 SELECT INTO student_id_output, score_output person_id, score FROM grade_item_entry WHERE id = grade_item_entry_id_arg;

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

 RETURN parent_id_arg || '#' || first_name_output || ' ' || middle_name_output || ' ' || last_name_output || '#' || email_output;

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

 SELECT INTO faculty_id_output person_id FROM person_load WHERE section_id = section_id_arg AND person_type = 'FACULTY';

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

 faculty TEXT;

BEGIN

 SELECT INTO section_name_output, subject_name_output, subject_type_output, subject_description_output, section_time_output, section_day_output, room_name_output, subject_unit_output section.name, subject.name, subject.type, subject.description, section.time, section.day, section.room, subject.units FROM section INNER JOIN subject ON (section.subject_id = subject.id) WHERE section.id = section_id_arg;

 SELECT INTO faculty first_name || ' ' || middle_name || ' ' || last_name FROM person WHERE id = section_faculty(section_id_arg);

 

 RETURN section_id_arg || '#' || subject_name_output || '#' || section_name_output || '#' || subject_description_output || '#' || section_day_output || ' ' || section_time_output || '#' || room_name_output || '#' || subject_unit_output || '#' || subject_type_output || '#' || faculty;

END;$$;


ALTER FUNCTION public.section_information(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION section_information(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION section_information(section_id_arg integer) IS 'input: grading system id, new weight

returns text; information of the section, format: id - subject code - section code - subject description - section day - section time - section room - subject units - subject type - faculty name';


--
-- Name: student_absence_count(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_absence_count(student_id_arg text, section_id_arg integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

 count INTEGER;

BEGIN

 SELECT INTO count count(*) FROM student_sessions_absented (student_id_arg, section_id_arg);

 IF count ISNULL THEN

  RETURN 0;

 ELSE

  RETURN count;

 END IF;

END;$$;


ALTER FUNCTION public.student_absence_count(student_id_arg text, section_id_arg integer) OWNER TO postgres;

--
-- Name: student_attendance_count(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_attendance_count(student_id_arg text, section_id_arg integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

 count INTEGER;

BEGIN

 SELECT INTO count count(*) FROM student_sessions_attended (student_id_arg, section_id_arg);

 IF count ISNULL THEN

  RETURN 0;

 ELSE

  RETURN count;

 END IF;

END;$$;


ALTER FUNCTION public.student_attendance_count(student_id_arg text, section_id_arg integer) OWNER TO postgres;

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

 image_source_output TEXT;

BEGIN

 SELECT INTO first_name_output, middle_name_output, last_name_output, course_name_output,  course_code_output, year_output, email_output,image_source_output person.first_name, person.middle_name, person.last_name, course.name, course.code, person.year, person.email,person.image_source FROM person INNER JOIN student_course ON (person.id = student_course.person_id) INNER JOIN course ON (student_course.course_id = course.id) WHERE person.id = student_id_arg AND person.type = 'STUDENT';

 RETURN student_id_arg || '#' || first_name_output || ' ' || middle_name_output || ' ' || last_name_output || '#' ||  course_code_output || '#' || course_name_output || '#' || year_output || '#' || email_output || '#' || image_source_output;

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

 SELECT INTO session_id_output MAX(session_id) FROM attendance INNER JOIN class_session ON (attendance.session_id = class_session.id) WHERE person_id = student_id_arg AND class_session.section_id = section_id_arg;

 IF session_id_output ISNULL THEN

  RETURN DATE '01-01-0001 00:00';

 END IF;

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

 FOR sections in SELECT section_id FROM person_load WHERE person_id = student_id_arg AND term_id = term_id_arg AND person_type = 'STUDENT' LOOP	

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

  IF session_id_output NOT IN (SELECT session_id FROM attendance WHERE person_id = student_id_arg) THEN

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

  IF session_id_output IN (SELECT session_id FROM attendance WHERE person_id = student_id_arg) THEN

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

 school_year_output TEXT;

 semester_output TEXT;

BEGIN

 SELECT INTO semester_output, school_year_output semester, school_year FROM term WHERE term.id = term_id_arg;

 RETURN term_id_arg || '#' || school_year_output || '#' || semester_output;

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
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attendance (
    confirmed boolean DEFAULT true NOT NULL,
    session_id integer NOT NULL,
    person_id text NOT NULL,
    person_type text DEFAULT 'STUDENT'::text NOT NULL,
    "time" timestamp without time zone NOT NULL
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: class_session; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE class_session (
    id bigint NOT NULL,
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

SELECT pg_catalog.setval('class_session_id_seq', 17, true);


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
-- Name: faculty_department; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE faculty_department (
    person_id text NOT NULL,
    person_type text DEFAULT 'FACULTY'::text NOT NULL,
    department_id integer NOT NULL
);


ALTER TABLE public.faculty_department OWNER TO postgres;

--
-- Name: grade_item; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grade_item (
    id bigint NOT NULL,
    grading_system_id bigint NOT NULL,
    name text NOT NULL,
    total_score double precision NOT NULL,
    date timestamp without time zone NOT NULL
);


ALTER TABLE public.grade_item OWNER TO postgres;

--
-- Name: grade_item_entry; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grade_item_entry (
    id bigint NOT NULL,
    grade_item_id bigint NOT NULL,
    score double precision NOT NULL,
    person_id text NOT NULL,
    person_type text DEFAULT 'STUDENT'::text NOT NULL
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

SELECT pg_catalog.setval('grade_item_entry_id_seq', 18, true);


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

SELECT pg_catalog.setval('grade_item_id_seq', 9, true);


--
-- Name: grading_system; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grading_system (
    weight double precision NOT NULL,
    id bigint NOT NULL,
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

SELECT pg_catalog.setval('grading_system_id_seq', 62, true);


--
-- Name: linked_account; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linked_account (
    student_id text NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    parent_id text NOT NULL,
    student_type text DEFAULT 'STUDENT'::text,
    parent_type text DEFAULT 'PARENT'::text,
    la_id text NOT NULL
);


ALTER TABLE public.linked_account OWNER TO postgres;

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
    image_source text DEFAULT 'nopic.jpg'::text NOT NULL,
    email text,
    year integer
);


ALTER TABLE public.person OWNER TO postgres;

--
-- Name: person_load; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE person_load (
    person_id text NOT NULL,
    person_type text NOT NULL,
    term_id integer NOT NULL,
    section_id integer NOT NULL
);


ALTER TABLE public.person_load OWNER TO postgres;

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
    person_id text NOT NULL,
    course_id integer NOT NULL,
    person_type text DEFAULT 'STUDENT'::text NOT NULL
);


ALTER TABLE public.student_course OWNER TO postgres;

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
    id integer NOT NULL,
    semester text,
    school_year text DEFAULT '2012 - 2013'::text NOT NULL
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

ALTER TABLE ONLY section ALTER COLUMN id SET DEFAULT nextval('section_id_seq'::regclass);


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
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO attendance VALUES (true, 12, '2010-7171', 'STUDENT', '2012-10-13 09:47:26');
INSERT INTO attendance VALUES (true, 12, '2009-1625', 'STUDENT', '2012-10-13 09:47:34');
INSERT INTO attendance VALUES (true, 13, '2010-7171', 'STUDENT', '2012-10-13 09:49:19');
INSERT INTO attendance VALUES (true, 13, '2009-1625', 'STUDENT', '2012-10-13 09:49:33');
INSERT INTO attendance VALUES (true, 14, '2010-7171', 'STUDENT', '2012-10-13 10:43:48');
INSERT INTO attendance VALUES (true, 14, '2009-1625', 'STUDENT', '2012-10-13 10:44:24');
INSERT INTO attendance VALUES (true, 15, '2009-1625', 'STUDENT', '2012-10-13 10:47:06');
INSERT INTO attendance VALUES (true, 15, '2010-7171', 'STUDENT', '2012-10-13 10:47:16');
INSERT INTO attendance VALUES (true, 17, '2009-1625', 'STUDENT', '2012-10-13 22:28:00');
INSERT INTO attendance VALUES (true, 17, '2010-7171', 'STUDENT', '2012-10-14 22:28:00');


--
-- Data for Name: class_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO class_session VALUES (2, 1, 'DISMISSED', '2012-09-28');
INSERT INTO class_session VALUES (4, 2, 'DISMISSED', '2012-09-28');
INSERT INTO class_session VALUES (8, 1, 'DISMISSED', '2012-10-11');
INSERT INTO class_session VALUES (9, 1, 'DISMISSED', '2012-10-11');
INSERT INTO class_session VALUES (10, 3, 'DISMISSED', '2012-10-13');
INSERT INTO class_session VALUES (11, 3, 'DISMISSED', '2012-10-13');
INSERT INTO class_session VALUES (12, 3, 'DISMISSED', '2012-10-13');
INSERT INTO class_session VALUES (13, 3, 'DISMISSED', '2012-10-13');
INSERT INTO class_session VALUES (14, 3, 'DISMISSED', '2012-10-13');
INSERT INTO class_session VALUES (15, 1, 'DISMISSED', '2012-10-13');
INSERT INTO class_session VALUES (17, 1, 'ONGOING', '2012-10-13');


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
-- Data for Name: faculty_department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO faculty_department VALUES ('1998-9999', 'FACULTY', 1);


--
-- Data for Name: grade_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grade_item VALUES (1, 41, 'preliminary', 50, '2012-09-26 00:55:48.419224');
INSERT INTO grade_item VALUES (5, 41, 'quiz', 40, '2012-09-26 23:32:28.603076');
INSERT INTO grade_item VALUES (9, 59, 'Assignment 1', 50, '2012-10-13 16:59:59');


--
-- Data for Name: grade_item_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grade_item_entry VALUES (8, 1, 33, '2009-1625', 'STUDENT');
INSERT INTO grade_item_entry VALUES (10, 5, 20, '2010-7171', 'STUDENT');
INSERT INTO grade_item_entry VALUES (2, 1, 33, '2010-7171', 'STUDENT');
INSERT INTO grade_item_entry VALUES (11, 5, 12, '2009-1625', 'STUDENT');


--
-- Data for Name: grading_system; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grading_system VALUES (20, 44, 'Midterm', 1);
INSERT INTO grading_system VALUES (20, 15, 'Assignment', 1);
INSERT INTO grading_system VALUES (10, 47, 'Midterm', 2);
INSERT INTO grading_system VALUES (24, 41, 'Prelim', 2);
INSERT INTO grading_system VALUES (16, 22, 'Prelim', 1);
INSERT INTO grading_system VALUES (10, 59, 'Assignment', 3);
INSERT INTO grading_system VALUES (30, 58, 'Prelim', 3);
INSERT INTO grading_system VALUES (25, 60, 'Quiz', 3);
INSERT INTO grading_system VALUES (30, 26, 'Finals', 3);


--
-- Data for Name: linked_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO linked_account VALUES ('2009-1625', true, 'P-2373', 'STUDENT', 'PARENT', '2009-1625P-2373');
INSERT INTO linked_account VALUES ('2010-7171', true, 'P-2373', 'STUDENT', 'PARENT', '2010-7171P-2373');


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO person VALUES ('P-2373', 'PARENT', 'uno', 'unta', 'dong', 4, 'NO IMAGE', 'uno@gmail.com', NULL);
INSERT INTO person VALUES ('2010-7171', 'STUDENT', 'Kevin Eric', 'Ridao', 'Siangco', 3, 'hawke.jpg', 'shdwstrider@gmail.com', 4);
INSERT INTO person VALUES ('2009-1625', 'STUDENT', 'Novo', 'Cubero', 'Dimaporo', 1, 'nero.jpg', 'encube@gmail.com', 3);
INSERT INTO person VALUES ('1998-9999', 'FACULTY', 'Eddie', 'Inc', 'Singko', 5, 'edisingko.jpg', 'smilingsingko@gmail.com', NULL);


--
-- Data for Name: person_load; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO person_load VALUES ('2009-1625', 'STUDENT', 6, 1);
INSERT INTO person_load VALUES ('2010-7171', 'STUDENT', 6, 2);
INSERT INTO person_load VALUES ('2009-1625', 'STUDENT', 6, 2);
INSERT INTO person_load VALUES ('2010-7171', 'STUDENT', 6, 1);
INSERT INTO person_load VALUES ('1998-9999', 'FACULTY', 6, 3);
INSERT INTO person_load VALUES ('1998-9999', 'FACULTY', 6, 2);
INSERT INTO person_load VALUES ('1998-9999', 'FACULTY', 6, 1);


--
-- Data for Name: section; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO section VALUES ('C2S', 2, '7:30 - 9:00', 1, 'TTH', 'LR1', 6);
INSERT INTO section VALUES ('CS24', 1, '10:30 - 12:00', 2, 'MS', 'LR3', 6);
INSERT INTO section VALUES ('C3S2', 4, '4:30-6:00', 3, 'TTh', 'SR', 6);


--
-- Data for Name: student_course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO student_course VALUES ('2009-1625', 1, 'STUDENT');
INSERT INTO student_course VALUES ('2010-7171', 1, 'STUDENT');


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

INSERT INTO term VALUES (6, '2', '2012-2013');


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
-- Name: attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (person_id, person_type, session_id);


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
-- Name: laid_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linked_account
    ADD CONSTRAINT laid_pk PRIMARY KEY (la_id);


--
-- Name: pd_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY faculty_department
    ADD CONSTRAINT pd_pk PRIMARY KEY (person_id, person_type, department_id);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id, type);


--
-- Name: pload_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person_load
    ADD CONSTRAINT pload_pk PRIMARY KEY (person_id, person_type, term_id, section_id);


--
-- Name: scourse_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY student_course
    ADD CONSTRAINT scourse_pk PRIMARY KEY (person_id, person_type, course_id);


--
-- Name: section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY section
    ADD CONSTRAINT section_pkey PRIMARY KEY (id);


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
-- Name: linked_account_pk_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER linked_account_pk_trig BEFORE INSERT ON linked_account FOR EACH ROW EXECUTE PROCEDURE autola_id();


--
-- Name: attendance_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_person_fk FOREIGN KEY (person_id, person_type) REFERENCES person(id, type);


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
-- Name: grade_item_entry_grade_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grade_item_entry
    ADD CONSTRAINT grade_item_entry_grade_item_id_fkey FOREIGN KEY (grade_item_id) REFERENCES grade_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: grade_item_entry_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grade_item_entry
    ADD CONSTRAINT grade_item_entry_person_fk FOREIGN KEY (person_id, person_type) REFERENCES person(id, type);


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
-- Name: laid_par_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linked_account
    ADD CONSTRAINT laid_par_fk FOREIGN KEY (parent_id, parent_type) REFERENCES person(id, type);


--
-- Name: laid_stu_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linked_account
    ADD CONSTRAINT laid_stu_fk FOREIGN KEY (student_id, student_type) REFERENCES person(id, type);


--
-- Name: pd_dept; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY faculty_department
    ADD CONSTRAINT pd_dept FOREIGN KEY (department_id) REFERENCES department(id);


--
-- Name: pd_prsn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY faculty_department
    ADD CONSTRAINT pd_prsn FOREIGN KEY (person_id, person_type) REFERENCES person(id, type);


--
-- Name: person_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pload_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY person_load
    ADD CONSTRAINT pload_person_fk FOREIGN KEY (person_id, person_type) REFERENCES person(id, type);


--
-- Name: pload_section_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY person_load
    ADD CONSTRAINT pload_section_fk FOREIGN KEY (section_id) REFERENCES section(id);


--
-- Name: pload_term_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY person_load
    ADD CONSTRAINT pload_term_fk FOREIGN KEY (term_id) REFERENCES term(id);


--
-- Name: scourse_person_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY student_course
    ADD CONSTRAINT scourse_person_fk FOREIGN KEY (person_id, person_type) REFERENCES person(id, type);


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
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: account; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE account FROM PUBLIC;
REVOKE ALL ON TABLE account FROM postgres;
GRANT ALL ON TABLE account TO postgres;
GRANT SELECT,UPDATE ON TABLE account TO student;
GRANT SELECT,UPDATE ON TABLE account TO parent;
GRANT SELECT,UPDATE ON TABLE account TO faculty;
GRANT ALL ON TABLE account TO su;


--
-- Name: attendance; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE attendance FROM PUBLIC;
REVOKE ALL ON TABLE attendance FROM postgres;
GRANT ALL ON TABLE attendance TO postgres;
GRANT SELECT,INSERT ON TABLE attendance TO student;
GRANT SELECT ON TABLE attendance TO parent;
GRANT ALL ON TABLE attendance TO faculty;
GRANT ALL ON TABLE attendance TO su;


--
-- Name: class_session; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE class_session FROM PUBLIC;
REVOKE ALL ON TABLE class_session FROM postgres;
GRANT ALL ON TABLE class_session TO postgres;
GRANT SELECT ON TABLE class_session TO student;
GRANT SELECT ON TABLE class_session TO parent;
GRANT SELECT ON TABLE class_session TO faculty;
GRANT ALL ON TABLE class_session TO su;


--
-- Name: course; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE course FROM PUBLIC;
REVOKE ALL ON TABLE course FROM postgres;
GRANT ALL ON TABLE course TO postgres;
GRANT SELECT ON TABLE course TO student;
GRANT SELECT ON TABLE course TO parent;
GRANT SELECT ON TABLE course TO faculty;
GRANT ALL ON TABLE course TO su;


--
-- Name: department; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE department FROM PUBLIC;
REVOKE ALL ON TABLE department FROM postgres;
GRANT ALL ON TABLE department TO postgres;
GRANT SELECT ON TABLE department TO student;
GRANT SELECT ON TABLE department TO parent;
GRANT SELECT ON TABLE department TO faculty;
GRANT ALL ON TABLE department TO su;


--
-- Name: grade_item; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE grade_item FROM PUBLIC;
REVOKE ALL ON TABLE grade_item FROM postgres;
GRANT ALL ON TABLE grade_item TO postgres;
GRANT SELECT ON TABLE grade_item TO student;
GRANT SELECT ON TABLE grade_item TO parent;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE grade_item TO faculty;
GRANT ALL ON TABLE grade_item TO su;


--
-- Name: grade_item_entry; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE grade_item_entry FROM PUBLIC;
REVOKE ALL ON TABLE grade_item_entry FROM postgres;
GRANT ALL ON TABLE grade_item_entry TO postgres;
GRANT SELECT ON TABLE grade_item_entry TO student;
GRANT SELECT ON TABLE grade_item_entry TO parent;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE grade_item_entry TO faculty;
GRANT ALL ON TABLE grade_item_entry TO su;


--
-- Name: grading_system; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE grading_system FROM PUBLIC;
REVOKE ALL ON TABLE grading_system FROM postgres;
GRANT ALL ON TABLE grading_system TO postgres;
GRANT SELECT ON TABLE grading_system TO student;
GRANT SELECT ON TABLE grading_system TO parent;
GRANT SELECT,INSERT,UPDATE ON TABLE grading_system TO faculty;
GRANT ALL ON TABLE grading_system TO su;


--
-- Name: linked_account; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE linked_account FROM PUBLIC;
REVOKE ALL ON TABLE linked_account FROM postgres;
GRANT ALL ON TABLE linked_account TO postgres;
GRANT SELECT ON TABLE linked_account TO student;
GRANT SELECT ON TABLE linked_account TO parent;
GRANT SELECT ON TABLE linked_account TO faculty;
GRANT ALL ON TABLE linked_account TO su;


--
-- Name: person; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE person FROM PUBLIC;
REVOKE ALL ON TABLE person FROM postgres;
GRANT ALL ON TABLE person TO postgres;
GRANT SELECT ON TABLE person TO student;
GRANT SELECT ON TABLE person TO parent;
GRANT SELECT ON TABLE person TO faculty;
GRANT ALL ON TABLE person TO su;


--
-- Name: person_load; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE person_load FROM PUBLIC;
REVOKE ALL ON TABLE person_load FROM postgres;
GRANT ALL ON TABLE person_load TO postgres;
GRANT SELECT ON TABLE person_load TO student;
GRANT SELECT ON TABLE person_load TO parent;
GRANT ALL ON TABLE person_load TO faculty;
GRANT ALL ON TABLE person_load TO su;


--
-- Name: section; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE section FROM PUBLIC;
REVOKE ALL ON TABLE section FROM postgres;
GRANT ALL ON TABLE section TO postgres;
GRANT SELECT ON TABLE section TO student;
GRANT SELECT ON TABLE section TO parent;
GRANT SELECT ON TABLE section TO faculty;
GRANT ALL ON TABLE section TO su;


--
-- Name: student_course; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE student_course FROM PUBLIC;
REVOKE ALL ON TABLE student_course FROM postgres;
GRANT ALL ON TABLE student_course TO postgres;
GRANT SELECT ON TABLE student_course TO student;
GRANT SELECT ON TABLE student_course TO parent;
GRANT SELECT ON TABLE student_course TO faculty;
GRANT ALL ON TABLE student_course TO su;


--
-- Name: subject; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE subject FROM PUBLIC;
REVOKE ALL ON TABLE subject FROM postgres;
GRANT ALL ON TABLE subject TO postgres;
GRANT SELECT ON TABLE subject TO student;
GRANT SELECT ON TABLE subject TO parent;
GRANT SELECT ON TABLE subject TO faculty;
GRANT ALL ON TABLE subject TO su;


--
-- Name: term; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE term FROM PUBLIC;
REVOKE ALL ON TABLE term FROM postgres;
GRANT ALL ON TABLE term TO postgres;
GRANT SELECT ON TABLE term TO student;
GRANT SELECT ON TABLE term TO parent;
GRANT SELECT ON TABLE term TO faculty;
GRANT ALL ON TABLE term TO su;


--
-- PostgreSQL database dump complete
--

