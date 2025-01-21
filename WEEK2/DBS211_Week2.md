# DBS211 Week2 - 数据库关系模型 (Database Relation Model) 📚

## 学习路径图 (Learning Path) 🗺️
```
数据库基础(Week1) → 关系模型 → 关系类型 → 参照完整性 → 表类型 → 键类型
Database Basics(Week1) → Relational Model → Relationship Types → Referential Integrity → Table Types → Key Types
```

## 目录 (Table of Contents) 📑
1. 关系模型基础
2. 关系类型
3. 参照完整性
4. 表类型
5. 键类型

## 知识点详解 (Detailed Content) 📝

### 关系模型 (Relational Model) 🟢
- 定义 | Definition
  - 中文：关系模型是一种基于数据之间关系的数据库模型，它将数据组织成相互关联的表格形式
  - English: The relational model is a database model based on relationships between data, organizing information into interconnected tables
- 特点 | Characteristics
  - 数据以表格形式存储 | Data stored in tables
  - 表之间存在关联关系 | Tables are related to each other
  - 使用SQL进行操作 | Uses SQL for operations

### 关系类型 (Relationship Types) 🟡
- 定义 | Definition
  - 描述数据库中表之间的联系类型
  - Describes the types of connections between tables in a database
- 主要类型 | Main Types
  1. 一对一 (One-to-One, 1:1)
  2. 一对多 (One-to-Many, 1:N)
  3. 多对多 (Many-to-Many, M:N)

### 参照完整性 (Referential Integrity) 🟡
- 定义 | Definition
  - 中文：确保表之间的关系保持一致性和有效性的规则
  - English: Rules ensuring consistency and validity of relationships between tables
- 重要性 | Importance
  - 防止孤立记录 | Prevents orphaned records
  - 维护数据一致性 | Maintains data consistency
  - 确保数据质量 | Ensures data quality

### 表类型 (Table Types) 🟢
- 基本类型 | Basic Types
  1. 实体表 (Entity Tables)
     - 存储主要业务对象
     - Stores primary business objects
  2. 关系表 (Relationship Tables)
     - 连接其他表之间的关系
     - Connects relationships between other tables
  3. 属性表 (Attribute Tables)
     - 存储附加信息
     - Stores additional information

### 键类型 (Key Types) 🟡
- 主要类型 | Main Types
  1. 主键 (Primary Key)
  2. 外键 (Foreign Key)
  3. 候选键 (Candidate Key)
  4. 超键 (Super Key)
  5. 替代键 (Alternate Key)

### 约束 (Constraints) 🟡
- 定义 | Definition
  - 中文：约束是用于限制表中数据的规则，以确保数据的完整性和有效性。
  - English: Constraints are rules that limit the data in a table to ensure its integrity and validity.
  
- 主要类型 | Main Types
  1. **主键约束 (Primary Key Constraint)**: 确保表中的每一行都是唯一的。
     - Ensures that each row in the table is unique.
  2. **外键约束 (Foreign Key Constraint)**: 确保表之间的关系有效，防止孤立记录。
     - Ensures that relationships between tables are valid, preventing orphaned records.
  3. **唯一约束 (Unique Constraint)**: 确保某一列的值在表中是唯一的。
     - Ensures that the values in a column are unique across the table.
  4. **检查约束 (Check Constraint)**: 确保列中的值满足特定条件。
     - Ensures that the values in a column meet specific conditions.

## FAQ (常见问题) ❓
1. 什么是关系模型的优势？
   - 数据独立性高
   - 易于维护
   - 数据一致性好
   
2. 为什么需要参照完整性？
   - 确保数据的准确性
   - 防止数据不一致
   - 维护数据质量

## 实践示例 (Practice Examples) 💻
```sql
-- 创建带有主键的表
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

-- 创建带有外键的表
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    student_id INT,
    course_name VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- 创建带有约束的表
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,  -- 主键约束
    name VARCHAR(50) NOT NULL,    -- 非空约束
    email VARCHAR(100) UNIQUE,     -- 唯一约束
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)  -- 外键约束
);

-- 创建部门表
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,  -- 主键约束
    department_name VARCHAR(50) NOT NULL CHECK (department_name <> '')  -- 检查约束
);
```

## 学习建议 (Study Tips) 💡
1. 先理解关系模型的基本概念
2. 通过实际例子理解不同类型的关系
3. 重点掌握参照完整性的重要性
4. 多练习创建表和定义键的SQL语句

## 版本信息 (Version Info) 📌
- 版本号：v1.0
- 更新日期：[当前日期]
- 更新内容：初始版本创建 