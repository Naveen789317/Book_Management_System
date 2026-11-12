package com.library.dao;

import com.library.model.Book;
import com.library.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    
    public static boolean addBook(Book book) {
        boolean flag = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO books (title, author, price, quantity, image_url) VALUES (?,?,?,?,?)");
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setDouble(3, book.getPrice());
            ps.setInt(4, book.getQuantity());
            ps.setString(5, book.getImageUrl());
            int i = ps.executeUpdate();
            if (i > 0) flag = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }

    // NEW: Update an existing book
    public static boolean updateBook(Book book) {
        boolean flag = false;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE books SET title=?, author=?, price=?, quantity=?, image_url=? WHERE id=?");
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setDouble(3, book.getPrice());
            ps.setInt(4, book.getQuantity());
            ps.setString(5, book.getImageUrl());
            ps.setInt(6, book.getId());
            int i = ps.executeUpdate();
            if (i > 0) flag = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }

    // NEW: Delete a book (also removes it from users' carts)
    public static boolean deleteBook(int bookId) {
        boolean flag = false;
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            // Remove from carts first (cart has FK to books)
            PreparedStatement delCart = con.prepareStatement("DELETE FROM cart WHERE book_id=?");
            delCart.setInt(1, bookId);
            delCart.executeUpdate();

            PreparedStatement ps = con.prepareStatement("DELETE FROM books WHERE id=?");
            ps.setInt(1, bookId);
            int i = ps.executeUpdate();
            if (i > 0) flag = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }
    
    public static List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM books");
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static Book getBookById(int id) {
        Book book = null;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM books WHERE id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                book = mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return book;
    }

    // Helper to map a ResultSet row to a Book
    private static Book mapRow(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setPrice(rs.getDouble("price"));
        book.setQuantity(rs.getInt("quantity"));
        book.setImageUrl(rs.getString("image_url"));
        return book;
    }
}