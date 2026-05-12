<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Life Admin Manager - Login</title>

<style>
    body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
        background: linear-gradient(135deg, #4e73df, #1cc88a);
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .login-container {
        background: white;
        padding: 40px;
        width: 350px;
        border-radius: 10px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        text-align: center;
    }

    .login-container h2 {
        margin-bottom: 20px;
        color: #333;
    }

    .form-group {
        margin-bottom: 15px;
        text-align: left;
    }

    .form-group label {
        font-weight: bold;
        display: block;
        margin-bottom: 5px;
    }

    .form-group input {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }

    .btn-login {
        width: 100%;
        padding: 10px;
        background-color: #4e73df;
        border: none;
        color: white;
        font-size: 16px;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 10px;
    }

    .btn-login:hover {
        background-color: #2e59d9;
    }

    .error {
        color: red;
        margin-bottom: 10px;
    }

    .footer {
        margin-top: 15px;
        font-size: 14px;
    }

    .footer a {
        text-decoration: none;
        color: #4e73df;
    }
</style>

</head>
<body>

<div class="login-container">
    <h2>Life Admin Manager</h2>

    <!-- Display Error Message -->
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <div class="error">Invalid Username or Password!</div>
    <%
        }
    %>

    <form action="LoginServlet" method="post" autocomplete="off">

        <div class="form-group">
            <label>Username</label>
            <input type="email" name="email" required autocomplete="off">
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required autocomplete="new-password">
        </div>

        <button type="submit" class="btn-login">Login</button>
    </form>

    <div class="footer">
        Don't have an account? <a href="register.jsp">Register</a>
    </div>
</div>

</body>
</html>