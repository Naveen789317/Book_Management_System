package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.dao.CartDAO;
import com.library.model.Book;
import com.library.model.CartItem;
import com.library.model.User;
import com.library.util.AIService;
import com.library.util.AIService.ChatResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;

@WebServlet("/chatBot")
public class ChatBotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print("{\"status\":\"ready\",\"service\":\"DC Library AI Assistant\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String message = request.getParameter("message");
        if (message == null) {
            message = "";
        }

        List<Book> catalog = BookDAO.getAllBooks();

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        List<CartItem> cartItems = (user != null)
                ? CartDAO.getCartItems(user.getId())
                : Collections.emptyList();

        ChatResult result = AIService.askLibraryAssistant(
                message,
                catalog,
                cartItems,
                user,
                getServletContext()
        );

        String jsonResponse = "{"
                + "\"reply\":\"" + AIService.escapeJson(result.getReply()) + "\","
                + "\"aiPowered\":" + result.isAiPowered()
                + "}";

        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse);
        }
    }
}
