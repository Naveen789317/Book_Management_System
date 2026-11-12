
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login | DC Library</title>

    <!-- Google Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html,
        body {
            width: 100%;
            min-height: 100%;
            font-family: 'Inter', sans-serif;
        }

        body {
            min-height: 100vh;
            min-height: 100dvh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background:
                radial-gradient(circle at 10% 10%, rgba(59,130,246,0.18), transparent 30%),
                radial-gradient(circle at 90% 90%, rgba(37,99,235,0.20), transparent 30%),
                linear-gradient(135deg, #0f172a, #172554 55%, #1e3a8a);
        }

        /* =========================
           MAIN AUTH CARD
        ========================== */

        .auth-card {
            width: 100%;
            max-width: 780px;
            display: grid;
            grid-template-columns: 0.9fr 1.1fr;
            background: #ffffff;
            border-radius: 18px;
            overflow: hidden;
            box-shadow:
                0 25px 60px rgba(0, 0, 0, 0.25);
        }

        /* =========================
           LEFT BRAND SECTION
        ========================== */

        .brand-section {
            position: relative;
            padding: 38px 32px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: white;
            background:
                linear-gradient(145deg, #172554, #1d4ed8);
        }

        .brand-section::before {
            content: "";
            position: absolute;
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background: rgba(255,255,255,0.07);
            top: -70px;
            left: -70px;
        }

        .brand-section::after {
            content: "";
            position: absolute;
            width: 140px;
            height: 140px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
            bottom: -60px;
            right: -50px;
        }

        .brand-content {
            position: relative;
            z-index: 2;
        }

        .brand-logo {
            width: 52px;
            height: 52px;
            margin: 0 auto 15px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,0.14);
            border: 1px solid rgba(255,255,255,0.20);
            backdrop-filter: blur(8px);
            font-size: 23px;
        }

        .brand-name {
            font-size: 25px;
            font-weight: 800;
            letter-spacing: -0.8px;
            margin-bottom: 7px;
        }

        .brand-name span {
            color: #bfdbfe;
        }

        .brand-description {
            max-width: 250px;
            margin: auto;
            font-size: 12.5px;
            line-height: 1.6;
            color: #dbeafe;
        }

        .brand-tag {
            margin-top: 22px;
            padding: 7px 12px;
            border-radius: 30px;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            font-size: 11px;
            font-weight: 600;
            color: #dbeafe;
            background: rgba(255,255,255,0.10);
            border: 1px solid rgba(255,255,255,0.15);
        }

        .brand-tag i {
            font-size: 10px;
        }

        /* =========================
           LOGIN SECTION
        ========================== */

        .login-section {
            padding: 38px 42px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-header {
            margin-bottom: 22px;
        }

        .login-header h1 {
            color: #111827;
            font-size: 27px;
            font-weight: 800;
            letter-spacing: -0.7px;
            margin-bottom: 6px;
        }

        .login-header p {
            color: #6b7280;
            font-size: 12.5px;
        }

        /* =========================
           ALERTS
        ========================== */

        .alert {
            padding: 10px 12px;
            margin-bottom: 15px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 9px;
            font-size: 12px;
            line-height: 1.4;
        }

        .success-alert {
            color: #166534;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
        }

        .error-alert {
            color: #b91c1c;
            background: #fef2f2;
            border: 1px solid #fecaca;
        }

        .alert i {
            font-size: 13px;
        }

        /* =========================
           FORM
        ========================== */

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            margin-bottom: 7px;
            color: #374151;
            font-size: 12px;
            font-weight: 600;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            font-size: 13px;
            pointer-events: none;
        }

        .input-wrapper input {
            width: 100%;
            height: 43px;
            padding: 0 13px 0 38px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            outline: none;
            background: #ffffff;
            color: #111827;
            font-family: inherit;
            font-size: 12.5px;
            transition: all 0.2s ease;
        }

        .input-wrapper input::placeholder {
            color: #9ca3af;
        }

        .input-wrapper input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.10);
        }

        .input-wrapper input:focus + i {
            color: #2563eb;
        }

        /* =========================
           LOGIN BUTTON
        ========================== */

        .login-button {
            width: 100%;
            height: 44px;
            margin-top: 4px;
            border: none;
            border-radius: 8px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
            font-family: inherit;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 8px 18px rgba(37,99,235,0.20);
            transition: all 0.2s ease;
        }

        .login-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 11px 22px rgba(37,99,235,0.28);
        }

        .login-button:active {
            transform: translateY(0);
        }

        /* =========================
           REGISTER
        ========================== */

        .register-section {
            margin-top: 20px;
            padding-top: 17px;
            border-top: 1px solid #e5e7eb;
            text-align: center;
        }

        .register-section p {
            color: #6b7280;
            font-size: 11.5px;
        }

        .register-section a {
            color: #2563eb;
            font-weight: 700;
            text-decoration: none;
        }

        .register-section a:hover {
            text-decoration: underline;
        }

        .home-link {
            margin-top: 12px;
            text-align: center;
        }

        .home-link a {
            color: #9ca3af;
            font-size: 11px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .home-link a:hover {
            color: #2563eb;
        }

        /* =========================
           RESPONSIVE
        ========================== */

        @media (max-width: 650px) {

            body {
                padding: 14px;
            }

            .auth-card {
                max-width: 430px;
                grid-template-columns: 1fr;
            }

            .brand-section {
                padding: 25px 22px;
            }

            .brand-logo {
                width: 45px;
                height: 45px;
                font-size: 19px;
                margin-bottom: 10px;
            }

            .brand-name {
                font-size: 21px;
            }

            .brand-description {
                display: none;
            }

            .brand-tag {
                margin-top: 12px;
            }

            .login-section {
                padding: 30px 25px;
            }

            .login-header {
                margin-bottom: 19px;
            }

            .login-header h1 {
                font-size: 24px;
            }
        }

        /* Short laptop / smaller viewport */

        @media (max-height: 650px) and (min-width: 651px) {

            body {
                padding: 12px;
            }

            .brand-section {
                padding: 25px;
            }

            .login-section {
                padding: 25px 35px;
            }

            .login-header {
                margin-bottom: 15px;
            }

            .form-group {
                margin-bottom: 12px;
            }

            .register-section {
                margin-top: 14px;
                padding-top: 12px;
            }

            .home-link {
                margin-top: 8px;
            }
        }

    </style>

</head>

<body>

    <div class="auth-card">

        <!-- =========================
             BRAND PANEL
        ========================== -->

        <div class="brand-section">

            <div class="brand-content">

                <div class="brand-logo">
                    <i class="fa-solid fa-book-open"></i>
                </div>

                <div class="brand-name">
                    DC <span>Library</span>
                </div>

                <p class="brand-description">
                    Your gateway to knowledge, learning and endless possibilities.
                </p>

                <div class="brand-tag">
                    <i class="fa-solid fa-shield-halved"></i>
                    Secure &amp; Simple
                </div>

            </div>

        </div>


        <!-- =========================
             LOGIN PANEL
        ========================== -->

        <div class="login-section">

            <div class="login-header">

                <h1>Welcome back</h1>

                <p>
                    Sign in to continue to your library account.
                </p>

            </div>


            <!-- SUCCESS MESSAGE -->

            <%
                if (request.getParameter("success") != null) {
            %>

                <div class="alert success-alert">
                    <i class="fa-solid fa-circle-check"></i>
                    <span>Registration successful! Please login.</span>
                </div>

            <%
                }

                String error = (String) request.getAttribute("error");

                if (error != null) {
            %>

                <div class="alert error-alert">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <span><%= error %></span>
                </div>

            <%
                }
            %>


            <!-- LOGIN FORM -->

            <form action="login" method="post">

                <div class="form-group">

                    <label for="email">
                        Email Address
                    </label>

                    <div class="input-wrapper">

                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="Enter your email"
                            autocomplete="email"
                            required>

                        <i class="fa-solid fa-envelope"></i>

                    </div>

                </div>


                <div class="form-group">

                    <label for="password">
                        Password
                    </label>

                    <div class="input-wrapper">

                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required>

                        <i class="fa-solid fa-lock"></i>

                    </div>

                </div>


                <button type="submit" class="login-button">

                    <span>Login to Account</span>

                    <i class="fa-solid fa-arrow-right"></i>

                </button>

            </form>


            <!-- REGISTER -->

            <div class="register-section">

                <p>
                    New to DC Library?
                    <a href="signup.jsp">Create an account</a>
                </p>

            </div>


            <!-- HOME -->

            <div class="home-link">

                <a href="index.jsp">
                    <i class="fa-solid fa-arrow-left"></i>
                    Back to Library
                </a>

            </div>

        </div>

    </div>

</body>

</html>
