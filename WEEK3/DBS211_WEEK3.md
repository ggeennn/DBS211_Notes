# Week 3 学习内容

## 数据库基础知识
https://opentextbc.ca/dbdesign01/chapter/chapter-sql-dml/

### 聚合函数 (Aggregate Function) 难度标记: 🟢
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
    这个查询将返回销售额的总和。

### 排序 (ASC & DESC) 难度标记: 🟢
- **ASC**: 升序排列 (Ascending Order)
- **DESC**: 降序排列 (Descending Order)
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT product_name FROM products ORDER BY price ASC;
    ```
    这个查询将按价格升序排列产品名称。

### 转换函数 (Conversion Function) 难度标记: 🟡
- **定义** | Definition
  - 将一种数据类型转换为另一种数据类型。
  - Converts one data type to another.
- **示例** | Example
  - `CAST()`, `CONVERT()`
  - 实际应用场景：将字符串转换为日期格式。
  - **示例代码**:
    ```sql
    SELECT CAST('2023-10-01' AS DATE) AS converted_date;
    ```
    这个查询将字符串转换为日期格式。

### 交叉连接 (Cross Join) 难度标记: 🟡
- **定义** | Definition
  - 结合两个表的笛卡尔积。
  - Combines two tables into a Cartesian product.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT * FROM table1 CROSS JOIN table2;
    ```
    这个查询将返回两个表的所有组合。

### 日期函数 (Date Function) 难度标记: 🟡
- **定义** | Definition
  - 显示有关日期和时间的信息。
  - Displays information about dates and times.
- **示例** | Example
  - `GETDATE()`, `DATEDIFF()`
  - 实际应用场景：获取当前日期和计算日期差。
  - **示例代码**:
    ```sql
    SELECT DATEDIFF(DAY, '2023-01-01', GETDATE()) AS days_since;
    ```
    这个查询将返回从2023年1月1日到当前日期的天数。

### 删除语句 (DELETE Statement) 难度标记: 🟢
- **定义** | Definition
  - 从记录集中删除行。
  - Removes rows from a record set.
- **示例** | Example
  - **示例代码**:
    ```sql
    DELETE FROM customers WHERE customer_id = 1;
    ```
    这个查询将删除客户ID为1的记录。

### 分组 (GROUP BY) 难度标记: 🟡
- **定义** | Definition
  - 用于为每个组创建一行输出，并为所选列生成汇总值。
  - Creates one output row per group and produces summary values for selected columns.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT customer_id, COUNT(order_id) AS order_count FROM orders GROUP BY customer_id;
    ```
    这个查询将返回每个客户的订单数量。

### 内连接 (Inner Join) 难度标记: 🟡
- **定义** | Definition
  - 在具有相同数据类型的列上连接两个表。
  - Connects two tables on columns with the same data type.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT a.*, b.* FROM tableA a INNER JOIN tableB b ON a.id = b.a_id;
    ```
    这个查询将返回两个表中匹配的记录。

### 插入语句 (INSERT Statement) 难度标记: 🟢
- **定义** | Definition
  - 向表中添加行。
  - Adds rows to a table.
- **示例** | Example
  - **示例代码**:
    ```sql
    INSERT INTO products (product_name, price) VALUES ('New Product', 19.99);
    ```
    这个查询将向产品表中添加一条新记录。

### 左外连接 (Left Outer Join) 难度标记: 🟡
- **定义** | Definition
  - 指定返回所有左外表的行。
  - Specifies that all left outer rows be returned.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT a.*, b.* FROM tableA a LEFT OUTER JOIN tableB b ON a.id = b.a_id;
    ```
    这个查询将返回左表的所有记录，即使右表没有匹配的记录。

### 右外连接 (Right Outer Join) 难度标记: 🟡
- **定义** | Definition
  - 包括所有未满足条件的右表行。
  - Includes all rows from the right table that did not meet the condition specified.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT a.*, b.* FROM tableA a RIGHT OUTER JOIN tableB b ON a.id = b.a_id;
    ```
    这个查询将返回右表的所有记录，即使左表没有匹配的记录。

### 选择语句 (SELECT Statement) 难度标记: 🟢
- **定义** | Definition
  - 用于查询数据库中的数据。
  - Used to query data in the database.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT * FROM customers;
    ```
    这个查询将返回客户表中的所有记录。

### 字符串函数 (String Function) 难度标记: 🟡
- **定义** | Definition
  - 对字符字符串、二进制数据或表达式执行操作。
  - Performs operations on character strings, binary data, or expressions.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT UPPER(customer_name) AS upper_name FROM customers;
    ```
    这个查询将返回客户名称的大写形式。

### 系统函数 (System Function) 难度标记: 🟡
- **定义** | Definition
  - 返回数据库中特殊的信息。
  - Returns special pieces of information from the database.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT @@VERSION AS sql_version;
    ```
    这个查询将返回当前 SQL Server 的版本信息。

### 文本和图像函数 (Text and Image Functions) 难度标记: 🟡
- **定义** | Definition
  - 对文本和图像数据执行操作。
  - Performs operations on text and image data.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT DATALENGTH(image_column) AS image_size FROM images;
    ```
    这个查询将返回图像列的大小。

### 更新语句 (UPDATE Statement) 难度标记: 🟡
- **定义** | Definition
  - 用于修改表中现有记录的值。
  - A syntax used to modify existing records in a table.
- **示例** | Example
  - **示例代码**:
    ```sql
    UPDATE employees 
    SET salary = salary * 1.1, 
        department = 'Sales'
    WHERE employee_id = 123;
    ```
  - **解释**:
    - `SET` 子句用于指定要更新的字段及其新值。
    - `WHERE` 子句用于指定更新的条件。

### 删除语句 (DELETE Statement) 难度标记: 🟢
- **定义** | Definition
  - 用于从表中删除记录。
  - A syntax used to delete records from a table.
- **示例** | Example
  - **示例代码**:
    ```sql
    DELETE FROM employees 
    WHERE employee_id = 123;
    ```
  - **解释**:
    - `WHERE` 子句用于指定删除的条件。
    - 如果不使用 `WHERE` 子句，表中的所有记录都会被删除。

### 通配符 (Wildcard) 难度标记: 🟢
- **定义** | Definition
  - 允许用户匹配包含特定字母的字段。
  - Allows users to match fields that contain certain letters.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT * FROM customers WHERE customer_name LIKE 'A%';
    ```
    这个查询将返回所有以字母"A"开头的客户名称。

### TO_DATE() 函数 难度标记: 🟡
- **定义** | Definition
  - 将字符串转换为日期格式的函数。
  - A function that converts a string to a date format.
- **示例** | Example
  - `TO_DATE('2023-10-01', 'YYYY-MM-DD')`
  - 实际应用场景：在插入硬编码日期时使用，确保日期被正确解析。
  - **示例代码**:
    ```sql
    INSERT INTO orders (order_id, order_date)
    VALUES (1, TO_DATE('2023-10-01', 'YYYY-MM-DD'));
    ```
    这个查询将插入一个订单，确保日期格式正确。

### INSERT ALL 语法与 MS SQL Server 的比较 难度标记: 🟡
- **定义** | Definition
  - 用于在 SQL 中一次性插入多条记录的语法。
  - A syntax used to insert multiple records into a SQL table at once.
- **Oracle SQL 示例** | Example
  - **示例代码**:
    ```sql
    INSERT ALL
        INTO offices VALUES (8, 'Toronto', '+1 416 555 1111', '200 Young St. N.', NULL, 'ON', 'Canada', 'M4A3A1', 'NA')
        INTO offices VALUES (9, 'Oshawa', '+1 905 555 2222', '155 Simcoe. S.', NULL, 'ON', 'Canada', 'N2L3G4', 'NA')
        INTO offices VALUES (10, 'Montreal', '+1 268 555 3333', '1245 Rue Lavac', NULL, 'QC', 'Canada', 'K3S2H4', 'NA')
    SELECT * FROM dual;
    ```
- **MS SQL Server 示例** | Example
  - **示例代码**:
    ```sql
    INSERT INTO offices (office_id, city, phone, address, address2, state, country, postal_code, region)
    VALUES 
        (8, 'Toronto', '+1 416 555 1111', '200 Young St. N.', NULL, 'ON', 'Canada', 'M4A3A1', 'NA'),
        (9, 'Oshawa', '+1 905 555 2222', '155 Simcoe. S.', NULL, 'ON', 'Canada', 'N2L3G4', 'NA'),
        (10, 'Montreal', '+1 268 555 3333', '1245 Rue Lavac', NULL, 'QC', 'Canada', 'K3S2H4', 'NA');
    ```
- **关键区别**:
  - Oracle SQL 需要以 `SELECT * FROM dual` 结束，而 MS SQL Server 不需要。
  - MS SQL Server 可以在一个 `VALUES` 子句中插入多条记录。

### INSERT INTO ... SELECT 语法 难度标记: 🟡
- **定义** | Definition
  - 用于将数据从一个表插入到另一个表的语法。
  - A syntax used to insert data from one table into another table.
- **示例** | Example
  - **包含字段列表的示例代码**:
    ```sql
    INSERT INTO employees (first_name, last_name, email)
    SELECT first_name, last_name, email
    FROM new_employees;
    ```
  - **不包含字段列表的示例代码**:
    ```sql
    INSERT INTO employees
    SELECT first_name, last_name, email
    FROM new_employees;
    ```
  - **解释**:
    - 如果不在 `INSERT` 行中包含字段列表，`SELECT` 行中返回的字段顺序必须与目标表中的字段顺序一致。
    - 可选的 `WHERE` 和 `ORDER BY` 子句可以用于过滤和排序数据。

### 模式匹配 (Pattern Matching) 使用 LIKE 难度标记: 🟡
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

### 替代变量 (Substitution Variables) 难度标记: 🟡
- **定义** | Definition
  - 替代变量用于在 SQL 查询中动态替换值。
  - Substitution variables are used to dynamically replace values in SQL queries.
- **示例** | Example
  - **示例代码**:
    ```sql
    DEFINE my_var = 'Sales';
    SELECT * FROM employees WHERE department = '&my_var';
    UNDEFINE my_var;
    ```

### DECODE 函数 难度标记: 🟡
- **定义** | Definition
  - `DECODE` 函数用于在 SQL 中实现条件逻辑。
  - The `DECODE` function is used to implement conditional logic in SQL.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT employee_id, 
           DECODE(department_id, 
                  10, 'Administration', 
                  20, 'Sales', 
                  'Other') AS department_name
    FROM employees;
    ```

### TRUNC 函数 难度标记: 🟡
- **定义** | Definition
  - `TRUNC` 函数用于截断数字或日期。
  - The `TRUNC` function is used to truncate numbers or dates.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT TRUNC(salary, -3) AS truncated_salary FROM employees;  -- 截断到千位
    SELECT TRUNC(SYSDATE) AS truncated_date FROM dual;            -- 截断到日期
    ```

### 字面字符字符串 (Literal Character Strings) 难度标记: 🟢
- **定义** | Definition
  - 字面字符字符串是直接在 SQL 查询中使用的字符串值。
  - Literal character strings are string values used directly in SQL queries.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT * FROM products WHERE product_name = 'Laptop';
    ```

### DISTINCT 难度标记: 🟢
- **定义** | Definition
  - `DISTINCT` 关键字用于返回唯一的值。
  - The `DISTINCT` keyword is used to return unique values.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT DISTINCT department_id FROM employees;
    ```

### 常见函数的用法 难度标记: 🟡

#### 1. INSTR 函数
- **定义** | Definition
  - `INSTR` 函数用于返回子字符串在字符串中首次出现的位置。
  - The `INSTR` function returns the position of a substring in a string.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT INSTR('HELLO WORLD', 'W') AS position FROM DUAL;
    ```
  - **解释**:
    - 这个查询将返回子字符串 'W' 在字符串 'HELLO WORLD' 中首次出现的位置。

#### 2. LPAD 函数
- **定义** | Definition
  - `LPAD` 函数用于将字符串左侧填充指定字符，直到达到指定长度。
  - The `LPAD` function pads the left side of a string with a specified character until it reaches a specified length.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT LPAD('123', 5, '0') AS padded_string FROM DUAL;
    ```
  - **解释**:
    - 这个查询将返回 '00123'，因为 '123' 被左侧填充了两个 '0'。

#### 3. RPAD 函数
- **定义** | Definition
  - `RPAD` 函数用于将字符串右侧填充指定字符，直到达到指定长度。
  - The `RPAD` function pads the right side of a string with a specified character until it reaches a specified length.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT RPAD('123', 5, '0') AS padded_string FROM DUAL;
    ```
  - **解释**:
    - 这个查询将返回 '12300'，因为 '123' 被右侧填充了两个 '0'。

#### 4. TRIM 函数
- **定义** | Definition
  - `TRIM` 函数用于去除字符串两端的空格或指定字符。
  - The `TRIM` function removes spaces or specified characters from both ends of a string.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT TRIM(' a ' ) AS trimmed_string FROM DUAL;
    ```
  - **解释**:
    - 这个查询将返回 'a'，因为两端的空格被去掉了。

#### 5. REPLACE 函数
- **定义** | Definition
  - `REPLACE` 函数用于替换字符串中的指定子字符串。
  - The `REPLACE` function replaces occurrences of a specified substring in a string.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT REPLACE('banana', 'a', 'A') AS replaced_string FROM DUAL;
    ```
  - **解释**:
    - 这个查询将返回 'bAnAnA'，因为所有的 'a' 被替换为 'A'。

#### 6. ROUND 函数
- **定义** | Definition
  - `ROUND` 函数用于对数字进行四舍五入。
  - The `ROUND` function rounds a number to a specified number of decimal places.
- **示例** | Example
  - **示例代码**:
    ```sql
    SELECT ROUND(123.456, 2) AS rounded_number FROM DUAL;
    ```
  - **解释**:
    - 这个查询将返回 123.46，因为数字被四舍五入到小数点后两位。
