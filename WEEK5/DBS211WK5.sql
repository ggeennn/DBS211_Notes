--column level
Create table student
(stid number(9) primary key,
lastname varchar(35),
fitrstname varchar(35) not null,
email varchar(45) not null unique
);
drop table student;
--table level
Create table student
(stid number(9),
lastname varchar(35),
fitrstname varchar(35) not null,
email varchar(45) not null unique,
primary key (stid)
);
SELECT * FROM STUDENT;
DESC STUDENT;
ALTER TABLE STUDENT ADD PHONE NUMBER(10);
ALTER table student drop constraint SYS_C002363069;

ALTER TABLE STUDENT ADD CONSTRAINT STID_PK PRIMARY KEY (STID);
CREATE TABLE COURSE
(COURSEID CHAR(6) CONSTRAINT CRS_ID_PK PRIMARY KEY,
COURSE_NAME VARCHAR(40) NOT NULL
);

CREATE TABLE ENROLL
(COURSEID CHAR(6) REFERENCES COURSE,
STID NUMBER(9),
GRADE CHAR(1),
CONSTRAINT STID_CRSID_PK PRIMARY KEY (COURSEID, STID)
);
CREATE TABLE ENROLL
(COURSEID CHAR(6)CONSTRAINT CRSID_FK REFERENCES COURSE,
STID NUMBER(9) REFERENCES STUDENT,
GRADE CHAR(1),
CONSTRAINT STID_CRSID_PK PRIMARY KEY (COURSEID, STID)
);
INSERT  INTO STUDENT VALUES (123, 'Kim', 'Jane', 'Kjane', 4164567777);
INSERT  INTO STUDENT VALUES (124, 'Allan', 'Ian', 'Aian', 6476567777);
INSERT  INTO STUDENT VALUES (125, 'Julia', 'Brad', 'Jbrad', 4162228888);
INSERT  INTO STUDENT VALUES (126, 'Mani', 'Ryan', 'Mryan', 6478769999);
select * from student;
desc student;
insert into student (stid, fitrstname, email)values (127, 'Mohan', 'Mrajan');
insert into course values ('DBS211', 'Database Design');
insert into course values ('OOP244', 'C++');
insert into enroll values ('DBS211', 123, 'A');           
insert into enroll values ('OOP244', 123,'B'); 
insert into enroll values ('DBS211',124, 'A'); 
insert into enroll values ( 'OOP244', 124,'A'); 
insert into enroll values ( 'DBS211', 125,'A'); 
insert into enroll values ('DBS211',126, 'A'); 
select * from enroll;
desc enroll;
select * from course;
DROP TABLE ENROLL;
ALTER TABLE STUDENT ADD CONSTRAINT STID_FK FOREIGN KEY (STID) REFERENCES STUDENT;
ALTER TABLE STUDENT DROP CONSTRAINT STID_FK;
ALTER TABLE ENROLL ADD CONSTRAINT STID_FK FOREIGN KEY (STID) REFERENCES STUDENT;
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'ENROLL';

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'STUDENT';
-- Display student name, course name and the student's grade
--What is the difference between Truncate and delete?
ALTER TABLE STUDENT RENAME COLUMN FITRSTNAME TO FIRSTNAME;
SELECT FIRSTNAME || ' ' || LASTNAME, COURSE_NAME, GRADE
FROM STUDENT S JOIN ENROLL E
ON S.STID = E.STID
JOIN COURSE C
ON C.COURSEID = E.COURSEID;
ALTER TABLE ENROLL ADD CONSTRAINT GRADE_CK CHECK (GRADE IN ('A','B', 'C','D', 'F'));
DESC STUDENT;
ALTER TABLE STUDENT MODIFY (LASTNAME VARCHAR2(40));
