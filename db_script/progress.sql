--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: account_role(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION account_role(account_name_arg text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
 role TEXT;
BEGIN
 SELECT INTO role account_roles.role FROM account INNER JOIN account_roles ON (account.id = account_roles.account_id) WHERE account.name = account_name_arg;
 RETURN role;
END;$$;


ALTER FUNCTION public.account_role(account_name_arg text) OWNER TO postgres;

--
-- Name: FUNCTION account_role(account_name_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION account_role(account_name_arg text) IS 'input: account name
returns the role of the account user';


--
-- Name: account_role_id(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION account_role_id(account_name_arg text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
 role_id TEXT;
BEGIN
 SELECT INTO role_id account_roles.role_id FROM account_roles INNER JOIN account ON (account_roles.account_id = account.id) WHERE account.name = account_name_arg;
 RETURN role_id;
END;$$;


ALTER FUNCTION public.account_role_id(account_name_arg text) OWNER TO postgres;

--
-- Name: FUNCTION account_role_id(account_name_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION account_role_id(account_name_arg text) IS 'input: account name
returns the role_id of the account user';


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

COMMENT ON FUNCTION current_term() IS 'returns current terms id';


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
 SELECT INTO first_name_output, middle_name_output, last_name_output, department_name_output, email_output faculty.first_name, faculty.middle_name, faculty.last_name, department.name, faculty.email FROM faculty INNER JOIN department ON (faculty.department_id = department.id) WHERE faculty.id = faculty_id_arg;
 RETURN first_name_output || '#' || middle_name_output || '#' || last_name_output || '#' || department_name_output || '#' || email_output;
END;$$;


ALTER FUNCTION public.faculty_information(faculty_id_arg text) OWNER TO postgres;

--
-- Name: FUNCTION faculty_information(faculty_id_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION faculty_information(faculty_id_arg text) IS 'input: faculty id
returns faculty information
 format: first name - middle name - last name - department name - email
 delimiter: #';


--
-- Name: login(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION login(name_arg text, password_arg text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
 result TEXT;
BEGIN
 SELECT INTO result id FROM account WHERE name = name_arg and password = password_arg;
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

COMMENT ON FUNCTION login(name_arg text, password_arg text) IS 'input: account, password
returns: string TRUE if successful, FALSE otherwise';


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
returns id of the faculty assigned to the section.';


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
 SELECT INTO section_name_output, subject_name_output, subject_type_output, subject_description_output, section_time_output, section_day_output, room_name_output, subject_unit_output section.name, subject.name, subject.type, subject.description, section.time, section.day, room.name, subject.units FROM section INNER JOIN room ON (section.room_id = room.id) INNER JOIN subject ON (section.subject_id = subject.id) WHERE section.id = section_id_arg;

 RETURN subject_name_output || '#' || section_name_output || '#' || subject_description_output || '#' || section_day_output || '#' || section_time_output || '#' || room_name_output || '#' || subject_unit_output || '#' || subject_type_output;

END;$$;


ALTER FUNCTION public.section_information(section_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION section_information(section_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION section_information(section_id_arg integer) IS 'returns section information;
 format: subject code - section code - subject description - section day - section time - section room - subject units - subject type
 delimiter: #';


--
-- Name: student_absence_count(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_absence_count(student_id_arg text, section_id_arg integer, term_id_arg integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE
 count INTEGER;
BEGIN
 SELECT INTO count count(*) FROM attendance WHERE student_id = student_id_arg and section_id = section_id_arg and term_id = term_id_arg and confirmed = false;
 RETURN count;
END;$$;


ALTER FUNCTION public.student_absence_count(student_id_arg text, section_id_arg integer, term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_absence_count(student_id_arg text, section_id_arg integer, term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_absence_count(student_id_arg text, section_id_arg integer, term_id_arg integer) IS 'input: student id, section id, term id
returns absence count of student on section in term';


--
-- Name: student_attendance_count(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_attendance_count(student_id_arg text, section_id_arg integer, term_id_arg integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE
 count INTEGER;
BEGIN
 SELECT INTO count count(*) FROM attendance WHERE student_id = student_id_arg and section_id = section_id_arg and term_id = term_id_arg and confirmed = true;
 RETURN count;
END;$$;


ALTER FUNCTION public.student_attendance_count(student_id_arg text, section_id_arg integer, term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_attendance_count(student_id_arg text, section_id_arg integer, term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_attendance_count(student_id_arg text, section_id_arg integer, term_id_arg integer) IS 'input: student id, section id, term id
returns attendance count of student on section in term';


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
 SELECT INTO first_name_output, middle_name_output, last_name_output, course_name_output,  course_code_output, year_output, email_output student.first_name, student.middle_name, student.last_name, course.name, course.code, student.year, student.email FROM student INNER JOIN course ON (student.course_id = course.id) WHERE student.id = student_id_arg;
 RETURN first_name_output || '#' || middle_name_output || '#' || last_name_output || '#' ||  course_code_output || '#' || course_name_output || '#' || year_output || '#' || email_output;
END;$$;


ALTER FUNCTION public.student_information(student_id_arg text) OWNER TO postgres;

--
-- Name: FUNCTION student_information(student_id_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_information(student_id_arg text) IS 'input: student id
returns student information
 format: first name - middle name - last name - course - year - email
 delimiter: #';


--
-- Name: student_last_attended(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_last_attended(student_id_arg text, section_id_arg integer, term_id_arg integer) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $$DECLARE
 stamp TIMESTAMP;
BEGIN
 SELECT INTO stamp max(time) FROM attendance WHERE student_id = student_id_arg and section_id = section_id_arg and term_id = term_id_arg;
 RETURN stamp;
END;$$;


ALTER FUNCTION public.student_last_attended(student_id_arg text, section_id_arg integer, term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_last_attended(student_id_arg text, section_id_arg integer, term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_last_attended(student_id_arg text, section_id_arg integer, term_id_arg integer) IS 'input: student id, section id, term id
returns last attendance timestamp';


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
returns a set of section id''s';


--
-- Name: student_sessions_absented(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_sessions_absented(student_id_arg text, section_id_arg integer, term_id_arg integer) RETURNS SETOF timestamp without time zone
    LANGUAGE plpgsql
    AS $$DECLARE

stamps TIMESTAMP;

BEGIN

 FOR stamps in SELECT time FROM attendance WHERE student_id = student_id_arg and section_id = section_id_arg and term_id = term_id_arg and confirmed = false LOOP

 RETURN NEXT stamps;

  END LOOP;

  RETURN;

END;$$;


ALTER FUNCTION public.student_sessions_absented(student_id_arg text, section_id_arg integer, term_id_arg integer) OWNER TO postgres;

--
-- Name: student_sessions_attended(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_sessions_attended(student_id_arg text, section_id_arg integer, term_id_arg integer) RETURNS SETOF timestamp without time zone
    LANGUAGE plpgsql
    AS $$DECLARE

stamps TIMESTAMP;

BEGIN

 FOR stamps in SELECT time FROM attendance WHERE student_id = student_id_arg and section_id = section_id_arg and term_id = term_id_arg and confirmed = true LOOP

 RETURN NEXT stamps;

  END LOOP;

  RETURN;

END;$$;


ALTER FUNCTION public.student_sessions_attended(student_id_arg text, section_id_arg integer, term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION student_sessions_attended(student_id_arg text, section_id_arg integer, term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION student_sessions_attended(student_id_arg text, section_id_arg integer, term_id_arg integer) IS 'input: student id, section id, term id
returns set of timestamp of attended session';


--
-- Name: term_information(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION term_information(term_id_arg integer) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
 school_year TEXT;
 semester TEXT;
BEGIN
 SELECT INTO semester, school_year semester.semester, school_year.school_year FROM term INNER JOIN semester ON (term.semester_id = semester.id) INNER JOIN school_year ON (term.school_year_id = school_year.id) WHERE term.id = term_id_arg;
 RETURN school_year || ' ' || semester;
END;$$;


ALTER FUNCTION public.term_information(term_id_arg integer) OWNER TO postgres;

--
-- Name: FUNCTION term_information(term_id_arg integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION term_information(term_id_arg integer) IS 'input: term id
returns: the terms information
 format: [school year] [semester]';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE account (
    name text NOT NULL,
    password text NOT NULL,
    salt text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.account OWNER TO postgres;

--
-- Name: COLUMN account.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN account.name IS 'account name';


--
-- Name: COLUMN account.password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN account.password IS 'hashed password';


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

SELECT pg_catalog.setval('account_id_seq', 4, true);


--
-- Name: account_roles; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE account_roles (
    account_id integer NOT NULL,
    role text NOT NULL,
    role_id text NOT NULL
);


ALTER TABLE public.account_roles OWNER TO postgres;

--
-- Name: assignation; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE assignation (
    section_id integer NOT NULL,
    faculty_id text NOT NULL,
    id integer NOT NULL
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

SELECT pg_catalog.setval('assignation_id_seq', 3, true);


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attendance (
    section_id integer NOT NULL,
    term_id integer NOT NULL,
    "time" timestamp without time zone NOT NULL,
    confirmed boolean DEFAULT false NOT NULL,
    id integer NOT NULL,
    student_id text NOT NULL
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

SELECT pg_catalog.setval('attendance_id_seq', 3, true);


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

SELECT pg_catalog.setval('enroll_id_seq', 3, true);


--
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE faculty (
    first_name text NOT NULL,
    middle_name text NOT NULL,
    last_name text NOT NULL,
    department_id integer NOT NULL,
    email text DEFAULT 'none'::text NOT NULL,
    id text NOT NULL
);


ALTER TABLE public.faculty OWNER TO postgres;

--
-- Name: grading_system; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grading_system (
    quiz integer NOT NULL,
    preliminary integer NOT NULL,
    midterm integer NOT NULL,
    final integer NOT NULL,
    attendance integer NOT NULL,
    others integer NOT NULL,
    id integer NOT NULL
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

SELECT pg_catalog.setval('grading_system_id_seq', 2, true);


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
-- Name: parent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE parent (
    first_name text NOT NULL,
    middle_name text NOT NULL,
    last_name text NOT NULL,
    email text DEFAULT 'none'::text NOT NULL,
    id text NOT NULL
);


ALTER TABLE public.parent OWNER TO postgres;

--
-- Name: room; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE room (
    name text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.room OWNER TO postgres;

--
-- Name: room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE room_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.room_id_seq OWNER TO postgres;

--
-- Name: room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE room_id_seq OWNED BY room.id;


--
-- Name: room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('room_id_seq', 9, true);


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
    grading_system_id integer NOT NULL,
    room_id integer NOT NULL,
    id integer NOT NULL,
    day text
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

SELECT pg_catalog.setval('section_id_seq', 2, true);


--
-- Name: semester; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE semester (
    semester text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.semester OWNER TO postgres;

--
-- Name: semester_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE semester_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.semester_id_seq OWNER TO postgres;

--
-- Name: semester_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE semester_id_seq OWNED BY semester.id;


--
-- Name: semester_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('semester_id_seq', 3, true);


--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE student (
    first_name text NOT NULL,
    middle_name text NOT NULL,
    last_name text NOT NULL,
    course_id integer NOT NULL,
    year integer NOT NULL,
    email text DEFAULT 'none'::text NOT NULL,
    id text NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

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
    semester_id integer NOT NULL,
    school_year_id integer NOT NULL,
    id integer NOT NULL
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

SELECT pg_catalog.setval('term_id_seq', 5, true);


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

ALTER TABLE ONLY grading_system ALTER COLUMN id SET DEFAULT nextval('grading_system_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linked_account ALTER COLUMN id SET DEFAULT nextval('linked_account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY room ALTER COLUMN id SET DEFAULT nextval('room_id_seq'::regclass);


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

ALTER TABLE ONLY semester ALTER COLUMN id SET DEFAULT nextval('semester_id_seq'::regclass);


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

INSERT INTO account VALUES ('encube', '2ecf49dcb3dea8b9777dfdef11ed2593ba12367eecbbb8100b75e3c2464e8239ab72cfa9a0d357285da4749dffd18f76c97a9219ffb85715a6c5c75c3832d889', '0457dea5c1cd443ca6692282c0780f72', 2);
INSERT INTO account VALUES ('razor0512', 'a8e52a4c08639ff544bc259334cd262c8abf8f81705116ad1f38ff6c14bcb1f5fc51e4f7688d99793be703d8189c33015d40baec9d6006f7b75577a5ec8444ba', 'c42501e4552b4f72b8512abc72e2c18d', 3);
INSERT INTO account VALUES ('mama', 'sjdfakjh3riu3o89uoeifaskdjfasfjalsdkfj aksjf laskdjflaskdjfifruowiaeflaksjfalskdj', 'sdkjflasidf93ur93urowtjuowierlas', 4);
INSERT INTO account VALUES ('encuberevenant', 'kjlsdf8779a3w8ruiuwhfa8ie7riausehk3wiuyrfkwhjfkaw8eyriu3hkrjwh8f7awo8rh', 'w832749urwer8oq734', 1);


--
-- Data for Name: account_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO account_roles VALUES (2, 'STUDENT', '2009-1625');
INSERT INTO account_roles VALUES (3, 'STUDENT', '2010-2312');
INSERT INTO account_roles VALUES (4, 'PARENT', 'P-2373');
INSERT INTO account_roles VALUES (1, 'FACULTY', '1992-9384');


--
-- Data for Name: assignation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO assignation VALUES (2, '1992-9384', 2);
INSERT INTO assignation VALUES (1, '1992-9384', 3);


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO attendance VALUES (2, 4, '2012-09-06 17:53:08.547604', true, 2, '2009-1625');
INSERT INTO attendance VALUES (1, 4, '2012-09-06 17:53:26.646385', true, 3, '2009-1625');


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

INSERT INTO enroll VALUES ('2009-1625', 4, 2, 1);
INSERT INTO enroll VALUES ('2009-1625', 4, 1, 3);


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO faculty VALUES ('eddie', 'ince', 'singko', 1, 'sandy@gmail.com', '1992-9384');


--
-- Data for Name: grading_system; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grading_system VALUES (20, 20, 20, 20, 10, 10, 1);
INSERT INTO grading_system VALUES (30, 20, 20, 20, 10, 0, 2);


--
-- Data for Name: linked_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO linked_account VALUES ('2010-2312', true, 2, 'P-2373');
INSERT INTO linked_account VALUES ('2009-1625', true, 1, 'P-2373');


--
-- Data for Name: parent; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO parent VALUES ('hay', 'nako', 'tres', 'mama@yahoo.com', 'P-2373');


--
-- Data for Name: room; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO room VALUES ('LHA', 1);
INSERT INTO room VALUES ('LHB', 2);
INSERT INTO room VALUES ('LHC', 3);
INSERT INTO room VALUES ('LR1', 4);
INSERT INTO room VALUES ('LR2', 5);
INSERT INTO room VALUES ('LR3', 6);
INSERT INTO room VALUES ('LR4', 7);
INSERT INTO room VALUES ('Hub Port', 8);
INSERT INTO room VALUES ('Software Engineering Laboratory', 9);


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

INSERT INTO section VALUES ('C2S', 2, '7:30 - 9:00', 1, 1, 1, 'TTH');
INSERT INTO section VALUES ('CS24', 1, '10:30 - 12:00', 2, 3, 2, 'MS');


--
-- Data for Name: semester; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO semester VALUES ('First Semester', 1);
INSERT INTO semester VALUES ('Second Semester', 2);
INSERT INTO semester VALUES ('Summer Semester', 3);


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO student VALUES ('novo', 'cubero', 'dimaporo', 1, 4, 'sandrevenant@gmail.com', '2009-1625');
INSERT INTO student VALUES ('johny', 'smith', 'english', 3, 2, 'encuberevenant@gmail.com', '2010-2312');


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

INSERT INTO term VALUES (1, 3, 1);
INSERT INTO term VALUES (2, 3, 2);
INSERT INTO term VALUES (1, 4, 3);
INSERT INTO term VALUES (2, 4, 4);
INSERT INTO term VALUES (3, 4, 5);


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
-- Name: faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (id);


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
-- Name: parent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY parent
    ADD CONSTRAINT parent_pkey PRIMARY KEY (id);


--
-- Name: room_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY room
    ADD CONSTRAINT room_pkey PRIMARY KEY (id);


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
-- Name: semester_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY semester
    ADD CONSTRAINT semester_pkey PRIMARY KEY (id);


--
-- Name: student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


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
-- Name: account_roles_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY account_roles
    ADD CONSTRAINT account_roles_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: assignation_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assignation
    ADD CONSTRAINT assignation_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES faculty(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: assignation_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assignation
    ADD CONSTRAINT assignation_section_id_fkey FOREIGN KEY (section_id) REFERENCES section(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: attendance_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_section_id_fkey FOREIGN KEY (section_id) REFERENCES section(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: attendance_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_student_id_fkey FOREIGN KEY (student_id) REFERENCES student(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: attendance_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_term_id_fkey FOREIGN KEY (term_id) REFERENCES term(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: enroll_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enroll
    ADD CONSTRAINT enroll_section_id_fkey FOREIGN KEY (section_id) REFERENCES section(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: enroll_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enroll
    ADD CONSTRAINT enroll_student_id_fkey FOREIGN KEY (student_id) REFERENCES student(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: enroll_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY enroll
    ADD CONSTRAINT enroll_term_id_fkey FOREIGN KEY (term_id) REFERENCES term(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: faculty_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY faculty
    ADD CONSTRAINT faculty_department_id_fkey FOREIGN KEY (department_id) REFERENCES department(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: linked_account_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linked_account
    ADD CONSTRAINT linked_account_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES parent(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: linked_account_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linked_account
    ADD CONSTRAINT linked_account_student_id_fkey FOREIGN KEY (student_id) REFERENCES student(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: section_grading_system_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY section
    ADD CONSTRAINT section_grading_system_id_fkey FOREIGN KEY (grading_system_id) REFERENCES grading_system(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: section_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY section
    ADD CONSTRAINT section_room_id_fkey FOREIGN KEY (room_id) REFERENCES room(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: section_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY section
    ADD CONSTRAINT section_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: student_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY student
    ADD CONSTRAINT student_course_id_fkey FOREIGN KEY (course_id) REFERENCES course(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: term_school_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY term
    ADD CONSTRAINT term_school_year_id_fkey FOREIGN KEY (school_year_id) REFERENCES school_year(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: term_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY term
    ADD CONSTRAINT term_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES semester(id) ON UPDATE CASCADE ON DELETE CASCADE;


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

