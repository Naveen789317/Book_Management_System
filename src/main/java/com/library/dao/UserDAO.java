package com.library.dao;

import com.library.model.User;
import com.library.util.DBConnection;

import java.sql.*;

public class UserDAO {
    
    public static boolean register(User user) {
        boolean flag = false;
        String cleanName = (user.getName() != null) ? user.getName().trim() : "";
        String cleanEmail = (user.getEmail() != null) ? user.getEmail().trim() : "";
        String rawPassword = (user.getPassword() != null) ? user.getPassword() : "";
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return false;
            }
            try (PreparedStatement ps = con.prepareStatement("INSERT INTO users (name, email, password, role) VALUES (?,?,?, 'user')")) {
                ps.setString(1, cleanName);
                ps.setString(2, cleanEmail);
                ps.setString(3, rawPassword);
                int i = ps.executeUpdate();
                if (i > 0) flag = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }
    
    public static User login(String email, String password) {
        User user = null;
        String cleanEmail = (email != null) ? email.trim() : "";
        String rawPassword = (password != null) ? password : "";
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                return null;
            }
            try (PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=? AND password=?")) {
                ps.setString(1, cleanEmail);
                ps.setString(2, rawPassword);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user = new User();
                        user.setId(rs.getInt("id"));
                        user.setName(rs.getString("name"));
                        user.setEmail(rs.getString("email"));
                        user.setRole(rs.getString("role"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
    
    // MD5 hashing (for demo; use stronger hash for production)
    /*  //HASHING FOR FUTURE USE
    private static String md5(String input) {

        try {

            java.security.MessageDigest md =
                java.security.MessageDigest.getInstance("MD5");

            byte[] digest = md.digest(input.getBytes());

            StringBuilder sb = new StringBuilder();

            for (byte b : digest) {

                sb.append(String.format("%02x", b));

            }

            return sb.toString();

        } catch (Exception e) {

            return input;

        }
    }
    */
   
}