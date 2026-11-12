package com.library.servlet;

import com.library.dao.UserDAO;
import com.library.model.User;
import com.library.util.DBConnection;

import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        User user = UserDAO.login(email, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("admin.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            String errorMessage = "Invalid email or password";
            try (Connection con = DBConnection.getConnection()) {
                if (con == null) {
                    errorMessage = "Unable to connect to the database. Please check database settings.";
                }
            } catch (Exception ignored) {
                errorMessage = "Unable to connect to the database. Please check database settings.";
            }
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}