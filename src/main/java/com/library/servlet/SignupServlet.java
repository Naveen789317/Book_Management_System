package com.library.servlet;

import com.library.dao.UserDAO;
import com.library.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        
        boolean success = UserDAO.register(user);
        if (success) {
            response.sendRedirect("login.jsp?success=1");
        } else {
            request.setAttribute("error", "Registration failed. Email might already exist.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}