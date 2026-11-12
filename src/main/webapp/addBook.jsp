
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

    <title>DC Library | Add Book</title>

    <!-- Google Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

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
            min-height: 100dvh;

            background:
                linear-gradient(
                    135deg,
                    #111827 0%,
                    #1e1b4b 50%,
                    #312e81 100%
                );

            display: flex;

            align-items: center;

            justify-content: center;

            padding: 25px;
        }


        /* =========================
           MAIN CARD
        ========================== */

        .page-card {

            width: 100%;

            max-width: 900px;

            background: #ffffff;

            border-radius: 18px;

            overflow: hidden;

            display: grid;

            grid-template-columns: 0.85fr 1.15fr;

            box-shadow:
                0 25px 70px rgba(0, 0, 0, 0.25);
        }


        /* =========================
           LEFT PANEL
        ========================== */

        .brand-panel {

            position: relative;

            overflow: hidden;

            padding: 42px;

            color: white;

            background:
                linear-gradient(
                    145deg,
                    #111827,
                    #1e1b4b
                );

            display: flex;

            flex-direction: column;

            justify-content: center;
        }


        .brand-panel::before {

            content: "";

            position: absolute;

            width: 280px;

            height: 280px;

            border-radius: 50%;

            background:
                rgba(99, 102, 241, 0.18);

            right: -100px;

            top: -80px;
        }


        .brand-panel::after {

            content: "";

            position: absolute;

            width: 200px;

            height: 200px;

            border-radius: 50%;

            background:
                rgba(129, 140, 248, 0.10);

            left: -80px;

            bottom: -70px;
        }


        .brand-content {

            position: relative;

            z-index: 2;
        }


        /* =========================
           LOGO
        ========================== */

        .brand-logo {

            font-size: 27px;

            font-weight: 800;

            letter-spacing: -1px;

            margin-bottom: 28px;
        }


        .brand-logo span {

            color: #818cf8;
        }


        /* =========================
           ICON
        ========================== */

        .book-icon {

            width: 58px;

            height: 58px;

            border-radius: 14px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                rgba(99, 102, 241, 0.18);

            border:
                1px solid rgba(129, 140, 248, 0.25);

            font-size: 27px;

            margin-bottom: 20px;
        }


        /* =========================
           BRAND TEXT
        ========================== */

        .brand-panel h1 {

            font-size: 31px;

            line-height: 1.2;

            letter-spacing: -1px;

            margin-bottom: 15px;
        }


        .brand-panel h1 span {

            color: #818cf8;
        }


        .brand-panel p {

            color: #c7d2fe;

            font-size: 13px;

            line-height: 1.7;

            max-width: 300px;
        }


        .brand-footer {

            margin-top: 25px;

            color: #9ca3af;

            font-size: 10.5px;
        }


        /* =========================
           FORM PANEL
        ========================== */

        .form-panel {

            padding: 38px 48px;

            display: flex;

            flex-direction: column;

            justify-content: center;
        }


        /* =========================
           HEADING
        ========================== */

        .form-heading {

            margin-bottom: 20px;
        }


        .form-heading h2 {

            font-size: 27px;

            color: #111827;

            letter-spacing: -0.6px;

            margin-bottom: 7px;
        }


        .form-heading p {

            color: #6b7280;

            font-size: 12.5px;

            line-height: 1.6;
        }


        /* =========================
           ALERTS
        ========================== */

        .alert {

            padding: 10px 12px;

            border-radius: 8px;

            font-size: 12px;

            margin-bottom: 15px;
        }


        .success-alert {

            background: #f0fdf4;

            color: #15803d;

            border: 1px solid #bbf7d0;
        }


        .error-alert {

            background: #fef2f2;

            color: #b91c1c;

            border: 1px solid #fecaca;
        }


        /* =========================
           FORM GROUP
        ========================== */

        .form-group {

            margin-bottom: 13px;
        }


        .form-group label {

            display: block;

            color: #374151;

            font-size: 12px;

            font-weight: 700;

            margin-bottom: 6px;
        }


        .required {

            color: #ef4444;
        }


        /* =========================
           INPUT
        ========================== */

        .input-wrapper {

            position: relative;
        }


        .input-icon {

            position: absolute;

            left: 14px;

            top: 50%;

            transform: translateY(-50%);

            color: #9ca3af;

            font-size: 14px;

            pointer-events: none;
        }


        .input-wrapper input {

            width: 100%;

            height: 42px;

            padding: 0 13px 0 40px;

            border: 1px solid #d1d5db;

            border-radius: 8px;

            background: #ffffff;

            color: #111827;

            outline: none;

            font-family: inherit;

            font-size: 12.5px;

            transition: 0.2s;
        }


        .input-wrapper input:focus {

            border-color: #6366f1;

            box-shadow:
                0 0 0 3px rgba(99, 102, 241, 0.10);
        }


        .input-wrapper input::placeholder {

            color: #9ca3af;
        }


        /* =========================
           IMAGE URL
        ========================== */

        .image-help {

            margin-top: 5px;

            color: #9ca3af;

            font-size: 10.5px;
        }


        /* =========================
           SUBMIT BUTTON
        ========================== */

        .submit-button {

            width: 100%;

            border: none;

            background: #4f46e5;

            color: white;

            padding: 12px;

            border-radius: 8px;

            font-family: inherit;

            font-size: 13px;

            font-weight: 700;

            cursor: pointer;

            margin-top: 4px;

            transition: 0.2s;
        }


        .submit-button:hover {

            background: #4338ca;

            transform: translateY(-1px);

            box-shadow:
                0 6px 15px rgba(79, 70, 229, 0.25);
        }


        /* =========================
           BACK LINK
        ========================== */

        .back-link {

            display: block;

            text-align: center;

            margin-top: 15px;

            color: #9ca3af;

            font-size: 11.5px;

            text-decoration: none;
        }


        .back-link:hover {

            color: #4f46e5;
        }


        /* =========================
           RESPONSIVE
        ========================== */

        @media (max-width: 750px) {

            body {

                padding: 14px;
            }


            .page-card {

                max-width: 470px;

                grid-template-columns: 1fr;
            }


            .brand-panel {

                padding: 27px 30px;

                text-align: center;

                min-height: 190px;
            }


            .brand-logo {

                font-size: 24px;

                margin-bottom: 14px;
            }


            .book-icon {

                width: 45px;

                height: 45px;

                font-size: 21px;

                margin: 0 auto 10px;
            }


            .brand-panel h1 {

                font-size: 25px;

                margin-bottom: 8px;
            }


            .brand-panel p {

                font-size: 12px;

                margin: auto;
            }


            .brand-footer {

                display: none;
            }


            .form-panel {

                padding: 30px 28px;
            }
        }


        /* =========================
           SHORT LAPTOP SCREEN
        ========================== */

        @media (max-height: 680px) and (min-width: 751px) {

            body {

                padding: 12px;
            }


            .brand-panel {

                padding: 30px;
            }


            .brand-logo {

                margin-bottom: 17px;
            }


            .book-icon {

                width: 48px;

                height: 48px;

                font-size: 22px;

                margin-bottom: 12px;
            }


            .brand-panel h1 {

                font-size: 27px;

                margin-bottom: 10px;
            }


            .brand-panel p {

                font-size: 12px;
            }


            .form-panel {

                padding: 25px 38px;
            }


            .form-heading {

                margin-bottom: 13px;
            }


            .form-group {

                margin-bottom: 9px;
            }


            .back-link {

                margin-top: 8px;
            }
        }

    </style>

</head>


<body>


<div class="page-card">


    <!-- =========================
         BRAND PANEL
    ========================== -->

    <section class="brand-panel">

        <div class="brand-content">


            <div class="brand-logo">

                DC<span>Library</span>

            </div>


            <div class="book-icon">

                📖

            </div>


            <h1>

                Build your

                <span>book collection.</span>

            </h1>


            <p>

                Add books to the library and make them
                available for readers to discover, purchase
                and manage through the system.

            </p>


            <div class="brand-footer">

                DC Library · Admin Management

            </div>

        </div>

    </section>


    <!-- =========================
         FORM PANEL
    ========================== -->

    <section class="form-panel">


        <div class="form-heading">

            <h2>

                Add New Book

            </h2>

            <p>

                Enter the book details below to add it to your library.

            </p>

        </div>


        <!-- =========================
             SUCCESS / ERROR
        ========================== -->

        <%

            String msg =
                (String) request.getAttribute("message");

            String err =
                (String) request.getAttribute("error");


            if (msg != null) {

        %>

            <div class="alert success-alert">

                ✓ <%= msg %>

            </div>

        <%

            }


            if (err != null) {

        %>

            <div class="alert error-alert">

                ⚠ <%= err %>

            </div>

        <%

            }

        %>


        <!-- =========================
             ADD BOOK FORM
        ========================== -->

        <form action="addBook" method="post">


            <!-- TITLE -->

            <div class="form-group">

                <label for="title">

                    Book Title

                    <span class="required">*</span>

                </label>


                <div class="input-wrapper">

                    <span class="input-icon">

                        📚

                    </span>


                    <input

                        type="text"

                        id="title"

                        name="title"

                        placeholder="Enter book title"

                        required>

                </div>

            </div>


            <!-- AUTHOR -->

            <div class="form-group">

                <label for="author">

                    Author

                </label>


                <div class="input-wrapper">

                    <span class="input-icon">

                        ✍

                    </span>


                    <input

                        type="text"

                        id="author"

                        name="author"

                        placeholder="Enter author name">

                </div>

            </div>


            <!-- PRICE -->

            <div class="form-group">

                <label for="price">

                    Price

                    <span class="required">*</span>

                </label>


                <div class="input-wrapper">

                    <span class="input-icon">

                        ₹

                    </span>


                    <input

                        type="number"

                        id="price"

                        step="0.01"

                        name="price"

                        placeholder="Enter book price"

                        min="0"

                        required>

                </div>

            </div>


            <!-- QUANTITY -->

            <div class="form-group">

                <label for="quantity">

                    Quantity

                    <span class="required">*</span>

                </label>


                <div class="input-wrapper">

                    <span class="input-icon">

                        #
                        
                    </span>


                    <input

                        type="number"

                        id="quantity"

                        name="quantity"

                        min="0"

                        placeholder="Enter available quantity"

                        required>

                </div>

            </div>


            <!-- IMAGE URL -->

            <div class="form-group">

                <label for="imageUrl">

                    Book Image URL

                </label>


                <div class="input-wrapper">

                    <span class="input-icon">

                        🖼

                    </span>


                    <input

                        type="text"

                        id="imageUrl"

                        name="imageUrl"

                        placeholder="Paste direct JPG / PNG image link">

                </div>


                <div class="image-help">

                    Optional · Use a direct image URL ending in .jpg, .jpeg or .png

                </div>

            </div>


            <!-- SUBMIT -->

            <button

                type="submit"

                class="submit-button">

                Add Book →

            </button>


        </form>


        <!-- =========================
             BACK
        ========================== -->

        <a

            href="admin.jsp"

            class="back-link">

            ← Back to Admin Panel

        </a>


    </section>


</div>


</body>

</html>

