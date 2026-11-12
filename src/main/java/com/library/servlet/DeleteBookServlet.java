package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/deleteBook")
public class DeleteBookServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin check
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("id"));
        boolean success = BookDAO.deleteBook(bookId);

        if (success) {
            request.getSession().setAttribute("msg", "Book deleted successfully!");
        } else {
            request.getSession().setAttribute("msg", "Failed to delete book!");
        }
        response.sendRedirect("manageBooks.jsp");
    }
}