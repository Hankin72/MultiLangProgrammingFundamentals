-- comp9311 20T3 Project 1
--
-- MyMyUNSW Solutions
-- haojin guo z5216214


-- Q1:
-- Q1:
CREATE OR REPLACE VIEW Q1(staff_role, course_num)
AS 
--... SQL statements, possibly using other views/functions defined by you ...
SELECT staff_roles.name AS staff_role, COUNT(DISTINCT courses.id) AS course_num
-- natural join
FROM staff_roles, course_staff, courses, semesters
-- euqal codnition 等值条件
WHERE staff_roles.id = course_staff.role 
AND course_staff.course  = courses.id
AND courses.semester =  semesters.id
-- condition
AND semesters.year = '2010'
-- Grouping 
GROUP BY staff_role
HAVING COUNT(courses.id) > 1
-- ordering from  low to high 
ORDER BY course_num ;


-- Q2:
--------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Q2(course_id)
AS
--... SQL statements, possibly using other views/functions defined by you ...
SELECT courses.id  AS course_id
-- Table:   class_types--> <-- classes -->rooms--> building,  
FROM courses JOIN classes ON courses.id = classes.course
			JOIN class_types ON class_types.id = classes.ctype 
			JOIN rooms ON classes.room =  rooms.id
			JOIN buildings ON rooms.building =  buildings.id
WHERE class_types.name = 'Studio'
GROUP BY course_id
-- THREE  differeny building, so need to distinct 
HAVING COUNT(DISTINCT buildings.id) >= 3 ;



-- Q3:
--------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Q3_V1(coursesID, roomsID)
AS 
--... SQL statements, possibly using other views/functions defined by you ...
-- INT  +  Teacher wheelchair access' + ROOM 
SELECT DISTINCT courses.id AS coursesID, rooms.id AS roomsID
FROM courses, course_enrolments, rooms, students, classes, room_facilities, facilities
WHERE courses.id = course_enrolments.course
AND course_enrolments.student = students.id
AND courses.id = classes.course
AND classes.room = rooms.id
AND rooms.id = room_facilities.room
AND room_facilities.facility = facilities.id
AND students.stype LIKE '%intl%'
AND facilities.description = 'Teacher wheelchair access' ;

CREATE OR REPLACE VIEW Q3_V2(coursesID, roomsID)
AS 
-- INT  +  Student wheelchair access' + ROOM 
SELECT DISTINCT courses.id AS coursesID, rooms.id AS roomsID
FROM courses JOIN course_enrolments ON courses.id = course_enrolments.course
JOIN classes ON courses.id = classes.course
JOIN students ON course_enrolments.student = students.id
JOIN rooms ON classes.room = rooms.id
JOIN room_facilities ON rooms.id = room_facilities.room
JOIN facilities ON room_facilities.facility = facilities.id
WHERE students.stype LIKE '%intl%'
AND facilities.description = 'Student wheelchair access' ;

CREATE OR REPLACE VIEW Q3(course_num)
AS  
SELECT COUNT(DISTINCT Q3_V1.coursesID) AS course_num
FROM Q3_V1, Q3_V2
WHERE Q3_V1.coursesID = Q3_V2.coursesID
AND Q3_V1.roomsID = Q3_V2.roomsID ;


-- Q4:
--------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Q4(unswid,name)
AS
--... SQL statements, possibly using other views/functions defined by you ...
-- local , distinct student, mark>= 87
SELECT DISTINCT people.unswid AS unswid, people.name AS name
-- people --> students  -- >  course_enrolments. mark -->courses -->subjects --> orgunits
FROM people JOIN students ON people.id = students.id
JOIN course_enrolments ON students.id = course_enrolments.student
JOIN courses ON course_enrolments.course = courses.id
JOIN subjects ON courses.subject = subjects.id 
JOIN orgunits ON subjects.offeredby = orgunits.id
WHERE orgunits.name = 'School of Chemical Sciences'
AND students.stype = 'local'
AND course_enrolments.mark > 87
ORDER BY unswid desc ;



--Q5:
--------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Q5_V1(courseID)
AS  
--... SQL statements, possibly using other views/functions defined by you ...
-- courses > 10 students;  AND avgmark
SELECT courses.id AS courseID
FROM courses JOIN course_enrolments ON courses.id = course_enrolments.course
WHERE course_enrolments.mark IS NOT NULL 
GROUP BY courseID     
HAVING COUNT(course_enrolments.student) >= 10 ;

-- ORDER BY courses.id DESC
 
--  courses - total students 
CREATE OR REPLACE VIEW Q5_V2(courseID, total_students_num, avgmark)
AS  
SELECT course_enrolments.course AS courseID, COUNT(course_enrolments.student) AS total_students_num,  AVG(course_enrolments.mark) AS avgmark
FROM Q5_V1 JOIN course_enrolments ON Q5_V1.courseID = course_enrolments.course 
GROUP BY course_enrolments.course;

-- student_num , over avgmarks 

CREATE OR REPLACE VIEW Q5_V3(courseID, student_num_over_avg)
AS  
SELECT courses.id AS courseID, COUNT(course_enrolments.student) as student_num_over_avg
FROM Q5_V2, course_enrolments, courses
WHERE Q5_V2.courseID =  course_enrolments.course
AND course_enrolments.course = courses.id
AND course_enrolments.mark > Q5_V2.avgmark;


--output
CREATE OR REPLACE VIEW Q5(course_id)
AS  
SELECT Q5_V3.courseID AS course_id
FROM Q5_V2, Q5_V3 
WHERE Q5_V2.coursesID = Q5_V3.courseID
AND Q5_V3.student_num_over_avg >  Q5_V2.total_students_num * 0.8;



-- Q6:
--------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE VIEW Q6_V1(courseID)
AS
SELECT course_enrolments.course AS courseID
FROM course_enrolments
GROUP BY courseID
HAVING count(course_enrolments.student)>=10;


-- CREATE OR REPLACE VIEW Q6_V0(courseID , stut_num)
-- AS
-- SELECT Q6_V0.course AS courseID,  Q6_V0.stut_num
-- FROM Q6_V0
-- WHERE stut_num >= 10;


CREATE OR REPLACE VIEW Q6_V2(semester, course_num)
AS
-- semester --- num of courses 
SELECT semesters.longname AS semester, COUNT(DISTINCT Q6_V1.courseID) AS course_num
FROM Q6_V1, semesters, courses
WHERE Q6_V1.courseID = courses.id
AND semesters.id = courses.semester
GROUP BY semester ;


CREATE OR REPLACE VIEW Q6_V3(max_course_num)
AS
-- the highest course_num 
SELECT MAX(Q6_V2.course_num) AS max_course_num 
FROM Q6_V2 ;


--SELECT *
-- FROM Q6_V2 
-- WHERE Q6_V2.course_num = (SELECT MAX(Q6_V2.course_num) AS max_course_num FROM Q6_V2)
--OUTPUT
CREATE OR REPLACE VIEW Q6(semester, course_num)
AS
SELECT Q6_V2.semester AS semester, Q6_V2.course_num AS course_num
FROM Q6_V2, Q6_V3
WHERE Q6_V2.course_num = Q6_V3.max_course_num ;



-- Q7:
--------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Q7(course_id, avgmark, semester)
AS
SELECT DISTINCT courses.id AS course_id, AVG(course_enrolments.mark) :: NUMERIC(4,2) AS avgmark, semesters.name AS semester
FROM courses JOIN course_enrolments ON courses.id = course_enrolments.course
JOIN semesters ON courses.semester = semesters.id
WHERE course_enrolments.mark IS NOT NULL
AND semesters.year IN ('2007', '2008')
GROUP BY course_id, semesters.name
HAVING COUNT(course_enrolments.mark) >= 20
AND AVG(course_enrolments.mark) > 75
AND AVG(course_enrolments.mark) < 80
ORDER BY course_id DESC ;


-- Q8: 
-------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Q8_V1(unswid)
AS
-- intl students num , in 2009 or 2010, streams.name = medicine
SELECT DISTINCT people.unswid AS unswid
-- people -- students -- course_enrolments -- courses -- subject --semester-- orgunits
-- 
FROM people JOIN students ON students.id = people.id
JOIN course_enrolments ON course_enrolments.student = students.id
JOIN courses ON course_enrolments.course = courses.id 
JOIN subjects ON courses.subject = subjects.id 
JOIN orgunits ON subjects.offeredby = orgunits.id
JOIN semesters ON courses.semester = semesters.id 
-- equal condition
-- codnition
WHERE students.stype LIKE '%intl%'
AND orgunits.name LIKE '%Engineering%';
-- AND semesters.year IN ('2009','2010');

CREATE OR REPLACE VIEW Q8_V2(unswid)
AS
-- intl students num , in 2009 or 2010, streams.name = medicine
SELECT DISTINCT people.unswid AS unswid
-- equal condition
FROM  streams JOIN stream_enrolments ON streams.id = stream_enrolments.stream
JOIN program_enrolments ON stream_enrolments.partof =  program_enrolments.id
JOIN semesters ON program_enrolments.semester = semesters.id
JOIN students ON program_enrolments.student = students.id
JOIN people ON students.id = people.id
WHERE semesters.year IN ('2009','2010')
AND students.stype LIKE '%intl%'
AND streams.name LIKE 'Medicine' ;


--- difference/ intersection 
CREATE OR REPLACE VIEW Q8(num)
AS 
SELECT COUNT(OUTPUT.unswid) AS num
FROM(
	SELECT Q8_V2.unswid FROM Q8_V2
	EXCEPT
	SELECT Q8_V1.unswid FROM Q8_V1) AS OUTPUT ;



-- Q9:
-------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Q9(year,term,average_mark)
AS
--... SQL statements, possibly using other views/functions defined by you ...
SELECT semesters.year AS year, semesters.term AS term, AVG(course_enrolments.mark)::NUMERIC(4,2) AS average_mark
-- semesters -- courses_enrolsments -- courses --> subject 
FROM course_enrolments JOIN courses ON course_enrolments.course = courses.id
JOIN semesters ON semesters.id = courses.semester
JOIN subjects ON subjects.id = courses.subject
WHERE course_enrolments.mark IS NOT NULL
AND subjects.name = 'Database Systems'
GROUP BY year, semesters.term ;



-- Q10:
-------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Q10_V1(year, num, unit)
AS
--... SQL statements, possibly using other views/functions defined by you ...
-- different years -- unit count, -- intl-students num 
SELECT semesters.year AS year, COUNT(DISTINCT students.id) AS num, orgunits.longname AS unit
-- students<--course_enrolments --> courses -- > semesters,,  orgunits--> subjects -->  courses, 
FROM students JOIN course_enrolments ON students.id = course_enrolments.student
JOIN courses ON course_enrolments.course = courses.id
JOIN semesters ON courses.semester = semesters.id
JOIN subjects ON courses.subject = subjects.id
JOIN orgunits ON orgunits.id = subjects.offeredby 

WHERE students.stype LIKE '%intl%'
GROUP BY year, orgunits.longname

ORDER BY unit;


-- max num <---> unit longname
CREATE OR REPLACE VIEW Q10_V2(unit, maxnum)
AS
SELECT Q10_V1.unit as unit, max(Q10_V1.num) as maxnum
FROM Q10_V1
GROUP BY unit;


CREATE OR REPLACE VIEW Q10(year, num, unit)
AS
SELECT Q10_V1.year AS year, Q10_V1.num AS num, Q10_V1.unit AS unit
FROM Q10_V1, Q10_V2
WHERE Q10_V1.num = Q10_V2.maxnum
AND Q10_V1.unit = Q10_V2.unit;



-- Q11:
-------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Q11_V1(unswid, name, avg_mark)
AS
--... SQL statements, possibly using other views/functions defined by you ...
-- rank(), order 
SELECT people.unswid AS unswid, people.name AS name,  AVG(course_enrolments.mark)::NUMERIC(4,2) AS avg_mark
-- people, -- students --> course_enrolments ----courses  -- semesters 
FROM people JOIN students ON students.id = people.id 
JOIN course_enrolments ON course_enrolments.student = students.id
JOIN courses ON courses.id = course_enrolments.course
JOIN semesters ON semesters.id = courses.semester
WHERE course_enrolments.mark IS NOT NULL
AND semesters.year = '2011'
AND semesters.term = 'S1'
GROUP BY people.unswid, people.name
HAVING  COUNT(course_enrolments.mark) >=3 
ORDER BY avg_mark DESC ;


CREATE OR REPLACE VIEW Q11_V2(unswid, name, avg_mark)
AS 
-- rank(), order 
SELECT Q11_V1.*, rank() over (ORDER BY avg_mark DESC)
FROM Q11_V1 ;


CREATE OR REPLACE VIEW Q11(unswid, name, avg_mark)
AS
--... SQL statements, possibly using other views/functions defined by you ...
-- rank(), order 
SELECT Q11_V2.unswid AS unswid, Q11_V2.name AS name, Q11_V2.avg_mark AS avg_mark
FROM Q11_V2
WHERE Q11_V2.rank <= 10;



-- Q12:
-------------------------------------------------------------------------------------------------------------------
-- find rooms_num ID, NAME, 容量
CREATE OR REPLACE VIEW Q12_V1(unswid, longname,capacity)
AS
--... SQL statements, possibly using other views/functions defined by you ...
SELECT DISTINCT rooms.unswid AS unswid, rooms.longname AS longname, rooms.capacity AS capacity
-- rooms, buildings, room_types, 
FROM rooms, buildings, room_types
WHERE rooms.building = buildings.id 
AND rooms.rtype = room_types.id
AND room_types.description LIKE 'Lecture Theatre'
AND buildings.name LIKE 'Mathews Building' ;



---对应教室的学生总是有多少人
CREATE OR REPLACE VIEW Q12_V2(unswid, longname,rate)
AS
--... SQL statements, possibly using other views/functions defined by you ...
SELECT DISTINCT rooms.unswid AS unswid, rooms.longname AS longname, classes.id AS class_id, rooms.capacity AS capacity, 
COUNT(DISTINCT course_enrolments.student) AS studt_num

FROM rooms, buildings, room_types, classes, courses, course_enrolments, semesters
WHERE rooms.building = buildings.id 
AND rooms.rtype = room_types.id
AND rooms.id = classes.room
AND classes.course = courses.id
AND courses.id = course_enrolments.course
AND courses.semester = semesters.id
AND room_types.description LIKE 'Lecture Theatre'
AND buildings.name LIKE 'Mathews Building'
AND semesters.term = 'S1' 
AND semesters.year = '2010'
GROUP BY rooms.unswid, rooms.longname, classes.id, rooms.capacity ;


CREATE OR REPLACE VIEW Q12_V3(unswid, longname,rate)
AS
--... SQL statements, possibly using other views/functions defined by you ...
-- SELECT Q12_V2.unswid, Q12_V2.longname, MAX(Q12_V2.studt_num::NUMERIC(4,2)/Q12_V2.capacity::NUMERIC(4,2)) AS rate
SELECT Q12_V2.unswid AS unswid, Q12_V2.longname AS lonngname, MAX(Q12_V2.studt_num::float/Q12_V1.capacity::float)::NUMERIC(4,2) AS rate
FROM Q12_V1, Q12_V2
WHERE Q12_V1.unswid = Q12_V2.unswid
GROUP BY Q12_V2.unswid, Q12_V2.longname ; 

 
CREATE OR REPLACE VIEW Q12_V4(unswid, longname,rate)
AS
-- SELECT Q12_V2.unswid, Q12_V2.longname, MAX(Q12_V2.studt_num::NUMERIC(4,2)/Q12_V2.capacity::NUMERIC(4,2)) AS rate
SELECT Q12_V4.unswid AS unswid, Q12_V4.longname AS lonngname, 0.00 AS rate
FROM (
	SELECT Q12_V1.unswid, Q12_V1.longname FROM Q12_V1
	EXCEPT
	SELECT Q12_V2.unswid, Q12_V2.longname FROM Q12_V2) AS Q12_V4 ; 



CREATE OR REPLACE VIEW Q12(unswid, longname,rate)
AS
--... SQL statements, possibly using other views/functions defined by you ...
-- SELECT Q12_V2.unswid, Q12_V2.longname, MAX(Q12_V2.studt_num::NUMERIC(4,2)/Q12_V2.capacity::NUMERIC(4,2)) AS rate
SELECT * 
FROM Q12_V3

UNION 

SELECT * 
FROM Q12_V4 ;



























