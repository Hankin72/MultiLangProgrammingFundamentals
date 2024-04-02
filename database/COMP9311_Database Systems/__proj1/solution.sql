
--Q1

create or replace view q1(staff_role, course_num) as
select  staff_roles.name, count(distinct courses.id)
from courses
inner join course_staff on courses.id = course_staff.course 
inner join staff_roles on staff_roles.id = course_staff.role
inner join semesters on semesters.id = courses.semester
where semesters.year = 2010
GROUP BY staff_roles.name
ORDER BY count(distinct courses.id) ASC;


-- Q2

create or replace view Q2(course_id)
as
SELECT c.course FROM Classes c, Class_types ct, Rooms r, Buildings b
WHERE c.ctype = ct.id AND c.room = r.id AND r.building = b.id AND ct.name = 'Studio'
GROUP BY c.course
HAVING count(distinct b.id) = 3;



--Q3

create or replace view Q3_1(course,room,f_description) as
select distinct classes.course,rooms.id,facilities.description
from students
inner join course_enrolments on course_enrolments.student = students.id
inner join courses on course_enrolments.course = courses.id 
inner join classes on courses.id = classes.course
inner join rooms on rooms.id = classes.room
inner join room_facilities on rooms.id = room_facilities.room
inner join facilities on room_facilities.facility = facilities.id
where students.stype = 'intl';

select count(distinct courses.id)
from students
inner join course_enrolments on course_enrolments.student = students.id
inner join courses on course_enrolments.course = courses.id 
-- inner join classes on courses.id = classes.course
where students.stype = 'intl';

create or replace view Q3_2(course,room)
as
SELECT DISTINCT Q3_1.course,Q3_1.room
FROM Q3_1
WHERE Q3_1.f_description = 'Student wheelchair access'
INTERSECT
SELECT DISTINCT Q3_1.course,Q3_1.room
FROM Q3_1
WHERE Q3_1.f_description = 'Teacher wheelchair access' 
;

create or replace view Q3(course_num)
as
select count(distinct course) from Q3_2;


-- Q4

create or replace view Q4(unswid, name)
as
SELECT p.unswid, p.name
FROM People p, Students s1, Course_enrolments ce, Courses c, Subjects s2, OrgUnits o
WHERE p.id = s1.id AND s1.id = ce.student AND ce.course = c.id 
AND c.subject = s2.id AND s1.stype = 'local' AND ce.mark>87 AND s2.offeredBy=o.id
AND o.name = 'School of Chemical Sciences'
ORDER BY p.unswid DESC;

--Q5

create or replace view student_avg_mark as 
select course, avg(mark) as avg_mark, count(distinct student) as student_num 
from course_enrolments 
where mark is not null
group by course
HAVING count(distinct student) > 10;

create or replace view Q5_1 as
select ce.course, student, student_avg_mark.student_num
from Course_enrolments ce
inner join student_avg_mark on ce.course = student_avg_mark.course
where ce.mark>avg_mark;

create or replace view Q5(course_id) as
select course
from Q5_1
group by course,student_num
HAVING count(distinct student)> (student_num*0.8)
ORDER BY course ASC;

-- Q6

create or replace view Q6_1(cid,sid)
as
SELECT c.id, c.semester
FROM Students s1, Course_enrolments ce, Courses c 
WHERE s1.id = ce.student AND ce.course = c.id
GROUP BY c.id, c.semester
HAVING count(DISTINCT s1.id) >= 10
;

create or replace view Q6_2(sid,cnum)
as
SELECT Q6_1.sid, count(DISTINCT Q6_1.cid)
FROM Q6_1
GROUP BY Q6_1.sid
;


create or replace view Q6(semester, course_num)
as
SELECT s.longname, cnum
FROM Q6_2, semesters s
WHERE Q6_2.sid = s.id AND cnum = (SELECT max(cnum) as max_ FROM Q6_2)
;

--Q7

create or replace view valid_courses as
select course, count(*)
from course_enrolments
where course_enrolments.mark is not null
group by course
having count(*) >= 20;

create or replace view q7(course_id, avgmark, semester) as
select distinct courses.id, avg(mark)::numeric(4,2), semesters.name from course_enrolments
inner join valid_courses on valid_courses.course = course_enrolments.course
inner join courses on courses.id = course_enrolments.course
inner join semesters on semesters.id = courses.semester
where semesters.year = 2007 or semesters.year = 2008
group by courses.id, semesters.name
having avg(mark)::numeric(4,2) > 75 AND avg(mark)::numeric(4,2) < 80
ORDER by courses.id DESC;

-- Q8

create or replace view Q8_1(sid)
as
SELECT p.unswid
FROM People p, Students s1, Program_enrolments pe, Semesters s2, Stream_enrolments se, Streams s3
WHERE p.id = s1.id AND s1.id = pe.student AND pe.semester = s2.id AND pe.id = se.partOf AND se.stream = s3.id
AND s1.stype = 'intl' AND (s2.year = '2009' OR s2.year = '2010') AND s3.name = 'Medicine'
EXCEPT
SELECT p.unswid
FROM People p, Students s1, Course_enrolments ce, Courses c, Subjects s2, OrgUnits o
WHERE p.id = s1.id AND s1.id = ce.student AND ce.course = c.id AND c.subject = s2.id AND s2.offeredBy = o.id
AND s1.stype = 'intl' AND  o.name like '%Engineering%'
;


create or replace view Q8(num)
as
SELECT count(*) FROM Q8_1
;



-- Q9:
create or replace view Q9(year,term,average_mark)
as
--... SQL statements, possibly using other views/functions defined by you ...
select sem.year, sem.term, round(avg(ce.mark),2)
from Course_enrolments ce 
join Courses c on ce.course = c.id
join Subjects sj on c.subject = sj.id
join Semesters sem on c.semester = sem.id
where ce.mark is not null and sj.name = 'Database Systems'
group by sem.year, sem.term
;

-- Q10:
create or replace view Q10(year, num, unit)
as
--... SQL statements, possibly using other views/functions defined by you ...
select year, num, longname
from (
	select org.longname, sem.year, count(distinct pe.student) as num, rank() over (partition by org.longname order by count(distinct pe.student) desc) as rank 
from Program_enrolments pe 
join students s on s.id = pe.student
join semesters sem on pe.semester = sem.id
join programs pr on pe.program = pr.id
join OrgUnits org on pr.offeredBy = org.id
where s.stype = 'intl'
group by org.longname, sem.year
) as sub
where rank  = 1 and num > 0
;

-- Q11:
create or replace view sub11(student, num)
as 
select ce.student, count(*) as num
from Course_enrolments ce
join courses c on ce.course = c.id
join Semesters s on c.semester = s.id
where s.year = 2011 and s.term = 'S1' and ce.mark >= 0
group by ce.student
;

create or replace view Q11(unswid, name, avg_mark)
as
--... SQL statements, possibly using other views/functions defined by you ...
select unswid, name, avg_mark
from (
select people.unswid, people.name, round(avg(ce.mark),2) as avg_mark, rank() over (order by round(avg(ce.mark),2) desc) as rank 
from Course_enrolments ce
join sub11 on ce.student = sub11.student
join people on ce.student = people.id
join courses c on ce.course = c.id
join Semesters s on c.semester = s.id
where s.year = 2011 and s.term = 'S1' and ce.mark >= 0 and sub11.num >= 3
group by people.unswid, people.name
) ss
where rank <= 10
;


-- Q12:
create or replace view validRoom(id, unswid, longname)
as
select r.id, r.unswid, r.longname, r.capacity
from rooms r
join buildings b on r.building = b.id
where b.name = 'Mathews Building' and longname like '%Theatre%'
;

create or replace view classinfo(id, course, room, num)
as
select cl.id, cl.course, cl.room, count(distinct ce.student) as num
from classes cl
join courses c on cl.course = c.id
join Course_enrolments ce on c.id = ce.course
join Semesters sem on c.semester = sem.id
where sem.year = 2010 and sem.term = 'S1'
group by cl.id, cl.course, cl.room
;

--... SQL statements, possibly using other views/functions defined by you ...
create or replace view Q12(unswid, longname,rate)
as
select unswid, longname, max(rrrr) as rate
from
(
select vr.unswid, vr.longname, case when num is null then cast(0 / (vr.capacity * 1.0) as numeric(4,2)) else cast(num / (vr.capacity * 1.0) as numeric(4,2)) end as rrrr
from validRoom vr
left join classinfo c on vr.id = c.room
) sss
group by unswid, longname
;
