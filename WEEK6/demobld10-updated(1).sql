Rem  -- Rem是Remark的缩写，用于SQL*Plus中的注释说明
Rem  NAME  "demobldnew.sql" - Drops and then Creates SIX tables for DEMO schema 
Rem  needed for SQL Notes material in Version 9.2
Rem  This set is a SUBSET of tables and data in the HR/HR schema
Rem

-- 连接数据库的两种方式示例（实际使用时需选择一种）
-- CONNECT scott/tiger OR
-- CONNECT demo/demo ( OR any other user that wants to have these tables)

Rem  -- 第一部分：删除现有数据库对象
Rem    This PART of script will drop all SEQUENCES and TABLES related to DEMO schema
Rem

-- 设置SQL*Plus环境参数
SET FEEDBACK 1  -- 显示DML操作影响的行数
SET NUMWIDTH 10  -- 设置数字显示宽度
SET LINESIZE 80  -- 设置每行输出字符数
--SET TRIMSPOOL ON  -- 去除spool文件尾部空格（注释状态）
--SET TAB OFF       -- 用空格代替制表符（注释状态）
SET PAGESIZE 100  -- 设置每页显示行数
SET ECHO OFF      -- 不显示执行的命令

-- 删除序列（sequence）
DROP SEQUENCE location_a_seq;  -- 删除位置表序列
DROP SEQUENCE departments_seq; -- 删除部门表序列
DROP SEQUENCE employees_a_seq;  -- 删除员工表序列

-- 删除表及其约束（CASCADE CONSTRAINTS级联删除依赖约束）
DROP TABLE countries_a CASCADE CONSTRAINTS;  -- 国家表
DROP TABLE location_a CASCADE CONSTRAINTS;   -- 位置表
DROP TABLE departments CASCADE CONSTRAINTS;  -- 部门表
DROP TABLE employees_a   CASCADE CONSTRAINTS;-- 员工表 
DROP TABLE job_grades;    -- 工资等级表
DROP TABLE job_history;   -- 工作历史表


Rem  -- 第二部分：创建新表结构
Rem      This PART of the script creates SIX tables, polulates data, adds associated constraints
Rem      and indexes for the DEMO user.
Rem

-- 重新设置SQL*Plus环境参数
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
--SET TRIMSPOOL ON
--SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF 

REM ********************************************************************
REM 创建国家表（countries_a）用于存储客户和公司位置的国家信息
REM location_a表将通过外键关联此表

Prompt ******  Creating countries_a table ....  -- 在输出中显示进度信息

CREATE TABLE countries_a 
    ( country_id      CHAR(2)       -- 2字符国家代码
       CONSTRAINT  country_id_nn NOT NULL  -- 非空约束
    , country_name    VARCHAR2(40)  -- 国家名称（最大40字符）
    , region_id       NUMBER         -- 地区编号
    , CONSTRAINT     country_c_id_pk 
        	     PRIMARY KEY (country_id)  -- 主键约束
    ) 
    ORGANIZATION INDEX;  -- 索引组织表（IOT）存储方式

REM ********************************************************************
REM 创建位置表（location_a）存储公司部门的地址信息
REM 部门表（DEPARTMENTS）将外键关联此表

Prompt ******  Creating location_a table ....

CREATE TABLE location_a
    ( location_id    NUMBER(4)      -- 4位数字位置ID
    , street_address VARCHAR2(40)   -- 街道地址
    , postal_code    VARCHAR2(12)   -- 邮政编码
    , city       VARCHAR2(30)       -- 城市名称
	CONSTRAINT     loc_city_nn  NOT NULL  -- 城市非空约束
    , state_province VARCHAR2(25)   -- 州/省名称
    , country_id     CHAR(2)        -- 国家代码（外键）
    ) ;

-- 创建唯一索引后添加主键约束（两种方式实现主键）
CREATE UNIQUE INDEX loc_id_pk
ON location_a (location_id) ;

ALTER TABLE location_a
ADD ( CONSTRAINT loc_id_pk
       		 PRIMARY KEY (location_id)
        ) ;

Rem 	-- 为位置表创建序列（sequence）用于自动生成ID
Rem 	Starts with 3300（从3300开始）

CREATE SEQUENCE locations_seq
 START WITH     3300    -- 起始值
 INCREMENT BY   100     -- 每次增加100
 MAXVALUE       9900    -- 最大值
 NOCACHE        -- 不缓存序列值
 NOCYCLE;       -- 不循环使用


REM ********************************************************************
REM Create the DEPARTMENTS table to hold company department information.
REM EMPLOYEES  has a foreign key to this table.

Prompt ******  Creating DEPARTMENTS table ....

CREATE TABLE departments
    ( department_id    NUMBER(4)
    , department_name  VARCHAR2(30)
	CONSTRAINT  dept_name_nn  NOT NULL
    , manager_id       NUMBER(6)
    , location_id      NUMBER(4)
    ) ;

CREATE UNIQUE INDEX dept_id_pk
ON departments (department_id) ;

ALTER TABLE departments
ADD ( CONSTRAINT dept_id_pk
       		 PRIMARY KEY (department_id)
         ) ;

Rem 	Useful for any subsequent addition of rows to departments table
Rem 	Starts with 280 

CREATE SEQUENCE departments_seq
 START WITH     280
 INCREMENT BY   10
 MAXVALUE       9990
 NOCACHE
 NOCYCLE;


REM ********************************************************************
REM Create the EMPLOYEES table to hold the employee personnel 
REM information for the company.
REM EMPLOYEES has a self referencing foreign key to this table.

Prompt ******  Creating EMPLOYEES table ....

CREATE TABLE employees_a
    ( employee_id    NUMBER(6)
    , first_name     VARCHAR2(20)
    , last_name      VARCHAR2(25)
	 CONSTRAINT     emp_last_name_nn  NOT NULL
    , email          VARCHAR2(25)
	CONSTRAINT     emp_email_nn  NOT NULL
    , phone_number   VARCHAR2(20)
    , hire_date      DATE
	CONSTRAINT     emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR2(10)
	CONSTRAINT     emp_job_nn  NOT NULL
    , salary         NUMBER(8,2)
    , commission_pct NUMBER(2,2)
    , manager_id     NUMBER(6)
    , department_id  NUMBER(4)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    ) ;

CREATE UNIQUE INDEX emp_emp_id_pk
ON employees_a (employee_id) ;


ALTER TABLE employees_a
ADD ( CONSTRAINT     emp_emp_id_pk
                     PRIMARY KEY (employee_id)
    , CONSTRAINT     emp_dept_fk
                     FOREIGN KEY (department_id)
                      REFERENCES departments
    , CONSTRAINT     emp_manager_fk
                     FOREIGN KEY (manager_id)
                      REFERENCES employees_a
    ) ;

ALTER TABLE departments
ADD ( CONSTRAINT dept_mgr_fk
      		 FOREIGN KEY (manager_id)
      		  REFERENCES employees_a (employee_id)
    ) ;


Rem 	Useful for any subsequent addition of rows to employees_a table
Rem 	Starts with 207 


CREATE SEQUENCE employees_a_seq
 START WITH     207
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;


REM ********************************************************************
REM Create the JOB_GRADES table that will show different SALARY GRADES 
REM depending on employee's SALARY RANGE

Prompt ******  Creating JOB_GRADES table ....

CREATE TABLE job_grades (
grade 		CHAR(1),
lowest_sal 	NUMBER(8,2) NOT NULL,
highest_sal	NUMBER(8,2) NOT NULL
);

ALTER TABLE job_grades
ADD CONSTRAINT jobgrades_grade_pk PRIMARY KEY (grade);


rem This PART of script will populate script for the DEMO account
rem
rem NOTES There is a circular foreign key reference between 
rem       employees_a and DEPARTMENTS. That's why we disable
rem       the FK constraints here
rem

SET VERIFY OFF

REM ***************************insert data into the COUNTRIES table

Prompt ******  Populating COUNTIRES table ....

INSERT INTO countries_a VALUES 
        ( 'IT'
        , 'Italy'
        , 1 
        );

INSERT INTO countries_a VALUES 
        ( 'JP'
        , 'Japan'
	, 3 
        );

INSERT INTO countries_a VALUES 
        ( 'US'
        , 'United States of America'
        , 2 
        );

INSERT INTO countries_a VALUES 
        ( 'CA'
        , 'Canada'
        , 2 
        );

INSERT INTO countries_a VALUES 
        ( 'CN'
        , 'China'
        , 3 
        );

INSERT INTO countries_a VALUES 
        ( 'IN'
        , 'India'
        , 3 
        );

INSERT INTO countries_a VALUES 
        ( 'AU'
        , 'Australia'
        , 3 
        );

INSERT INTO countries_a VALUES 
        ( 'ZW'
        , 'Zimbabwe'
        , 4 
        );

INSERT INTO countries_a VALUES 
        ( 'SG'
        , 'Singapore'
        , 3 
        );

INSERT INTO countries_a VALUES 
        ( 'UK'
        , 'United Kingdom'
        , 1 
        );

INSERT INTO countries_a VALUES 
        ( 'FR'
        , 'France'
        , 1 
        );

INSERT INTO countries_a VALUES 
        ( 'DE'
        , 'Germany'
        , 1 
        );

INSERT INTO countries_a VALUES 
        ( 'ZM'
        , 'Zambia'
        , 4 
        );

INSERT INTO countries_a VALUES 
        ( 'EG'
        , 'Egypt'
        , 4 
        );

INSERT INTO countries_a VALUES 
        ( 'BR'
        , 'Brazil'
        , 2 
        );

INSERT INTO countries_a VALUES 
        ( 'CH'
        , 'Switzerland'
        , 1 
        );

INSERT INTO countries_a VALUES 
        ( 'NL'
        , 'Netherlands'
        , 1 
        );

INSERT INTO countries_a VALUES 
        ( 'MX'
        , 'Mexico'
        , 2 
        );

INSERT INTO countries_a VALUES 
        ( 'KW'
        , 'Kuwait'
        , 4 
        );

INSERT INTO countries_a VALUES 
        ( 'IL'
        , 'Israel'
        , 4 
        );

INSERT INTO countries_a VALUES 
        ( 'DK'
        , 'Denmark'
        , 1 
        );

INSERT INTO countries_a VALUES 
        ( 'HK'
        , 'HongKong'
        , 3 
        );

INSERT INTO countries_a VALUES 
        ( 'NG'
        , 'Nigeria'
        , 4 
        );

INSERT INTO countries_a VALUES 
        ( 'AR'
        , 'Argentina'
        , 2 
        );

INSERT INTO countries_a VALUES 
        ( 'BE'
        , 'Belgium'
        , 1 
        );


REM ***************************insert data into the location_a table

Prompt ******  Populating location_a table ....

INSERT INTO location_a VALUES 
        ( 1000 
        , '1297 Via Cola di Rie'
        , '00989'
        , 'Roma'
        , NULL
        , 'IT'
        );

INSERT INTO location_a VALUES 
        ( 1100 
        , '93091 Calle della Testa'
        , '10934'
        , 'Venice'
        , NULL
        , 'IT'
        );

INSERT INTO location_a VALUES 
        ( 1200 
        , '2017 Shinjuku-ku'
        , '1689'
        , 'Tokyo'
        , 'Tokyo Prefecture'
        , 'JP'
        );

INSERT INTO location_a VALUES 
        ( 1300 
        , '9450 Kamiya-cho'
        , '6823'
        , 'Hiroshima'
        , NULL
        , 'JP'
        );

INSERT INTO location_a VALUES 
        ( 1400 
        , '2014 Jabberwocky Rd'
        , '26192'
        , 'Southlake'
        , 'Texas'
        , 'US'
        );

INSERT INTO location_a VALUES 
        ( 1500 
        , '2011 Interiors Blvd'
        , '99236'
        , 'South San Francisco'
        , 'California'
        , 'US'
        );

INSERT INTO location_a VALUES 
        ( 1600 
        , '2007 Zagora St'
        , '50090'
        , 'South Brunswick'
        , 'New Jersey'
        , 'US'
        );

INSERT INTO location_a VALUES 
        ( 1700 
        , '2004 Charade Rd'
        , '98199'
        , 'Seattle'
        , 'Washington'
        , 'US'
        );

INSERT INTO location_a VALUES 
        ( 1800 
        , '147 Spadina Ave'
        , 'M5V 2L7'
        , 'Toronto'
        , 'Ontario'
        , 'CA'
        );

INSERT INTO location_a VALUES 
        ( 1900 
        , '6092 Boxwood St'
        , 'YSW 9T2'
        , 'Whitehorse'
        , 'Yukon'
        , 'CA'
        );

INSERT INTO location_a VALUES 
        ( 2000 
        , '40-5-12 Laogianggen'
        , '190518'
        , 'Beijing'
        , NULL
        , 'CN'
        );

INSERT INTO location_a VALUES 
        ( 2100 
        , '1298 Vileparle (E)'
        , '490231'
        , 'Bombay'
        , 'Maharashtra'
        , 'IN'
        );

INSERT INTO location_a VALUES 
        ( 2200 
        , '12-98 Victoria Street'
        , '2901'
        , 'Sydney'
        , 'New South Wales'
        , 'AU'
        );

INSERT INTO location_a VALUES 
        ( 2300 
        , '198 Clementi North'
        , '540198'
        , 'Singapore'
        , NULL
        , 'SG'
        );

INSERT INTO location_a VALUES 
        ( 2400 
        , '8204 Arthur St'
        , NULL
        , 'London'
        , NULL
        , 'UK'
        );

INSERT INTO location_a VALUES 
        ( 2500 
        , 'Magdalen Centre, The Oxford Science Park'
        , 'OX9 9ZB'
        , 'Oxford'
        , 'Oxford'
        , 'UK'
        );

INSERT INTO location_a VALUES 
        ( 2600 
        , '9702 Chester Road'
        , '09629850293'
        , 'Stretford'
        , 'Manchester'
        , 'UK'
        );

INSERT INTO location_a VALUES 
        ( 2700 
        , 'Schwanthalerstr. 7031'
        , '80925'
        , 'Munich'
        , 'Bavaria'
        , 'DE'
        );

INSERT INTO location_a VALUES 
        ( 2800 
        , 'Rua Frei Caneca 1360 '
        , '01307-002'
        , 'Sao Paulo'
        , 'Sao Paulo'
        , 'BR'
        );

INSERT INTO location_a VALUES 
        ( 2900 
        , '20 Rue des Corps-Saints'
        , '1730'
        , 'Geneva'
        , 'Geneve'
        , 'CH'
        );

INSERT INTO location_a VALUES 
        ( 3000 
        , 'Murtenstrasse 921'
        , '3095'
        , 'Bern'
        , 'BE'
        , 'CH'
        );

INSERT INTO location_a VALUES 
        ( 3100 
        , 'Pieter Breughelstraat 837'
        , '3029SK'
        , 'Utrecht'
        , 'Utrecht'
        , 'NL'
        );

INSERT INTO location_a VALUES 
        ( 3200 
        , 'Mariano Escobedo 9991'
        , '11932'
        , 'Mexico City'
        , 'Distrito Federal,'
        , 'MX'
        );


REM ****************************insert data into the DEPARTMENTS table

Prompt ******  Populating DEPARTMENTS table ....

REM disable integrity constraint to employees_a to load data

ALTER TABLE departments 
  DISABLE CONSTRAINT dept_mgr_fk;

INSERT INTO departments VALUES 
        ( 10
        , 'Administration'
        , 200
        , 1700
        );

INSERT INTO departments VALUES 
        ( 20
        , 'Marketing'
        , 201
        , 1800
        );
                                
INSERT INTO departments VALUES 
        ( 50
        , 'Shipping'
        , 124
        , 1500
        );
                
INSERT INTO departments VALUES 
        ( 60 
        , 'IT'
        , 103
        , 1400
        );
                              
INSERT INTO departments VALUES 
        ( 80 
        , 'Sales'
        , 149
        , 2500
        );
                
INSERT INTO departments VALUES 
        ( 90 
        , 'Executive'
        , 100
        , 1700
        );
               
INSERT INTO departments VALUES 
        ( 110 
        , 'Accounting'
        , 205
        , 1700
        );

INSERT INTO departments VALUES 
        ( 190 
        , 'Contracting'
        , NULL
        , 1700
        );

REM ***************************insert data into the employees_a table

Prompt ******  Populating employees_a table ....

INSERT INTO employees_a VALUES 
        ( 100
        , 'Steven'
        , 'King'
        , 'SKING'
        , '515.123.4567'
        , TO_DATE('17-JUN-1987', 'dd-MON-yyyy')
        , 'AD_PRES'
        , 24000
        , NULL
        , NULL
        , 90
        );

INSERT INTO employees_a VALUES 
        ( 101
        , 'Neena'
        , 'Kochhar'
        , 'NKOCHHAR'
        , '515.123.4568'
        , TO_DATE('21-SEP-1989', 'dd-MON-yyyy')
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        );

INSERT INTO employees_a VALUES 
        ( 102
        , 'Lex'
        , 'De Haan'
        , 'LDEHAAN'
        , '515.123.4569'
        , TO_DATE('13-JAN-1993', 'dd-MON-yyyy')
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        );

INSERT INTO employees_a VALUES 
        ( 103
        , 'Alexander'
        , 'Hunold'
        , 'AHUNOLD'
        , '590.423.4567'
        , TO_DATE('03-JAN-1990', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 9000
        , NULL
        , 102
        , 60
        );

INSERT INTO employees_a VALUES 
        ( 104
        , 'Bruce'
        , 'Ernst'
        , 'BERNST'
        , '590.423.4568'
        , TO_DATE('21-MAY-1991', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 6000
        , NULL
        , 103
        , 60
        );

INSERT INTO employees_a VALUES 
        ( 107
        , 'Diana'
        , 'Lorentz'
        , 'DLORENTZ'
        , '590.423.5567'
        , TO_DATE('07-FEB-1999', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 4200
        , NULL
        , 103
        , 60
        );

INSERT INTO employees_a VALUES 
        ( 124
        , 'Kevin'
        , 'Mourgos'
        , 'KMOURGOS'
        , '650.123.5234'
        , TO_DATE('16-NOV-1999', 'dd-MON-yyyy')
        , 'ST_MAN'
        , 5800
        , NULL
        , 100
        , 50
        );

INSERT INTO employees_a VALUES 
        ( 141
        , 'Trenna'
        , 'Rajs'
        , 'TRAJS'
        , '650.121.8009'
        , TO_DATE('17-OCT-1995', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 3500
        , NULL
        , 124
        , 50
        );

INSERT INTO employees_a VALUES 
        ( 142
        , 'Curtis'
        , 'Davies'
        , 'CDAVIES'
        , '650.121.2994'
        , TO_DATE('29-JAN-1997', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 3100
        , NULL
        , 124
        , 50
        );

INSERT INTO employees_a VALUES 
        ( 143
        , 'Randall'
        , 'Matos'
        , 'RMATOS'
        , '650.121.2874'
        , TO_DATE('15-MAR-1998', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 2600
        , NULL
        , 124
        , 50
        );

INSERT INTO employees_a VALUES 
        ( 144
        , 'Peter'
        , 'Vargas'
        , 'PVARGAS'
        , '650.121.2004'
        , TO_DATE('09-JUL-1998', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 2500
        , NULL
        , 124
        , 50
        );

INSERT INTO employees_a VALUES 
        ( 149
        , 'Eleni'
        , 'Zlotkey'
        , 'EZLOTKEY'
        , '011.44.1344.429018'
        , TO_DATE('29-JAN-2000', 'dd-MON-yyyy')
        , 'SA_MAN'
        , 10500
        , .2
        , 100
        , 80
        );

INSERT INTO employees_a VALUES 
        ( 174
        , 'Ellen'
        , 'Abel'
        , 'EABEL'
        , '011.44.1644.429267'
        , TO_DATE('11-MAY-1996', 'dd-MON-yyyy')
        , 'SA_REP'
        , 11000
        , .30
        , 149
        , 80
        );

INSERT INTO employees_a VALUES 
        ( 176
        , 'Jonathon'
        , 'Taylor'
        , 'JTAYLOR'
        , '011.44.1644.429265'
        , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
        , 'SA_REP'
        , 8600
        , .20
        , 149
        , 80
        );

INSERT INTO employees_a VALUES 
        ( 178
        , 'Kimberely'
        , 'Grant'
        , 'KGRANT'
        , '011.44.1644.429263'
        , TO_DATE('24-MAY-1999', 'dd-MON-yyyy')
        , 'SA_REP'
        , 7000
        , .15
        , 149
        , NULL
        );

INSERT INTO employees_a VALUES 
        ( 200
        , 'Jennifer'
        , 'Whalen'
        , 'JWHALEN'
        , '515.123.4444'
        , TO_DATE('17-SEP-1987', 'dd-MON-yyyy')
        , 'AD_ASST'
        , 4400
        , NULL
        , 101
        , 10
        );

INSERT INTO employees_a VALUES 
        ( 201
        , 'Michael'
        , 'Hartstein'
        , 'MHARTSTE'
        , '515.123.5555'
        , TO_DATE('17-FEB-1996', 'dd-MON-yyyy')
        , 'MK_MAN'
        , 13000
        , NULL
        , 100
        , 20
        );

INSERT INTO employees_a VALUES 
        ( 202
        , 'Pat'
        , 'Fay'
        , 'PFAY'
        , '603.123.6666'
        , TO_DATE('17-AUG-1997', 'dd-MON-yyyy')
        , 'MK_REP'
        , 6000
        , NULL
        , 201
        , 20
        );

INSERT INTO employees_a VALUES 
        ( 205
        , 'Shelley'
        , 'Higgins'
        , 'SHIGGINS'
        , '515.123.8080'
        , TO_DATE('07-JUN-1994', 'dd-MON-yyyy')
        , 'AC_MGR'
        , 12000
        , NULL
        , 101
        , 110
        );

INSERT INTO employees_a VALUES 
        ( 206
        , 'William'
        , 'Gietz'
        , 'WGIETZ'
        , '515.123.8181'
        , TO_DATE('07-JUN-1994', 'dd-MON-yyyy')
        , 'AC_ACCOUNT'
        , 8300
        , NULL
        , 205
        , 110
        );

REM ***************************insert data into the JOB_GRADES table

Prompt ******  Populating JOB_GRADES table ....

INSERT INTO job_grades VALUES 
	('A'
	,1000
	,2999
	);

INSERT INTO job_grades VALUES 
	('B'
	,3000
	,5999
	);

INSERT INTO job_grades VALUES 
	('C'
	,6000
	,9999
	);

INSERT INTO job_grades VALUES 
	('D'
	,10000
	,14999
	);

INSERT INTO job_grades VALUES 
	('E'
	,15000
	,24999
	);

INSERT INTO job_grades VALUES 
	('F'
	,25000
	,40000
	);

COMMIT;

REM enable integrity constraint to DEPARTMENTS

ALTER TABLE departments 
  ENABLE CONSTRAINT dept_mgr_fk;


REM  Creating table JOB_HISTORY and populating data

Prompt ******  Creating JOB_HISTORY table ....

CREATE TABLE job_history
    ( employee_id   NUMBER(6)
	 CONSTRAINT    jhist_employee_nn  NOT NULL
    , start_date    DATE
	CONSTRAINT    jhist_start_date_nn  NOT NULL
    , end_date      DATE
	CONSTRAINT    jhist_end_date_nn  NOT NULL
    , job_id        VARCHAR2(10)
	CONSTRAINT    jhist_job_nn  NOT NULL
    , department_id NUMBER(4)
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    ) ;

CREATE UNIQUE INDEX jhist_emp_id_st_date_pk 
ON job_history (employee_id, start_date) ;

ALTER TABLE job_history
ADD ( CONSTRAINT jhist_emp_id_st_date_pk
      PRIMARY KEY (employee_id, start_date)
      , CONSTRAINT     jhist_dept_fk
                     FOREIGN KEY (department_id)
                     REFERENCES departments
    ) ;

Prompt ******  Populating JOB_HISTORY table ....


INSERT INTO job_history
VALUES (102
       , TO_DATE('13-JAN-1993', 'dd-MON-yyyy')
       , TO_DATE('24-JUL-1998', 'dd-MON-yyyy')
       , 'IT_PROG'
       , 60);

INSERT INTO job_history
VALUES (101
       , TO_DATE('21-SEP-1989', 'dd-MON-yyyy')
       , TO_DATE('27-OCT-1993', 'dd-MON-yyyy')
       , 'AC_ACCOUNT'
       , 110);

INSERT INTO job_history
VALUES (101
       , TO_DATE('28-OCT-1993', 'dd-MON-yyyy')
       , TO_DATE('15-MAR-1997', 'dd-MON-yyyy')
       , 'AC_MGR'
       , 110);

INSERT INTO job_history
VALUES (201
       , TO_DATE('17-FEB-1996', 'dd-MON-yyyy')
       , TO_DATE('19-DEC-1999', 'dd-MON-yyyy')
       , 'MK_REP'
       , 20);

INSERT INTO job_history
VALUES  (114
        , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1999', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 50
        );

INSERT INTO job_history
VALUES  (122
        , TO_DATE('01-JAN-1999', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1999', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 50
        );

INSERT INTO job_history
VALUES  (200
        , TO_DATE('17-SEP-1987', 'dd-MON-yyyy')
        , TO_DATE('17-JUN-1993', 'dd-MON-yyyy')
        , 'AD_ASST'
        , 90
        );

INSERT INTO job_history
VALUES  (176
        , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1998', 'dd-MON-yyyy')
        , 'SA_REP'
        , 80
        );

INSERT INTO job_history
VALUES  (176
        , TO_DATE('01-JAN-1999', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1999', 'dd-MON-yyyy')
        , 'SA_MAN'
        , 80
        );

INSERT INTO job_history
VALUES  (200
        , TO_DATE('01-JUL-1994', 'dd-MON-yyyy')
        , TO_DATE('31-DEC-1998', 'dd-MON-yyyy')
        , 'AC_ACCOUNT'
        , 90
        );

COMMIT;

Rem
Rem    This PART will create indexes for DEMO schema
Rem

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
--SET TRIMSPOOL ON
--SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF 

CREATE INDEX emp_department_ix
       ON employees_a (department_id);

CREATE INDEX emp_job_ix
       ON employees_a (job_id);

CREATE INDEX emp_manager_ix
       ON employees_a (manager_id);

CREATE INDEX emp_name_ix
       ON employees_a (last_name, first_name);

CREATE INDEX dept_location_ix
       ON departments (location_id);

CREATE INDEX loc_city_ix
       ON location_a (city);

CREATE INDEX loc_state_province_ix	
       ON location_a (state_province);

CREATE INDEX loc_country_ix
       ON location_a (country_id);

Rem
Rem    This PART will create comments for DEMO schema
Rem

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
--SET TRIMSPOOL ON
--SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF 

REM *********************************************

COMMENT ON TABLE countries_a
IS 'country table. Contains 25 rows. References with location_a table.';

COMMENT ON COLUMN countries_a.country_id
IS 'Primary key of countries_a table.';

COMMENT ON COLUMN countries_a.country_name
IS 'Country name';

COMMENT ON COLUMN countries_a.region_id
IS 'Region ID for the country'; 

REM *********************************************

COMMENT ON TABLE location_a
IS 'location_a table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
location_a of customers. Contains 23 rows; references with the
departments and countries_a tables. ';

COMMENT ON COLUMN location_a.location_id
IS 'Primary key of location_a table';

COMMENT ON COLUMN location_a.street_address
IS 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';

COMMENT ON COLUMN location_a.postal_code
IS 'Postal code of the location of an office, warehouse, or production site 
of a company. ';

COMMENT ON COLUMN location_a.city
IS 'A not null column that shows city where an office, warehouse, or 
production site of a company is located. ';

COMMENT ON COLUMN location_a.state_province
IS 'State or Province where an office, warehouse, or production site of a 
company is located.';

COMMENT ON COLUMN location_a.country_id
IS 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries_a table.';


REM *********************************************

COMMENT ON TABLE departments
IS 'Departments table that shows details of departments where employees_a 
work. Contains 27 rows; references with location_a, employees_a, and job_history tables.';

COMMENT ON COLUMN departments.department_id
IS 'Primary key column of departments table.';

COMMENT ON COLUMN departments.department_name
IS 'A not null column that shows name of a department. Administration, 
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public 
Relations, Sales, Finance, and Accounting. ';

COMMENT ON COLUMN departments.manager_id
IS 'Manager_id of a department. Foreign key to employee_id column of employees_a table. The manager_id column of the employee table references this column.';

COMMENT ON COLUMN departments.location_id
IS 'Location id where a department is located. Foreign key to location_id column of location_a table.';


REM *********************************************

COMMENT ON TABLE employees_a
IS 'employees_a table. Contains 107 rows. References with departments, 
jobs, job_history tables. Contains a self reference.';

COMMENT ON COLUMN employees_a.employee_id
IS 'Primary key of employees_a table.';

COMMENT ON COLUMN employees_a.first_name
IS 'First name of the employee. A not null column.';

COMMENT ON COLUMN employees_a.last_name
IS 'Last name of the employee. A not null column.';

COMMENT ON COLUMN employees_a.email
IS 'Email id of the employee';

COMMENT ON COLUMN employees_a.phone_number
IS 'Phone number of the employee; includes country code and area code';

COMMENT ON COLUMN employees_a.hire_date
IS 'Date when the employee started on this job. A not null column.';

COMMENT ON COLUMN employees_a.job_id
IS 'Current job of the employee; foreign key to job_id column of the 
jobs table. A not null column.';

COMMENT ON COLUMN employees_a.salary
IS 'Monthly salary of the employee. Must be greater 
than zero (enforced by constraint emp_salary_min)';

COMMENT ON COLUMN employees_a.commission_pct
IS 'Commission percentage of the employee; Only employees_a in sales 
department elgible for commission percentage';

COMMENT ON COLUMN employees_a.manager_id
IS 'Manager id of the employee; has same domain as manager_id in 
departments table. Foreign key to employee_id column of employees_a table.
(useful for reflexive joins and CONNECT BY query)';

COMMENT ON COLUMN employees_a.department_id
IS 'Department id where employee works; foreign key to department_id 
column of the departments table';

COMMIT;