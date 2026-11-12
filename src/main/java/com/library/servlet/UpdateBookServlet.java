package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.model.Book;
import com.library.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateBook")
public class UpdateBookServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin check
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String imageUrl = request.getParameter("imageUrl");

        Book book = new Book();
        book.setId(id);
        book.setTitle(title);
        book.setAuthor(author);
        book.setPrice(price);
        book.setQuantity(quantity);
        book.setImageUrl(imageUrl);

        boolean success = BookDAO.updateBook(book);

        if (success) {
            session.setAttribute("msg", "Book updated successfully!");
        } else {
            session.setAttribute("msg", "Failed to update book!");
        }
        response.sendRedirect("manageBooks.jsp");
    }
}