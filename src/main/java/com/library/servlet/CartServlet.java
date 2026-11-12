package com.library.servlet;

import com.library.dao.CartDAO;
import com.library.model.CartItem;
import com.library.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/viewCart")
public class CartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        // Retrieve cart items for the user
        List<CartItem> cartItems = CartDAO.getCartItems(userId);

        // Set as request attribute
        request.setAttribute("cartItems", cartItems);

        // Forward to cart.jsp
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
}