package com.library.dao;

import com.library.model.Book;
import com.library.model.CartItem;
import com.library.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    
    public static boolean addToCart(int userId, int bookId, int quantity) {
        boolean flag = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement check = con.prepareStatement("SELECT * FROM cart WHERE user_id=? AND book_id=?");
            check.setInt(1, userId);
            check.setInt(2, bookId);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                PreparedStatement update = con.prepareStatement("UPDATE cart SET quantity = quantity + ? WHERE user_id=? AND book_id=?");
                update.setInt(1, quantity);
                update.setInt(2, userId);
                update.setInt(3, bookId);
                update.executeUpdate();
            } else {
                PreparedStatement insert = con.prepareStatement("INSERT INTO cart (user_id, book_id, quantity) VALUES (?,?,?)");
                insert.setInt(1, userId);
                insert.setInt(2, bookId);
                insert.setInt(3, quantity);
                insert.executeUpdate();
            }
            flag = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }
    
    public static List<CartItem> getCartItems(int userId) {
        List<CartItem> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT b.*, c.quantity AS cart_qty FROM cart c JOIN books b ON c.book_id = b.id WHERE c.user_id=?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setPrice(rs.getDouble("price"));
                book.setImageUrl(rs.getString("image_url"));   // ⬅️ THIS LINE WAS MISSING — now fixed
                int qty = rs.getInt("cart_qty");
                list.add(new CartItem(book, qty));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static boolean removeFromCart(int userId, int bookId) {
        boolean flag = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM cart WHERE user_id=? AND book_id=?");
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            int i = ps.executeUpdate();
            if (i > 0) flag = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }
    
    public static boolean clearCart(int userId) {
        boolean flag = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM cart WHERE user_id=?");
            ps.setInt(1, userId);
            ps.executeUpdate();
            flag = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }
}