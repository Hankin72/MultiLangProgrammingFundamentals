# MySQL约束 - 主键约束
---

### 概念

- mysql主键约束是一个列或者多个列的组合，***其值能唯一地标识表中的每一行，方便在RDMS中尽快的找到某一行。***
- 主键约束相当于，***唯一约束 + 非空约束*** 的组合， 主键约束不允许重复， 也不允许出现控值
- 每个表最多只允许出现一个主键
- 主键约束的关键字是: **Primary Key**
- *当创建主键的约束的时候，系统会默认在所在的列和列组合上建立对应的唯一索引。*

### 操作

- 添加单列主键

- 添加多列联合主键

- 删除主键

  

##  1.0 操作 - 添加单列主键

### 创建单列主键有两种方式，**一种是在定义字段的同时制定主键，**一种是定义完字段之后指定主键

**方式1 -- 语法：**

> ```sql
> -- 在create table语句中，通过 primary key 关键字来指定主键。
> 
> -- 语法格式如下：
> ```
>
> create table 表名 （
>
> ​	...
>
> ​	<字段名> <数据类型> primary key
>
> ​	...	
>
> ）;
>
> ```sql
> USE mydb1;
> 
> CREATE TABLE emp1(
>  eid int PRIMARY KEY,
>  name VARCHAR(20),
>  deptId int,
>  salary double
> 
> );
> ```

**方式2 -- 语法：**

> ```sql
> -- 在定义字段之后再指定主键，语法格式如下：
> ```
>
> create table 表名 (
>
> ​	...
>
> ​	[constriant <约束名>] primary key (字段名)
>
> );
>
> ```sql
> CREATE TABLE emp2(
>  eid int,
>  name VARCHAR(20),
>  deptId int,
>  salary double,
>  constraint pk1 PRIMARY KEY(eid)  -- constraint pk1  可以省略
> );
> 
> --  主键的作用 
> --  主键约束的列，非空，而且唯一
> INSERT into emp2(eid, name, deptId, salary) VALUES (1001,'hello', 10, 5000);
> 
> INSERT into emp2(eid, name, deptId, salary) VALUES (1001,'harry', 20, 6000);  -- 运行会报错
> 
> INSERT into emp2(eid, name, deptId, salary) VALUES (NULL,'harry', 20, 6000); -- 主键不能为 空
> 
> ```
>
> 

##  1.1       通过     修改表结构     添加主键(联合主键)          

主键约束不仅可以在创建表的同时创建， 也可以在修改表的时候添加。

> 语法：
>
> create table 表名(
>
> ​	...
>
> );
>
> alter table <表名> add primary key (字段列表/也可以指定多个列);
>
> **注意： 也可以创建联合主键**
>
> ```sql
> create table if not EXISTS mydb1.emp4(
>  eid int,
>   name varchar(20),
>   deptId int,
>   salary double
> );
> 
> alter TABLE emp4 add PRIMARY KEY(eid);
> 
> --  -----------------------------
> 
> create table if not EXISTS mydb1.emp5(
>  eid int,
>   name varchar(20),
>   deptId int,
>   salary double
> );
> 
> alter TABLE emp5 add PRIMARY KEY(name, deptId);
> 
> ```



##  2.0 操作 - 添加联合主键

所谓联合主键，就是这个主键由一张表中多个字段组成。

**注意：**

​	1.**当主键是由多个字段组成时， 不能直接在字段名后面声明主键约束。**

​	2.**一张表只能有一个主键，联合主键也是一个主键。**

### 语法：

> create table 表名 (
>
> ​	...
>
> ​	[constriant <约束名>] primary key （字段1，字段2，..., 字段n）
>
> );
>
> ```sql
> create table emp3(
> 	name varchar(20),
>   deptId int,
>   salary double,
>   primary key(name, deptId)
>   
> );
> 
> -- --------------------------------- 
> CREATE TABLE emp3(
> NAME VARCHAR(20),
> deptId int,
> salary double,
> constraint pk2 PRIMARY KEY(name, deptId)
> 
> );
> 
> -- 联合主键的特点 
> -- 联合主键的各列，每一列都不能为空
> INSERT into emp3 VALUES ('hankin', 10, 5000);
> INSERT into emp3 VALUES ('hankin', 20, 5000);
> INSERT into emp3 VALUES ('hankin', 10, 5000);  -- 会报错, 主键 hankin-10 主键重复
> 
> INSERT into emp3 VALUES (null, 10, 5000);  -- 报错，name不为空
> INSERT into emp3 VALUES ('hello', null, 5000);  -- 报错， deptId 不为空
> 
> ```



##  3.0 操作 - 删除主键

一个表中不需要主键约束时，就需要从表中将其删除。 删除主键约束的方法要比创建主键约束容易的多。

> 格式：
>
> ​	alter atble <数据表名> drop primary key;
>
> ```sql
> -- 删除主键：
> -- 1. 删除单列主键
> ALTER TABLE emp1 drop PRIMARY KEY;
> 
> -- 2.删除多列主键
> ALTER TABLE emp3 DROP PRIMARY KEY;
> ```
>
> 

---



# MySQL 自增长约束

- ### 概念：

  - 在mysql中，当主键定义为自增长后，这个主键的值不再需要用户输入数据，而由数据库系统根据定义自动赋值

  - 通过给字段添加  auto_increment 属性来实现主键自增长。

  - 
  
    > 语法：
    >
    > ​	字段名 数据类型 auto_increment
  
    > 操作：
    >
    > ```sql
    > CREATE TABLE user1(
    > id int PRIMARY KEY auto_increment,
    > name VARCHAR(20)
    > 
    > );
    > INSERT into user1 VALUES(null, 'hhjkhkj');
    > INSERT into user1 VALUES(null, 'aaaa');
    > INSERT into user1(name) VALUES ('asdas');
    > INSERT into user1(name) VALUES ('bbbb');
    > 
    > ```

  - ### 特点：
  
  - > 1. 默认情况下， auto_increment的初始值为1， 字段值自动+1.
    > 2. 一个表中只能有一个字段使用auto_increment约束，且**该字段必须有唯一索引**，以避免序号重复（即为主键或主键的一部分）。
    > 3. auto_increment 约束字段必须具备 not null 属性。
    > 4. auto_increment 约束字段 只能是 整数型类型（tinyint, smallint, int, bigint）
    > 5. auto_increment 约束字段的最大值首该字段的数据类型约束， 如果达到上限,auto_increment就会失效。
    > 5. 和主键一起使用，
    
    ##  指定自增字段的初始值
    
    > 方式1:   创建表的时候指定
    >
    > CREATE TABLE 表名(
    > ... PRIMARY KEY auto_increment,
    > ...
    >
    > ) auto_increment = 100;  -- 初始值100开始 
    > 
    >
    > ```sql
    > CREATE TABLE user2(
    > id int PRIMARY KEY auto_increment,
    > name VARCHAR(20)
    > 
    > ) auto_increment = 100;  -- 初始值100开始 
    > INSERT into user2 VALUES(null, 'hhjkhkj');
    > INSERT into user2 VALUES(null, 'aaaa');
    > INSERT into user2(name) VALUES ('asdas');
    > INSERT into user2(name) VALUES ('bbbb');
    > 
    > ```
    >
    > 
    
    >方式2: 创建表之后指定 alter table 。。。 修改表的操作
    >
    >CREATE TABLE 表名(
    >... PRIMARY KEY auto_increment,
    >...
    >
    >) ;  
    >
    >alter TABLE 表名 auto_increment = 200;  -- 初始值100开始 
    >
    >```sql
    >CREATE TABLE if not EXISTS user3(
    >id int PRIMARY KEY auto_increment,
    >name VARCHAR(20)
    >
    >); 
    >alter TABLE user3 auto_increment = 200;
    >
    >INSERT into user3 VALUES(null, 'hhjkhkj');
    >INSERT into user3 VALUES(null, 'aaaa');
    >```
    
  - ##  delete 和 truncate 在删除后自增列的变化
  
    - delete 数据之后自增长从**断点**开始。（自增长的值会保留，从上次开始增加）
  
    - truncate 数据之后自动增长从**默认值（默认值=1）**开始。（truncate删除表，创建新表，从1开始）
  
    - ```sql
      
      DELETE FROM user1;
      INSERT into user1 VALUES(null, 'hhjkhkj');  --  断点位置 +1
      
      truncate table user1;
      INSERT into user1 VALUES(null, 'hhjkhkj');
      ```
  
      ---

---



# MySQL 非空约束

- ### 概念

  mysql 非空约束（not null）指字段不能为空。对于使用了非空约束的字段， 如果用户在添加数据时没有指定值，系统就会报错

- ### 语法 - 添加非空约束

  > 方式1: <字段名> <数据类型> not null;
  >
  > ```sql
  > -- 方式1: 创建表时指定
  > 
  > use mydb1;
  > 
  > CREATE TABLE if not EXISTS user6(
  > 	id int primary key auto_increment,
  >   name varchar(20) not null,
  >   address varchar(30) not null
  > );
  > 
  > alter TABLE user6 auto_increment = 100;
  > 
  > insert into user6(id, name, address) VALUES (null,'name','asdas');
  > ```
  >
  > 
  >
  > 方式2: alter table 表名  modify 字段 类型 not null;
  >
  > ```sql
  > -- 方式2；创建表之后
  > 
  > CREATE TABLE if not EXISTS user7(
  > 	id int primary key auto_increment,
  >   name varchar(20),
  >   address varchar(30)
  > );
  > 
  > alter table user7 MODIFY name varchar(20) not null;
  > alter table user7 MODIFY address varchar(30) not null;
  > 
  > desc user7;
  > 
  > ```

- ### 删除非空约束

  > alter table 表名 modify 字段 类型
  >
  > ```sql
  > alter table user7 MODIFY name varchar(20) ;
  > alter table user7 MODIFY address varchar(30) ;
  > desc user7;
  > ```

---



#  MySQL 唯一约束（unique）

- ### **概念

  唯一约束（unique key）是指所有记录中字段的值不能重复出现。 例如，为id字段加上唯一约束后，每一条记录的id值都是唯一的， 不能出现重复的情况。

- ### 语法 

  > 方式1: <字段名><数据类型> unqiue;
  >
  > ```sql
  > -- 直接在创建的时候
  > 
  > use mydb1;
  > 
  > CREATE TABLE if not EXISTS user8(
  > 	id int,
  >   name varchar(20) not null,
  >   phone_number VARCHAR(30) UNIQUE
  > );
  > 
  > desc user8;
  > 
  > INSERT into user8 VALUES (1001, 'a', 138);
  > INSERT into user8 VALUES (1002, 'b', 138); --  这个位置会报错， phone number 重复，
  > 
  > -- mysql 中 null和任何值都不相同，甚至和自己都不一样
  > INSERT into user8 VALUES (1003, 'b', null);
  > INSERT into user8 VALUES (1004, 'b', null);
  > 
  > ```
  >
  > 
  >
  > 方式2: alter table 表名 add constraint 约束名 unqiue（列）;
  >
  > ```sql
  > -- 修改表的操作
  > CREATE TABLE if not EXISTS user9(
  > 	id int,
  >   name varchar(20) not null,
  >   phone_number VARCHAR(30)
  > );
  > ALTER table user9 add CONSTRAINT unique_ph UNIQUE(phone_number);
  > desc user9;
  > ```

-  删除唯一约束

  - > #### 格式：
    >
    > ​	ALTER TABLE <表名> drop index <唯一约束名>
    >
    > ```sql
    > ALTER TABLE user8 drop index phone_number;
    > alter table user9 drop index unique_ph;
    > ```
    >
    > 



---

# MySQL 默认约束(default)

- ### 概念

  mysql 默认值约束用来指定某列的默认值

- ### 语法

  > 方式1: <字段名> <数据类型> default <默认值>;
  >
  > ```sql
  > CREATE table if not EXISTS user10(
  > id int,
  > name VARCHAR(20),
  > address VARCHAR(20) DEFAULT 'bejing'  -- 指定默认约束
  > 
  > );
  > desc user10;
  > 
  > INSERT into user10(id,name) VALUES(1001, 'hakn');
  > 
  > INSERT into user10(id,name, address) VALUES(1002, 'aaa', null);
  > 
  > INSERT into user10(id,name, address) VALUES(1003, 'bbb', 'shanghai');
  > ```
  >
  > 

  

  > 方式2: alter table 表名 modify 列名 类型 default 默认值;
  >
  > ```sql
  > 
  > CREATE table if not EXISTS user11(
  > id int,
  > name VARCHAR(20),
  > address VARCHAR(20) 
  > 
  > );
  > 
  > alter TABLE user11 MODIFY address varchar(20) DEFAULT 'shenzhen';
  > INSERT into user11 (id, name) values (1010, 'aaa');
  > ```
  >
  > 

删除默认约束

> 格式： alter table <表名> change column <字段名> <类型> default null;
>
> ```sql
> alter TABLE user11 MODIFY address varchar(20) DEFAULT null;
> INSERT into user11 (id, name) values (1010, 'aaa');
> ```
>
> 



----

# MySQL 零填充约束（zerofill）

- ### 概念

  1.插入数据时，当该字段的值的长度小于定义的长度时，会在该值的前面补上相应的0

  2.zeofill 默认为int(10)

  3.当使用zerofill时，默认会自动加unsined（无符号属性），使用unsigned属性后，数值范围是原值的2倍，例如 有符号为 -128～+127， 无符号为0～256

- ### 操作

- > ```sql
  > CREATE table if not EXISTS user12(
  > id int ZEROFILL,
  > name VARCHAR(20)
  > );
  > INSERT into user12 VALUES(123, 'a');
  > ```

- ### 删除

  > ```sql
  > --  删除约束 
  > alter TABLE user12 MODIFY id int;
  > INSERT into user12 VALUES(123, 'a');
  > ```

























