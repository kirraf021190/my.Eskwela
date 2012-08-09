--create language plpgsql;
create table student (
     id text primary key,
     name_ text,
     courseyear text
);

create table sy (
     schoolyear text primary key
);

/*
CREATE OR REPLACE FUNCTION insups2dent(text, text, text)
  RETURNS void AS
$BODY$
  declare
  	id_ alias for $1;
   	mname_ alias for $2;
        courseyear_ alias for $3;
        b text;
  begin
	select into b id from student where id = id_;CREATE OR REPLACE FUNCTION clistwithpercent(in text, out text, out text, out numeric, out numeric, out numeric, out text)
  RETURNS setof record AS
$BODY$
    select id, getname(id), sum(score * mult), 
       getmaxscore($1,getcurrsem()),
      (sum(score * mult) / getmaxscore($1, getcurrsem())) * 100 as d, computegrade(id, getcurrsem(), $1) from performance where 
       schoolyear = getcurrsem() and
       getsubject(section_code,getcurrsem()) = $1 
       group by id order by d desc;
$BODY$
  LANGUAGE 'sql' VOLATILE;

        if b isnull then
             insert into student(id, name_, courseyear) values (id_, mname_, courseyear_);
        else
             update student set name_ = mname_, courseyear = courseyear_ where id = id_;
        end if;
        return;
  end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
*/

CREATE OR REPLACE FUNCTION insups2dent(text, text)
  RETURNS void AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION getname(text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION getcourseyear(text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


create table subject (
     section_code text primary key,
     type_ text default 'Lec', -- type will become the subject id (i.e., csc101..)
     room text,
     schoolyear text,
     schedule text,
     constraint subj_sy_fk foreign key (schoolyear) references sy (schoolyear) match simple on update cascade on delete cascade
);


CREATE OR REPLACE FUNCTION insupsubject(text, text, text, text, text)
  RETURNS void AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION getschedule(text,text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION getsubject(text, text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;



CREATE OR REPLACE FUNCTION getroom(text,text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION gettype(text,text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;



CREATE OR REPLACE FUNCTION insupsy(text)
  RETURNS void AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION getsy(text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION getcurrsem()
  RETURNS text AS
$BODY$
  declare
        b text;
  begin
	select into b max(schoolyear) from sy;
        if b isnull then
             b = 'NOT FOUND!!!';
        end if;
        return b;
  end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


create table attendance(
     id text,
     section_code text,
     schoolyear text,
     time_ timestamp without time zone,
     confirmed boolean,
     constraint att_pk primary key (id,section_code, schoolyear, time_),
     constraint att_id_fk foreign key (id) references student (id) match simple on update cascade on delete cascade,
     constraint att_sc_fk foreign key (section_code) references subject (section_code) match simple on update cascade on delete cascade, 
     constraint att_sy_fk foreign key (schoolyear) references sy (schoolyear) match simple on update cascade on delete cascade
);


CREATE OR REPLACE FUNCTION insupattendance(text, text, text, timestamp without time zone, boolean)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;



CREATE OR REPLACE FUNCTION confattendance(text, text, text,boolean)
  RETURNS void AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION getconf(text, text, text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION max_attendance(text, text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;




CREATE OR REPLACE FUNCTION my_attendance(text, text, text, text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


create or replace view student_load as
  Select distinct section_code, id, schoolyear from attendance order by id asc;

--select period, description,score, maxscore from performance where schoolyear = getcurrsem() and id = '' 
create table performance(
     id text,
     section_code text,
     schoolyear text,
     period int, -- 1 - prelim 2-midterm 3-finals
     score numeric,
     mult  numeric, -- -/+
     description text,
     constraint perf_pk primary key (id,section_code, schoolyear,period, description),
     constraint perf_id_fk foreign key (id) references student (id) match simple on update cascade on delete cascade,
     constraint perf_sc_fk foreign key (section_code) references subject (section_code) match simple on update cascade on delete cascade, 
     constraint perf_sy_fk foreign key (schoolyear) references sy (schoolyear) match simple on update cascade on delete cascade
);

alter table performance add column maxscore numeric;

CREATE OR REPLACE FUNCTION insupsperf(text, text, text, integer, numeric, numeric, text, numeric)
  RETURNS void AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION detPeriod(integer)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION tounistring(text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


CREATE OR REPLACE FUNCTION ccard(text, text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


--update performance set description = 'EXMLEC' where description = 'EXAM (LEC)';
--update performance set description = '1STREQ' where description = 'PENALTY (1st reqt)';
/*

CREATE OR REPLACE FUNCTION myabsences(text)
  RETURNS text AS
$BODY$
  declare
     id_ alias for $1;
     abs text;
     subj text;
     absence record;
     mycodes record;
     def text;
  begin

     abs = ''; 
     def = 'none'; 
     for mycodes in select distinct section_code from attendance where id = id_ and schoolyear = getcurrsem() order by section_code asc loop
       subj = getsubject(mycodes.section_code, getcurrsem());
       abs = abs || mycodes.section_code || '     '; 
       for absence in select time_::date as deyt from attendance where schoolyear = getcurrsem() and section_code = mycodes.section_code 
           and id in 
            (select distinct id from attendance 
                where
                   and id in (select id from attendance where time_::date in (select time_::date from attendance where id = id_)) -- get my lab mate
                     and 
                       my_attendance(id,subj,mycodes.section_code) = max_attendance(subj,mycodes.section_code) 
                         limit 1) and time_::date not in 
                           (select time_::date from attendance where id = id_ and section_code = mycodes.section_code) order by deyt asc loop
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

 --select myabsences('2006-5446');
*/

CREATE OR REPLACE FUNCTION myabsences(text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


create or replace function computeGrade(text, text, text) 
  returns text as
$BODY$
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
$BODY$
   language 'plpgsql' volatile;

CREATE OR REPLACE FUNCTION mygrade(text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

create table exam (
    examid text,
    schoolyear text,
    answer text,
    points text,
    maxscore numeric,
    constraint examid_pk primary key (examid, schoolyear),
    constraint exam_sy_fk foreign key (schoolyear) references sy (schoolyear) match simple on update cascade on delete cascade
);

create or replace function getexamanswer(text, text) returns text as 
$$
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
$$
  language 'plpgsql' volatile;



create or replace function insupexam(text, text, text,text, numeric) returns void as
$BODY$
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
$BODY$
  language 'plpgsql' volatile;
--select insupexam('11011', getcurrsem(),'ans','score', maxscore);
create table stuanswer(
    id text,
    schoolyear text,
    examid text,
    answer text,
    time_ timestamp without time zone,
    constraint s2ans_pk primary key (id, schoolyear, examid),
    constraint s2ans_exid_fk foreign key (examid, schoolyear) references exam(examid, schoolyear) match simple on update cascade on delete cascade,
    constraint s2ans_id_fk foreign key (id) references student (id) match simple on update cascade on delete cascade,
    constraint s2ans_sy_fk foreign key (schoolyear) references sy (schoolyear) match simple on update cascade on delete cascade
);

alter table stuanswer add column ansfrom int default 0; -- 0 means from cp, 1 means keyboard entry
alter table stuanswer drop constraint s2ans_pk;
alter table stuanswer add constraint s2ans_pk primary key (id, schoolyear, examid, ansfrom);

create or replace function getstuans(text, text, text, int) returns text as 
$$
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
$$
  language 'plpgsql' volatile;


create or replace function getstuscore(text, text, text, int) returns text as
$$
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
$$
  language 'plpgsql' volatile;


create or replace function ins2ans2(text, text,text,text, int) returns void as
$BODY$
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
$BODY$
  language 'plpgsql' volatile;


create or replace function ins2ans(text, text,text,text) returns text as
$BODY$
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
$BODY$
  language 'plpgsql' volatile;

CREATE OR REPLACE FUNCTION todec(text)
  RETURNS int AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION answer(text, text, text)
  RETURNS text AS
$BODY$
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
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
   --delete from stuanswer;
   --update exam set isallow = false where examid like '%100%' and schoolyear = getcurrsem(); 
   --select answer('0000','21002','cdbeaghic');

alter table exam add column isallow boolean default false;

create or replace function getmaxscore(text,text) returns numeric as 
$$
  declare
     subj_ alias for $1;
     sy_ alias for $2;
     s record;
  begin
     select into s id, sum(maxscore) as d   from performance where getsubject(section_code, sy_) = subj_ and 
         schoolyear = sy_ group by id order by d desc limit 1;
     return s.d;
  end;
$$
  language 'plpgsql' volatile;

CREATE OR REPLACE FUNCTION clistwithpercent(in text, out text, out text, out numeric, out numeric, out numeric, out text)
  RETURNS setof record AS
$BODY$
    select id, getname(id), sum(score * mult), 
       getmaxscore($1,getcurrsem()),
      (sum(score * mult) / getmaxscore($1, getcurrsem())) * 100 as d, computegrade(id, getcurrsem(), $1) from performance where 
       schoolyear = getcurrsem() and
       getsubject(section_code,getcurrsem()) = $1 
       group by id order by d desc;
$BODY$
  LANGUAGE 'sql' VOLATILE;

CREATE OR REPLACE FUNCTION clistwithpercent(in text, in text,out text, out text, out numeric, out numeric, out numeric, out text)
  RETURNS setof record AS
$BODY$
    select id, getname(id), sum(score * mult), 
       getmaxscore($1,$2),
      (sum(score * mult) / getmaxscore($1, $2)) * 100 as d, computegrade(id, $2, $1) from performance where 
       schoolyear = $2 and
       getsubject(section_code,$2) = $1 
       group by id order by d desc;
$BODY$
  LANGUAGE 'sql' VOLATILE;


 --usage: select * from clistwithpercent('CSC100');

CREATE OR REPLACE FUNCTION max_attendance(text, text, text, text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION computepercent(text, text, text)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;


--select max_attendance('CSC101', 'A4H23-LAB','2009-1260', getcurrsem());
/*
CREATE OR REPLACE FUNCTION clistwithpercentname(IN text, OUT text, OUT text, OUT numeric, OUT numeric, OUT numeric, OUT text)
  RETURNS SETOF record AS
$BODY$
   
     select id, getname(id) as n, sum(score * mult), 
        getmaxscore($1,getcurrsem()),
        (sum(score * mult) / getmaxscore($1, getcurrsem())) * 100 as d, computegrade(id, getcurrsem(), $1) from performance where 
        schoolyear = getcurrsem() and
        getsubject(section_code,getcurrsem()) = $1 
        group by id order by n asc;
 
      
$BODY$
  LANGUAGE 'sql' VOLATILE;

  select * from clistwithpercentname('CSC101');
*/

-- Function: clistwithpercent(text)

-- DROP FUNCTION clistwithpercent(text);

CREATE OR REPLACE FUNCTION clistwithpercent(IN text, IN text,OUT text, OUT text, OUT numeric, OUT numeric, OUT numeric, OUT text)
  RETURNS SETOF record AS
$BODY$
    select id, getname(id), sum(score * mult), 
       getmaxscore($1,$2),
      (sum(score * mult) / getmaxscore($1, $2)) * 100 as d, computegrade(id, $2, $1) from performance where 
       schoolyear = $2 and
       getsubject(section_code,schoolyear) = $1 
       group by id order by d desc;
$BODY$
  LANGUAGE 'sql' VOLATILE;

 CREATE OR REPLACE FUNCTION clistwithpercentname(IN text, IN text,OUT text, OUT text, OUT numeric, OUT numeric, OUT numeric, OUT text)
  RETURNS SETOF record AS
$BODY$
   
     select id, getname(id) as n, sum(score * mult), 
        getmaxscore($1,$2),
        (sum(score * mult) / getmaxscore($1, $2)) * 100 as d, computegrade(id, $2, $1) from performance where 
        schoolyear = $2 and
        getsubject(section_code,schoolyear) = $1 
        group by id order by n asc;
 
      
$BODY$
  LANGUAGE 'sql' VOLATILE;

grant select on table attendance to group students;
grant select on table exam to group students;
grant select on table performance to group students;
grant select on table stuanswer to group students;
grant select on table subject to group students;
grant select on table sy to group students;
grant select on table student to group students;
grant select on student_load to group students;

  
--- $2 is schoolyear



/*

select insupexam('31001', getcurrsem(), 'adbcacbda', '25121548C', 40.0);

list all students with their scores, order from highest to lowest
select id, 'CSC101', sum(score * mult), 
       getmaxscore('CSC101',getcurrsem()),
      (sum(score * mult) / getmaxscore('CSC101', getcurrsem())) * 100 as d from performance where 
       schoolyear = getcurrsem() and
       getsubject(section_code,getcurrsem()) = 'CSC101' 
       group by id order by d desc 


select * from student where 
       my_attendance(id, 'CSC100', 'M45H67-LEC') = max_attendance('CSC100','M45H67-LEC') -- students with perfect attendance
select ccard('2009-1143', 'PLM');
select insupsy('2ndsem0910');
select * from attendance where my_attendance(id,getsubject(section_code, getcurrsem()),'%' || substr(section_code, length(section_code) -2, length(section_code ))) = '3';
select * from attendance where id='2008-0962';
select insupsperf('2009-1143'::text,'A4H23-LEC'::text,getcurrsem()::text,1,40::numeric, 1,'EXAM (LEC)'::text, 60);
select insupsperf('2006-5722'::text, 'M45H67-LEC'::text,getcurrsem()::text,1,27::numeric, 1,'EXAM (LEC)'::text,50);
select insupsubject('M45H67-LEC'::TEXT, 'CSC100'::TEXT, 'LR1'::TEXT, '2ndsem0910','12:00-02:00'::TEXT);
select insupsubject('M45H67-LAB1'::TEXT, 'CSC100'::TEXT, 'LA1'::TEXT,'2ndsem0910' ,'03:00-06:00'::TEXT);
select insupsubject('M45H67-LAB2'::TEXT, 'CSC100'::TEXT, 'LA1'::TEXT, '2ndsem0910','03:00-06:00'::TEXT);
select insupsubject('A4H23-LEC'::TEXT, 'CSC101'::TEXT, 'LR1'::TEXT,'2ndsem0910' ,'12:30-01:30'::TEXT);
select insupsubject('A4H23-LAB'::TEXT, 'CSC101'::TEXT, 'LA1'::TEXT, '2ndsem0910','09:00-12:00'::TEXT);
select insupsubject('A4T23-LEC'::TEXT, 'CSC101'::TEXT, 'LR1'::TEXT,'2ndsem0910' ,'12:30-01:30'::TEXT);
select insupsubject('A4T23-LAB'::TEXT, 'CSC101'::TEXT, 'LA1'::TEXT,'2ndsem0910' ,'09:00-12:00'::TEXT);
select insups2dent('2006-6168','Grote, Jesson M.');
select insups2dent('2008-0505','Ong, Esther Grace R.');
select insups2dent('2008-0254','Gorit, Alexis G.');
image source code
<img src="http://x4150my.msuiit.edu.ph/horde/timthumb.php?src=2001-4492&h=190&w=150&zc=1&q=100" border="0" style="border:1px solid #C1DAD7;float:left; margin-right:10px;"> 


things to include in the web site...
1st tab.. container class card --> performance table
attendance summary

*/
