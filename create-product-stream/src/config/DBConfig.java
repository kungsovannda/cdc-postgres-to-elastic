package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConfig {

    private static final String USERNAME = "postgres";
    private static final String PASSWORD = "post";
    private static final String URL = "jdbc:postgresql://localhost:5168/postgres";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
