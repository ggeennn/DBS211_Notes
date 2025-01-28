# Week 3 SQL DML (Data Manipulation Language)

## 1. 基础查询操作 (Basic Query Operations) 📝

### 1.1 SELECT 语句基础 (SELECT Statement Basics) 难度标记: 🟢
- **定义** | Definition
  - 用于查询数据库中的数据。
  - Used to query data in the database.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT * FROM customers;
    ```
    这个查询将返回客户表中的所有记录。

### 1.2 排序和去重 (Sorting and Distinct) 难度标记: 🟢
#### 排序 (ASC & DESC)
- **ASC**: 升序排列 (Ascending Order)
- **DESC**: 降序排列 (Descending Order)
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT product_name FROM products ORDER BY price ASC;
    ```
    这个查询将按价格升序排列产品名称。

#### DISTINCT 关键字
- **定义** | Definition
  - `DISTINCT` 关键字用于返回唯一的值。
  - The `DISTINCT` keyword is used to return unique values.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT DISTINCT department_id FROM employees;
    ```

### 1.3 模式匹配和通配符 (Pattern Matching and Wildcards) 难度标记: 🟢
#### 通配符 (Wildcard)
- **定义** | Definition
  - 允许用户匹配包含特定字母的字段。
  - Allows users to match fields that contain certain letters.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT * FROM customers WHERE customer_name LIKE 'A%';
    ```

#### LIKE 操作符
- **定义** | Definition
  - `LIKE` 运算符用于在 SQL 中进行模式匹配。
  - The `LIKE` operator is used for pattern matching in SQL.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT * FROM customers WHERE customer_name LIKE 'A%';  -- 以"A"开头的客户名称
    SELECT * FROM customers WHERE customer_name LIKE '%son';  -- 以"son"结尾的客户名称
    SELECT * FROM customers WHERE customer_name LIKE '_a%';   -- 第二个字符为"a"的客户名称
    ```

## 2. 数据分组和聚合 (Data Grouping and Aggregation) 📊

### 2.1 聚合函数 (Aggregate Functions) 难度标记: 🟢
- **定义** | Definition
  - 返回汇总值的函数。
  - A function that returns summary values.
- **示例** | Example
  - `SUM()`, `AVG()`, `COUNT()`
  - 实际应用场景：计算总销售额、平均分数等。
  - **示例代码**:
    ```sql
    SELECT SUM(sales_amount) AS total_sales FROM sales;
    ```

### 2.2 GROUP BY 操作 难度标记: 🟡
#### 基本分组
- **定义** | Definition
  - 用于为每个组创建一行输出，并为所选列生成汇总值。
  - Creates one output row per group and produces summary values for selected columns.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT customer_id, COUNT(order_id) AS order_count FROM orders GROUP BY customer_id;

    SELECT type AS 'Type', MIN(price) AS 'Minimum Price'
    FROM Books
    WHERE royalty > 10
    GROUP BY type;
    ```

#### 高级分组用法
- **定义** | Definition
  - GROUP BY 子句与聚合函数的组合使用方法
  - Advanced usage of GROUP BY clause with aggregate functions
- **示例** | Example
  ```sql
  SELECT COUNT(*) FROM Books GROUP BY type;
  SELECT AVG(qty) FROM Books GROUP BY type;
  SELECT SUM(qty) FROM Books GROUP BY type;
  SELECT 'Total Sales' = SUM(qty), 'Average Sales' = AVG(qty), stor_id
  FROM Sales
  GROUP BY StorID 
  ORDER BY 'Total Sales';
  ```

### 2.3 HAVING 子句 难度标记: 🟡
- **定义** | Definition
  - HAVING 子句用于对分组后的结果进行筛选
  - The HAVING clause is used to filter results after grouping
- **示例** | Example
  ```sql
  SELECT au_fname AS 'Author''s First Name', province as 'Province'
  FROM Authors
  GROUP BY au_fname, province
  HAVING province <> 'BC';
  ```

## 3. 数据修改操作 (Data Modification Operations) 🔄

### 3.1 插入数据 (INSERT Operations) 难度标记: 🟢
#### 基本插入
- **定义** | Definition
  - 向表中添加行。
  - Adds rows to a table.
- **示例** | Example
  - **示例代码**:
    ```sql
    INSERT INTO products (product_name, price) VALUES ('New Product', 19.99);
    ```

#### 高级插入技术
##### IDENTITY_INSERT
- **定义** | Definition
  - 允许向 IDENTITY 列插入特定值的选项
  - An option that allows inserting specific values into an IDENTITY column
- **示例** | Example
  ```sql
  SET IDENTITY_INSERT jobs ON;
  INSERT INTO jobs (job_id, job_desc, min_lvl, max_lvl)
  VALUES (19, 'DBA2', 100, 175);
  SET IDENTITY_INSERT jobs OFF;
  ```

##### INSERT ALL 和批量插入
- **定义** | Definition
  - 用于在 SQL 中一次性插入多条记录的语法。
  - A syntax used to insert multiple records into a SQL table at once.
- **Oracle SQL 示例** | Example
  ```sql
  INSERT ALL
      INTO offices VALUES (8, 'Toronto', '+1 416 555 1111', '200 Young St. N.', NULL, 'ON', 'Canada', 'M4A3A1', 'NA')
      INTO offices VALUES (9, 'Oshawa', '+1 905 555 2222', '155 Simcoe. S.', NULL, 'ON', 'Canada', 'N2L3G4', 'NA')
      INTO offices VALUES (10, 'Montreal', '+1 268 555 3333', '1245 Rue Lavac', NULL, 'QC', 'Canada', 'K3S2H4', 'NA')
  SELECT * FROM dual;
  ```

##### INSERT INTO ... SELECT
- **定义** | Definition
  - 用于将数据从一个表插入到另一个表的语法。
  - A syntax used to insert data from one table into another table.
- **示例** | Example
  ```sql
  INSERT INTO employees (first_name, last_name, email)
  SELECT first_name, last_name, email
  FROM new_employees;
  ```

### 3.1.1 向 IDENTITY 列插入特定值 (Inserting Specific Values into an IDENTITY Column) 难度标记: 🟡
- **定义** | Definition
  - 默认情况下，数据不能直接插入到 IDENTITY 列中；但是，如果意外删除了某一行，或者 IDENTITY 列值中存在间隙，可以插入一行并指定 IDENTITY 列的值。
  - By default, data cannot be inserted directly into an IDENTITY column; however, if a row is accidentally deleted, or there are gaps in the IDENTITY column values, you can insert a row and specify the IDENTITY column value.

- **IDENTITY_INSERT 选项** | IDENTITY_INSERT Option
  - 为了允许插入特定的身份值，可以使用 IDENTITY_INSERT 选项，如下所示：
  
- **示例代码**:
  ```sql
  SET IDENTITY_INSERT jobs ON;
  INSERT INTO jobs (job_id, job_desc, min_lvl, max_lvl)
  VALUES (19, 'DBA2', 100, 175);
  SET IDENTITY_INSERT jobs OFF;
  ```

### 3.2 更新数据 (UPDATE Operations) 难度标记: 🟡
#### 基本更新
- **定义** | Definition
  - 用于修改表中现有记录的值。
  - A syntax used to modify existing records in a table.
- **示例** | Example
  ```sql
  UPDATE employees 
  SET salary = salary * 1.1, 
      department = 'Sales'
  WHERE employee_id = 123;
  ```

#### 高级更新技术
##### 子查询更新
- **定义** | Definition
  - 在 UPDATE 语句中使用子查询来更新数据
  - Using subqueries in UPDATE statements to modify data
- **示例** | Example
  ```sql
  UPDATE Employees
  SET job_lvl = (
      SELECT max_lvl 
      FROM jobs
      WHERE employee.job_id = jobs.job_id
  )
  WHERE DATEPART(year, employee.hire_date) = 2010;
  ```

##### 多表更新
- **定义** | Definition
  - 使用连接更新多个表中的数据
  - Update data in multiple tables using joins
- **示例** | Example
  ```sql
  UPDATE publishers
  SET pub_name = 'New Publisher Name'
  FROM publishers p
  INNER JOIN titles t ON p.pub_id = t.pub_id
  WHERE t.type = 'business';
  ```

##### 复合条件更新
- **定义** | Definition
  - 基于多个条件的复杂更新操作
  - Complex update operations based on multiple conditions
- **示例** | Example
  ```sql
  UPDATE employees
  SET salary = CASE
      WHEN department = 'IT' AND years_service > 5 THEN salary * 1.15
      WHEN department = 'Sales' AND sales_target_met = 1 THEN salary * 1.10
      ELSE salary * 1.05
  END
  WHERE status = 'Active';
  ```

### 3.3 删除数据 (DELETE Operations) 难度标记: 🟢
#### 基本删除
- **定义** | Definition
  - 从记录集中删除行。
  - Removes rows from a record set.
- **示例** | Example
  ```sql
  DELETE FROM customers WHERE customer_id = 1;
  ```

#### 批量删除策略
- **定义** | Definition
  - 使用高效的方式删除大量数据
  - Efficient methods for deleting large amounts of data
- **示例** | Example
  ```sql
  DELETE TOP (1000) FROM large_table WHERE date_column < '2020-01-01';
  
  WHILE EXISTS (SELECT 1 FROM large_table WHERE date_column < '2020-01-01')
  BEGIN
      DELETE TOP (1000)
      FROM large_table
      WHERE date_column < '2020-01-01';
  END
  ```

## 4. 特殊数据处理 (Special Data Handling) 🛠️

### 4.1 NULL 值处理 难度标记: 🟡
- **定义** | Definition
  - 处理数据库中的 NULL 值的方法
  - Methods for handling NULL values in database
- **示例** | Example
  ```sql
  SELECT ISNULL(price, 0) AS price FROM books;
  SELECT COALESCE(price, msrp, 0) AS final_price FROM products;
  SELECT * FROM employees WHERE manager_id IS NULL;
  ```

### 4.2 数据转换和格式化 难度标记: 🟡
#### 转换函数
- **定义** | Definition
  - 将一种数据类型转换为另一种数据类型。
  - Converts one data type to another.
- **示例** | Example
  ```sql
  SELECT CAST('2023-10-01' AS DATE) AS converted_date;
  ```

#### TO_DATE() 函数
- **定义** | Definition
  - 将字符串转换为日期格式的函数。
  - A function that converts a string to a date format.
- **示例** | Example
  ```sql
  INSERT INTO orders (order_id, order_date)
  VALUES (1, TO_DATE('2023-10-01', 'YYYY-MM-DD'));
  ```

### 4.3 字符串处理 难度标记: 🟡
#### 字符串函数
- **定义** | Definition
  - 对字符字符串、二进制数据或表达式执行操作。
  - Performs operations on character strings, binary data, or expressions.
- **示例** | Example
  ```sql
  SELECT UPPER(customer_name) AS upper_name FROM customers;
  ```

#### 文本处理函数
- **定义** | Definition
  - 对文本和图像数据执行操作。
  - Performs operations on text and image data.
- **示例** | Example
  ```sql
  SELECT DATALENGTH(image_column) AS image_size FROM images;
  ```

## 5. 事务控制 (Transaction Control) 💼
- **定义** | Definition
  - 用于管理数据库事务的语句
  - Statements used to manage database transactions
- **主要命令** | Main Commands
  - BEGIN TRANSACTION
  - COMMIT
  - ROLLBACK
- **示例** | Example
  ```sql
  BEGIN TRANSACTION;
    UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
    IF @@ERROR = 0
      COMMIT;
    ELSE
      ROLLBACK;
  ```

## 6. SQL 编码规范和最佳实践 (SQL Coding Standards and Best Practices) 📚

### 6.1 DML 语句格式规范 难度标记: 🟢
- **定义** | Definition
  - SQL DML (Data Manipulation Language) 语句的书写规范。
  - Writing standards for SQL DML (Data Manipulation Language) statements.
- **规则** | Rules
  - 每个子句应该从新行开始
  - 所有子句的开头应该对齐
  - 如果一个子句有多个部分，应该分行并在子句开始处缩进
  - 保留字使用大写字母
  - 用户定义的词使用小写字母
- 💡实践提示 | Practice Tips
  - 良好的格式可以提高代码的可读性
  - 保持一致的格式风格有助于团队协作

### 6.2 替代变量使用 难度标记: 🟡
- **定义** | Definition
  - 替代变量用于在 SQL 查询中动态替换值。
  - Substitution variables are used to dynamically replace values in SQL queries.
- **示例** | Example
  ```sql
  DEFINE my_var = 'Sales';
  SELECT * FROM employees WHERE department = '&my_var';
  UNDEFINE my_var;
  ```

### 6.3 常用函数参考 难度标记: 🟡
#### INSTR 函数
- **定义** | Definition
  - `INSTR` 函数用于返回子字符串在字符串中首次出现的位置。
  - The `INSTR` function returns the position of a substring in a string.
- **示例** | Example
  ```sql
  SELECT INSTR('HELLO WORLD', 'W') AS position FROM DUAL;
  ```

#### LPAD/RPAD 函数
- **定义** | Definition
  - `LPAD` 函数用于将字符串左侧填充指定字符，直到达到指定长度。
  - The `LPAD` function pads the left side of a string with a specified character until it reaches a specified length.
- **示例** | Example
  ```sql
  SELECT LPAD('123', 5, '0') AS padded_string FROM DUAL;
  ```

#### TRIM 函数
- **定义** | Definition
  - `TRIM` 函数用于去除字符串两端的空格或指定字符。
  - The `TRIM` function removes spaces or specified characters from both ends of a string.
- **示例** | Example
  ```sql
  SELECT TRIM(' a ' ) AS trimmed_string FROM DUAL;
  ```

#### REPLACE 函数
- **定义** | Definition
  - `REPLACE` 函数用于替换字符串中的指定子字符串。
  - The `REPLACE` function replaces occurrences of a specified substring in a string.
- **示例** | Example
  ```sql
  SELECT REPLACE('banana', 'a', 'A') AS replaced_string FROM DUAL;
  ```

#### ROUND 函数
- **定义** | Definition
  - `ROUND` 函数用于对数字进行四舍五入。
  - The `ROUND` function rounds a number to a specified number of decimal places.
- **示例** | Example
  ```sql
  SELECT ROUND(123.456, 2) AS rounded_number FROM DUAL;
  ```

#### DECODE 函数
- **定义** | Definition
  - `DECODE` 函数用于在 SQL 中实现条件逻辑，类似于编程语言中的 `switch` 语句。
  - The `DECODE` function is used to implement conditional logic in SQL, similar to the `switch` statement in programming languages.
- **示例** | Example
  ```sql
  SELECT employee_id, 
         DECODE(department_id, 
                10, 'Administration', 
                20, 'Sales', 
                'Other') AS department_name
  FROM employees;
  ```

#### TRUNC 函数
- **定义** | Definition
  - `TRUNC` 函数用于截断数字或日期。
  - The `TRUNC` function is used to truncate numbers or dates.
- **示例** | Example
  ```sql
  SELECT TRUNC(salary, -3) AS truncated_salary FROM employees;  -- 截断到千位
  SELECT TRUNC(SYSDATE) AS truncated_date FROM dual;            -- 截断到日期
  ```

## 7. 表连接 (Joining Tables) 🔗

### 7.1 连接的定义
- **定义** | Definition
  - 连接两个或多个表的过程，通过比较指定列中的数据，并使用比较结果形成一个新表。
  - Joining two or more tables is the process of comparing the data in specified columns and using the comparison results to form a new table from the rows that qualify.

### 7.2 连接的基本操作
- **操作步骤**:
  1. 指定每个表中的列。
  2. 按行比较这些列中的值。
  3. 将具有符合条件的值的行组合成新行。

### 7.3 连接类型
- **内连接 (Inner Join)**:
  - 只返回两个表中匹配的记录。
  - **示例代码**:
    ```sql
    SELECT a.*, b.*
    FROM tableA a
    INNER JOIN tableB b ON a.id = b.a_id;
    ```

- **左外连接 (Left Outer Join)**:
  - 返回左表的所有记录，即使右表没有匹配的记录。
  - **示例代码**:
    ```sql
    SELECT c.customer_id, c.customer_name, o.order_id, o.order_amount
    FROM Customers c
    LEFT OUTER JOIN Orders o ON c.customer_id = o.customer_id;
    ```

- **右外连接 (Right Outer Join)**:
  - 返回右表的所有记录，即使左表没有匹配的记录。
  - **示例代码**:
    ```sql
    SELECT a.*, b.*
    FROM tableA a
    RIGHT OUTER JOIN tableB b ON a.id = b.a_id;
    ```

- **交叉连接 (Cross Join)**:
  - 返回两个表的笛卡尔积。
  - **示例代码**:
    ```sql
    SELECT * FROM table1 CROSS JOIN table2;
    ```

### 7.4 连接的注意事项
- 连接通常是基于相等的比较，但也可以指定其他类型的比较。
- 确保连接条件的正确性，以避免意外结果。

### 7.5 全外连接 (Full Outer Join) 难度标记: 🟡
- **定义** | Definition
  - 全外连接指定如果任一表中的行不符合选择标准，则该行将包含在结果集中，并且其对应于另一个表的输出列将设置为 NULL。
  - A full outer join specifies that if a row from either table does not match the selection criteria, the row is included in the result set, and its output columns that correspond to the other table are set to NULL.

- **示例代码**:
  ```sql
  SELECT books.title, publishers.pub_name, publishers.province
  FROM Publishers
  FULL OUTER JOIN Books ON books.pub_id = publishers.pub_id
  WHERE (publishers.province <> 'BC' AND publishers.province <> 'ON')
  ORDER BY books.title_id;
  ```

- **解释**:
  - 这个查询将返回所有书籍及其对应的出版商信息，即使某些书籍没有对应的出版商，或某些出版商没有对应的书籍。
  - 如果没有匹配的行，结果中的相应列将显示为 NULL。

## 8. 数据定义语言 (DDL) 📊

### 8.1 DDL 概述
- **定义** | Definition
  - 数据定义语言（DDL）是用于定义和管理数据库结构的 SQL 语句。
  - DDL (Data Definition Language) is a set of SQL statements used to define and manage the structure of a database.

### 8.2 常见 DDL 语句
#### 1. CREATE
- **定义** | Definition
  - 用于创建数据库对象，如表、视图、索引等。
  - Used to create database objects such as tables, views, and indexes.
- **示例** | Example
  ```sql
  CREATE TABLE employees (
      employee_id INT PRIMARY KEY,
      first_name NVARCHAR(50),
      last_name NVARCHAR(50),
      hire_date DATE
  );
  ```

#### 2. ALTER
- **定义** | Definition
  - 用于修改现有数据库对象的结构。
  - Used to modify the structure of existing database objects.
- **示例** | Example
  ```sql
  ALTER TABLE employees
  ADD salary DECIMAL(10, 2);
  ```

#### 3. DROP
- **定义** | Definition
  - 用于删除数据库对象，如表、视图、索引等。
  - Used to delete database objects such as tables, views, and indexes.
- **示例** | Example
  ```sql
  DROP TABLE employees;
  ```

#### 4. TRUNCATE
- **定义** | Definition
  - 用于快速删除表中的所有行，但不删除表本身。
  - Used to quickly delete all rows in a table without deleting the table itself.
- **示例** | Example
  ```sql
  TRUNCATE TABLE employees;
  ```

#### 5. RENAME
- **定义** | Definition
  - 用于重命名数据库对象。
  - Used to rename database objects.
- **示例** | Example
  ```sql
  RENAME employees TO staff;
  ```

#### 6. COPY
- **定义** | Definition
  - 在某些数据库系统中（如 PostgreSQL），用于从文件或其他表中复制数据。
  - Used in some database systems (like PostgreSQL) to copy data from files or other tables.
- **示例** | Example
  ```sql
  COPY employees FROM '/path/to/file.csv' DELIMITER ',' CSV HEADER;
  ```

#### 7. COMMENT
- **定义** | Definition
  - 用于添加注释到数据库对象。
  - Used to add comments to database objects.
- **示例** | Example
  ```sql
  COMMENT ON TABLE employees IS 'This table stores employee information.';
  ```

### 8.3 DDL 的注意事项
- DDL 语句通常会立即生效，并且在执行后会自动提交。
- 使用 DDL 语句时要小心，因为某些操作（如 DROP 和 TRUNCATE）是不可逆的。
