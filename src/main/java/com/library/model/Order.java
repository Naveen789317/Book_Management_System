package com.library.model;

import java.sql.Timestamp;

public class Order {
    private int id;
    private String bookTitle;
    private String bookImage;      // NEW
    private int quantity;
    private Timestamp orderDate;
    
    public Order() {}
    
    public Order(int id, String bookTitle, String bookImage, int quantity, Timestamp orderDate) {
        this.id = id;
        this.bookTitle = bookTitle;
        this.bookImage = bookImage;
        this.quantity = quantity;
        this.orderDate = orderDate;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    
    public String getBookImage() { return bookImage; }
    public void setBookImage(String bookImage) { this.bookImage = bookImage; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
}