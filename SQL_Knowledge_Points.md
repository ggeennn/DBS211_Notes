# SQL知识点整理
> 基于DBS211示例数据库的SQL语法总结

## 目录
1. [数据库基础操作](#1-数据库基础操作)
2. [表结构操作](#2-表结构操作)
3. [数据操作](#3-数据操作)
4. [约束条件](#4-约束条件)
5. [Oracle特有语法](#5-oracle特有语法)
6. [数据库设计与建模](#6-数据库设计与建模)
7. [高级SQL特性](#7-高级sql特性)
8. [数据完整性约束](#8-数据完整性约束)
9. [Oracle特定功能](#9-oracle特定功能)
10. [数据类型详解](#10-数据类型详解)
11. [数据库对象命名规范](#11-数据库对象命名规范)
12. [性能优化考虑](#12-性能优化考虑)
13. [错误处理](#13-错误处理)

## 1. 数据库基础操作

### 1.1 数据库对象删除
```sql
-- 删除表（带级联约束）
DROP TABLE table_name CASCADE CONSTRAINTS;
```

### 1.2 Oracle特殊命令
```sql
-- 设置回显关闭
SET ECHO OFF;

-- 设置验证关闭
SET VERIFICATION OFF;

-- 显示提示信息
PROMPT 'message';
```

## 2. 表结构操作

### 2.1 创建表 (CREATE TABLE)
```sql
CREATE TABLE offices (
    officeCode      VARCHAR(10) NOT NULL,   -- 非空字段
    city            VARCHAR(50) NOT NULL,
    addressLine2    VARCHAR(50) DEFAULT NULL,-- 可空字段带默认值
    PRIMARY KEY (officeCode)                 -- 主键定义
);
```

### 2.2 常用数据类型
- **VARCHAR(n)** - 可变长字符串
- **INT** - 整数
- **DECIMAL(p,s)** - 精确小数，p是总位数，s是小数位数
- **DATE** - 日期类型
- **SMALLINT** - 小整数

## 3. 数据操作

### 3.1 基本查询 (Basic Queries)
```sql
-- 查询所有员工
SELECT * FROM employees;

-- 查询特定列
SELECT firstName, lastName, email 
FROM employees;

-- 条件查询
SELECT * FROM employees 
WHERE jobTitle = 'Sales Rep';

-- 排序查询
SELECT * FROM employees 
ORDER BY lastName ASC;

-- 分组查询
SELECT jobTitle, COUNT(*) as emp_count
FROM employees
GROUP BY jobTitle;
```

### 3.2 数据插入 (INSERT)
```sql
-- 单行插入
INSERT INTO employees 
(employeeNumber, lastName, firstName, extension, email, officeCode, jobTitle)
VALUES 
(1001, 'Smith', 'John', 'x102', 'john@example.com', '1', 'Sales Rep');

-- 多行插入（Oracle语法）
INSERT ALL 
    INTO employees VALUES (1002, 'Johnson', 'Mary', 'x103', 'mary@example.com', '1', 'Sales Rep')
    INTO employees VALUES (1003, 'Brown', 'David', 'x104', 'david@example.com', '2', 'Sales Rep')
SELECT * FROM DUAL;
```

### 3.3 数据更新 (UPDATE)
```sql
-- 单条件更新
UPDATE employees
SET jobTitle = 'Senior Sales Rep'
WHERE employeeNumber = 1001;

-- 多条件更新
UPDATE employees
SET salary = salary * 1.1,
    jobTitle = 'Senior ' || jobTitle
WHERE officeCode = '1' 
AND jobTitle LIKE '%Sales%';
```

### 3.4 数据删除 (DELETE)
```sql
-- 条件删除
DELETE FROM employees
WHERE employeeNumber = 1001;

-- 多条件删除
DELETE FROM employees
WHERE officeCode = '1'
AND jobTitle = 'Sales Rep';
```

### 3.5 高级查询示例
```sql
-- 连接查询
SELECT e.firstName, e.lastName, o.city
FROM employees e
JOIN offices o ON e.officeCode = o.officeCode;

-- 子查询
SELECT firstName, lastName
FROM employees
WHERE officeCode IN (
    SELECT officeCode 
    FROM offices 
    WHERE country = 'USA'
);

-- 聚合函数
SELECT o.city,
       COUNT(e.employeeNumber) as emp_count,
       MAX(e.salary) as max_salary
FROM offices o
LEFT JOIN employees e ON o.officeCode = e.officeCode
GROUP BY o.city
HAVING COUNT(e.employeeNumber) > 2;
```

## 4. 约束条件

### 4.1 主键约束 (Primary Key)
```sql
-- 方式1：在列定义中
column_name datatype PRIMARY KEY

-- 方式2：在表级别定义
PRIMARY KEY (column_name)
```

### 4.2 外键约束 (Foreign Key)
```sql
-- 创建带名称的外键约束
CONSTRAINT emp_office_fk 
FOREIGN KEY (officeCode) 
REFERENCES offices (officeCode)
```

### 4.3 非空约束 (NOT NULL)
```sql
column_name datatype NOT NULL
```

### 4.4 默认值约束 (DEFAULT)
```sql
column_name datatype DEFAULT default_value
```

## 5. Oracle特有语法

### 5.1 异常处理
```sql
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE offices CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
```

### 5.2 批量插入
```sql
INSERT ALL
    INTO table_name VALUES (value1, value2, ...)
    INTO table_name VALUES (value1, value2, ...)
SELECT * FROM DUAL;
```

### 5.3 日期函数
```sql
-- 日期格式化
to_date('2003-01-06','yyyy-mm-dd')
```

## 表关系设计

### 主要表及其关系
1. **OFFICES表** (办公室信息)
   - 主键：officeCode

2. **EMPLOYEES表** (员工信息)
   - 主键：employeeNumber
   - 外键：
     - officeCode -> OFFICES表
     - reportsTo -> EMPLOYEES表(自引用)

3. **CUSTOMERS表** (客户信息)
   - 主键：customerNumber
   - 外键：salesRepEmployeeNumber -> EMPLOYEES表

4. **ORDERS表** (订单信息)
   - 主键：orderNumber
   - 外键：customerNumber -> CUSTOMERS表

5. **ORDERDETAILS表** (订单详情)
   - 复合主键：(orderNumber, productCode)
   - 外键：
     - orderNumber -> ORDERS表
     - productCode -> PRODUCTS表

## 最佳实践

### 1. 命名规范
- 表名使用复数形式
- 主键通常使用"表名+Number"格式
- 外键约束使用有意义的名称（如：emp_office_fk）

### 2. 数据完整性
- 使用主键确保记录唯一性
- 使用外键维护引用完整性
- 适当使用非空约束
- 为重要字段设置默认值

### 3. 异常处理
- 删除表时使用CASCADE CONSTRAINTS
- 使用异常处理块处理可能的错误
- 批量操作后及时COMMIT

### 4. 性能考虑
- 合理使用数据类型
- 适当设置字段长度
- 批量插入时使用INSERT ALL
- 大量数据操作时注意事务控制 

## 6. 数据库设计与建模

### 6.1 表结构设计
```sql
-- 产品线表设计示例
CREATE TABLE productlines (
    productLine varchar(50) NOT NULL PRIMARY KEY,  -- 主键，产品线编号
    textDescription varchar(4000) DEFAULT NULL,    -- 长文本描述
    htmlDescription varchar(4000),                 -- HTML格式描述
    image varchar(150)                            -- 图片路径
);

-- 产品表设计示例
CREATE TABLE products (
    productCode varchar(15) NOT NULL PRIMARY KEY,  -- 产品编码
    productName varchar(70) NOT NULL,             -- 产品名称
    productLine varchar(50) NOT NULL,             -- 产品线（外键）
    productScale varchar(10) NOT NULL,            -- 产品规格
    quantityInStock int NOT NULL,                 -- 库存数量
    buyPrice decimal(10,2) NOT NULL,              -- 进价
    MSRP decimal(10,2) NOT NULL                   -- 建议零售价
);
```

### 6.2 复合主键设计
```sql
-- 订单详情表使用复合主键
CREATE TABLE orderdetails (
    orderNumber int NOT NULL,                     -- 订单号
    productCode varchar(15) NOT NULL,             -- 产品编码
    quantityOrdered int NOT NULL,                 -- 订购数量
    priceEach decimal(10,2) NOT NULL,            -- 单价
    orderLineNumber smallint NOT NULL,            -- 订单行号
    PRIMARY KEY (orderNumber, productCode)        -- 复合主键
);
```

## 7. 高级SQL特性

### 7.1 事务控制
```sql
-- 开始事务（隐式）
INSERT/UPDATE/DELETE ...

-- 提交事务
COMMIT;

-- 回滚事务（异常时）
ROLLBACK;
```

### 7.2 注释
```sql
-- 单行注释
-- This is a single line comment

/* 多行注释
   This is a multi-line comment
   Multiple lines can be commented
*/
```

### 7.3 数据导入导出
```sql
-- 数据导入示例（使用INSERT ALL）
INSERT ALL 
    INTO customers VALUES (103,'Atelier graphique','Schmitt','Carine',...)
    INTO customers VALUES (112,'Signal Gift Stores','King','Jean',...)
SELECT * FROM DUAL;
```

### 7.4 常用函数示例
```sql
-- 字符串函数
SELECT UPPER(lastName) as upper_name,
       LOWER(firstName) as lower_name,
       LENGTH(email) as email_length,
       SUBSTR(phone, 1, 3) as area_code
FROM employees;

-- 数值函数
SELECT productCode,
       ROUND(buyPrice, 2) as rounded_price,
       CEIL(buyPrice) as ceiling_price,
       FLOOR(buyPrice) as floor_price
FROM products;

-- 日期函数
SELECT orderNumber,
       orderDate,
       ADD_MONTHS(orderDate, 1) as next_month,
       MONTHS_BETWEEN(SYSDATE, orderDate) as months_ago
FROM orders;
```

### 7.5 条件表达式
```sql
-- CASE表达式
SELECT orderNumber,
       status,
       CASE status
           WHEN 'Shipped' THEN 'Delivered'
           WHEN 'In Process' THEN 'Processing'
           ELSE 'Pending'
       END as status_description
FROM orders;

-- DECODE函数（Oracle特有）
SELECT productName,
       DECODE(productLine,
              'Classic Cars', 'Vintage',
              'Motorcycles', 'Two-Wheeler',
              'Other') as category
FROM products;
```

## 8. 数据完整性约束

### 8.1 复合外键约束
```sql
-- 订单详情表的复合外键约束
CONSTRAINT orderdetails_ibfk_1 
    FOREIGN KEY (orderNumber) 
    REFERENCES orders (orderNumber),
CONSTRAINT orderdetails_ibfk_2 
    FOREIGN KEY (productCode) 
    REFERENCES products (productCode)
```

### 8.2 自引用外键
```sql
-- 员工表的自引用（管理者关系）
CONSTRAINT emp_rtEmp_fk 
    FOREIGN KEY (reportsTo) 
    REFERENCES employees (employeeNumber)
```

## 9. Oracle特定功能

### 9.1 DUAL表使用
```sql
-- 在INSERT ALL后使用DUAL表
SELECT * FROM DUAL;
```

### 9.2 执行立即命令
```sql
-- 使用EXECUTE IMMEDIATE执行动态SQL
EXECUTE IMMEDIATE 'DROP TABLE offices CASCADE CONSTRAINTS';
```

### 9.3 PL/SQL块
```sql
-- 基本PL/SQL块结构
BEGIN
    -- SQL statements
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
```

## 10. 数据类型详解

### 10.1 字符类型
- **VARCHAR(n)** - 可变长度字符串，最大长度为n
- **VARCHAR2(n)** - Oracle特有的可变长度字符串
- **CHAR(n)** - 固定长度字符串

### 10.2 数值类型
- **INT** - 整数
- **DECIMAL(p,s)** - 精确小数
- **SMALLINT** - 小范围整数
- **NUMERIC** - 精确数值

### 10.3 日期时间类型
- **DATE** - 日期类型（包含时间）
- **TIMESTAMP** - 带时区的日期时间

## 11. 数据库对象命名规范

### 11.1 表命名
- 使用复数形式（customers而不是customer）
- 使用小写字母
- 使用下划线分隔单词

### 11.2 约束命名
- 主键：表名_pk
- 外键：表名_字段名_fk
- 唯一约束：表名_字段名_uk

## 12. 性能优化考虑

### 12.1 索引设计
- 主键自动创建索引
- 外键字段考虑创建索引
- 经常查询的字段考虑创建索引

### 12.2 数据类型选择
- 选择适当的字段长度
- 使用适合的数据类型
- 考虑存储空间和性能平衡

### 12.3 批量操作
- 使用INSERT ALL进行批量插入
- 大量数据操作时使用事务控制
- 考虑使用临时表进行大量数据处理

## 13. 错误处理

### 13.1 异常捕获
```sql
BEGIN
    -- 操作语句
EXCEPTION
    WHEN OTHERS THEN
        -- 错误处理
END;
```

### 13.2 安全删除
```sql
-- 使用CASCADE CONSTRAINTS安全删除表
DROP TABLE table_name CASCADE CONSTRAINTS;
```

## 最佳实践补充

### 1. 数据库设计
- 遵循数据库范式
- 适当使用外键约束
- 合理设计字段类型和长度
- 考虑未来扩展性

### 2. 代码组织
- 使用适当的注释
- 保持代码缩进一致
- 使用有意义的对象命名
- 模块化SQL脚本

### 3. 安全性
- 使用参数化查询
- 实施适当的访问控制
- 定期备份数据
- 使用事务确保数据一致性 