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

 role    TEXT;

 account_id_arg INTEGER;

BEGIN

 SELECT INTO role account_roles.role FROM account INNER JOIN account_roles ON (account.id = account_roles.account_id) WHERE account.name = account_name_arg;

 SELECT INTO account_id_arg account.id FROM account WHERE name = account_name_arg;

 IF role = 'STUDENT' THEN

  SELECT INTO role_id student.id FROM student WHERE student.account_id = account_id_arg;

 ELSE

  IF role = 'PARENT' THEN

   SELECT INTO role_id parent.id FROM parent WHERE parent.account_id = account_id_arg;

  ELSE

   SELECT INTO role_id faculty.id FROM faculty WHERE faculty.account_id = account_id_arg;

  END IF;

 END IF;

 RETURN role_id;

END;$$;


ALTER FUNCTION public.account_role_id(account_name_arg text) OWNER TO postgres;

--
-- Name: FUNCTION account_role_id(account_name_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION account_role_id(account_name_arg text) IS 'input: account name

returns the role_id of the account user';


--
-- Name: add_grade_item(text, integer, double precision, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_grade_item(name_arg text, grading_system_id_arg integer, total_score_arg double precision, date timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE
 grade_item_id INTEGER;
BEGIN
 SELECT INTO grade_item_id id FROM grade_item WHERE name = name_arg;
 IF name_arg IN (SELECT name FROM grade_item WHERE name = name_arg) THEN
  RETURN 0;
 ELSE
  INSERT INTO grade_item(grading_system_id, name, total_score, date) VALUES(grading_system_id_arg, name_arg, total_score_arg, date_arg);
  SELECT INTO grade_item_id id FROM grade_item WHERE name = name_arg;
  RETURN grade_item_id;
 END IF;
END;$$;


ALTER FUNCTION public.add_grade_item(name_arg text, grading_system_id_arg integer, total_score_arg double precision, date timestamp without time zone) OWNER TO postgres;

--
-- Name: FUNCTION add_grade_item(name_arg text, grading_system_id_arg integer, total_score_arg double precision, date timestamp without time zone); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION add_grade_item(name_arg text, grading_system_id_arg integer, total_score_arg double precision, date timestamp without time zone) IS 'input: name of the grade item to be created, grading system id, total score, date

output: id of the created grade item or 0 if it already exist';


--
-- Name: addattend(integer, timestamp without time zone, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addattend(sec_id integer, timestamp_ timestamp without time zone, stud_id text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

     currterm integer;

BEGIN

     currterm = getcurrsem();

     INSERT INTO attendance (section_id,term_id,time,student_id) VALUES(sec_id,currterm,timestamp_,stud_id);

     return 'true';

END$$;


ALTER FUNCTION public.addattend(sec_id integer, timestamp_ timestamp without time zone, stud_id text) OWNER TO postgres;

--
-- Name: FUNCTION addattend(sec_id integer, timestamp_ timestamp without time zone, stud_id text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION addattend(sec_id integer, timestamp_ timestamp without time zone, stud_id text) IS 'WEB INTERFACE

Accepts: sec_id(int), timestamp_(timestamp w/o time zone), stud_id(text)

Returns: ''true'' (text) if successful';


--
-- Name: addgradecategory(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addgradecategory(name_ text, weight_ integer, sec_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$BEGIN

     INSERT INTO grading_system(weight,name,section_id) VALUES(weight_,name_,sec_id);

     return 'true';

END$$;


ALTER FUNCTION public.addgradecategory(name_ text, weight_ integer, sec_id integer) OWNER TO postgres;

--
-- Name: FUNCTION addgradecategory(name_ text, weight_ integer, sec_id integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION addgradecategory(name_ text, weight_ integer, sec_id integer) IS 'WEB INTERFACE

Accepts: name_ (text), weight_(integer), sec_id (integer)

Returns: ''true'' (text) if successful';


--
-- Name: confirmattendance(text, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION confirmattendance(idnum text, sec_id integer, timein timestamp without time zone) RETURNS text
    LANGUAGE plpgsql
    AS $$BEGIN

     UPDATE attendance SET confirmed = TRUE WHERE student_id = idnum AND section_id = sec_id AND time = timein;

     return 'true';

END$$;


ALTER FUNCTION public.confirmattendance(idnum text, sec_id integer, timein timestamp without time zone) OWNER TO postgres;

--
-- Name: FUNCTION confirmattendance(idnum text, sec_id integer, timein timestamp without time zone); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION confirmattendance(idnum text, sec_id integer, timein timestamp without time zone) IS 'WEB INTERFACE

Accepts: idnum (text), sec_id(integer), timein(timestamp w/o time zone)

Returns: ''true'' (text) if successful';


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

output: student count enrolled in the section';


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
-- Name: deletegradecategory(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION deletegradecategory(name_ text, sec_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$BEGIN

     DELETE FROM grading_system WHERE name = name_ AND section_id = sec_id;

     return 'true';

END;$$;


ALTER FUNCTION public.deletegradecategory(name_ text, sec_id integer) OWNER TO postgres;

--
-- Name: FUNCTION deletegradecategory(name_ text, sec_id integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION deletegradecategory(name_ text, sec_id integer) IS 'WEB INTERFACE

Accepts: name_ (text), sec_id (integer)

Returns: ''true'' (text) if successful';


--
-- Name: editcatweight(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION editcatweight(name_ text, weight_ integer, sec_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$BEGIN

     UPDATE grading_system SET weight = weight_ WHERE name = name_ AND section_id = sec_id;

     return 'true';

END;$$;


ALTER FUNCTION public.editcatweight(name_ text, weight_ integer, sec_id integer) OWNER TO postgres;

--
-- Name: FUNCTION editcatweight(name_ text, weight_ integer, sec_id integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION editcatweight(name_ text, weight_ integer, sec_id integer) IS 'WEB INTERFACE

Accepts: name_ (text), weight_ (integer), sec_id (integer)

Returns: ''true'' (text) if successful';


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

output: setof student id';


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

COMMENT ON FUNCTION get_children(parent_id_arg text) IS 'intput: parents id

output: childrens id number';


--
-- Name: get_email(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_email(id_arg text, role text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
 email_output TEXT;
BEGIN
 IF role = 'STUDENT' THEN
  SELECT INTO email_output email FROM student WHERE id = id_arg;
 ELSE
  IF role = 'PARENT' THEN
   SELECT INTO email_output email FROM parent WHERE id = id_arg;
  ELSE
   SELECT INTO email_output email FROM faculty WHERE id = id_arg;
  END IF;
 END IF;
 IF email_output ISNULL THEN
  RETURN 'ID NOT FOUND UNDER ' || role;
 ELSE
  RETURN email_output;
 END IF;
END;$$;


ALTER FUNCTION public.get_email(id_arg text, role text) OWNER TO postgres;

--
-- Name: FUNCTION get_email(id_arg text, role text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_email(id_arg text, role text) IS 'input: id number and role e.g. get_email(''2009-7263'', ''STUDENT'')
       role must be any of this (STUDENT, FACULTY, PARENT)

output: email';


--
-- Name: get_image_location(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_image_location(id_arg text, role text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
 image_location TEXT;
BEGIN
 IF role = 'STUDENT' THEN
  SELECT INTO image_location image_source FROM student WHERE id = id_arg;
 ELSE
  IF role = 'PARENT' THEN
   SELECT INTO image_location image_source FROM parent WHERE id = id_arg;
  ELSE
   SELECT INTO image_location image_source FROM faculty WHERE id = id_arg;
  END IF;
 END IF;
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

COMMENT ON FUNCTION get_image_location(id_arg text, role text) IS 'input: id number and role e.g. get_image_location(''2009-7263'', ''STUDENT'')
       role must be any of this (STUDENT, FACULTY, PARENT)

output: image location';


--
-- Name: getaccounttype(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getaccounttype(userid integer) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

      role TEXT;

BEGIN

 SELECT INTO role account_roles.role FROM account INNER JOIN account_roles ON (account.id = account_roles.account_id) WHERE account.id = userid;

 RETURN role;

END;$$;


ALTER FUNCTION public.getaccounttype(userid integer) OWNER TO postgres;

--
-- Name: FUNCTION getaccounttype(userid integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getaccounttype(userid integer) IS 'WEB INTERFACE

Accepts: userid (integer)

Returns: Account type (text)';


--
-- Name: getattend(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getattend(sec_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$DECLARE

     temp text;

     att text;

BEGIN

att = '';

FOR temp IN SELECT attendance.student_id || '$' || student.first_name|| ' ' || student.last_name || '$' || attendance.time  || '$' || confirmed  FROM attendance,student WHERE attendance.section_id = sec_id AND attendance.student_id = student.id ORDER BY time DESC loop

att = att || temp || '@';

end loop;

return att;

END;$_$;


ALTER FUNCTION public.getattend(sec_id integer) OWNER TO postgres;

--
-- Name: FUNCTION getattend(sec_id integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getattend(sec_id integer) IS 'WEB INTERFACE

Accepts: sec_id (integer)

Returns: String of attendances with delimiters (text)

Delimiter: $ for column, @ for row';


--
-- Name: getclasses(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getclasses(userid integer, usertype text) RETURNS text
    LANGUAGE plpgsql
    AS $_$DECLARE 

     temp text;

     classes text;

     type text;

BEGIN

classes = '';

IF usertype='STUDENT' then

 FOR temp IN SELECT subject.name||'$'|| section.name||'$'|| subject.description ||'$'|| section.day ||' '|| section.time ||'$'||  section.room ||'$'|| subject.type||'$'|| faculty.first_name ||' '||faculty.last_name ||'$'|| section.id FROM section,subject,enroll,student,faculty,assignation WHERE enroll.student_id = student.id AND assignation.faculty_id = faculty.id AND subject.id = section.subject_id AND section.id = assignation.section_id AND student.account_id = userid and enroll.section_id = section.id  loop

classes = classes || temp || '@';

end loop; 

end if;

IF usertype='FACULTY' then

FOR temp IN SELECT subject.name||'$'|| section.name||'$'|| subject.description ||'$'|| section.day ||' '|| section.time ||'$'||  section.room ||'$'|| subject.type ||'$'|| section.id  FROM subject,faculty,section,assignation WHERE assignation.faculty_id = faculty.id AND subject.id = section.subject_id AND section.id = assignation.section_id AND faculty.account_id = userid loop

classes = classes || temp || '@';

end loop; 

end if;

return classes;

END;$_$;


ALTER FUNCTION public.getclasses(userid integer, usertype text) OWNER TO postgres;

--
-- Name: FUNCTION getclasses(userid integer, usertype text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getclasses(userid integer, usertype text) IS 'WEB INTERFACE

Accepts: userid (integer), usertype (text)

Returns: String of classes (text)

Delimiter: $ for column, @ for row';


--
-- Name: getcurrsem(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getcurrsem() RETURNS integer
    LANGUAGE plpgsql
    AS $$declare

        b integer;

  begin

	select into b max(term.id) from term;

        if b isnull then

             b = 'NOT FOUND!!!';

        end if;

        return b;

  end;$$;


ALTER FUNCTION public.getcurrsem() OWNER TO postgres;

--
-- Name: FUNCTION getcurrsem(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getcurrsem() IS 'WEB INTERFACE

Accepts: none

Returns: ID reference to current semester(integer)';


--
-- Name: getgradesystem(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getgradesystem(sec_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$DECLARE

     temp text;

     gs text;

BEGIN

gs = '';

FOR temp IN SELECT name || '$' || weight FROM grading_system WHERE grading_system.section_id =sec_id ORDER BY weight DESC loop 

gs = gs || temp || '@';

end loop;

return gs;

END;$_$;


ALTER FUNCTION public.getgradesystem(sec_id integer) OWNER TO postgres;

--
-- Name: FUNCTION getgradesystem(sec_id integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getgradesystem(sec_id integer) IS 'WEB INTERFACE

Accepts: sec_id (integer)

Returns: String of grade system with delimiters

Delimiters: $ for column, @ for row';


--
-- Name: getid(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getid(username_ text) RETURNS integer
    LANGUAGE plpgsql
    AS $$declare

     userid_ integer;

begin

     SELECT INTO userid_ id FROM account WHERE name = username_;

     return userid_;

end;$$;


ALTER FUNCTION public.getid(username_ text) OWNER TO postgres;

--
-- Name: FUNCTION getid(username_ text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getid(username_ text) IS 'WEB INTERFACE 

Accepts: username (text)

Returns: userid_(integer)';


--
-- Name: getinfo(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getinfo(userid integer, type_ text) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

     info text;

BEGIN 

     IF type_ = 'STUDENT' then

          SELECT into info first_name||' '||middle_name||' '||last_name||' '||','||student.id||','||course.name||' '||year||','||email from student, course where account_id = userid;

     end if;

     IF type_ = 'FACULTY' then

          SELECT into info first_name||' '||middle_name||' '||last_name||' '||','||faculty.id||','||department.name||','||email from faculty,department where account_id = userid;

     end if;

     return info;

END;$$;


ALTER FUNCTION public.getinfo(userid integer, type_ text) OWNER TO postgres;

--
-- Name: FUNCTION getinfo(userid integer, type_ text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION getinfo(userid integer, type_ text) IS 'WEB INTERFACE

Accepts: userid (integer), account type (text)

Returns: string of user information (text)

Delimiter: ,';


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

COMMENT ON FUNCTION getsalt(username_ text) IS 'WEB INTERFACE

Accepts: username (text)

Returns: salt (text)';


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

COMMENT ON FUNCTION login(name_arg text, password_arg text) IS 'input: account, password

returns: string TRUE if successful, FALSE otherwise';


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

 SELECT INTO first_name_output, middle_name_output, last_name_output, email_output first_name, middle_name, last_name, email FROM parent WHERE parent.id = parent_id_arg;

 RETURN first_name_output || '#' || middle_name_output || '#' || last_name_output || '#' || email_output;

END;$$;


ALTER FUNCTION public.parent_information(parent_id_arg text) OWNER TO postgres;

--
-- Name: FUNCTION parent_information(parent_id_arg text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION parent_information(parent_id_arg text) IS 'input: parent id

output: parent information';


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

 SELECT INTO section_name_output, subject_name_output, subject_type_output, subject_description_output, section_time_output, section_day_output, room_name_output, subject_unit_output section.name, subject.name, subject.type, subject.description, section.time, section.day, section.room, subject.units FROM section INNER JOIN subject ON (section.subject_id = subject.id) WHERE section.id = section_id_arg;

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

 FOR stamps in SELECT DISTINCT time FROM attendance WHERE term_id = term_id_arg AND section_id = section_id_arg LOOP
 IF stamps NOT IN (SELECT time FROM attendance WHERE student_id = student_id_arg AND section_id = section_id_arg AND term_id = term_id_arg) THEN
  RETURN NEXT stamps;
 END IF;

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

 FOR stamps in SELECT DISTINCT time FROM attendance WHERE term_id = term_id_arg AND section_id = section_id_arg LOOP
 IF stamps IN (SELECT time FROM attendance WHERE student_id = student_id_arg AND section_id = section_id_arg AND term_id = term_id_arg) THEN
  RETURN NEXT stamps;
 END IF;

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
-- Name: account_roles; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE account_roles (
    account_id integer NOT NULL,
    role text NOT NULL
);


ALTER TABLE public.account_roles OWNER TO postgres;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE activities (
    id integer NOT NULL,
    grading_system_id integer NOT NULL,
    score double precision NOT NULL,
    total double precision NOT NULL
);


ALTER TABLE public.activities OWNER TO postgres;

--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activities_id_seq OWNER TO postgres;

--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('activities_id_seq', 3, true);


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

SELECT pg_catalog.setval('attendance_id_seq', 14, true);


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
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE faculty (
    first_name text NOT NULL,
    middle_name text NOT NULL,
    last_name text NOT NULL,
    department_id integer NOT NULL,
    email text DEFAULT 'none'::text NOT NULL,
    id text NOT NULL,
    account_id integer,
    image_source text DEFAULT 'NO_IMAGE'::text NOT NULL
);


ALTER TABLE public.faculty OWNER TO postgres;

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

SELECT pg_catalog.setval('grade_item_entry_id_seq', 5, true);


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

SELECT pg_catalog.setval('grade_item_id_seq', 2, true);


--
-- Name: grading_system; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE grading_system (
    weight integer NOT NULL,
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

SELECT pg_catalog.setval('grading_system_id_seq', 47, true);


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
    id text NOT NULL,
    account_id integer,
    image_source text DEFAULT 'NO_IMAGE'::text NOT NULL
);


ALTER TABLE public.parent OWNER TO postgres;

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
    room text
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
-- Name: student; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE student (
    first_name text NOT NULL,
    middle_name text NOT NULL,
    last_name text NOT NULL,
    course_id integer NOT NULL,
    year integer NOT NULL,
    email text DEFAULT 'none'::text NOT NULL,
    id text NOT NULL,
    account_id integer,
    image_source text DEFAULT 'NO_IMAGE'::text NOT NULL
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

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


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
-- Data for Name: account_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO account_roles VALUES (2, 'STUDENT');
INSERT INTO account_roles VALUES (3, 'STUDENT');
INSERT INTO account_roles VALUES (4, 'PARENT');
INSERT INTO account_roles VALUES (1, 'FACULTY');
INSERT INTO account_roles VALUES (5, 'FACULTY');


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO activities VALUES (1, 22, 20, 25);
INSERT INTO activities VALUES (2, 44, 57, 80);
INSERT INTO activities VALUES (3, 15, 19, 35);


--
-- Data for Name: assignation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO assignation VALUES (2, '1992-9384', 2, 6);
INSERT INTO assignation VALUES (1, '1992-9384', 4, 6);
INSERT INTO assignation VALUES (3, '1992-9384', 5, 6);


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO attendance VALUES (2, 6, '2012-09-20 17:46:54', true, 7, '2010-7171');
INSERT INTO attendance VALUES (2, 6, '2012-09-20 17:43:08', true, 5, '2010-7171');
INSERT INTO attendance VALUES (2, 6, '2012-09-20 17:09:19', true, 4, '2010-7171');
INSERT INTO attendance VALUES (1, 6, '2012-09-20 17:43:49', true, 6, '2010-7171');
INSERT INTO attendance VALUES (1, 6, '2012-09-20 19:41:31', true, 9, '2010-7171');
INSERT INTO attendance VALUES (1, 6, '2012-09-20 19:41:54', true, 10, '2010-7171');
INSERT INTO attendance VALUES (1, 6, '2012-09-20 19:42:45', true, 11, '2010-7171');
INSERT INTO attendance VALUES (2, 6, '2012-09-20 19:56:18', true, 12, '2010-7171');
INSERT INTO attendance VALUES (1, 6, '2012-09-20 22:18:26', true, 13, '2010-7171');
INSERT INTO attendance VALUES (1, 6, '2012-09-21 08:58:30', true, 14, '2010-7171');


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
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO faculty VALUES ('Eddie', 'Inc', 'Singko', 1, 'renegade_0512@yahoo.com', '1992-9384', 1, 'NO_IMAGE');


--
-- Data for Name: grade_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grade_item VALUES (1, 41, 'preliminary', 50, '2012-09-26 00:55:48.419224');
INSERT INTO grade_item VALUES (2, 42, 'Quiz, about algorithm', 20, '2012-09-26 00:56:47.595565');


--
-- Data for Name: grade_item_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grade_item_entry VALUES (2, 1, 43, '2010-7171');
INSERT INTO grade_item_entry VALUES (3, 2, 15, '2010-7171');
INSERT INTO grade_item_entry VALUES (4, 2, 15, '2009-1625');
INSERT INTO grade_item_entry VALUES (5, 2, 15, '2010-2312');


--
-- Data for Name: grading_system; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grading_system VALUES (20, 41, 'Prelim', 2);
INSERT INTO grading_system VALUES (15, 22, 'Prelim', 1);
INSERT INTO grading_system VALUES (20, 44, 'Midterm', 1);
INSERT INTO grading_system VALUES (20, 23, 'Prelim', 3);
INSERT INTO grading_system VALUES (20, 15, 'Assignment', 1);
INSERT INTO grading_system VALUES (15, 26, 'Finals', 3);
INSERT INTO grading_system VALUES (10, 47, 'Midterm', 2);
INSERT INTO grading_system VALUES (10, 42, 'Quiz', 2);


--
-- Data for Name: linked_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO linked_account VALUES ('2010-2312', true, 2, 'P-2373');
INSERT INTO linked_account VALUES ('2009-1625', true, 1, 'P-2373');


--
-- Data for Name: parent; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO parent VALUES ('hay', 'nako', 'tres', 'mama@yahoo.com', 'P-2373', 4, 'NO_IMAGE');


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

INSERT INTO section VALUES ('C2S', 2, '7:30 - 9:00', 1, 'TTH', 'LR1');
INSERT INTO section VALUES ('CS24', 1, '10:30 - 12:00', 2, 'MS', 'LR3');
INSERT INTO section VALUES ('C3S2', 4, '4:30-6:00', 3, 'TTh', 'SR');


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO student VALUES ('johny', 'smith', 'english', 3, 2, 'encuberevenant@gmail.com', '2010-2312', NULL, 'NO_IMAGE');
INSERT INTO student VALUES ('Kevin  Eric', 'Ridao', 'Siangco', 1, 3, 'shdwstrider@gmail.com', '2010-7171', 3, 'NO_IMAGE');
INSERT INTO student VALUES ('Novo', 'Cubero', 'Dimaporo', 1, 4, 'sandrevenant@gmail.com', '2009-1625', 2, 'NO_IMAGE');


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
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


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
-- Name: parent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY parent
    ADD CONSTRAINT parent_pkey PRIMARY KEY (id);


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
-- Name: activities_grading_system_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_grading_system_id_fkey FOREIGN KEY (grading_system_id) REFERENCES grading_system(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: assignation_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY assignation
    ADD CONSTRAINT assignation_term_id_fkey FOREIGN KEY (term_id) REFERENCES term(id);


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
-- Name: faculty_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY faculty
    ADD CONSTRAINT faculty_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: faculty_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY faculty
    ADD CONSTRAINT faculty_department_id_fkey FOREIGN KEY (department_id) REFERENCES department(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: grade_item_entry_grade_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grade_item_entry
    ADD CONSTRAINT grade_item_entry_grade_item_id_fkey FOREIGN KEY (grade_item_id) REFERENCES grade_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: grade_item_entry_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY grade_item_entry
    ADD CONSTRAINT grade_item_entry_student_id_fkey FOREIGN KEY (student_id) REFERENCES student(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: parent_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY parent
    ADD CONSTRAINT parent_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: section_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY section
    ADD CONSTRAINT section_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: student_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY student
    ADD CONSTRAINT student_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

