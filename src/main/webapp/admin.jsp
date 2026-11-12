<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.library.model.User" %>

<%

    HttpSession sess = request.getSession(false);

    User user = (sess != null)
                ? (User) sess.getAttribute("user")
                : null;

    if (user == null || !"admin".equals(user.getRole())) {

        response.sendRedirect("login.jsp");

        return;
    }

%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>DC Library | Admin Panel</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">


    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        body {

            font-family: "Inter", "Segoe UI", Arial, sans-serif;

            min-height: 100vh;

            background: #f8fafc;

            color: #111827;
        }


        /* ==================================================
           SIDEBAR
        ================================================== */

        .sidebar {

            position: fixed;

            left: 0;

            top: 0;

            bottom: 0;

            width: 235px;

            padding: 25px 16px;

            background:
                linear-gradient(
                    180deg,
                    #111827,
                    #1e1b4b
                );

            color: white;

            display: flex;

            flex-direction: column;

            z-index: 100;
        }


        .logo {

            padding: 0 12px;

            margin-bottom: 38px;

            font-size: 21px;

            font-weight: 800;

            letter-spacing: -0.7px;
        }


        .logo span {

            color: #818cf8;
        }


        /* ==================================================
           NAVIGATION
        ================================================== */

        .nav-label {

            padding: 0 12px;

            margin-bottom: 10px;

            color: #6b7280;

            font-size: 9px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1px;
        }


        .nav-item {

            display: flex;

            align-items: center;

            gap: 11px;

            width: 100%;

            padding: 11px 12px;

            margin-bottom: 4px;

            border-radius: 8px;

            color: #c7d2fe;

            text-decoration: none;

            font-size: 11px;

            font-weight: 600;

            transition: 0.2s;
        }


        .nav-item:hover {

            color: white;

            background:
                rgba(255,255,255,0.08);
        }


        .nav-item.active {

            color: white;

            background:
                rgba(99,102,241,0.25);
        }


        .nav-icon {

            width: 19px;

            text-align: center;

            font-size: 14px;
        }


        .sidebar-bottom {

            margin-top: auto;
        }


        .logout {

            color: #fca5a5;
        }


        .logout:hover {

            color: #fecaca;

            background:
                rgba(239,68,68,0.10);
        }


        /* ==================================================
           MAIN CONTENT
        ================================================== */

        .main {

            margin-left: 235px;

            min-height: 100vh;
        }


        /* ==================================================
           TOP BAR
        ================================================== */

        .topbar {

            height: 70px;

            padding: 0 38px;

            background: white;

            border-bottom: 1px solid #e5e7eb;

            display: flex;

            align-items: center;

            justify-content: space-between;
        }


        .topbar-title {

            color: #111827;

            font-size: 13px;

            font-weight: 700;
        }


        .admin-profile {

            display: flex;

            align-items: center;

            gap: 10px;
        }


        .avatar {

            width: 34px;

            height: 34px;

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #eef2ff;

            color: #4f46e5;

            font-size: 13px;

            font-weight: 800;
        }


        .admin-info {

            display: flex;

            flex-direction: column;

            gap: 2px;
        }


        .admin-name {

            font-size: 11px;

            font-weight: 700;

            color: #111827;
        }


        .admin-role {

            color: #9ca3af;

            font-size: 9px;
        }


        /* ==================================================
           CONTENT
        ================================================== */

        .content {

            max-width: 1150px;

            margin: auto;

            padding: 42px 38px 60px;
        }


        /* ==================================================
           WELCOME
        ================================================== */

        .welcome {

            margin-bottom: 30px;
        }


        .welcome-label {

            color: #4f46e5;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1px;

            margin-bottom: 7px;
        }


        .welcome h1 {

            font-size: 30px;

            letter-spacing: -1.2px;

            margin-bottom: 7px;
        }


        .welcome p {

            color: #6b7280;

            font-size: 12px;

            line-height: 1.6;
        }


        /* ==================================================
           QUICK ACTIONS
        ================================================== */

        .section-heading {

            margin-bottom: 14px;

            font-size: 14px;

            font-weight: 700;
        }


        .action-grid {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 16px;
        }


        .action-card {

            position: relative;

            padding: 22px;

            background: white;

            border: 1px solid #e5e7eb;

            border-radius: 12px;

            text-decoration: none;

            color: #111827;

            transition: 0.25s;

            overflow: hidden;
        }


        .action-card:hover {

            transform: translateY(-3px);

            border-color: #c7d2fe;

            box-shadow:
                0 12px 25px rgba(15,23,42,0.08);
        }


        .action-icon {

            width: 42px;

            height: 42px;

            border-radius: 10px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #eef2ff;

            color: #4f46e5;

            font-size: 19px;

            margin-bottom: 17px;
        }


        .action-card h3 {

            font-size: 13px;

            margin-bottom: 6px;
        }


        .action-card p {

            color: #6b7280;

            font-size: 10.5px;

            line-height: 1.6;
        }


        .action-arrow {

            position: absolute;

            right: 18px;

            top: 20px;

            color: #9ca3af;

            font-size: 13px;

            transition: 0.2s;
        }


        .action-card:hover .action-arrow {

            color: #4f46e5;

            transform: translateX(3px);
        }


        /* ==================================================
           ADMIN INFO CARD
        ================================================== */

        .info-card {

            margin-top: 25px;

            padding: 20px 22px;

            background:
                linear-gradient(
                    135deg,
                    #eef2ff,
                    #f5f3ff
                );

            border: 1px solid #e0e7ff;

            border-radius: 12px;

            display: flex;

            align-items: center;

            gap: 15px;
        }


        .info-icon {

            width: 40px;

            height: 40px;

            flex-shrink: 0;

            border-radius: 9px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: white;

            color: #4f46e5;

            font-size: 17px;
        }


        .info-text h3 {

            color: #312e81;

            font-size: 12px;

            margin-bottom: 4px;
        }


        .info-text p {

            color: #6366f1;

            font-size: 10.5px;

            line-height: 1.5;
        }


        /* ==================================================
           FOOTER
        ================================================== */

        .footer {

            margin-top: 55px;

            padding-top: 20px;

            border-top: 1px solid #e5e7eb;

            color: #9ca3af;

            font-size: 10px;
        }


        .footer strong {

            color: #4f46e5;
        }


        /* ==================================================
           RESPONSIVE
        ================================================== */

        @media (max-width: 850px) {

            .sidebar {

                width: 190px;
            }


            .main {

                margin-left: 190px;
            }


            .action-grid {

                grid-template-columns: 1fr;
            }


            .content {

                padding: 35px 25px 50px;
            }


            .topbar {

                padding: 0 25px;
            }
        }


        @media (max-width: 600px) {

            .sidebar {

                position: static;

                width: 100%;

                height: auto;

                padding: 16px;

                display: block;
            }


            .logo {

                margin-bottom: 15px;

                padding: 0 5px;
            }


            .nav-label {

                display: none;
            }


            .nav-item {

                display: inline-flex;

                width: auto;

                margin-right: 4px;

                padding: 8px 9px;
            }


            .nav-icon {

                font-size: 12px;
            }


            .sidebar-bottom {

                display: inline;
            }


            .main {

                margin-left: 0;
            }


            .topbar {

                height: 60px;

                padding: 0 18px;
            }


            .content {

                padding: 28px 18px 45px;
            }


            .welcome h1 {

                font-size: 26px;
            }


            .action-grid {

                gap: 12px;
            }


            .info-card {

                align-items: flex-start;
            }
        }

    </style>

</head>


<body>


<!-- ==================================================
     SIDEBAR
================================================== -->

<aside class="sidebar">


    <div class="logo">

        DC<span>Library</span>

    </div>


    <div class="nav-label">

        Management

    </div>


    <a href="admin.jsp"
       class="nav-item active">

        <span class="nav-icon">▦</span>

        Dashboard

    </a>


    <a href="addBook.jsp"
       class="nav-item">

        <span class="nav-icon">＋</span>

        Add New Book

    </a>


    <a href="manageBooks.jsp"
       class="nav-item">

        <span class="nav-icon">📚</span>

        Manage Books

    </a>


    <a href="index.jsp"
       class="nav-item">

        <span class="nav-icon">⌂</span>

        View Library

    </a>


    <div class="sidebar-bottom">

        <div class="nav-label">

            Account

        </div>


        <a href="logout"
           class="nav-item logout">

            <span class="nav-icon">↪</span>

            Logout

        </a>

    </div>


</aside>


<!-- ==================================================
     MAIN
================================================== -->

<main class="main">


    <!-- TOP BAR -->

    <header class="topbar">


        <div class="topbar-title">

            Admin Dashboard

        </div>


        <div class="admin-profile">


            <div class="avatar">

                <%= user.getName().substring(0, 1).toUpperCase() %>

            </div>


            <div class="admin-info">

                <div class="admin-name">

                    <%= user.getName() %>

                </div>


                <div class="admin-role">

                    Administrator

                </div>

            </div>


        </div>


    </header>


    <!-- CONTENT -->

    <div class="content">


        <!-- WELCOME -->

        <section class="welcome">


            <div class="welcome-label">

                Administration

            </div>


            <h1>

                Welcome, <%= user.getName() %>.

            </h1>


            <p>

                Manage your library, books and catalogue
                from one central dashboard.

            </p>


        </section>


        <!-- ACTIONS -->

        <h2 class="section-heading">

            Quick Actions

        </h2>


        <div class="action-grid">


            <!-- ADD BOOK -->

            <a href="addBook.jsp"
               class="action-card">


                <div class="action-icon">

                    ＋

                </div>


                <h3>

                    Add New Book

                </h3>


                <p>

                    Add a new book to your library
                    catalogue.

                </p>


                <span class="action-arrow">

                    →

                </span>


            </a>


            <!-- MANAGE BOOKS -->

            <a href="manageBooks.jsp"
               class="action-card">


                <div class="action-icon">

                    📚

                </div>


                <h3>

                    Manage Books

                </h3>


                <p>

                    View, edit or remove books
                    from the catalogue.

                </p>


                <span class="action-arrow">

                    →

                </span>


            </a>


            <!-- VIEW LIBRARY -->

            <a href="index.jsp"
               class="action-card">


                <div class="action-icon">

                    👁

                </div>


                <h3>

                    View Library

                </h3>


                <p>

                    Browse the customer-facing
                    library catalogue.

                </p>


                <span class="action-arrow">

                    →

                </span>


            </a>


        </div>


        <!-- INFO -->

        <div class="info-card">


            <div class="info-icon">

                ✓

            </div>


            <div class="info-text">


                <h3>

                    Administrator Access

                </h3>


                <p>

                    You are signed in with administrator
                    privileges and can manage the library catalogue.

                </p>


            </div>


        </div>


        <!-- FOOTER -->

        <div class="footer">

            © <%= java.time.Year.now() %>

            <strong>DC Library</strong> ·

            Admin Management Panel

        </div>


    </div>


</main>


</body>

</html>
