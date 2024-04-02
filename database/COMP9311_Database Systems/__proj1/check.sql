-- COMP9311 19s1 Project 1 Check
--
-- MyMyUNSW Check

create or replace function
	proj1_table_exists(tname text) returns boolean
as $$
declare
	_check integer := 0;
begin
	select count(*) into _check from pg_class
	where relname=tname and relkind='r';
	return (_check = 1);
end;
$$ language plpgsql;

create or replace function
	proj1_view_exists(tname text) returns boolean
as $$
declare
	_check integer := 0;
begin
	select count(*) into _check from pg_class
	where relname=tname and relkind='v';
	return (_check = 1);
end;
$$ language plpgsql;

create or replace function
	proj1_function_exists(tname text) returns boolean
as $$
declare
	_check integer := 0;
begin
	select count(*) into _check from pg_proc
	where proname=tname;
	return (_check > 0);
end;
$$ language plpgsql;

-- proj1_check_result:
-- * determines appropriate message, based on count of
--   excess and missing tuples in user output vs expected output

create or replace function
	proj1_check_result(nexcess integer, nmissing integer) returns text
as $$
begin
	if (nexcess = 0 and nmissing = 0) then
		return 'correct';
	elsif (nexcess > 0 and nmissing = 0) then
		return 'too many result tuples';
	elsif (nexcess = 0 and nmissing > 0) then
		return 'missing result tuples';
	elsif (nexcess > 0 and nmissing > 0) then
		return 'incorrect result tuples';
	end if;
end;
$$ language plpgsql;

-- proj1_check:
-- * compares output of user view/function against expected output
-- * returns string (text message) containing analysis of results

create or replace function
	proj1_check(_type text, _name text, _res text, _query text) returns text
as $$
declare
	nexcess integer;
	nmissing integer;
	excessQ text;
	missingQ text;
begin
	if (_type = 'view' and not proj1_view_exists(_name)) then
		return 'No '||_name||' view; did it load correctly?';
	elsif (_type = 'function' and not proj1_function_exists(_name)) then
		return 'No '||_name||' function; did it load correctly?';
	elsif (not proj1_table_exists(_res)) then
		return _res||': No expected results!';
	else
		excessQ := 'select count(*) '||
			   'from (('||_query||') except '||
			   '(select * from '||_res||')) as X';
		-- raise notice 'Q: %',excessQ;
		execute excessQ into nexcess;
		missingQ := 'select count(*) '||
			    'from ((select * from '||_res||') '||
			    'except ('||_query||')) as X';
		-- raise notice 'Q: %',missingQ;
		execute missingQ into nmissing;
		return proj1_check_result(nexcess,nmissing);
	end if;
	return '???';
end;
$$ language plpgsql;

-- proj1_rescheck:
-- * compares output of user function against expected result
-- * returns string (text message) containing analysis of results

create or replace function
	proj1_rescheck(_type text, _name text, _res text, _query text) returns text
as $$
declare
	_sql text;
	_chk boolean;
begin
	if (_type = 'function' and not proj1_function_exists(_name)) then
		return 'No '||_name||' function; did it load correctly?';
	elsif (_res is null) then
		_sql := 'select ('||_query||') is null';
		-- raise notice 'SQL: %',_sql;
		execute _sql into _chk;
		-- raise notice 'CHK: %',_chk;
	else
		_sql := 'select ('||_query||') = '||quote_literal(_res);
		-- raise notice 'SQL: %',_sql;
		execute _sql into _chk;
		-- raise notice 'CHK: %',_chk;
	end if;
	if (_chk) then
		return 'correct';
	else
		return 'incorrect result';
	end if;
end;
$$ language plpgsql;

-- check_all:
-- * run all of the checks and return a table of results

drop type if exists TestingResult cascade;
create type TestingResult as (test text, result text);

create or replace function
	check_all() returns setof TestingResult
as $$
declare
	i int;
	testQ text;
	result text;
	out TestingResult;
	tests text[] := array['q1', 'q2', 'q3', 'q4', 'q5','q6','q7','q8','q9','q10','q11','q12'];
begin
	for i in array_lower(tests,1) .. array_upper(tests,1)
	loop
		testQ := 'select check_'||tests[i]||'()';
		execute testQ into result;
		out := (tests[i],result);
		return next out;
	end loop;
	return;
end;
$$ language plpgsql;


--
-- Check functions for specific test-cases in Project 1
--

create or replace function check_q1() returns text
as $chk$
select proj1_check('view','q1','q1_expected',
                   $$select * from q1$$)
$chk$ language sql;

create or replace function check_q2() returns text
as $chk$
select proj1_check('view','q2','q2_expected',
                   $$select * from q2$$)
$chk$ language sql;

create or replace function check_q3() returns text
as $chk$
select proj1_check('view','q3','q3_expected',
                   $$select * from q3$$)
$chk$ language sql;

create or replace function check_q4() returns text
as $chk$
select proj1_check('view','q4','q4_expected',
                   $$select * from q4$$)
$chk$ language sql;

create or replace function check_q5() returns text
as $chk$
select proj1_check('view','q5','q5_expected',
                   $$select * from q5$$)
$chk$ language sql;

create or replace function check_q6() returns text
as $chk$
select proj1_check('view','q6','q6_expected',
                   $$select * from q6$$)
$chk$ language sql;

create or replace function check_q7() returns text
as $chk$
select proj1_check('view','q7','q7_expected',
                   $$select * from q7$$)
$chk$ language sql;

create or replace function check_q8() returns text
as $chk$
select proj1_check('view','q8','q8_expected',
                   $$select * from q8$$)
$chk$ language sql;

create or replace function check_q9() returns text
as $chk$
select proj1_check('view','q9','q9_expected',
                   $$select * from q9$$)
$chk$ language sql;

create or replace function check_q10() returns text
as $chk$
select proj1_check('view','q10','q10_expected',
                   $$select * from q10$$)
$chk$ language sql;

create or replace function check_q11() returns text
as $chk$
select proj1_check('view','q11','q11_expected',
                   $$select * from q11$$)
$chk$ language sql;

create or replace function check_q12() returns text
as $chk$
select proj1_check('view','q12','q12_expected',
                   $$select * from q12$$)
$chk$ language sql;
--
-- Tables of expected results for test cases
--

drop table if exists q1_expected;
create table q1_expected (
	staff_role longstring, course_num bigint
);

drop table if exists q2_expected;
create table q2_expected (
	course_id integer
);

drop table if exists q3_expected;
create table q3_expected (
	course_num bigint
);

drop table if exists q4_expected;
create table q4_expected (
	unswid integer, name longname
);

drop table if exists q5_expected;
create table q5_expected (
	course_id integer
);

drop table if exists q6_expected;
create table q6_expected (
  semester longname,
  course_num bigint
);

drop table if exists q7_expected;
create table q7_expected (
  course_id integer,
  avgmark numeric(4,2),
  semester shortname
);

drop table if exists q8_expected;
create table q8_expected (
	num bigint
);

drop table if exists q9_expected;
create table q9_expected (
	year courseyeartype,
    term ShortName,
    average_mark numeric(4,2)
);

drop table if exists q10_expected;
create table q10_expected (
	year courseyeartype,
    num bigint,
    unit longstring
);

drop table if exists q11_expected;
create table q11_expected (
    unswid integer,
    name longname,
    avg_mark numeric(4,2)
);

drop table if exists q12_expected;
create table q12_expected (
	unswid ShortString,
    longname longname,
    rate numeric(4,2)
);

-- ( )+\|+( )+

COPY q1_expected (staff_role, course_num) FROM stdin;
Course Tutor	220
Course Lecturer	722
Course Convenor	3685
\.

COPY q2_expected (course_id) FROM stdin;
     68619
     70427
\.

COPY q3_expected (course_num) FROM stdin;
2468
\.

COPY q4_expected (unswid,name) FROM stdin;
 3194868	Paul Klaassen
 3187575	James Patsalis
 3140496	Courtney Yaskil
 3128423	G Ming
 3124566	Thanuja Steele
 3100291	Sylvie Ricci
 3066859	Murphy Lok
\.

COPY q5_expected (course_id) FROM stdin;
  15978
  37727
\.

COPY q6_expected (semester, course_num) FROM stdin;
2011 Semester 2	1297
\.

COPY q7_expected (course_id, avgmark, semester) FROM stdin;
  39581	77.30	Sem2 2008
  39458	77.16	Sem2 2008
  39441	76.52	Sem2 2008
  38195	75.05	Sem2 2008
  38095	78.91	Sem2 2008
  37807	75.05	Sem2 2008
  37740	78.81	Sem2 2008
  37739	75.78	Sem2 2008
  37521	77.53	Sem2 2008
  37517	76.04	Sem2 2008
  37413	79.67	Sem2 2008
  37191	78.65	Sem2 2008
  36857	75.24	Sem2 2008
  36483	75.33	Sem2 2008
  36251	77.50	Sem1 2008
  36135	76.47	Sem1 2008
  36125	75.04	Sem1 2008
  35937	79.81	Sem1 2008
  35683	78.81	Sem1 2008
  35592	76.78	Sem1 2008
  35523	76.24	Sem1 2008
  34710	77.42	Sem1 2008
  34351	78.26	Sem1 2008
  34136	75.12	Sem1 2008
  34133	75.42	Sem1 2008
  34127	78.69	Sem1 2008
  34056	75.48	Sem1 2008
  34051	76.07	Sem1 2008
  32809	77.10	Summ 2008
  32488	78.82	ASemA2007
  31111	75.19	ASemA2007
  31101	75.27	ASemA2007
  30965	75.92	ASemA2007
  30398	77.03	ASemA2007
  30314	76.65	ASemA2007
  30006	75.82	ASemA2007
  27819	77.85	ASemM2007
  25843	79.30	Summ 2007
\.

COPY q8_expected (num) FROM stdin;
126
\.

COPY q9_expected (
    year,
    term,
    average_mark
) FROM stdin;
2003	S1	78.22
2003	S2	72.88
2004	S1	82.33
2004	S2	67.62
2005	S1	81.83
2005	S2	69.90
2006	S1	71.29
2006	S2	77.31
2007	S1	70.08
2007	S2	76.05
2008	S1	67.94
2008	S2	68.73
2009	S1	73.20
2009	S2	64.13
2010	S1	67.47
2010	S2	76.23
2011	S1	68.10
2011	S2	70.85
2012	S1	63.74
2012	S2	74.56
\.

COPY q10_expected (year, num, unit) FROM stdin;
2013	6	Department of Anatomy
2011	28	School of Biotechnology and Biomolecular Sciences
2011	45	School of Art - COFA
2011	23	School of Art History & Art Education - COFA
2011	348	Faculty of Arts and Social Sciences
2009	4	UNSW Canberra at ADFA
2010	4	UNSW Canberra at ADFA
2011	4	UNSW Canberra at ADFA
2011	249	Faculty of Science
2012	16	School of Biological, Earth and Environmental Sciences
2011	477	Faculty of Built Environment
2011	238	School of Chemical Engineering
2012	34	School of Chemistry
2012	263	School of Civil and Environmental Engineering
2012	7	Clinical School - Prince of Wales Hospital
2011	2	Clinical School - South Western Sydney
2012	2	Clinical School - South Western Sydney
2012	6	Clinical School - St George Hospital
2012	8	Clinical School - St Vincent's Hospital
2011	4	College of Fine Arts (COFA)
2011	281	School of Computer Science and Engineering
2010	104	School of Design Studies - COFA
2012	11	School of Education
2012	209	School of Electrical Engineering & Telecommunications
2011	504	Faculty of Engineering
2011	58	School of the Arts and Media
2009	30	Institute of Environmental Studies
2012	15	School of Surveying and Spatial Information Systems
2011	37	Graduate School of Biomedical Engineering
2013	2	School of Management
2013	11	School of Information Systems, Technology and Management
2011	26	Faculty of Law
2012	114	School of Law
2012	15	School of Materials Science & Engineering
2011	11	School of Mathematics & Statistics
2012	318	School of Mechanical and Manufacturing Engineering
2012	200	Faculty of Medicine
2010	27	School of Mining Engineering
2010	34	School of Optometry and Vision Science
2012	8	Department of Pathology
2012	87	School of Petroleum Engineering
2012	4	School of Physics
2013	4	School of Physics
2011	5	School of Psychiatry
2012	19	School of Psychology
2010	39	School of Risk & Safety Science
2012	3	School of Social Sciences
2012	161	School of Photovoltaic and Renewable Engineering
2013	74	School of Aviation
2011	16	School of Actuarial Studies
2011	296	UNSW Foundation Studies
2012	52	School of Public Health & Community Medicine
2011	10	School of Medical Sciences
2012	10	School of Medical Sciences
2011	5	School of Women's and Children's Health
2012	5	School of Women's and Children's Health
2011	60	School of Media Arts
2011	17	School of Business (ADFA)
2012	17	School of Business (ADFA)
2013	7	School of Humanities and Social Sciences (ADFA)
2010	18	School of Physical, Environmental and Mathematical Sciences (ADFA)
2012	922	Australian School of Business
2010	131	AGSM MBA Programs
2010	1	Nura Gili Indigenous Programs
2012	1	Nura Gili Indigenous Programs
2012	9	Graduate Programs in Business and Technology
2009	1	School of Obstetrics and Gynaecology
2010	1	School of Obstetrics and Gynaecology
2011	1	School of Obstetrics and Gynaecology
2010	5	School of Paediatrics
2011	5	School of Paediatrics
2012	5	School of Paediatrics
2012	3	School of Biochemistry and Molecular Genetics
2013	6	Department of Biotechnology
2007	3	School of Microbiology and Immunology
2012	44	UC Information Technology and Electrical Eng
2011	33	UC School of Aerospace, Civil and Mechanical Eng
2011	16	UC School of Humanities and Social Science
2010	4	School of Physiology and Pharmacology
2010	11	Division of Registrar and Deputy Principal
2004	1	Building Construction Management Program
2005	1	Building Construction Management Program
2012	1	School of Engineering and Information Technology (ADFA)
2013	1	School of Engineering and Information Technology (ADFA)
2010	11	Australian School of Taxation and Business Law
\.


COPY q11_expected (unswid, name, avg_mark) FROM stdin;
3239177	Mithril Abdul Razak	99.00
3353787	Erin Gati	98.67
3267525	Michael Mohamed Anuar	97.33
3363572	Alicia Almasi	96.25
3230032	Matthew Gonsalves	96.25
3392655	Alexander Shahpoor	96.25
3375583	Margustin Chauw	95.75
3354505	Ching Bau	95.33
3376647	Yanmin Qian	95.00
3302603	Darren Haffner	94.75
3395322	Simon Perri	94.75
\.

COPY q12_expected (unswid, longname,rate) FROM stdin;
K-F23-201	Matthews Theatre A	0.00
K-F23-203	Matthews Theatre B	0.03
K-F23-303	Matthews Theatre C	0.68
K-F23-304	Matthews Theatre D	0.00
\.
