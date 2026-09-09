package com.armora.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Database credentials
    private static final String URL = "jdbc:mysql://localhost:3306/armora_db";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Update your DB password here

    /**
     * Establishes and returns a database connection.
     */
    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Load the MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found. Ensure the MySQL connector JAR is in your WEB-INF/lib.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection failed. Please check your URL, User, and Password.");
            e.printStackTrace();
        }
        return connection;
    }
}
