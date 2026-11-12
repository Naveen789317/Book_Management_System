package com.library.servlet;

import com.library.dao.BookDAO;
import com.library.model.Book;
import com.library.util.AIService;
import com.library.util.AIService.SearchResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/smartSearch")
public class SmartSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleSearch(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleSearch(request, response);
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String query = request.getParameter("query");
        if (query == null || query.trim().isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        String trimmedQuery = query.trim();
        List<Book> allBooks = BookDAO.getAllBooks();
        SearchResult searchResult = AIService.smartSearchBookIds(trimmedQuery, allBooks, getServletContext());

        Map<Integer, Book> bookById = new HashMap<>();
        for (Book b : allBooks) {
            bookById.put(b.getId(), b);
        }

        List<Book> matchedBooks = new ArrayList<>();
        for (Integer id : searchResult.getBookIds()) {
            Book matched = bookById.get(id);
            if (matched != null) {
                matchedBooks.add(matched);
            }
        }

        request.setAttribute("books", matchedBooks);
        request.setAttribute("searchQuery", trimmedQuery);
        request.setAttribute("aiSearchActive", Boolean.TRUE);
        request.setAttribute("aiPowered", Boolean.valueOf(searchResult.isAiPowered()));
        request.setAttribute("aiStatusNote", searchResult.getStatusNote());

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
