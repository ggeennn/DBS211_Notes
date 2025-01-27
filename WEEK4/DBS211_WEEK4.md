# Week 4 SQL Joins & Views
==========================================================
 read until page 17 Reporting Aggregated Data and  joins
==========================================================
## 1. SQL 连接基础 (SQL Joins Basics) 📝

### 1.1 ANSI-89 连接语法 (ANSI-89 Join Syntax) 难度标记: 🟡
- **定义** | Definition
  - ANSI-89 是一种较早的连接语法标准，使用 WHERE 子句来定义连接条件。
  - ANSI-89 is an older join syntax standard that uses WHERE clause to define join conditions.
- **示例** | Example
  ```sql
  SELECT e.employee_name, d.department_name
  FROM employees e, departments d
  WHERE e.department_id = d.department_id;
  ```

### 1.2 ANSI-92 连接语法 (ANSI-92 Join Syntax) 难度标记: 🟡
- **定义** | Definition
  - ANSI-92 是更现代的连接语法标准，使用 JOIN 关键字显式定义连接。
  - ANSI-92 is a more modern join syntax standard that explicitly defines joins using the JOIN keyword.
- **示例** | Example
  ```sql
  SELECT e.employee_name, d.department_name
  FROM employees e
  INNER JOIN departments d ON e.department_id = d.department_id;
  ```

## 2. 连接类型 (Types of Joins) 📊

### 2.1 INNER JOIN 难度标记: 🟢
- **定义** | Definition
  - 返回两个表中匹配的行。
  - Returns matching rows from both tables.
- **示例** | Example
  ```sql
  SELECT customers.customer_name, orders.order_date
  FROM customers
  INNER JOIN orders ON customers.customer_id = orders.customer_id;
  ```

### 2.2 OUTER JOIN 难度标记: 🟡

#### LEFT OUTER JOIN
- **定义** | Definition
  - 返回左表的所有行和右表中匹配的行。
  - Returns all rows from the left table and matching rows from the right table.
- **示例** | Example
  ```sql
  SELECT customers.customer_name, orders.order_date
  FROM customers
  LEFT OUTER JOIN orders ON customers.customer_id = orders.customer_id;
  ```

#### RIGHT OUTER JOIN
- **定义** | Definition
  - 返回右表的所有行和左表中匹配的行。
  - Returns all rows from the right table and matching rows from the left table.

- **示例分析** | Example Analysis
  ```sql
  SELECT employees.employee_name, departments.department_name
  FROM employees
  RIGHT OUTER JOIN departments ON employees.department_id = departments.department_id;
  ```
  - `departments` 是右表，`employees` 是左表。
  - `departments` is the right table, and `employees` is the left table.
  - 返回所有部门的名称和与之匹配的员工名称。
  - Returns all department names and matching employee names.

#### FULL OUTER JOIN
- **定义** | Definition
  - 返回两个表中的所有行，不管是否匹配。
  - Returns all rows from both tables, whether they match or not.
- **示例** | Example
  ```sql
  SELECT students.student_name, courses.course_name
  FROM students
  FULL OUTER JOIN enrollments ON students.student_id = enrollments.student_id
  FULL OUTER JOIN courses ON enrollments.course_id = courses.course_id;
  ```

## 3. 视图 (Views) 🔍

### 3.1 视图基础 (View Basics) 难度标记: 🟢
- **定义** | Definition
  - 视图是基于 SQL 查询的虚拟表。
  - A view is a virtual table based on an SQL query.
- **示例** | Example
  ```sql
  CREATE VIEW employee_details AS
  SELECT employee_id, first_name, last_name, department_name
  FROM employees
  JOIN departments ON employees.department_id = departments.department_id;
  ```

### 3.2 视图的类型 (Types of Views) 难度标记: 🟡

#### 简单视图 (Simple Views)
- **定义** | Definition
  - 从单个表创建的视图，没有聚合函数。
  - Views created from a single table without aggregate functions.
- **示例** | Example
  ```sql
  CREATE VIEW active_employees AS
  SELECT employee_id, first_name, last_name
  FROM employees
  WHERE status = 'Active';
  ```

#### 复杂视图 (Complex Views)
- **定义** | Definition
  - 包含多个表、聚合函数或 GROUP BY 子句的视图。
  - Views that include multiple tables, aggregate functions, or GROUP BY clauses.
- **示例** | Example
  ```sql
  CREATE VIEW department_summary AS
  SELECT d.department_name,
         COUNT(e.employee_id) as employee_count,
         AVG(e.salary) as avg_salary
  FROM departments d
  LEFT JOIN employees e ON d.department_id = e.department_id
  GROUP BY d.department_name;
  ```

### 3.3 视图的使用 (Using Views) 难度标记: 🟢
- **查询视图** | Querying Views
  ```sql
  SELECT * FROM employee_details;
  ```

- **更新视图** | Updating Views
  ```sql
  UPDATE employee_details
  SET first_name = 'John'
  WHERE employee_id = 100;
  ```

### 3.4 视图的优势 (Advantages of Views) 难度标记: 🟢
- **简化复杂查询**
- **提供数据安全性**
- **数据独立性**
- **自定义数据展示**

## 4. 最佳实践 (Best Practices) 📚

### 4.1 连接最佳实践 难度标记: 🟡
- 始终使用明确的连接语法（ANSI-92）
- 在连接条件中使用适当的索引
- 避免不必要的表连接
- 使用有意义的表别名

### 4.2 视图最佳实践 难度标记: 🟡
- 为视图提供清晰的命名
- 在视图定义中包含适当的注释
- 避免创建过于复杂的视图
- 定期维护和更新视图

## 5. 性能考虑 (Performance Considerations) 💡

### 5.1 连接性能优化 难度标记: 🟡
- **索引使用**
- **连接顺序**
- **WHERE 子句优化**
- **避免笛卡尔积**

### 5.2 视图性能优化 难度标记: 🟡
- **索引视图**
- **materialized views（物化视图）的使用**
- **定期刷新策略**
- **查询优化**

## 6. 分组函数与空值 (Group Functions and Null Values) 📊

- **分组函数的定义** | Definition of Group Functions
  - 分组函数用于对一组值进行计算并返回单个值，例如 `AVG`、`SUM`、`COUNT` 等。
  - Group functions are used to perform calculations on a set of values and return a single value, such as `AVG`, `SUM`, `COUNT`, etc.

- **空值的处理** | Handling Null Values
  - 分组函数会忽略列中的空值。
  - Group functions ignore null values in the column.
  
- **使用 NVL 函数** | Using the NVL Function
  - `NVL` 函数可以强制分组函数包含空值。
  - The `NVL` function forces group functions to include null values.
  
- **示例** | Example
  ```sql
  -- 计算员工的平均佣金，忽略空值
  SELECT AVG(commission_pct) FROM employees;

  -- 使用 NVL 函数计算员工的平均佣金，将空值视为 0
  SELECT AVG(NVL(commission_pct, 0)) FROM employees;
  ```