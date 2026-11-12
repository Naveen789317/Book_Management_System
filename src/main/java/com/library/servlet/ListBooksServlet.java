package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.model.Book;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/listBooks")
public class ListBooksServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch all books from the database
        List<Book> books = BookDAO.getAllBooks();

        // Set as request attribute
        request.setAttribute("books", books);

        // Forward to index.jsp (which will display them)
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}