--Student and course relationship
--they have many to many relationship
-- we need a bridge table-- enroll
-- default constraint names -- Sys_Cn
-- what is the differnce between unique and primary key constraints
-- column level constraint given write after column
CREATE TABLE student
(stid number(9) primary key,
lasname varchar2(30) not null,
firstname varchar2(30) not null,
email varchar2(35) not null unique
);
DESC STUDENT;
ALTER TABLE STUDENT MODIFY (LASNAME VARCHAR2(40));
create table course
(course_id char(6) PRIMARY KEY,
coursename varchar2(45) not null
);

-- COMPOSITE pk IS ALWAYS AT TABLE LEVEL
--SYS_C001605407 Sys_Cn
CREATE TABLE ENROLL
(STID NUMBER(9) REFERENCES STUDENT(STID) ON DELETE CASCADE ,
COURSEID CHAR(6) REFERENCES COURSE ON DELETE CASCADE,
CONSTRAINT STID_CRSID_PK PRIMARY KEY(STID, COURSEID)
);

DROP TABLE ENROLL;
DESC ENROLL;
DESC STUDENT;
ALTER TABLE STUDENT ADD DOB DATE DEFAULT SYSDATE;
ALTER TABLE ENROLL ADD (GRADE CHAR(1));
ALTER TABLE ENROLL DROP COLUMN GRADE;

ALTER TABLE ENROLL ADD CONSTRAINT CRSID_FK FOREIGN KEY (COURSEID) REFERENCES COURSE;
ALTER TABLE ENROLL DROP CONSTRAINT SYS_C001605407;
ALTER TABLE STUDENT DROP CONSTRAINT STID_FK;
ALTER TABLE ENROLL DROP PRIMARY KEY;
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('STUDENT', 'COURSE', 'ENROLL');
SELECT * FROM STUDENT;
SELECT * FROM COURSE;
SELECT * FROM ENROLL;
ALTER TABLE ENROLL ADD CONSTRAINT STID_CRS_ID_PK PRIMARY KEY(STID,COURSEID);
ALTER TABLE ENROLL ADD GRADE CHAR(1);
ALTER TABLE ENROLL ADD CONSTRAINT GRADE_ck CHECK(GRADE IN ('A', 'B','C','D', 'F'));
DELETE FROM STUDENT WHERE STID = 123;

ALTER TABLE STUDENT ADD MARKS NUMBER(3);
DESC STUDENT;
ALTER TABLE STUDENT MODIFY MARKS DEFAULT ON NULL 0;
UPDATE STUDENT SET MARKS = 99 WHERE STID =123;
UPDATE STUDENT SET MARKS = 100 WHERE STID =124;
UPDATE STUDENT SET MARKS = 99 WHERE STID =125;
UPDATE STUDENT SET MARKS = 100 WHERE STID =126;

DELETE FROM ENROLL WHERE STID = 123;
DELETE FROM STUDENT WHERE STID = 123;
SELECT * FROM STUDENT;
INSERT INTO STUDENT (STID, LASNAME,FIRSTNAME,EMAIL) VALUES(123, 'John', 'Taylor', 'Jtaylor');
INSERT INTO STUDENT VALUES(124, 'Jim', 'Lu', 'Jlu');
INSERT INTO STUDENT VALUES(125, 'Laura', 'Windsor', 'Lwindsor');
INSERT INTO STUDENT VALUES(126, 'Andy', 'Kin', 'Akin');

insert into course values ('DBS211', 'Database');
insert into course values('OOP244', 'C++');

INSERT INTO ENROLL VALUES (123, 'DBS211', 'E');
INSERT INTO ENROLL VALUES (123, 'OOP244', 'B');
INSERT INTO ENROLL VALUES (124, 'DBS211', 'A');
INSERT INTO ENROLL VALUES (124, 'OOP244', 'B');
INSERT INTO ENROLL VALUES (125, 'DBS211', 'A');
INSERT INTO ENROLL VALUES (125, 'OOP244', 'B');

rollback;
commit;
delete from student;
select * from student;
select * from enroll;
rollback;
update enroll set grade ='C' where stid = 124;
truncate table enroll;
