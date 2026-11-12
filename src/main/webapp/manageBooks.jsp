
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.dao.BookDAO, com.library.model.*, java.util.List"%>

<%
    HttpSession sess = request.getSession(false);

    User user = (sess != null) ? (User) sess.getAttribute("user") : null;

    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String msg = (String) sess.getAttribute("msg");
    sess.removeAttribute("msg");

    List<Book> books = BookDAO.getAllBooks();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Manage Books | DC Library</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
        rel="stylesheet"
    >

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #f8fafc;
            color: #111827;
            min-height: 100vh;
        }

        /* =========================
           SIDEBAR
        ========================= */

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 250px;
            height: 100vh;
            background: linear-gradient(180deg, #111827 0%, #1e1b4b 100%);
            color: white;
            padding: 28px 18px;
            z-index: 100;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0 12px 30px;
            border-bottom: 1px solid rgba(255,255,255,0.10);
            margin-bottom: 25px;
        }

        .logo-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 21px;
        }

        .logo-text {
            font-size: 20px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .logo-text span {
            display: block;
            font-size: 10px;
            color: #a5b4fc;
            font-weight: 500;
            letter-spacing: 1px;
            margin-top: 2px;
        }

        .nav-title {
            color: #818cf8;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            padding: 0 12px;
            margin-bottom: 10px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            margin-bottom: 5px;
            border-radius: 10px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: 0.2s ease;
        }

        .nav-link:hover {
            background: rgba(255,255,255,0.08);
            color: white;
        }

        .nav-link.active {
            background: linear-gradient(135deg, #4f46e5, #6366f1);
            color: white;
            box-shadow: 0 8px 20px rgba(79,70,229,0.25);
        }

        .nav-icon {
            width: 20px;
            text-align: center;
            font-size: 16px;
        }

        .sidebar-bottom {
            position: absolute;
            bottom: 25px;
            left: 18px;
            right: 18px;
        }

        .sidebar-user {
            border-top: 1px solid rgba(255,255,255,0.10);
            padding: 18px 10px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: #4f46e5;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 700;
        }

        .user-info {
            min-width: 0;
        }

        .user-name {
            font-size: 12px;
            font-weight: 600;
            color: white;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .user-role {
            font-size: 10px;
            color: #94a3b8;
            margin-top: 2px;
        }

        /* =========================
           MAIN
        ========================= */

        .main {
            margin-left: 250px;
            min-height: 100vh;
        }

        /* =========================
           TOPBAR
        ========================= */

        .topbar {
            height: 72px;
            background: white;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 42px;
        }

        .breadcrumb {
            font-size: 13px;
            color: #64748b;
        }

        .breadcrumb strong {
            color: #111827;
            font-weight: 600;
        }

        .admin-profile {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .profile-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #eef2ff;
            color: #4f46e5;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
        }

        .profile-name {
            font-size: 12px;
            font-weight: 600;
        }

        .profile-role {
            color: #94a3b8;
            font-size: 10px;
            margin-top: 2px;
        }

        /* =========================
           CONTENT
        ========================= */

        .content {
            padding: 42px;
            max-width: 1400px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            gap: 20px;
            margin-bottom: 28px;
        }

        .page-label {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            background: #eef2ff;
            color: #4f46e5;
            padding: 7px 11px;
            border-radius: 7px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            margin-bottom: 12px;
        }

        .page-header h1 {
            font-size: 30px;
            font-weight: 800;
            letter-spacing: -1px;
            color: #111827;
        }

        .page-header p {
            color: #64748b;
            font-size: 13px;
            margin-top: 7px;
        }

        .add-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            height: 43px;
            padding: 0 18px;
            border-radius: 9px;
            background: linear-gradient(135deg, #4f46e5, #6366f1);
            color: white;
            text-decoration: none;
            font-size: 11px;
            font-weight: 700;
            box-shadow: 0 7px 16px rgba(79,70,229,0.20);
            white-space: nowrap;
            transition: 0.2s ease;
        }

        .add-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(79,70,229,0.27);
        }

        /* =========================
           SUCCESS MESSAGE
        ========================= */

        .message {
            background: #ecfdf5;
            border: 1px solid #bbf7d0;
            color: #166534;
            padding: 13px 16px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 20px;
        }

        /* =========================
           STATS
        ========================= */

        .stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 22px;
        }

        .stat-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 13px;
            padding: 17px 20px;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .stat-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: #eef2ff;
            color: #4f46e5;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 17px;
        }

        .stat-label {
            color: #64748b;
            font-size: 10px;
            font-weight: 500;
        }

        .stat-value {
            color: #111827;
            font-size: 18px;
            font-weight: 800;
            margin-top: 2px;
        }

        /* =========================
           TABLE CARD
        ========================= */

        .table-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(15,23,42,0.04);
        }

        .table-header {
            padding: 19px 22px;
            border-bottom: 1px solid #eef2f7;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .table-header h2 {
            font-size: 14px;
            font-weight: 700;
        }

        .table-header span {
            font-size: 10px;
            color: #94a3b8;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 850px;
        }

        th {
            background: #f8fafc;
            color: #64748b;
            font-size: 9px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            padding: 13px 16px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 11px;
            color: #475569;
            vertical-align: middle;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tbody tr {
            transition: 0.15s ease;
        }

        tbody tr:hover {
            background: #fafbff;
        }

        /* =========================
           BOOK IMAGE
        ========================= */

        .book-image {
            width: 48px;
            height: 65px;
            object-fit: cover;
            border-radius: 6px;
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            display: block;
        }

        .book-title {
            font-weight: 700;
            color: #111827;
            max-width: 210px;
        }

        .book-author {
            color: #64748b;
            max-width: 170px;
        }

        .book-id {
            font-size: 10px;
            color: #94a3b8;
            font-weight: 600;
        }

        /* =========================
           PRICE
        ========================= */

        .price {
            color: #111827;
            font-weight: 700;
        }

        /* =========================
           STOCK BADGE
        ========================= */

        .stock {
            display: inline-flex;
            align-items: center;
            padding: 5px 9px;
            border-radius: 6px;
            font-size: 9px;
            font-weight: 700;
        }

        .stock.available {
            background: #ecfdf5;
            color: #15803d;
        }

        .stock.low {
            background: #fff7ed;
            color: #c2410c;
        }

        .stock.out {
            background: #fef2f2;
            color: #dc2626;
        }

        /* =========================
           ACTIONS
        ========================= */

        .actions {
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .action-btn {
            height: 31px;
            padding: 0 10px;
            border-radius: 7px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
            font-size: 9px;
            font-weight: 700;
            transition: 0.2s ease;
        }

        .edit-btn {
            background: #eef2ff;
            color: #4f46e5;
        }

        .edit-btn:hover {
            background: #e0e7ff;
        }

        .delete-btn {
            background: #fef2f2;
            color: #dc2626;
            border: none;
            cursor: pointer;
            font-family: inherit;
        }

        .delete-btn:hover {
            background: #fee2e2;
        }

        /* =========================
           EMPTY STATE
        ========================= */

        .empty-state {
            text-align: center;
            padding: 65px 20px;
        }

        .empty-icon {
            width: 55px;
            height: 55px;
            margin: 0 auto 15px;
            border-radius: 14px;
            background: #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        .empty-state h3 {
            font-size: 15px;
            color: #111827;
        }

        .empty-state p {
            color: #94a3b8;
            font-size: 11px;
            margin-top: 6px;
        }

        .empty-add {
            display: inline-flex;
            margin-top: 18px;
            padding: 9px 14px;
            border-radius: 8px;
            background: #eef2ff;
            color: #4f46e5;
            text-decoration: none;
            font-size: 10px;
            font-weight: 700;
        }

        /* =========================
           FOOTER
        ========================= */

        .footer {
            padding: 25px 42px;
            color: #94a3b8;
            font-size: 10px;
        }

        /* =========================
           RESPONSIVE
        ========================= */

        @media (max-width: 900px) {

            .sidebar {
                width: 210px;
            }

            .main {
                margin-left: 210px;
            }

            .content {
                padding: 30px;
            }

            .stats {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 650px) {

            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
                padding: 18px;
            }

            .logo {
                padding-bottom: 15px;
                margin-bottom: 15px;
            }

            .nav-title {
                display: none;
            }

            .nav-link {
                display: inline-flex;
                margin-right: 4px;
                padding: 9px;
            }

            .nav-link span:not(.nav-icon) {
                display: none;
            }

            .sidebar-bottom {
                display: none;
            }

            .main {
                margin-left: 0;
            }

            .topbar {
                padding: 0 20px;
                height: 62px;
            }

            .profile-name,
            .profile-role {
                display: none;
            }

            .content {
                padding: 25px 18px;
            }

            .page-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .page-header h1 {
                font-size: 25px;
            }

            .add-btn {
                width: 100%;
                justify-content: center;
            }

            .stats {
                grid-template-columns: 1fr;
            }

            .table-card {
                border-radius: 12px;
            }
        }

    </style>

</head>

<body>

    <!-- =========================
         SIDEBAR
    ========================== -->

    <aside class="sidebar">

        <div class="logo">

            <div class="logo-icon">
                📚
            </div>

            <div class="logo-text">
                DC Library
                <span>ADMIN CONSOLE</span>
            </div>

        </div>

        <div class="nav-title">
            Management
        </div>

        <a href="admin.jsp" class="nav-link">
            <span class="nav-icon">⌂</span>
            <span>Dashboard</span>
        </a>

        <a href="addBook.jsp" class="nav-link">
            <span class="nav-icon">＋</span>
            <span>Add New Book</span>
        </a>

        <a href="manageBooks.jsp" class="nav-link active">
            <span class="nav-icon">▤</span>
            <span>Manage Books</span>
        </a>

        <a href="index.jsp" class="nav-link">
            <span class="nav-icon">◉</span>
            <span>View Library</span>
        </a>

        <div class="sidebar-bottom">

            <div class="sidebar-user">

                <div class="avatar">
                    <%= user.getName().substring(0, 1).toUpperCase() %>
                </div>

                <div class="user-info">

                    <div class="user-name">
                        <%= user.getName() %>
                    </div>

                    <div class="user-role">
                        Administrator
                    </div>

                </div>

            </div>

            <a href="logout" class="nav-link" style="margin-top:10px;">
                <span class="nav-icon">↪</span>
                <span>Logout</span>
            </a>

        </div>

    </aside>


    <!-- =========================
         MAIN
    ========================== -->

    <main class="main">

        <!-- TOP BAR -->

        <header class="topbar">

            <div class="breadcrumb">
                Admin Console &nbsp;/&nbsp;
                <strong>Manage Books</strong>
            </div>

            <div class="admin-profile">

                <div class="profile-avatar">
                    <%= user.getName().substring(0, 1).toUpperCase() %>
                </div>

                <div>

                    <div class="profile-name">
                        <%= user.getName() %>
                    </div>

                    <div class="profile-role">
                        Administrator
                    </div>

                </div>

            </div>

        </header>


        <!-- PAGE CONTENT -->

        <section class="content">

            <!-- HEADER -->

            <div class="page-header">

                <div>

                    <div class="page-label">
                        📚 Catalogue
                    </div>

                    <h1>Manage Books</h1>

                    <p>
                        View, edit and manage the books available in your library.
                    </p>

                </div>

                <a href="addBook.jsp" class="add-btn">
                    ＋ Add New Book
                </a>

            </div>


            <!-- SUCCESS MESSAGE -->

            <% if (msg != null) { %>

                <div class="message">
                    ✓ &nbsp; <%= msg %>
                </div>

            <% } %>


            <!-- STATS -->

            <div class="stats">

                <div class="stat-card">

                    <div class="stat-icon">
                        📚
                    </div>

                    <div>
                        <div class="stat-label">
                            Total Books
                        </div>

                        <div class="stat-value">
                            <%= books.size() %>
                        </div>
                    </div>

                </div>


                <div class="stat-card">

                    <div class="stat-icon">
                        ✓
                    </div>

                    <div>

                        <div class="stat-label">
                            In Stock
                        </div>

                        <div class="stat-value">

                            <%
                                int inStock = 0;

                                for (Book book : books) {
                                    if (book.getQuantity() > 0) {
                                        inStock++;
                                    }
                                }
                            %>

                            <%= inStock %>

                        </div>

                    </div>

                </div>


                <div class="stat-card">

                    <div class="stat-icon">
                        ⚠
                    </div>

                    <div>

                        <div class="stat-label">
                            Out of Stock
                        </div>

                        <div class="stat-value">

                            <%
                                int outOfStock = 0;

                                for (Book book : books) {
                                    if (book.getQuantity() == 0) {
                                        outOfStock++;
                                    }
                                }
                            %>

                            <%= outOfStock %>

                        </div>

                    </div>

                </div>

            </div>


            <!-- BOOK TABLE -->

            <div class="table-card">

                <div class="table-header">

                    <h2>Book Catalogue</h2>

                    <span>
                        <%= books.size() %> book(s)
                    </span>

                </div>


                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>
                                <th>Book</th>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Author</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Actions</th>
                            </tr>

                        </thead>


                        <tbody>

                        <%
                            if (books.isEmpty()) {
                        %>

                            <tr>

                                <td colspan="7">

                                    <div class="empty-state">

                                        <div class="empty-icon">
                                            📚
                                        </div>

                                        <h3>
                                            No books found
                                        </h3>

                                        <p>
                                            Your library catalogue is currently empty.
                                        </p>

                                        <a
                                            href="addBook.jsp"
                                            class="empty-add"
                                        >
                                            ＋ Add Your First Book
                                        </a>

                                    </div>

                                </td>

                            </tr>

                        <%
                            } else {

                                for (Book b : books) {

                                    String img = b.getImageUrl();

                                    if (img == null || img.trim().isEmpty()) {
                                        img = "https://picsum.photos/id/237/200/280";
                                    }
                        %>

                            <tr>

                                <!-- IMAGE -->

                                <td>

                                    <img
                                        src="<%= img %>"
                                        class="book-image"
                                        alt="<%= b.getTitle() %>"
                                    >

                                </td>


                                <!-- ID -->

                                <td>
                                    <span class="book-id">
                                        #<%= b.getId() %>
                                    </span>
                                </td>


                                <!-- TITLE -->

                                <td>

                                    <div class="book-title">
                                        <%= b.getTitle() %>
                                    </div>

                                </td>


                                <!-- AUTHOR -->

                                <td>

                                    <div class="book-author">

                                        <%= (b.getAuthor() == null ||
                                             b.getAuthor().trim().isEmpty())
                                             ? "—"
                                             : b.getAuthor() %>

                                    </div>

                                </td>


                                <!-- PRICE -->

                                <td>

                                    <span class="price">
                                        &#8377;<%= b.getPrice() %>
                                    </span>

                                </td>


                                <!-- STOCK -->

                                <td>

                                    <%
                                        if (b.getQuantity() == 0) {
                                    %>

                                        <span class="stock out">
                                            Out of Stock
                                        </span>

                                    <%
                                        } else if (b.getQuantity() <= 5) {
                                    %>

                                        <span class="stock low">
                                            Low · <%= b.getQuantity() %>
                                        </span>

                                    <%
                                        } else {
                                    %>

                                        <span class="stock available">
                                            <%= b.getQuantity() %> Available
                                        </span>

                                    <%
                                        }
                                    %>

                                </td>


                                <!-- ACTIONS -->

                                <td>

                                    <div class="actions">

                                        <a
                                            href="editBook.jsp?id=<%= b.getId() %>"
                                            class="action-btn edit-btn"
                                        >
                                            ✎ Edit
                                        </a>

                                        <button
                                            type="button"
                                            class="action-btn delete-btn"
                                            onclick="confirmDelete(<%= b.getId() %>, '<%= b.getTitle().replace("'", "\\'") %>')"
                                        >
                                            🗑 Delete
                                        </button>

                                    </div>

                                </td>

                            </tr>

                        <%
                                }
                            }
                        %>

                        </tbody>

                    </table>

                </div>

            </div>

        </section>


        <!-- FOOTER -->

        <footer class="footer">
            © 2026 DC Library · Admin Console
        </footer>

    </main>


    <!-- =========================
         DELETE CONFIRMATION
    ========================== -->

    <script>

        function confirmDelete(id, title) {

            if (
                confirm(
                    "Are you sure you want to delete \"" +
                    title +
                    "\"?"
                )
            ) {

                window.location.href =
                    "deleteBook?id=" + id;

            }

        }

    </script>

</body>

</html>

