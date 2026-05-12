
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Life Admin Manager - Register</title>

<style>
    body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
        background: linear-gradient(135deg, #1cc88a, #4e73df);
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .register-container {
        background: white;
        padding: 40px;
        width: 400px;
        border-radius: 10px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        text-align: center;
    }

    .register-container h2 {
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
    }

    .btn-register {
        width: 100%;
        padding: 10px;
        background-color: #1cc88a;
        border: none;
        color: white;
        font-size: 16px;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 10px;
    }

    .btn-register:hover {
        background-color: #17a673;
    }

    .error {
        color: red;
        margin-bottom: 10px;
    }

    .success {
        color: green;
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

<div class="register-container">
    <h2>Create Account</h2>

    <!-- Error Message -->
    <%
        String error = request.getParameter("error");
        String success = request.getParameter("success");

        if (error != null) {
    %>
        <div class="error">Registration Failed! Try again.</div>
    <%
        }

        if (success != null) {
    %>
        <div class="success">Registration Successful! Please Login.</div>
    <%
        }
    %>

    <form action="RegisterServlet" method="post">
        
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="name" required>
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>

        
        <div class="form-group">
            <label>Phone Number</label>
            <input type="text" name="phone" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>

        <button type="submit" class="btn-register">Register</button>
    </form>

    <div class="footer">
        Already have an account? <a href="login.jsp">Login</a>
    </div>
</div>

</body>
</html>


