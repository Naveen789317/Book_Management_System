
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.dao.BookDAO, com.library.model.*" %>

<%
    HttpSession sess = request.getSession(false);

    User user = (sess != null) ? (User) sess.getAttribute("user") : null;

    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));

    Book b = BookDAO.getBookById(id);

    if (b == null) {
        out.println("<p>Book not found!</p><a href='manageBooks.jsp'>Back</a>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Edit Book - <%= b.getTitle() %> | DC Library</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

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
            max-width: 1150px;
        }

        .page-header {
            margin-bottom: 30px;
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

        /* =========================
           EDIT LAYOUT
        ========================= */

        .edit-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 24px;
            align-items: start;
        }

        /* =========================
           BOOK PREVIEW
        ========================= */

        .preview-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 22px;
            box-shadow: 0 5px 20px rgba(15,23,42,0.04);
        }

        .preview-title {
            font-size: 12px;
            font-weight: 700;
            color: #475569;
            margin-bottom: 18px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .book-cover {
            width: 100%;
            height: 290px;
            object-fit: cover;
            border-radius: 10px;
            background: #f1f5f9;
            border: 1px solid #e5e7eb;
            display: block;
        }

        .preview-info {
            padding-top: 17px;
        }

        .preview-info h3 {
            font-size: 15px;
            font-weight: 700;
            line-height: 1.4;
            color: #111827;
        }

        .preview-author {
            color: #64748b;
            font-size: 11px;
            margin-top: 5px;
        }

        .book-id {
            display: inline-block;
            margin-top: 12px;
            padding: 5px 8px;
            background: #f1f5f9;
            color: #64748b;
            border-radius: 5px;
            font-size: 9px;
            font-weight: 600;
        }

        /* =========================
           FORM CARD
        ========================= */

        .form-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(15,23,42,0.04);
        }

        .form-card-header {
            padding-bottom: 20px;
            border-bottom: 1px solid #eef2f7;
            margin-bottom: 24px;
        }

        .form-card-header h2 {
            font-size: 18px;
            font-weight: 700;
            color: #111827;
        }

        .form-card-header p {
            color: #94a3b8;
            font-size: 11px;
            margin-top: 5px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        label {
            font-size: 11px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 7px;
        }

        .required {
            color: #ef4444;
        }

        input {
            width: 100%;
            height: 44px;
            border: 1px solid #dbe2ea;
            border-radius: 9px;
            padding: 0 13px;
            font-family: 'Inter', sans-serif;
            font-size: 12px;
            color: #111827;
            background: #fff;
            outline: none;
            transition: 0.2s ease;
        }

        input:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.10);
        }

        input::placeholder {
            color: #a8b2c1;
        }

        .input-help {
            font-size: 9px;
            color: #94a3b8;
            margin-top: 6px;
            line-height: 1.5;
        }

        /* =========================
           ACTIONS
        ========================= */

        .form-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-top: 28px;
            padding-top: 22px;
            border-top: 1px solid #eef2f7;
        }

        .cancel-btn {
            height: 43px;
            padding: 0 18px;
            border: 1px solid #dbe2ea;
            border-radius: 9px;
            background: white;
            color: #475569;
            text-decoration: none;
            font-size: 11px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            transition: 0.2s ease;
        }

        .cancel-btn:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }

        .update-btn {
            height: 43px;
            padding: 0 22px;
            border: none;
            border-radius: 9px;
            background: linear-gradient(135deg, #4f46e5, #6366f1);
            color: white;
            font-family: 'Inter', sans-serif;
            font-size: 11px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 7px 16px rgba(79,70,229,0.22);
            transition: 0.2s ease;
        }

        .update-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(79,70,229,0.28);
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

            .edit-layout {
                grid-template-columns: 1fr;
            }

            .preview-card {
                display: none;
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

            .page-header h1 {
                font-size: 25px;
            }

            .form-card {
                padding: 22px;
            }

            .form-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .form-group.full {
                grid-column: auto;
            }

            .form-actions {
                flex-direction: column-reverse;
                align-items: stretch;
            }

            .cancel-btn,
            .update-btn {
                justify-content: center;
                width: 100%;
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
            <div class="logo-icon">📚</div>

            <div class="logo-text">
                DC Library
                <span>ADMIN CONSOLE</span>
            </div>
        </div>

        <div class="nav-title">Management</div>

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
         MAIN CONTENT
    ========================== -->

    <main class="main">

        <!-- TOP BAR -->

        <header class="topbar">

            <div class="breadcrumb">
                Manage Books &nbsp;/&nbsp;
                <strong>Edit Book</strong>
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

            <div class="page-header">

                <div class="page-label">
                    ✎ Book Management
                </div>

                <h1>Edit Book</h1>

                <p>
                    Update the details of your book and keep your library catalogue accurate.
                </p>

            </div>


            <div class="edit-layout">

                <!-- BOOK PREVIEW -->

                <div class="preview-card">

                    <div class="preview-title">
                        Current Book
                    </div>

                    <%
                        String previewImg = b.getImageUrl();

                        if (previewImg == null || previewImg.trim().isEmpty()) {
                            previewImg = "https://picsum.photos/id/237/200/280";
                        }
                    %>

                    <img
                        src="<%= previewImg %>"
                        class="book-cover"
                        alt="<%= b.getTitle() %>"
                    >

                    <div class="preview-info">

                        <h3>
                            <%= b.getTitle() %>
                        </h3>

                        <div class="preview-author">
                            <%= (b.getAuthor() == null || b.getAuthor().trim().isEmpty())
                                ? "Author not specified"
                                : b.getAuthor() %>
                        </div>

                        <span class="book-id">
                            BOOK ID #<%= b.getId() %>
                        </span>

                    </div>

                </div>


                <!-- EDIT FORM -->

                <div class="form-card">

                    <div class="form-card-header">

                        <h2>Book Information</h2>

                        <p>
                            Modify the information below and save your changes.
                        </p>

                    </div>


                    <form action="updateBook" method="post">

                        <input
                            type="hidden"
                            name="id"
                            value="<%= b.getId() %>"
                        >


                        <div class="form-grid">

                            <!-- TITLE -->

                            <div class="form-group full">

                                <label>
                                    Book Title <span class="required">*</span>
                                </label>

                                <input
                                    type="text"
                                    name="title"
                                    value="<%= b.getTitle() %>"
                                    placeholder="Enter book title"
                                    required
                                >

                            </div>


                            <!-- AUTHOR -->

                            <div class="form-group">

                                <label>
                                    Author
                                </label>

                                <input
                                    type="text"
                                    name="author"
                                    value="<%= (b.getAuthor() == null ? "" : b.getAuthor()) %>"
                                    placeholder="Enter author name"
                                >

                            </div>


                            <!-- PRICE -->

                            <div class="form-group">

                                <label>
                                    Price <span class="required">*</span>
                                </label>

                                <input
                                    type="number"
                                    step="0.01"
                                    name="price"
                                    value="<%= b.getPrice() %>"
                                    placeholder="0.00"
                                    required
                                >

                            </div>


                            <!-- QUANTITY -->

                            <div class="form-group">

                                <label>
                                    Available Quantity <span class="required">*</span>
                                </label>

                                <input
                                    type="number"
                                    name="quantity"
                                    min="0"
                                    value="<%= b.getQuantity() %>"
                                    placeholder="Enter quantity"
                                    required
                                >

                            </div>


                            <!-- IMAGE URL -->

                            <div class="form-group">

                                <label>
                                    Book Image URL
                                </label>

                                <input
                                    type="text"
                                    name="imageUrl"
                                    value="<%= (b.getImageUrl() == null ? "" : b.getImageUrl()) %>"
                                    placeholder="https://example.com/book.jpg"
                                >

                                <div class="input-help">
                                    Use a direct JPG, PNG or WebP image URL.
                                </div>

                            </div>

                        </div>


                        <!-- ACTION BUTTONS -->

                        <div class="form-actions">

                            <a
                                href="manageBooks.jsp"
                                class="cancel-btn"
                            >
                                ← Cancel
                            </a>

                            <button
                                type="submit"
                                class="update-btn"
                            >
                                ✓ Update Book
                            </button>

                        </div>

                    </form>

                </div>

            </div>

        </section>


        <footer class="footer">
            © 2026 DC Library · Admin Console
        </footer>

    </main>

</body>
</html>

