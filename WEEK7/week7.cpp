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
        stmt->setSQL("SELECT * FROM students WHERE age > :1");

        // 获取并打印当前SQL语句
        string currentSQL = stmt->getSQL();
        cout << "Current SQL: " << currentSQL << endl;

        // 绑定参数并执行查询
        stmt->setInt(1, 18);
        ResultSet* rs = stmt->executeQuery();

        // 处理结果集
        while (rs->next()) {
            // 处理每一行数据
        }

        // 释放资源
        stmt->closeResultSet(rs);
        conn->terminateStatement(stmt);
        env->terminateConnection(conn);
    } catch (SQLException& e) {
        cerr << "SQL Error: " << e.what() << endl;
    }

    Environment::terminateEnvironment(env);
    return 0;
}