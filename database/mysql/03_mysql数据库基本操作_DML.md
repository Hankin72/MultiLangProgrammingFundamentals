##  MySQL数据库基本操作-DML

### 1. 基本介绍

*DML* 是指 ***数据操作语言***， data manipulation language， 用来对数据库中的表的数据记录进行更新。

关键字： **增，删，改**

- 插入 insert  (INSERT INTO ...(...) values ...(...))
- 删除 delete  (delete from ... /truncate)
- 更新 update  (update 表名 set ... where ...)



##  （1）-- 数据插入

### 1. 语法格式：

>insert into 表（列名1， 列名2，列名3 ...）values （值1， 值2，值3 ...）;  //向表中插入这些
>
>insert into 表 values （值1， 值2，值3 ...）;  //向表中插入所有列

例子：

```sql
insert into student (sid, name, age, birth, address, score) values (1001, 'name', '男', 18, '1996-12-23'， '北京', 83.5);

insert into student values(1001,'name', '男', 18, '1996-12-23'， '北京', 83.5);
```

```sql
-- DML操作
-- 1，数据的插入
-- 格式1: insert into 表（列名1， 列名2，列名3 ...）values （值1， 值2，值3 ...）;
INSERT INTO student ( sid, NAME, gender, age, birth, address, score )
VALUES
	( 1001, '张三', '男', 18, '2001-12-23', 'Beijing', 85.2 ),
	( 1002, '李三', '女', 28, '2001-12-22', 'shenzhen', 82.2 ),
	( 1003, '赵三', '男', 38, '2001-12-24', 'shanghai', 80.2 );
	
INSERT INTO student ( sid ) VALUES ( 1010 );
INSERT INTO student ( sid, NAME ) VALUES	( 1111, '二狗子' );
	
-- 格式2: insert into 表 values （值1， 值2，值3 ...）;
INSERT INTO student VALUES	( 2000, 'Hankin', '男', 25, '1995-07-06', 'hangzhou', 90.5);
INSERT INTO student
VALUES
	( 2001, 'Cindy', '女', 25, '1991-11-03', 'taiyuan', 95.5 ),
	( 2002, 'harry', '男', 25, '1992-12-06', 'shanhe', 98.5 );
```



##  (2) -- 数据修改

### 1. 语法格式：

>update 表名 set 字段名=值， 字段名=值 ...;
>
>update 表名 set 字段名=值， 字段名=值 ... where 条件;

例子：

```sql
-- 将所有学生的地址修改为重庆
update student set address = '重庆';

-- 将id为1004的学生的地址修改为北京
update student set address = '北京' where sid = 1004;

-- 将id为1005的学生的地址修改为广州，成绩修改为100
update student set adress = '广州', score = 100 where sid = 1005;
```

```sql
-- 2.DML 操作 - 数据的修改 
	-- 格式1: update 表名 set 字段名=值， 字段名=值 ...;

	-- 格式2: update 表名 set 字段名=值， 字段名=值 ... where 条件;
	
	-- 将所有学生的地址修改为重庆
	update student set address = '重庆';

	-- 将id为1003的学生的地址修改为北京
	update student set address = '北京' WHERE sid = 1003;
	update student set address = '上海' WHERE sid > 1003;
	
	-- 将id为1010的学生的地址修改为广州，成绩修改为100
	UPDATE student set address = '广州', score = 100 WHERE sid = 1010;

```

##  (3) -- 数据删除

### 1. 语法格式：

>**delete from 表名 [where 条件];**
>
>（drop是删除数据库db或者删除表table， delete涉及删除内容）
>
>**truncate table 表名** 或者 **truncate 表名**;

例子：

```sql
-- 1.删除sid为1004的学生数据, 有目的性的删除
delete from student where sid = 1004;

-- 2.删除表中所有数据
delete from student;

-- 3.清空表数据
truncate table student;
truncate student;

```

> **注意：** *delete 和truncate原理不一样，delete只删除内容，而truncate类似于drop table， 可以理解为将整个表删除，然后再创建该表。*

```sql
-- 3.DML 操作 - 数据删除
	-- 格式: delete from 表名 [where 条件];
	-- truncate table 表名 或者 truncate 表名


	-- 1.删除sid为1003的学生数据
	DELETE FROM student where sid=1003;
	DELETE FROM student where sid > 1010;


	-- 2.删除表中所有数据
	DELETE FROM student;


	-- 3.清空表数据
	TRUNCATE TABLE student;
	TRUNCATE student;


```

##  练习

```sql

# 选择使用哪个数据库：
use mydb1;
# or, mydb1.employee

-- 1. 创建表 
/*
创建员工表employee， 字段如下；
id （员工编号），name， gender， salary
*/

create TABLE if not EXISTS mydb1.employee(
 id int,	
 name VARCHAR(20),
 gender VARCHAR(10),
 salary DOUBLE
);


-- 2. 给表插入数据
INSERT into employee(id, name, gender, salary) values (1, 'amy', 'female', 2000);
INSERT into employee values (2, 'bob', 'male', 4000),(3, 'cindy', 'female', 6000);

-- 3.修改表格数据 
	-- 3.1 将所有员工薪水修改为 5000 
	UPDATE employee set salary = 5000;
	
	-- 3.2 将‘Amy’薪水修改为 3800
	UPDATE employee set salary = 3800 WHERE name = 'amy';
	
	-- 3.3 将‘bob’薪水修改为 4000 gender修改为 ‘女’ 
	UPDATE employee set salary = 4000, gender = '女' WHERE name = 'bob';
	
	-- 3.4 将 ‘Cindy’薪水在原来基础上增加1000 
	update employee set salary = salary + 1000 where name = 'cindy';
	
	-- 4.删除表数据
	DELETE from employee where id =1;
	DELETE from employee;
	
	TRUNCATE table employee;
	
	truncate employee;
	
```













