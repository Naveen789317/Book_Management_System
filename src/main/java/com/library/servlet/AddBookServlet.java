package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.model.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addBook")
public class AddBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String imageUrl = request.getParameter("imageUrl");
        
        Book book = new Book();
        book.setTitle(title);
        book.setAuthor(author);
        book.setPrice(price);
        book.setQuantity(quantity);
        book.setImageUrl(imageUrl);
        
        boolean success = BookDAO.addBook(book);
        if (success) {
            request.setAttribute("message", "Book added successfully!");
        } else {
            request.setAttribute("error", "Failed to add book.");
        }
        request.getRequestDispatcher("addBook.jsp").forward(request, response);
    }
}