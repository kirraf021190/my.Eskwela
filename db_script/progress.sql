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
-- Name: addparent(text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addparent(text, text, text, text, text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$declare
     username_ alias for $1;
     salt_ alias for $2;
     hash_ alias for $3;
     fname_ alias for $4;
     mname_ alias for $5;
     lname_ alias for $6;
     email_ alias for $7;
     tempnum integer;

begin
     INSERT INTO useraccounts VALUES(username_, salt_, hash_);
     SELECT INTO  tempnum userid FROM useraccounts WHERE username = username_;
     INSERT INTO parent VALUES(fname_,mname_,lname_,email_,tempnum);
     return 'true';
end;$_$;


ALTER FUNCTION public.addparent(text, text, text, text, text, text, text) OWNER TO postgres;

--
-- Name: answer(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION answer(text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

     declare

        id_ alias for $1;

        exid_ alias for $2; --exam id shall be 21011 where 2 (1 - prelim, 3 - final) is midterm 101 for csc 101 and 1 for set number

        ans_ alias for $3;

        exans record;

        score numeric;

        mscore numeric;

        i int;

        name_ text;

        skode text;

        msg text;

        subj text;

        semid_ text;

        axes boolean;

        pts int;

     begin

         score = 0;

         semid_ = getcurrsem();

         select into axes isallow from exam where examid = exid_ and schoolyear = semid_;

         if axes then

         	if ins2ans(id_, semid_, exid_,ans_) = 'OK' then

			name_ = tounistring(getname(id_));

			select into skode section_code from student_load where id = id_ and schoolyear = semid_ and section_code like '%LEC';

                	-- and time is in the range of subject time.. this is the case when students enrolled in >1 subjects

			select into exans * from exam where schoolyear = semid_ and examid = exid_;

                	mscore = exans.maxscore;

         		for i in 1..length(exans.answer) loop

				if substring(exans.answer,i,1) = substring(ans_,i,1) then

					pts = todec(substring(exans.points,i,1));

				else

					pts = 0;     

				end if;

				score = score + pts;

			end loop;

                	subj = getsubject(skode, semid_);--'CSC' || substring(exid_,2,3);

			perform insupsperf(id_, skode, semid_, substring(exid_, 1,1)::int,score, 1, 'EXMLEC', exans.maxscore);

                	msg = name_ || E'\n' || subj || E'\n' || 'SCORE: ' || score::text || '/' || mscore::text || E'\n' ||

                       	'GRADE: ' || computeGrade(id_, semid_, subj) || E'\n' ||

                       	'NOTE:GRADE is not final.' || E'\nFor queries,pls. see your instructor.';

         	else

            		msg = 'You can submit answer only once.';

         	end if;

            else

               msg = 'Exam is not opened for answering.';

            end if; 

         return msg;

     end;

  $_$;


ALTER FUNCTION public.answer(text, text, text) OWNER TO postgres;

--
-- Name: ccard(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ccard(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	id_ alias for $1;

  	period_ alias for $2;

        perf_ record;

        att_ record;

        card text;

        b text;

  begin

       card = tounistring(getname(id_)) || '\n';   

       FOR perf_ in select 3 as period,  description,score, mult,maxscore from performance where detperiod(period) = period_ and schoolyear = getcurrsem() and id = id_ order by description desc LOOP

              card = card || detperiod(perf_.period) || ' ' || perf_.description || ' ' || perf_.score * perf_.mult || '/' || perf_.maxscore || '\n';

       END LOOP;

       FOR att_ in select distinct 3 as period, 'ATND ' || getsubject(section_code, getcurrsem()) || '-' || 

                substr(section_code, length(section_code) -2, 

               length(section_code )) as description,my_attendance(id,getsubject(section_code, getcurrsem()),

               '%' || substr(section_code, length(section_code) -2 , length(section_code ))) as score, max_attendance(getsubject(section_code, getcurrsem()),

               '%' || substr(section_code, length(section_code) -2 , length(section_code ))) as maxscore from student_load where id = id_ LOOP

          card = card || detperiod(att_.period) || ' ' || att_.description || ' ' || att_.score || '/' || att_.maxscore || '\n';

      END LOOP;

        return card;

  end;

$_$;


ALTER FUNCTION public.ccard(text, text) OWNER TO postgres;

--
-- Name: change_password(integer, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION change_password(id integer, oldhashedpassword text, newhashedpassword text, newsalt text) RETURNS text
    LANGUAGE plpgsql
    AS $$declare

   usr text;

begin

    SELECT INTO usr username FROM useraccounts WHERE userid = id and hashed_password = oldHashedPassword;

    if usr isnull then

        return 'false';

    else

        UPDATE useraccounts SET salt = newSalt, hashed_password = newHashedPassword WHERE username = usr;

        return 'true';

    end if;

end;$$;


ALTER FUNCTION public.change_password(id integer, oldhashedpassword text, newhashedpassword text, newsalt text) OWNER TO postgres;

--
-- Name: clistwithpercent(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION clistwithpercent(text, OUT text, OUT text, OUT numeric, OUT numeric, OUT numeric, OUT text) RETURNS SETOF record
    LANGUAGE sql
    AS $_$

    select id, getname(id), sum(score * mult), 

       getmaxscore($1,getcurrsem()),

      (sum(score * mult) / getmaxscore($1, getcurrsem())) * 100 as d, computegrade(id, getcurrsem(), $1) from performance where 

       schoolyear = getcurrsem() and

       getsubject(section_code,getcurrsem()) = $1 

       group by id order by d desc;

$_$;


ALTER FUNCTION public.clistwithpercent(text, OUT text, OUT text, OUT numeric, OUT numeric, OUT numeric, OUT text) OWNER TO postgres;

--
-- Name: clistwithpercent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION clistwithpercent(text, text, OUT text, OUT text, OUT numeric, OUT numeric, OUT numeric, OUT text) RETURNS SETOF record
    LANGUAGE sql
    AS $_$

    select id, getname(id), sum(score * mult), 

       getmaxscore($1,$2),

      (sum(score * mult) / getmaxscore($1, $2)) * 100 as d, computegrade(id, $2, $1) from performance where 

       schoolyear = $2 and

       getsubject(section_code,schoolyear) = $1 

       group by id order by d desc;

$_$;


ALTER FUNCTION public.clistwithpercent(text, text, OUT text, OUT text, OUT numeric, OUT numeric, OUT numeric, OUT text) OWNER TO postgres;

--
-- Name: clistwithpercentname(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION clistwithpercentname(text, text, OUT text, OUT text, OUT numeric, OUT numeric, OUT numeric, OUT text) RETURNS SETOF record
    LANGUAGE sql
    AS $_$

     select id, getname(id) as n, sum(score * mult), 

        getmaxscore($1,$2),

        (sum(score * mult) / getmaxscore($1, $2)) * 100 as d, computegrade(id, $2, $1) from performance where 

        schoolyear = $2 and

        getsubject(section_code,schoolyear) = $1 

        group by id order by n asc;

$_$;


ALTER FUNCTION public.clistwithpercentname(text, text, OUT text, OUT text, OUT numeric, OUT numeric, OUT numeric, OUT text) OWNER TO postgres;

--
-- Name: computegrade(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION computegrade(text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

    declare

       id_ alias for $1;

       sem_ alias for $2;

       subject alias for $3;

       scores record;

       percentage numeric;

       initgrd numeric;

       grd text;

       mxscore numeric;

    begin

        select into scores sum(score * mult) as mscore 

               from performance where id = id_ and schoolyear = sem_ and getsubject(section_code, sem_) = subject;

        mxscore = getmaxscore(subject, sem_);

        if not scores.mscore isnull then

          if scores.mscore > 0 then

             percentage = (scores.mscore::numeric / mxscore::numeric) * 100;

             --return percentage;

             if percentage >= 95 then

                 initgrd = 1.0;

             elsif percentage >= 90.0 and percentage <= 94.9 then

                 initgrd = 1.25;

             elsif percentage >= 85.0 and percentage <= 89.9 then

                 initgrd = 1.5;

             elsif percentage >= 80.0 and percentage <= 84.9 then

                  initgrd = 1.75;

             elsif percentage >= 75.0 and percentage <= 79.9 then

                  initgrd = 2.00;

             elsif percentage >= 70.0 and percentage <= 74.9 then

                  initgrd = 2.25;

             elsif percentage >= 60.0 and percentage <= 69.9 then 

                  initgrd = 2.50;

             elsif percentage > 50.0 and percentage <= 59.9 then

                  initgrd = 2.75;

             elsif percentage <= 50.0 then     

                  initgrd = 3.0 + (50.0 - percentage) / 10;

                  if initgrd > 5.0 then

                     initgrd = 5.0;

                  end if;

             end if;

             grd = round(initgrd,2)::text;

          else

               grd = '5.00';

          end if;

        else

          grd = 'NOT FOUND!';

        end if;     

        return grd;

    end;

$_$;


ALTER FUNCTION public.computegrade(text, text, text) OWNER TO postgres;

--
-- Name: computepercent(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION computepercent(text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

    declare

       id_ alias for $1;

       sem_ alias for $2;

       subject alias for $3;

       pers numeric;

    begin

       select into pers (sum(score * mult) / getmaxscore(subject, sem_)) * 100 

          from performance where id = id_ and schoolyear = sem_ and 

          getsubject(section_code, sem_) = subject; 

      if pers isnull then

          pers = 0.0;

      end if;    

      return pers;

    end;

$_$;


ALTER FUNCTION public.computepercent(text, text, text) OWNER TO postgres;

--
-- Name: confattendance(text, text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION confattendance(text, text, text, boolean) RETURNS void
    LANGUAGE plpgsql
    AS $_$

  declare

  	id_ alias for $1;

   	skode alias for $2;

        sy_ alias for $3;

        conf alias for $4;

        b text;

  begin

        update attendance set confirmed = conf where id = id_ and schoolyear = sy_ and section_code = skode;

        return;

  end;

$_$;


ALTER FUNCTION public.confattendance(text, text, text, boolean) OWNER TO postgres;

--
-- Name: detperiod(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION detperiod(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	per alias for $1;

        s text;

  begin

        IF per = 1 THEN 

     	      s = 'PLM';

        ELsIF per = 2 THEN 

              s = 'MTM';

        ELsIF per = 3 THEN 

              s = '';   

        ELSE 

              s = 'FIN';

       END IF;

        return s;

  end;

$_$;


ALTER FUNCTION public.detperiod(integer) OWNER TO postgres;

--
-- Name: getconf(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getconf(text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	id_ alias for $1;

   	skode alias for $2;

        sy_ alias for $3;

        b text;

  begin

	select into b confirmed from attendance where id = id_ and schoolyear = sy_ and section_code = skode;

        if b isnull then

              b = 'NOT FOUND!';

        end if;

        return b;

  end;

$_$;


ALTER FUNCTION public.getconf(text, text, text) OWNER TO postgres;

--
-- Name: getcourseyear(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getcourseyear(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	id_ alias for $1;

        b text;

  begin

	select into b courseyear from student where id = id_;

        if b isnull then

             b = 'NOT FOUND!';

        end if;

        return b;

  end;

$_$;


ALTER FUNCTION public.getcourseyear(text) OWNER TO postgres;

--
-- Name: getcurrsem(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getcurrsem() RETURNS text
    LANGUAGE plpgsql
    AS $$

  declare

        b text;

  begin

	select into b max(schoolyear) from sy;

        if b isnull then

             b = 'NOT FOUND!!!';

        end if;

        return b;

  end;

$$;


ALTER FUNCTION public.getcurrsem() OWNER TO postgres;

--
-- Name: getexamanswer(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getexamanswer(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

       exid alias for $1;

       sy_ alias for $2;

       res text;

  begin

       select into res answer || ',' || points from exam where examid = exid and schoolyear = sy_;

       if res isnull then

          raise exception 'EXAM ID is NOT FOUND!!!';

       end if;

       return res;

  end;

$_$;


ALTER FUNCTION public.getexamanswer(text, text) OWNER TO postgres;

--
-- Name: getmaxscore(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getmaxscore(text, text) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$

  declare

     subj_ alias for $1;

     sy_ alias for $2;

     s record;

  begin

     select into s id, sum(maxscore) as d   from performance where getsubject(section_code, sy_) = subj_ and 

         schoolyear = sy_ group by id order by d desc limit 1;

     return s.d;

  end;

$_$;


ALTER FUNCTION public.getmaxscore(text, text) OWNER TO postgres;

--
-- Name: getname(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getname(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	id_ alias for $1;

        b text;

  begin

	select into b name_ from student where id = id_;

        if b isnull then

             b = 'NOT FOUND!';

        end if;

        return b;

  end;

$_$;


ALTER FUNCTION public.getname(text) OWNER TO postgres;

--
-- Name: getroom(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getroom(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	skode alias for $1;

        sy alias for $2;

        b text;

  begin

	select into b room from subject where section_code = skode and schoolyear = sy;

        if b isnull then

             b = 'NOT FOUND!';

        end if;

        return b;

  end;

$_$;


ALTER FUNCTION public.getroom(text, text) OWNER TO postgres;

--
-- Name: getsalt(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getsalt(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$declare 

     username_ alias for $1;

     salt_ text;

begin 

     SELECT INTO salt_ salt from useraccounts where username = username_;

return salt_;

end;$_$;


ALTER FUNCTION public.getsalt(text) OWNER TO postgres;

--
-- Name: getschedule(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getschedule(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	skode alias for $1;

        sy alias for $2;

        b text;

  begin

	select into b schedule from subject where section_code = skode and schoolyear = sy;

        if b isnull then

             b = 'NOT FOUND!';

        end if;

        return b;

  end;

$_$;


ALTER FUNCTION public.getschedule(text, text) OWNER TO postgres;

--
-- Name: getstuans(text, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getstuans(text, text, text, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$

   declare

      id_ alias for $1;

      exid alias for $2;

      sy_ alias for $3;

      src alias for $4;

      ans text;

   begin 

      select into ans answer from stuanswer where id = id_ and schoolyear = sy_ and examid = exid and ansfrom = src;

      if ans isnull then

          ans = '';

      end if;

      return ans;

   end;

$_$;


ALTER FUNCTION public.getstuans(text, text, text, integer) OWNER TO postgres;

--
-- Name: getstuscore(text, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getstuscore(text, text, text, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

     id_ alias for $1;

     skod alias for $2;

     sy_ alias for $3;

     prd alias for $4;

     sc text;

  begin

     select into sc score::text || '/' || maxscore from performance where id = id_ and section_code = skod and schoolyear = sy_ and period = prd and mult = 1 and description like '%X%';

      if sc isnull then

         sc = '0/0';

      end if;

      return sc;

  end;

$_$;


ALTER FUNCTION public.getstuscore(text, text, text, integer) OWNER TO postgres;

--
-- Name: getsubject(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getsubject(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	skode alias for $1;

        sy alias for $2;

        b text;

  begin

	select into b type_ from subject where section_code = skode and schoolyear = sy;

        if b isnull then

             b = 'NOT FOUND!';

        end if;

        return b;

  end;

$_$;


ALTER FUNCTION public.getsubject(text, text) OWNER TO postgres;

--
-- Name: getsy(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getsy(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	sy_ alias for $1;

        b text;

  begin

	select into b schoolyear from sy where schoolyear = sy_;

        if b isnull then

             b = 'NOT FOUND!!!';

        end if;

        return b;

  end;

$_$;


ALTER FUNCTION public.getsy(text) OWNER TO postgres;

--
-- Name: gettype(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gettype(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	skode alias for $1;

        sy alias for $2;

        b text;

  begin

	select into b type_ from subject where section_code = skode and schoolyear = sy;

        if b isnull then

             b = 'NOT FOUND!';

        end if;

        return b;

  end;

$_$;


ALTER FUNCTION public.gettype(text, text) OWNER TO postgres;

--
-- Name: ins2ans(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins2ans(text, text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

   declare

      id_ alias for $1;

      sy_ alias for $2;

      exid_ alias for $3;

      ans_ alias for $4;

      b text;

   begin

      select into b id from stuanswer where id = id_ and schoolyear = sy_ and examid = exid_;

      if b isnull then

          b = 'OK';

          insert into stuanswer(id, schoolyear, examid, answer, time_) values (id_, sy_, exid_, ans_, now());

      else

          b = 'DEN';

      end if;

      return b;

   end;

$_$;


ALTER FUNCTION public.ins2ans(text, text, text, text) OWNER TO postgres;

--
-- Name: ins2ans2(text, text, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ins2ans2(text, text, text, text, integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

   declare

      id_ alias for $1;

      sy_ alias for $2;

      exid_ alias for $3;

      ans_ alias for $4;

      src_ alias for $5;

      b text;

   begin

      select into b id from stuanswer where id = id_ and schoolyear = sy_ and examid = exid_ and ansfrom = src_;

      if b isnull then

          insert into stuanswer(id, schoolyear, examid, answer, time_, ansfrom) values (id_, sy_, exid_, ans_, now(), src_);

      else

          update stuanswer set answer = ans_ where id = id_ and schoolyear = sy_ and examid = exid_ and ansfrom = src_;

      end if;

   end;

$_$;


ALTER FUNCTION public.ins2ans2(text, text, text, text, integer) OWNER TO postgres;

--
-- Name: insupattendance(text, text, text, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insupattendance(text, text, text, timestamp without time zone, boolean) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	id_ alias for $1;

   	skode alias for $2;

        sy_ alias for $3;

        tym alias for $4;

        conf alias for $5;

        b text;

  begin

	select into b section_code from attendance where id = id_ and schoolyear = sy_ and section_code = skode and time_::date = tym::date;

        if b isnull then

             insert into attendance (id, section_code, schoolyear, time_, confirmed) values (id_, skode, sy_, tym, conf);

        else

             update attendance set time_ = tym, confirmed = conf where id = id_ and schoolyear = sy_ and section_code = skode and time_::date = tym::date;

        end if;

        return 'OK';

  end;

$_$;


ALTER FUNCTION public.insupattendance(text, text, text, timestamp without time zone, boolean) OWNER TO postgres;

--
-- Name: insupexam(text, text, text, text, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insupexam(text, text, text, text, numeric) RETURNS void
    LANGUAGE plpgsql
    AS $_$

  declare

      ex_ alias for $1; -- exam id shall be 21011 where 2 (1 - prelim, 3 - final) is midterm 101 for csc 101 and 1 for set number

      sy_ alias for $2;

      ans_ alias for $3; -- a1a2a3....an

      pts_ alias for $4; -- p1p2p3....pn

      mscore alias for $5;

      b text;

  begin

      select into b ex_ from exam where examid = ex_ and schoolyear = sy_;

      if b isnull then

         insert into exam (examid, schoolyear, answer, points, maxscore) values (ex_, sy_, ans_, pts_,mscore);

      else

         update exam set answer = ans_, points = pts_, maxscore = mscore where examid = ex_ and schoolyear = sy_;

      end if;

  end;

$_$;


ALTER FUNCTION public.insupexam(text, text, text, text, numeric) OWNER TO postgres;

--
-- Name: insups2dent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insups2dent(text, text) RETURNS void
    LANGUAGE plpgsql
    AS $_$

  declare

  	id_ alias for $1;

   	mname_ alias for $2;

        b text;

  begin

	select into b id from student where id = id_;

        if b isnull then

             insert into student(id, name_) values (id_, mname_);

        else

             update student set name_ = mname_ where id = id_;

        end if;

        return;

  end;

$_$;


ALTER FUNCTION public.insups2dent(text, text) OWNER TO postgres;

--
-- Name: insupsperf(text, text, text, integer, numeric, numeric, text, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insupsperf(text, text, text, integer, numeric, numeric, text, numeric) RETURNS void
    LANGUAGE plpgsql
    AS $_$

  declare

  	id_ alias for $1;

   	scode_ alias for $2;

        sy_ alias for $3;

        peryod_ alias for $4;

        skor_ alias for $5;

        sign_ alias for $6;

        desc_ alias for $7;

        mscore_ alias for $8;

        b text;

  begin

	select into b id from performance where id = id_ and section_code = scode_ and schoolyear = sy_ and period = peryod_ and description = desc_;

        if b isnull then

             insert into performance(id, section_code, schoolyear, period, score, mult, description, maxscore) values (id_, scode_, sy_, peryod_, skor_, sign_, desc_, mscore_);

        else

             update performance set maxscore = mscore_, score = skor_, mult = sign_  where description = desc_ and id = id_ and section_code = scode_ and schoolyear = sy_ and period = peryod_;

        end if;

        return;

  end;

$_$;


ALTER FUNCTION public.insupsperf(text, text, text, integer, numeric, numeric, text, numeric) OWNER TO postgres;

--
-- Name: insupsubject(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insupsubject(text, text, text, text, text) RETURNS void
    LANGUAGE plpgsql
    AS $_$

  declare

  	skode alias for $1;

   	typ alias for $2;

        rm alias for $3;

        sy alias for $4;

        sked alias for $5;

        b text;

  begin

	select into b section_code from subject where section_code = skode and schoolyear = sy;

        if b isnull then

             insert into subject(section_code, type_, room, schoolyear, schedule) values (skode, typ, rm, sy, sked);

        else

             update subject set type_ = typ, room = rm, schedule = sked where section_code = skode and schoolyear = sy;

        end if;

        return;

  end;

$_$;


ALTER FUNCTION public.insupsubject(text, text, text, text, text) OWNER TO postgres;

--
-- Name: insupsy(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insupsy(text) RETURNS void
    LANGUAGE plpgsql
    AS $_$

  declare

  	sy_ alias for $1;

        b text;

  begin

	select into b schoolyear from sy where schoolyear = sy_;

        if b isnull then

             insert into sy (schoolyear) values (sy_);

        else

             update sy set schoolyear = sy_ where schedue = sy_;

        end if;

        return;

  end;

$_$;


ALTER FUNCTION public.insupsy(text) OWNER TO postgres;

--
-- Name: login(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION login(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$declare

     hash_ alias for $1;

     username_ alias for $2;

     num_ text;

begin

    SELECT INTO num_ userid FROM useraccounts WHERE username = username_ AND hash = hash_;

    if num_ isnull then

       return 'FALSE';

    else

       return 'TRUE';

    end if;

end;$_$;


ALTER FUNCTION public.login(text, text) OWNER TO postgres;

--
-- Name: max_attendance(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION max_attendance(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	subj_ alias for $1;

   	typ_ alias for $2;

        b numeric;

  begin

           select into b max(my_attendance(id, subj_, typ_)::numeric) from attendance 

           where section_code like typ_;

        --select into b count(*) as c from attendance where section_code in

        --          (select section_code from subject where type_ = subj_ and

         --          schoolyear = getcurrsem() and section_code like typ_) 

         --          group by id order by c desc limit 1;

        return b::text;

  end;

$_$;


ALTER FUNCTION public.max_attendance(text, text) OWNER TO postgres;

--
-- Name: max_attendance(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION max_attendance(text, text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	subj_ alias for $1;

   	typ_ alias for $2;

   	id_ alias for $3;

   	sem_ alias for $4;

        myclassmate record;

  begin

       --subj = getsubject(mycodes.section_code, getcurrsem());

       select into myclassmate id, my_attendance(id, subj_, typ_, sem_)::numeric as b from 

                 attendance where schoolyear = sem_ and section_code = typ_ and time_::date in

                         (select time_::date from attendance where id = id_ 

                              and section_code = typ_) order by b desc limit 1;

         --   select into b max(my_attendance(id, subj_, typ_)::numeric) from attendance 

        --   where section_code like typ_;

        --select into b count(*) as c from attendance where section_code in

        --          (select section_code from subject where type_ = subj_ and

         --          schoolyear = getcurrsem() and section_code like typ_) 

         --          group by id order by c desc limit 1;

        return myclassmate.b::text;

  end;

$_$;


ALTER FUNCTION public.max_attendance(text, text, text, text) OWNER TO postgres;

--
-- Name: my_attendance(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION my_attendance(text, text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

        id_ alias for $1;

  	subj_ alias for $2;

   	typ_ alias for $3;

   	sem_ alias for $4;

        b int;

  begin

        select into b count(*) as c from attendance where id = id_ and 

                  section_code in

                  (select section_code from subject where type_ = subj_ and

                   schoolyear = sem_ and section_code like typ_);

        return b;

  end;

$_$;


ALTER FUNCTION public.my_attendance(text, text, text, text) OWNER TO postgres;

--
-- Name: myabsences(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION myabsences(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

     id_ alias for $1;

     abs text;

     subj text;

     absence record;

     mycodes record;

     def text;

     myclassmate record;

  begin

     abs = ''; 

     def = 'none'; 

     for mycodes in select distinct section_code from attendance where id = id_ and schoolyear = getcurrsem() order by section_code asc loop

       subj = getsubject(mycodes.section_code, getcurrsem());

       abs = abs || mycodes.section_code || '     ';

       select into myclassmate id, my_attendance(id, subj, mycodes.section_code)::numeric as b from 

                 attendance where section_code = mycodes.section_code and time_::date in

                         (select time_::date from attendance where id = id_ 

                              and section_code = mycodes.section_code) order by b desc limit 1;

       --abs = abs || myclassmate.id || E'\n';

       for absence in select time_::date as deyt from attendance where 

            schoolyear = getcurrsem() and section_code = mycodes.section_code 

               and id = myclassmate.id 

                     and time_::date not in 

                           (select time_::date from attendance where 

                               id = id_ and section_code = mycodes.section_code) 

                                 order by deyt asc loop

                     abs = abs || absence.deyt || ', '; --'\n                            ';

                     def = '';

         end loop;

             if def = 'none' then

                 abs = abs || def;

             end if;

             abs = abs || E'\n';

             def = 'none';

      end loop;

      return abs;    

   end;

$_$;


ALTER FUNCTION public.myabsences(text) OWNER TO postgres;

--
-- Name: mygrade(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mygrade(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

   declare

      id_ alias for $1;

      stugrade record;

      grdinfo text;

   begin

      grdinfo = tounistring(getname(id_)) || E'\n';

      for stugrade in select  distinct getsubject(section_code,schoolyear) as subj, 

         computegrade(id, getcurrsem(), getsubject(section_code,schoolyear)) as grd from

         performance where id = id_ and schoolyear = getcurrsem() loop

            grdinfo = grdinfo || stugrade.subj || '      ' || stugrade.grd || E'\n';

      end loop;

      grdinfo = grdinfo || 'NOTE:This is not final.' || E'\nFor clarification, please see your instructor.';

      return grdinfo;

   end;

$_$;


ALTER FUNCTION public.mygrade(text) OWNER TO postgres;

--
-- Name: requestlink(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION requestlink(parentid integer, studentidnum text) RETURNS text
    LANGUAGE plpgsql
    AS $_$declare

     parentid_ alias for $1;

     studentidnum_ alias for $2;

     userexist text;

begin

     SELECT INTO userexist id FROM student WHERE id = studentidnum_;

     if userexist isnull then

          return 'false';

     else

          INSERT INTO linkedaccounts values (parentid_,studentidnum_,'false');

          return 'true';

     end if;

end;$_$;


ALTER FUNCTION public.requestlink(parentid integer, studentidnum text) OWNER TO postgres;

--
-- Name: student_attendance(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION student_attendance(student_id text, section_code text, school_year text) RETURNS SETOF timestamp without time zone
    LANGUAGE plpgsql
    AS $$DECLARE
    stamps TIMESTAMP;
BEGIN
    FOR stamps in SELECT time_ FROM attendance WHERE id = student_id and section = section_code and schoolyear = school_year and confirmed = true LOOP
        RETURN NEXT stamps;
    END LOOP;
    RETURN;
END;$$;


ALTER FUNCTION public.student_attendance(student_id text, section_code text, school_year text) OWNER TO postgres;

--
-- Name: todec(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION todec(text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$

   DECLARE

      n alias for $1;

      h int;

   BEGIn

   	If n = 'A' Then

     		h = 10;

   	end if; 

        If n = 'B' Then

     		h = 11;

   	end if; 

        If n = 'C' Then

     		h = 12;

   	end if; 

        If n = 'D' Then

     		h = 13;

	end if;

	If n = 'E' Then

     		h = 14;

        end if;

	If n = 'F' Then

     		h = 15;

   	end if;

   	IF n = 'O' then

   	        h = 0;

   	end if;

        if not (n = 'A' or n = 'B' or n = 'C' or n = 'D' or n = 'E' or n = 'F' or n = 'O') then

     		h = to_number(n, '99');

   	End If;

  	return h;

    End;

$_$;


ALTER FUNCTION public.todec(text) OWNER TO postgres;

--
-- Name: tounistring(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tounistring(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

  declare

  	str_ alias for $1;

  	c text;

        b text;

  begin

        b = '';

        For i in 1..Length(str_) loop

            c = substring(str_,i,1);

   	    if c = 'ñ' then

   	       b = b || '~';

            else 

               b = b || c;

   	    end if;

	end loop;

        return b;

  end;

$_$;


ALTER FUNCTION public.tounistring(text) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE attendance (
    id text NOT NULL,
    section text NOT NULL,
    schoolyear text NOT NULL,
    time_ timestamp without time zone NOT NULL,
    confirmed boolean
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: exam; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE exam (
    examid text NOT NULL,
    schoolyear text NOT NULL,
    answer text,
    points text,
    maxscore numeric,
    isallow boolean DEFAULT false
);


ALTER TABLE public.exam OWNER TO postgres;

--
-- Name: linkedaccounts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkedaccounts (
    parentid text,
    studentidnum text,
    verified boolean
);


ALTER TABLE public.linkedaccounts OWNER TO postgres;

--
-- Name: parent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE parent (
    fname text,
    mname text,
    lname text,
    email text,
    acctnumber integer
);


ALTER TABLE public.parent OWNER TO postgres;

--
-- Name: performance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE performance (
    id text NOT NULL,
    section_code text NOT NULL,
    schoolyear text NOT NULL,
    period integer NOT NULL,
    score numeric,
    mult numeric,
    description text NOT NULL,
    maxscore numeric
);


ALTER TABLE public.performance OWNER TO postgres;

--
-- Name: stuanswer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stuanswer (
    id text NOT NULL,
    schoolyear text NOT NULL,
    examid text NOT NULL,
    answer text,
    time_ timestamp without time zone,
    ansfrom integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.stuanswer OWNER TO postgres;

--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE student (
    id text NOT NULL,
    fname text,
    mname text,
    lname text,
    courseyear text,
    acctnumber integer
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_load; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW student_load AS
    SELECT DISTINCT attendance.section AS section_code, attendance.id, attendance.schoolyear FROM attendance ORDER BY attendance.id;


ALTER TABLE public.student_load OWNER TO postgres;

--
-- Name: subject; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE subject (
    section_code text NOT NULL,
    type_ text DEFAULT 'Lec'::text,
    room text,
    schoolyear text,
    schedule text
);


ALTER TABLE public.subject OWNER TO postgres;

--
-- Name: sy; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sy (
    schoolyear text NOT NULL
);


ALTER TABLE public.sy OWNER TO postgres;

--
-- Name: useraccounts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE useraccounts (
    username text,
    salt text,
    hash text,
    userid integer NOT NULL
);


ALTER TABLE public.useraccounts OWNER TO postgres;

--
-- Name: username_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE username_userid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.username_userid_seq OWNER TO postgres;

--
-- Name: username_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE username_userid_seq OWNED BY useraccounts.userid;


--
-- Name: username_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('username_userid_seq', 4, true);


--
-- Name: userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY useraccounts ALTER COLUMN userid SET DEFAULT nextval('username_userid_seq'::regclass);


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY attendance (id, section_code, schoolyear, time_, confirmed) FROM stdin;
\.


--
-- Data for Name: exam; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY exam (examid, schoolyear, answer, points, maxscore, isallow) FROM stdin;
\.


--
-- Data for Name: linkedaccounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY linkedaccounts (parentid, studentidnum, verified) FROM stdin;
\.


--
-- Data for Name: parent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY parent (fname, mname, lname, email, acctnumber) FROM stdin;
kalels	reyes	mom	kalel@yahoo.com	4
\.


--
-- Data for Name: performance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY performance (id, section_code, schoolyear, period, score, mult, description, maxscore) FROM stdin;
\.


--
-- Data for Name: stuanswer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY stuanswer (id, schoolyear, examid, answer, time_, ansfrom) FROM stdin;
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY student (id, fname, mname, lname, courseyear, acctnumber) FROM stdin;
\.


--
-- Data for Name: subject; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY subject (section_code, type_, room, schoolyear, schedule) FROM stdin;
\.


--
-- Data for Name: sy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sy (schoolyear) FROM stdin;
\.


--
-- Data for Name: useraccounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY useraccounts (username, salt, hash, userid) FROM stdin;
ADMIN	0457dea5c1cd443ca6692282c0780f72	2ecf49dcb3dea8b9777dfdef11ed2593ba12367eecbbb8100b75e3c2464e8239ab72cfa9a0d357285da4749dffd18f76c97a9219ffb85715a6c5c75c3832d889	1
mrsreyes	asdf	fdsa	4
\.


--
-- Name: att_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT att_pk PRIMARY KEY (id, section, schoolyear, time_);


--
-- Name: examid_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY exam
    ADD CONSTRAINT examid_pk PRIMARY KEY (examid, schoolyear);


--
-- Name: perf_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT perf_pk PRIMARY KEY (id, section_code, schoolyear, period, description);


--
-- Name: s2ans_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stuanswer
    ADD CONSTRAINT s2ans_pk PRIMARY KEY (id, schoolyear, examid, ansfrom);


--
-- Name: student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- Name: subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (section_code);


--
-- Name: sy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sy
    ADD CONSTRAINT sy_pkey PRIMARY KEY (schoolyear);


--
-- Name: att_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT att_id_fk FOREIGN KEY (id) REFERENCES student(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: att_sc_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT att_sc_fk FOREIGN KEY (section) REFERENCES subject(section_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: att_sy_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT att_sy_fk FOREIGN KEY (schoolyear) REFERENCES sy(schoolyear) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: exam_sy_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY exam
    ADD CONSTRAINT exam_sy_fk FOREIGN KEY (schoolyear) REFERENCES sy(schoolyear) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: perf_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT perf_id_fk FOREIGN KEY (id) REFERENCES student(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: perf_sc_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT perf_sc_fk FOREIGN KEY (section_code) REFERENCES subject(section_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: perf_sy_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY performance
    ADD CONSTRAINT perf_sy_fk FOREIGN KEY (schoolyear) REFERENCES sy(schoolyear) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: s2ans_exid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stuanswer
    ADD CONSTRAINT s2ans_exid_fk FOREIGN KEY (examid, schoolyear) REFERENCES exam(examid, schoolyear) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: s2ans_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stuanswer
    ADD CONSTRAINT s2ans_id_fk FOREIGN KEY (id) REFERENCES student(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: s2ans_sy_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stuanswer
    ADD CONSTRAINT s2ans_sy_fk FOREIGN KEY (schoolyear) REFERENCES sy(schoolyear) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: subj_sy_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subj_sy_fk FOREIGN KEY (schoolyear) REFERENCES sy(schoolyear) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: attendance; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE attendance FROM PUBLIC;
REVOKE ALL ON TABLE attendance FROM postgres;
GRANT ALL ON TABLE attendance TO postgres;
GRANT SELECT ON TABLE attendance TO students;


--
-- Name: exam; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE exam FROM PUBLIC;
REVOKE ALL ON TABLE exam FROM postgres;
GRANT ALL ON TABLE exam TO postgres;
GRANT SELECT ON TABLE exam TO students;


--
-- Name: performance; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE performance FROM PUBLIC;
REVOKE ALL ON TABLE performance FROM postgres;
GRANT ALL ON TABLE performance TO postgres;
GRANT SELECT ON TABLE performance TO students;


--
-- Name: stuanswer; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stuanswer FROM PUBLIC;
REVOKE ALL ON TABLE stuanswer FROM postgres;
GRANT ALL ON TABLE stuanswer TO postgres;
GRANT SELECT ON TABLE stuanswer TO students;


--
-- Name: student; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE student FROM PUBLIC;
REVOKE ALL ON TABLE student FROM postgres;
GRANT ALL ON TABLE student TO postgres;
GRANT SELECT ON TABLE student TO students;


--
-- Name: student_load; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE student_load FROM PUBLIC;
REVOKE ALL ON TABLE student_load FROM postgres;
GRANT ALL ON TABLE student_load TO postgres;
GRANT SELECT ON TABLE student_load TO students;


--
-- Name: subject; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE subject FROM PUBLIC;
REVOKE ALL ON TABLE subject FROM postgres;
GRANT ALL ON TABLE subject TO postgres;
GRANT SELECT ON TABLE subject TO students;


--
-- Name: sy; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sy FROM PUBLIC;
REVOKE ALL ON TABLE sy FROM postgres;
GRANT ALL ON TABLE sy TO postgres;
GRANT SELECT ON TABLE sy TO students;


--
-- PostgreSQL database dump complete
--

