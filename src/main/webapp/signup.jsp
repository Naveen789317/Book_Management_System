
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>DC Library | Create Account</title>

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

            padding: 20px;
        }


        /* =========================
           MAIN CONTAINER
        ========================== */

        .auth-wrapper {

            width: 100%;
            max-width: 900px;

            background: #ffffff;

            border-radius: 18px;

            overflow: hidden;

            display: grid;

            grid-template-columns: 1fr 1fr;

            box-shadow:
                0 25px 70px rgba(0, 0, 0, 0.25);
        }


        /* =========================
           LEFT BRAND PANEL
        ========================== */

        .brand-panel {

            background:
                linear-gradient(
                    145deg,
                    #111827,
                    #1e1b4b
                );

            color: white;

            padding: 42px;

            display: flex;
            flex-direction: column;
            justify-content: center;

            position: relative;

            overflow: hidden;
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
           BOOK ICON
        ========================== */

        .book-icon {

            font-size: 46px;

            margin-bottom: 15px;
        }


        /* =========================
           BRAND HEADING
        ========================== */

        .brand-panel h1 {

            font-size: 32px;

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

            max-width: 350px;
        }


        /* =========================
           BRAND FOOTER
        ========================== */

        .brand-footer {

            margin-top: 25px;

            color: #9ca3af;

            font-size: 10.5px;
        }


        /* =========================
           REGISTER PANEL
        ========================== */

        .register-panel {

            padding: 38px 48px;

            display: flex;

            flex-direction: column;

            justify-content: center;
        }


        /* =========================
           HEADING
        ========================== */

        .register-heading {

            margin-bottom: 19px;
        }


        .register-heading h2 {

            font-size: 28px;

            color: #111827;

            margin-bottom: 7px;

            letter-spacing: -0.5px;
        }


        .register-heading p {

            color: #6b7280;

            font-size: 12.5px;

            line-height: 1.6;
        }


        /* =========================
           ERROR MESSAGE
        ========================== */

        .alert {

            padding: 10px 12px;

            border-radius: 8px;

            font-size: 12px;

            margin-bottom: 15px;

            background: #fef2f2;

            color: #b91c1c;

            border: 1px solid #fecaca;
        }


        /* =========================
           FORM
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

            font-size: 12.5px;

            color: #111827;

            outline: none;

            transition: 0.2s;

            font-family: inherit;
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
           REGISTER BUTTON
        ========================== */

        .register-button {

            width: 100%;

            border: none;

            background: #4f46e5;

            color: white;

            padding: 12px;

            border-radius: 8px;

            font-size: 13px;

            font-weight: 700;

            cursor: pointer;

            margin-top: 3px;

            transition: 0.2s;
        }


        .register-button:hover {

            background: #4338ca;

            transform: translateY(-1px);

            box-shadow:
                0 6px 15px rgba(79, 70, 229, 0.25);
        }


        /* =========================
           LOGIN LINK
        ========================== */

        .login-link {

            text-align: center;

            margin-top: 17px;

            color: #6b7280;

            font-size: 12px;
        }


        .login-link a {

            color: #4f46e5;

            font-weight: 700;

            text-decoration: none;
        }


        .login-link a:hover {

            color: #3730a3;

            text-decoration: underline;
        }


        /* =========================
           HOME LINK
        ========================== */

        .back-home {

            display: block;

            text-align: center;

            margin-top: 10px;

            color: #9ca3af;

            font-size: 11px;

            text-decoration: none;
        }


        .back-home:hover {

            color: #4f46e5;
        }


        /* =========================
           RESPONSIVE
        ========================== */

        @media (max-width: 750px) {

            body {

                padding: 14px;
            }


            .auth-wrapper {

                grid-template-columns: 1fr;

                max-width: 450px;
            }


            .brand-panel {

                padding: 27px 30px;

                text-align: center;

                min-height: 195px;
            }


            .brand-logo {

                margin-bottom: 13px;

                font-size: 24px;
            }


            .book-icon {

                font-size: 34px;

                margin-bottom: 8px;
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


            .register-panel {

                padding: 30px 28px;
            }
        }


        /* =========================
           SHORT SCREEN
        ========================== */

        @media (max-height: 650px) and (min-width: 751px) {

            body {

                padding: 10px;
            }


            .brand-panel {

                padding: 28px 32px;
            }


            .brand-logo {

                margin-bottom: 17px;
            }


            .book-icon {

                font-size: 38px;

                margin-bottom: 9px;
            }


            .brand-panel h1 {

                font-size: 27px;

                margin-bottom: 9px;
            }


            .brand-panel p {

                font-size: 12px;
            }


            .register-panel {

                padding: 25px 38px;
            }


            .register-heading {

                margin-bottom: 13px;
            }


            .form-group {

                margin-bottom: 9px;
            }


            .login-link {

                margin-top: 11px;
            }


            .back-home {

                margin-top: 6px;
            }
        }

    </style>

</head>


<body>


<div class="auth-wrapper">


    <!-- =========================
         BRAND SECTION
    ========================== -->

    <section class="brand-panel">

        <div class="brand-content">

            <div class="brand-logo">

                DC<span>Library</span>

            </div>


            <div class="book-icon">

                📚

            </div>


            <h1>

                Start your

                <span>reading journey.</span>

            </h1>


            <p>

                Create your DC Library account and get access
                to our collection of books, shopping cart and
                order management.

            </p>


            <div class="brand-footer">

                Your knowledge. Your collection. Your journey.

            </div>

        </div>

    </section>


    <!-- =========================
         REGISTER SECTION
    ========================== -->

    <section class="register-panel">


        <div class="register-heading">

            <h2>

                Create account

            </h2>

            <p>

                Fill in your details to create your DC Library account.

            </p>

        </div>


        <!-- =========================
             ERROR MESSAGE
        ========================== -->

        <%

            String error =
                (String) request.getAttribute("error");


            if (error != null) {

        %>

            <div class="alert">

                ⚠ <%= error %>

            </div>

        <%

            }

        %>


        <!-- =========================
             REGISTER FORM
        ========================== -->

        <form action="signup" method="post">


            <!-- NAME -->

            <div class="form-group">

                <label for="name">

                    Full Name

                    <span class="required">*</span>

                </label>


                <div class="input-wrapper">

                    <span class="input-icon">

                        👤

                    </span>


                    <input

                        type="text"

                        id="name"

                        name="name"

                        placeholder="Enter your full name"

                        autocomplete="name"

                        required>

                </div>

            </div>


            <!-- EMAIL -->

            <div class="form-group">

                <label for="email">

                    Email Address

                    <span class="required">*</span>

                </label>


                <div class="input-wrapper">

                    <span class="input-icon">

                        ✉

                    </span>


                    <input

                        type="email"

                        id="email"

                        name="email"

                        placeholder="Enter your email"

                        autocomplete="email"

                        required>

                </div>

            </div>


            <!-- PASSWORD -->

            <div class="form-group">

                <label for="password">

                    Password

                    <span class="required">*</span>

                </label>


                <div class="input-wrapper">

                    <span class="input-icon">

                        🔒

                    </span>


                    <input

                        type="password"

                        id="password"

                        name="password"

                        placeholder="Create a password"

                        autocomplete="new-password"

                        required>

                </div>

            </div>


            <!-- SUBMIT -->

            <button

                type="submit"

                class="register-button">

                Create Account →

            </button>


        </form>


        <!-- =========================
             LOGIN LINK
        ========================== -->

        <div class="login-link">

            Already have an account?

            <a href="login.jsp">

                Sign in

            </a>

        </div>


        <!-- =========================
             HOME
        ========================== -->

        <a

            href="index.jsp"

            class="back-home">

            ← Back to Library

        </a>


    </section>


</div>


</body>

</html>

