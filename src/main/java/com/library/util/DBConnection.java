package com.library.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        String url = "jdbc:mysql://localhost:3306/dc_library_ai";
        String userName = "root";
        String password = "Naveen@123";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, userName, password);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
