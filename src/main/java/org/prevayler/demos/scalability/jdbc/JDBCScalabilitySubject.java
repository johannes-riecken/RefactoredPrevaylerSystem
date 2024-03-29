//Contributions by Stefan Ortmanns.

package org.prevayler.demos.scalability.jdbc;

import org.prevayler.demos.scalability.*;
import java.sql.*;


abstract class JDBCScalabilitySubject implements ScalabilityTestSubject {

    protected final String connectionURL;
    protected final String user;
    protected final String password;

    {System.gc();}


    protected JDBCScalabilitySubject(String jdbcDriverClassName, String connectionURL, String user, String password) {
        try {
            Class.forName(jdbcDriverClassName);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Exception loading JDBC driver class: " + jdbcDriverClassName);
        }

        this.connectionURL = connectionURL;
        this.user = user;
        this.password = password;
    }

    @Override
    public String name() {
        return "JDBC";
    }

    @Override
    public void replaceAllRecords(int records) {
        ((JDBCScalabilityConnection)createTestConnection()).replaceAllRecords(records);
    }

    protected Connection createConnection() {
        try {

            return DriverManager.getConnection(connectionURL, user, password);

        } catch (SQLException sqlx) {
            sqlx.printStackTrace();
            throw new RuntimeException("Exception while trying to connect: " + sqlx);
        }
    }
}
