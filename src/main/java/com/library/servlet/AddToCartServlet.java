package com.library.servlet;

import com.library.dao.CartDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = ((com.library.model.User)session.getAttribute("user")).getId();
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int quantity = 1; // default quantity 1
        boolean success = CartDAO.addToCart(userId, bookId, quantity);
        if (success) {
            response.sendRedirect("cart.jsp");
        } else {
            response.getWriter().println("Failed to add to cart.");
        }
    }
}