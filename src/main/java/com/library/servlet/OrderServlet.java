package com.library.servlet;

import com.library.dao.CartDAO;
import com.library.dao.OrderDAO;
import com.library.model.CartItem;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/placeOrder")
public class OrderServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = ((com.library.model.User)session.getAttribute("user")).getId();
        // Place order for all items in cart
        List<CartItem> cartItems = CartDAO.getCartItems(userId);
        for (CartItem item : cartItems) {
            OrderDAO.placeOrder(userId, item.getBook().getId(), item.getQuantity());
        }
        CartDAO.clearCart(userId);
        response.sendRedirect("orders.jsp");
    }
}