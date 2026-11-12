package com.library.dao;

import com.library.model.Order;
import com.library.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    public static boolean placeOrder(int userId, int bookId, int quantity) {
        boolean flag = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO orders (user_id, book_id, quantity) VALUES (?,?,?)");
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);
            ps.executeUpdate();
            PreparedStatement updateQty = con.prepareStatement("UPDATE books SET quantity = quantity - ? WHERE id=?");
            updateQty.setInt(1, quantity);
            updateQty.setInt(2, bookId);
            updateQty.executeUpdate();
            CartDAO.removeFromCart(userId, bookId);
            flag = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }
    
    public static List<Order> getOrders(int userId) {
        List<Order> orders = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            // LEFT JOIN so history stays visible even if a book is later deleted
            PreparedStatement ps = con.prepareStatement(
                "SELECT o.id, b.title, b.image_url, o.quantity, o.order_date " +
                "FROM orders o LEFT JOIN books b ON o.book_id=b.id WHERE o.user_id=?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setBookTitle(rs.getString("title"));
                order.setBookImage(rs.getString("image_url"));   // NEW
                order.setQuantity(rs.getInt("quantity"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }
}