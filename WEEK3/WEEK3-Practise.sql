DESC customers;

-- % 表示任意字符，_ 表示单个字符
SELECT customername
FROM customers
WHERE customername like '%Co.' OR customername like '_o%Co.';

SELECT customerName, state 
FROM customers
WHERE state IN ('CA', 'NY', 'TX');

SELECT customerName, creditLimit
FROM customers
WHERE creditLimit BETWEEN 100000 AND 200000; -- eqt WHERE creditLimit >= 100000 AND creditLimit <= 200000;

SELECT orderdate, status
FROM orders
WHERE EXTRACT(year FROM orderdate) = 2005;
SELECT orderdate, status
FROM orders
WHERE orderdate BETWEEN '01-JAN-05' AND '31-DEC-05'; -- 性能更优

-- to_char() 格式化日期和数字
SELECT to_char(orderdate, 'Month ddth, YYYY'), status
FROM orders
WHERE orderdate like '%05';
SELECT to_char(orderdate, 'Month ddth, YYYY') AS "Formatted date", status
FROM orders
WHERE orderdate like '%05';

-- SUBSTR() 截取字符串
SELECT lastname, SUBSTR(lastname, 4) AS "Last Name"
FROM employees;

SELECT INSTR('HELLO WORLD', 'W')
FROM DUAL;

SELECT LPAD(, 10, '*')
SELECT RPAD(, 10, '*')
SELECT TRIM(lastname, 'a')
SELECT REPLACE(lastname, 'a', 'A')
SELECT ROUND(123.456, 2)
WHERE ROWNUM <= 5;

-- DDL 数据定义语言 
DROP TABLE CUS_COPY; --永久删除
ROLLBACK; --undo the 
COMMIT; -- 提交

CREATE TABLE CUS_COPY AS SELECT * FROM customers
WHERE 'a' = 'b'; -- 创建表
SELECT * FROM CUS_COPY;

INSERT INTO CUS_COPY VALUES ('John Doe', 'Doe', 'John', '1234567890', '123 Main St', 'Anytown', 'CA', '12345', 'USA');
UPDATE CUS_COPY SET customerName = 'Jane Doe' WHERE customerName = 'John Doe';
