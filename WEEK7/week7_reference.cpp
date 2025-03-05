#include <iostream>
#include <occi.h>

using namespace oracle::occi;
using namespace std;

int main() {
    Environment* env = nullptr;
    Connection* conn = nullptr;
    Statement* stmt = nullptr;

    try {
        // 创建环境并连接数据库
        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection("username", "password", "myoracle2c.senecacollege.ca:1521/orcl12c");

        // 创建语句对象
        stmt = conn->createStatement();

        // 设置SQL语句
        stmt->setSQL("BEGIN countStudents(:1, :2); END;");

        // 设置第一个参数（IN参数）
        stmt->setString(1, "CPA");

        // 注册第二个参数（OUT参数）
        int count;
        stmt->registerOutParam(2, Type::OCCIINT, sizeof(count));

        // 执行存储过程
        stmt->executeUpdate();

        // 获取返回值
        count = stmt->getInt(2);
        cout << "Number of CPA students: " << count << endl;

        // 释放资源
        conn->terminateStatement(stmt);
        env->terminateConnection(conn);
    } catch (SQLException& e) {
        cerr << "SQL Error: " << e.what() << endl;
    }

    Environment::terminateEnvironment(env);
    return 0;
}

/*
CREATE PROCEDURE countStudents(IN program VARCHAR, OUT student_count INT)
BEGIN
    SELECT COUNT(*) INTO student_count FROM students WHERE program = program;
END;
*/