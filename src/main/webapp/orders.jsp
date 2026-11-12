
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.dao.OrderDAO, com.library.model.*, java.util.List"%>

<%
    HttpSession sess = request.getSession(false);

    User user = (sess != null) ? (User) sess.getAttribute("user") : null;

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Order> orders = OrderDAO.getOrders(user.getId());
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Orders | DC Library</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

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

        a {
            text-decoration: none;
        }

        /* =========================
           NAVBAR
        ========================== */

        .navbar {
            height: 70px;
            background: #111827;
            color: white;

            display: flex;
            align-items: center;
            justify-content: space-between;

            padding: 0 6%;

            position: sticky;
            top: 0;

            z-index: 100;

            box-shadow: 0 3px 15px rgba(15, 23, 42, 0.12);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .brand-icon {
            width: 39px;
            height: 39px;

            border-radius: 10px;

            background: linear-gradient(
                135deg,
                #6366f1,
                #4f46e5
            );

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 19px;
        }

        .brand-name {
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .brand-subtitle {
            font-size: 8px;
            color: #a5b4fc;
            letter-spacing: 1px;
            margin-top: 2px;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .nav-link {
            color: #cbd5e1;

            font-size: 11px;
            font-weight: 500;

            padding: 9px 12px;

            border-radius: 7px;

            transition: 0.2s ease;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.08);
            color: white;
        }

        .nav-link.active {
            background: rgba(99, 102, 241, 0.18);
            color: #c7d2fe;
        }

        .logout {
            color: #fca5a5;
        }

        /* =========================
           PAGE HEADER
        ========================== */

        .page-header {
            background: linear-gradient(
                135deg,
                #111827 0%,
                #1e1b4b 100%
            );

            color: white;

            padding: 45px 6% 50px;
        }

        .header-inner {
            max-width: 1250px;
            margin: auto;
        }

        .header-label {
            display: inline-flex;
            align-items: center;
            gap: 7px;

            background: rgba(99, 102, 241, 0.18);

            color: #c7d2fe;

            padding: 7px 11px;

            border-radius: 7px;

            font-size: 9px;
            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.8px;

            margin-bottom: 13px;
        }

        .page-header h1 {
            font-size: 31px;
            font-weight: 800;

            letter-spacing: -1px;
        }

        .page-header p {
            color: #cbd5e1;

            font-size: 12px;

            margin-top: 7px;
        }

        /* =========================
           CONTENT
        ========================== */

        .content {
            max-width: 1250px;

            margin: -25px auto 0;

            padding: 0 6% 50px;

            position: relative;

            z-index: 2;
        }

        /* =========================
           ORDER CARD
        ========================== */

        .orders-card {
            background: white;

            border: 1px solid #e5e7eb;

            border-radius: 16px;

            overflow: hidden;

            box-shadow:
                0 7px 25px rgba(15, 23, 42, 0.05);
        }

        .orders-header {
            padding: 20px 23px;

            border-bottom: 1px solid #eef2f7;

            display: flex;

            align-items: center;

            justify-content: space-between;
        }

        .orders-header h2 {
            font-size: 14px;

            font-weight: 700;

            color: #111827;
        }

        .order-count {
            background: #f1f5f9;

            color: #64748b;

            padding: 6px 10px;

            border-radius: 6px;

            font-size: 9px;

            font-weight: 700;
        }

        /* =========================
           ORDER ITEM
        ========================== */

        .order-item {
            display: grid;

            grid-template-columns:
                85px
                1fr
                110px
                90px
                145px;

            align-items: center;

            gap: 18px;

            padding: 19px 23px;

            border-bottom: 1px solid #f1f5f9;

            transition: 0.2s ease;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .order-item:hover {
            background: #fafbff;
        }

        /* =========================
           BOOK IMAGE
        ========================== */

        .book-img {
            width: 62px;
            height: 84px;

            object-fit: cover;

            border-radius: 7px;

            border: 1px solid #e2e8f0;

            background: #f1f5f9;

            display: block;
        }

        /* =========================
           BOOK DETAILS
        ========================== */

        .book-details {
            min-width: 0;
        }

        .book-title {
            color: #111827;

            font-size: 12px;

            font-weight: 700;

            line-height: 1.5;

            max-width: 400px;
        }

        .book-meta {
            color: #94a3b8;

            font-size: 9px;

            margin-top: 5px;
        }

        /* =========================
           ORDER ID
        ========================== */

        .order-id {
            display: inline-flex;

            align-items: center;

            padding: 6px 9px;

            border-radius: 6px;

            background: #eef2ff;

            color: #4f46e5;

            font-size: 9px;

            font-weight: 700;
        }

        /* =========================
           QUANTITY
        ========================== */

        .quantity {
            display: inline-flex;

            align-items: center;

            justify-content: center;

            min-width: 30px;

            height: 28px;

            padding: 0 9px;

            border-radius: 7px;

            background: #f1f5f9;

            color: #334155;

            font-size: 10px;

            font-weight: 700;
        }

        /* =========================
           DATE
        ========================== */

        .order-date {
            color: #475569;

            font-size: 10px;

            font-weight: 500;

            line-height: 1.5;
        }

        /* =========================
           LABEL
        ========================== */

        .column-label {
            display: none;

            color: #94a3b8;

            font-size: 8px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.5px;

            margin-bottom: 4px;
        }

        /* =========================
           STATUS
        ========================== */

        .status {
            display: inline-flex;

            align-items: center;

            gap: 5px;

            padding: 6px 9px;

            border-radius: 6px;

            background: #ecfdf5;

            color: #15803d;

            font-size: 8px;

            font-weight: 700;
        }

        .status-dot {
            width: 5px;
            height: 5px;

            border-radius: 50%;

            background: #22c55e;
        }

        /* =========================
           EMPTY STATE
        ========================== */

        .empty-orders {
            background: white;

            border: 1px solid #e5e7eb;

            border-radius: 16px;

            padding: 75px 25px;

            text-align: center;

            box-shadow:
                0 7px 25px rgba(15, 23, 42, 0.04);
        }

        .empty-icon {
            width: 65px;
            height: 65px;

            margin: 0 auto 18px;

            border-radius: 17px;

            background: #eef2ff;

            color: #4f46e5;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 26px;
        }

        .empty-orders h2 {
            font-size: 18px;

            color: #111827;

            font-weight: 700;
        }

        .empty-orders p {
            color: #94a3b8;

            font-size: 11px;

            margin-top: 7px;

            line-height: 1.6;
        }

        .browse-btn {
            display: inline-flex;

            align-items: center;

            justify-content: center;

            height: 41px;

            padding: 0 19px;

            margin-top: 20px;

            border-radius: 8px;

            background: #4f46e5;

            color: white;

            font-size: 10px;

            font-weight: 700;

            transition: 0.2s ease;
        }

        .browse-btn:hover {
            background: #4338ca;

            transform: translateY(-1px);
        }

        /* =========================
           BOTTOM ACTIONS
        ========================== */

        .bottom-actions {
            display: flex;

            justify-content: center;

            gap: 10px;

            margin-top: 22px;
        }

        .action-btn {
            display: inline-flex;

            align-items: center;

            justify-content: center;

            height: 39px;

            padding: 0 15px;

            border-radius: 8px;

            font-size: 10px;

            font-weight: 600;

            transition: 0.2s ease;
        }

        .books-btn {
            background: #eef2ff;

            color: #4f46e5;
        }

        .cart-btn {
            background: white;

            border: 1px solid #dbe2ea;

            color: #475569;
        }

        .action-btn:hover {
            transform: translateY(-1px);
        }

        /* =========================
           FOOTER
        ========================== */

        footer {
            border-top: 1px solid #e5e7eb;

            background: white;

            padding: 25px 6%;

            text-align: center;

            color: #94a3b8;

            font-size: 9px;
        }

        /* =========================
           RESPONSIVE
        ========================== */

        @media (max-width: 950px) {

            .order-item {
                grid-template-columns:
                    75px
                    1fr
                    100px
                    80px;

                gap: 15px;
            }

            .order-item > div:last-child {
                grid-column: 2 / -1;
            }

        }

        @media (max-width: 700px) {

            .navbar {
                padding: 0 20px;
            }

            .nav-links {
                gap: 2px;
            }

            .nav-link {
                padding: 8px;
            }

            .nav-link span {
                display: none;
            }

            .page-header {
                padding: 35px 20px 45px;
            }

            .content {
                padding: 0 20px 40px;
            }

            .order-item {
                grid-template-columns: 65px 1fr;

                gap: 13px;

                padding: 17px;
            }

            .book-img {
                grid-row: span 4;
            }

            .order-item > div:nth-child(3),
            .order-item > div:nth-child(4),
            .order-item > div:nth-child(5) {
                grid-column: 2;
            }

            .column-label {
                display: block;
            }

            .orders-header {
                padding: 17px;
            }

            .bottom-actions {
                flex-direction: column;
            }

            .action-btn {
                width: 100%;
            }

        }

        @media (max-width: 450px) {

            .brand-name {
                font-size: 16px;
            }

            .brand-icon {
                width: 35px;
                height: 35px;
            }

            .page-header h1 {
                font-size: 26px;
            }

            .page-header p {
                font-size: 10px;
            }

            .logout {
                display: none;
            }

        }

    </style>

</head>

<body>


    <!-- =========================
         NAVBAR
    ========================== -->

    <nav class="navbar">

        <a href="index.jsp" class="brand">

            <div class="brand-icon">
                📚
            </div>

            <div>

                <div class="brand-name">
                    DC Library
                </div>

                <div class="brand-subtitle">
                    YOUR DIGITAL LIBRARY
                </div>

            </div>

        </a>


        <div class="nav-links">

            <a href="index.jsp" class="nav-link">
                🏠 <span>Books</span>
            </a>

            <a href="cart.jsp" class="nav-link">
                🛒 <span>Cart</span>
            </a>

            <a href="orders.jsp" class="nav-link active">
                📦 <span>My Orders</span>
            </a>

            <a href="logout" class="nav-link logout">
                ↪ <span>Logout</span>
            </a>

        </div>

    </nav>


    <!-- =========================
         PAGE HEADER
    ========================== -->

    <section class="page-header">

        <div class="header-inner">

            <div class="header-label">
                📦 Order History
            </div>

            <h1>
                My Orders
            </h1>

            <p>
                Keep track of the books you've ordered from DC Library.
            </p>

        </div>

    </section>


    <!-- =========================
         CONTENT
    ========================== -->

    <main class="content">

        <%
            if (orders == null || orders.isEmpty()) {
        %>

            <!-- EMPTY STATE -->

            <div class="empty-orders">

                <div class="empty-icon">
                    📦
                </div>

                <h2>
                    No orders yet
                </h2>

                <p>
                    You haven't placed any orders yet.
                    Find a book you love and make your first order.
                </p>

                <a
                    href="index.jsp"
                    class="browse-btn"
                >
                    Browse Books
                </a>

            </div>


        <%
            } else {
        %>

            <!-- ORDERS -->

            <div class="orders-card">

                <div class="orders-header">

                    <h2>
                        Your Order History
                    </h2>

                    <span class="order-count">
                        <%= orders.size() %> order(s)
                    </span>

                </div>


                <%
                    for (Order o : orders) {

                        String img = o.getBookImage();

                        if (img == null || img.trim().isEmpty()) {

                            img = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='140'%3E%3Crect width='100' height='140' fill='%23ddd'/%3E%3Ctext x='50' y='75' font-size='12' text-anchor='middle' fill='%23666'%3ENo Image%3C/text%3E%3C/svg%3E";

                        }
                %>


                    <!-- ORDER -->

                    <div class="order-item">


                        <!-- IMAGE -->

                        <div>

                            <img
                                src="<%= img %>"
                                class="book-img"
                                alt="<%= o.getBookTitle() %>"
                            >

                        </div>


                        <!-- BOOK -->

                        <div class="book-details">

                            <div class="column-label">
                                Book
                            </div>

                            <div class="book-title">

                                <%= (o.getBookTitle() == null)
                                    ? "Book removed from catalog"
                                    : o.getBookTitle() %>

                            </div>

                            <div class="book-meta">
                                Order placed successfully
                            </div>

                        </div>


                        <!-- ORDER ID -->

                        <div>

                            <div class="column-label">
                                Order ID
                            </div>

                            <span class="order-id">
                                #<%= o.getId() %>
                            </span>

                        </div>


                        <!-- QUANTITY -->

                        <div>

                            <div class="column-label">
                                Quantity
                            </div>

                            <span class="quantity">
                                <%= o.getQuantity() %>
                            </span>

                        </div>


                        <!-- DATE -->

                        <div>

                            <div class="column-label">
                                Order Date
                            </div>

                            <div class="order-date">
                                <%= o.getOrderDate() %>
                            </div>

                            <div style="margin-top:7px;">

                                <span class="status">
                                    <span class="status-dot"></span>
                                    Order Placed
                                </span>

                            </div>

                        </div>


                    </div>


                <%
                    }
                %>

            </div>


            <!-- ACTIONS -->

            <div class="bottom-actions">

                <a
                    href="index.jsp"
                    class="action-btn books-btn"
                >
                    ← Continue Shopping
                </a>

                <a
                    href="cart.jsp"
                    class="action-btn cart-btn"
                >
                    🛒 View Cart
                </a>

            </div>

        <%
            }
        %>

    </main>


    <!-- FOOTER -->

    <footer>
        © 2026 DC Library · Discover. Read. Learn.
    </footer>


</body>

</html>

