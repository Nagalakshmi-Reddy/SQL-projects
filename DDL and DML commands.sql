use youtube;

create table course(cid int,
 cname varchar(15),
 primary key(cid));

create table student(sid int,
 sname varchar(10) not null, 
 institute varchar(15) default "MCE Collge",
 cid int,
 Age int,
 gender varchar(10),
 contact int unique,
 primary key(sid),
 foreign key(cid) references course(cid),
 check(Age >= 18));
 
insert into course values(101, "Mech"),
 (102, "CSE"),
 (103, "ECE"),
 (104, "CIVIL"),
 (105, "DATA SCIENCE"),
 (106, "AI");
 
Insert into student(sid, sname, cid, gender, contact)
 values(1, "Pragna", 103, "F", 123456);
 
Insert into student values(2, "Michel", "PHP", 101, 19, "M", 467838),
 (3, "Nikil", "PHP", 105, 20, "M", 648398),
 (4, "Ambika", "MCE", 102, 19, "F", 809245),
 (5, "Preeti", "Geeta", 103, 21, "F", 352057),
 (6, "Abhi", "Geeta", 105, 20, "M", 365741);
 
SELECT * FROM STUDENT;

/* Errors you may get while dealing with constraints*/

insert into student values(7, "Priya", "MCE", 102, 17, "F", 281378);
insert into student values(7, "Priya", "MCE", 102, 18, "F", 365741);
insert into student values(5, "Priya", "MCE", 102, 18, "F", 798579);
insert into student values(7, "Priya", "MCE", 108, 18, "F", 798579);
insert into student(sid, cid) values(8, 104);

/* ALTER QUERY (DDL COMMAND) */
-----------------------------------

/* 1. Add colum to the existing table */
alter table student add perc int;

/* 2. Modify the datatype of existing column */
alter table student modify perc float;

/* 3. Drop column from the table */
alter table student drop contact;

/* 4. Add Unique constraint to the column */
alter table student add email varchar(50);
alter table student add constraint unique(email);

/* 5. Add NOT NULL */
alter table student modify gender varchar(5) not null;

/* 6. Add Constraint CHECK */
alter table student add constraint check(age>16);

/* 7. Add Primary Key */
alter table student add constraint primary key(sid);

/* Add Foreign key */
Alter table student add constraint foreign key(cid) references course(cid);

/* 8. Add default key */
alter table student modify institute varchar(10) default "ABC clg";

/* 9. Drop Primary Key */
alter table student drop primary key;

/* 10. Drop Constraint Unique */
alter table student drop index email;

/* DROP and TRUNCATE Queries*/

truncate table student;
drop table student;

/* UPDATE and DELETE */

Update student set age=20 where sid=1;
Delete from student where sid=5;

/* EXERCISE QUESTIONS - writing query using multiple table without using JOINS */
/* Tables - boats, sailors, reserves */

/* 1. Finding Names of sailors who reserved boat no.3 */
select sname from sailors,reserves where sailors.sid=reserves.sid and bid=3;

/* 2. Finding Names of sailors where reserved RED boat */
select sname from sailors,reserves,boats where sailors.sid=reserves.sid and reserves.bid=boats.bid and boats.color="RED";

/* 3. Finding color of boats reserved by Ron */
select color from boats,reserves,sailors where boats.bid=reserves.bid and reserves.sid=sailors.sid and sailors.sname="Ron";

/* 4. Finding Names of sailors who have reserved atleast one boat */
select distinct sname from sailors,reserves where sailors.sid=reserves.sid;


# DCL commands - Grant, Revoke
# TCL commands - Commit, Rollback



