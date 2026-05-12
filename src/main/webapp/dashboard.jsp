<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="com.model.User" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>

<%
    User user = (User) session.getAttribute("us");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = user.getName();

    int totalDocs = 0;
    int expiringSoon = 0;
    int alerts = 0;
    int completedTasks = 0;
    double monthlyExpense = 0.0;
    try {

        Connection con = DBConnection.getConnection();

        String sql = "SELECT SUM(amount) FROM expenses";

        PreparedStatement ps = con.prepareStatement(sql);

        ResultSet rs = ps.executeQuery();

        if(rs.next()){
            monthlyExpense = rs.getDouble(1);
        }

    }catch(Exception e){
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LifeAdmin Dashboard</title>

<!-- Bootstrap CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
body{
    background-color:#f4f6f9;
}

.sidebar{
    height:100vh;
    background:#1f3c88;
    color:white;
    padding-top:20px;
}

.sidebar a{
    color:white;
    text-decoration:none;
    display:block;
    padding:12px 20px;
    border-radius:8px;
}

.sidebar a:hover{
    background:#4062bb;
}

.card-custom{
    border-radius:15px;
    box-shadow:0 4px 10px rgba(0,0,0,0.05);
}

.top-card{
    border-radius:15px;
    padding:20px;
    color:white;
}

.bg-blue{background:#4e73df;}
.bg-orange{background:#f6a04d;}
.bg-yellow{background:#f4c542;}
.bg-green{background:#28a745;}

.btn-custom{
    border-radius:8px;
}
</style>

</head>
<body>

<div class="container-fluid">
<div class="row">

    <!-- Sidebar -->
    <div class="col-md-2 sidebar">
        <h4 class="text-center mb-4">LifeAdminManager</h4>

        <a href="#"><i class="fa fa-home"></i> Dashboard</a>
        <a href="#"><i class="fa fa-folder"></i> Documents</a>
        <a href="#"><i class="fa fa-money-bill"></i> Expenses</a>
        <a href="#"><i class="fa fa-check-square"></i> Tasks</a>
        <a href="#"><i class="fa fa-credit-card"></i> Cards</a>
        <a href="#"><i class="fa fa-bell"></i> Reminders</a>
        <a href="#"><i class="fa fa-cog"></i> Settings</a>
        <a href="logout" class="btn btn-danger">Logout</a>
        
    </div>

    <!-- Main Content -->
    <div class="col-md-10 p-4">

        <!-- Top Bar -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <input type="text" class="form-control w-50" placeholder="Search...">
            <div>
                <i class="fa fa-bell me-3"></i>
                Hi, <b><%= username %></b>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="top-card bg-blue">
                    <h6>Total Docs</h6>
                    <h3><%= totalDocs %></h3>
                </div>
            </div>

            <div class="col-md-3">
                <div class="top-card bg-orange">
                    <h6>Expiring Soon</h6>
                    <h3><%= expiringSoon %></h3>
                </div>
            </div>

            <div class="col-md-3">
                <div class="top-card bg-yellow">
                    <h6>Alerts</h6>
                    <h3><%= alerts %></h3>
                </div>
            </div>

            <div class="col-md-3">
                <div class="top-card bg-green">
                    <h6>Completed Tasks</h6>
                    <h3><%= completedTasks %></h3>
                </div>
            </div>
        </div>

        <!-- Middle Section -->
        <div class="row mb-4">

            <div class="col-md-8">
                <div class="card card-custom p-4">
                    <h5>Total Docs</h5>
                    <p><%= totalDocs %> saved documents</p>
                    <a href="documents.jsp" class="btn btn-primary btn-custom">
                        View Documents
                    </a>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card card-custom p-4">
                    <h4>₹ <%= monthlyExpense %></h4>
                    <p>This month expenses</p>
                    <div class="progress">
                        <div class="progress-bar bg-info" style="width:70%"></div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Feature Cards -->
        <div class="row">

            <!-- Documents -->
            <div class="col-md-4 mb-4">
                <div class="card card-custom p-4">
                    <h5>Documents</h5>
                    <p><%= totalDocs %> saved documents</p>
                    <a href="documents.jsp" class="btn btn-primary btn-custom">View Documents</a>
                </div>
            </div>

            <!-- Expenses -->
            <div class="col-md-4 mb-4">
                <div class="card card-custom p-4">
                    <h5>Expenses</h5>
                    <p>₹ <%= monthlyExpense %> spent this month</p>
                    <a href="expenses.jsp" class="btn btn-success btn-custom">View Expenses</a>
                </div>
            </div>

            <!-- Tasks -->
            <div class="col-md-4 mb-4">
                <div class="card card-custom p-4">
                    <h5>Tasks</h5>
                    <p><%= completedTasks %> completed tasks</p>
                    <a href="tasks.jsp" class="btn btn-warning btn-custom">View Tasks</a>
                </div>
            </div>

            <!-- Reminders -->
            <div class="col-md-4 mb-4">
                <div class="card card-custom p-4">
                    <h5>Reminders</h5>
                    <p>5 active reminders</p>
                    <a href="reminders.jsp" class="btn btn-danger btn-custom">View Reminders</a>
                </div>
            </div>

            <!-- Cards -->
            <div class="col-md-4 mb-4">
                <div class="card card-custom p-4">
                    <h5>Cards</h5>
                    <p>4 saved cards</p>
                    <a href="cards.jsp" class="btn btn-secondary btn-custom">View Cards</a>
                </div>
            </div>

            <!-- Bills -->
            <div class="col-md-4 mb-4">
                <div class="card card-custom p-4">
                    <h5>Settings</h5>
                    <p>Adjust preferences and security</p>
                    <a href="settings.jsp" class="btn btn-dark btn-custom">View Settings</a>
                </div>
            </div>

        </div>

    </div>

</div>
</div>

</body>
</html>