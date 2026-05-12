<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Document" %>

<%
    // ================= SESSION CHECK =================
    User user = (User) session.getAttribute("us");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ================= DOCUMENT LIST =================
    List<Document> docs = (List<Document>) request.getAttribute("docs");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Documents</title>

<style>
body{
    font-family: Arial, sans-serif;
    background:#f4f6f9;
    padding:20px;
}

h2{
    color:#1f3c88;
}

table{
    width:100%;
    border-collapse: collapse;
    background:white;
}

th, td{
    padding:12px;
    border:1px solid #ddd;
    text-align:center;
}

th{
    background:#1f3c88;
    color:white;
}

.back{
    margin-top:20px;
    display:inline-block;
    text-decoration:none;
    background:#4e73df;
    color:white;
    padding:10px 15px;
    border-radius:5px;
}

.empty{
    color:red;
    font-weight:bold;
}
</style>

</head>
<body>

<h2>My Documents</h2>

<table>
    <tr>
        <th>Document Name</th>
        <th>Type</th>
        <th>Expiry Date</th>
    </tr>

<%
    if (docs != null && !docs.isEmpty()) {
        for (Document d : docs) {
%>
    <tr>
        <td><%= d.getTitle() %></td>
        <td><%= d.getType() %></td>
        <td><%= d.getExpiryDate() %></td>
    </tr>
<%
        }
    } else {
%>
    <tr>
        <td colspan="3" class="empty">No documents found</td>
    </tr>
<%
    }
%>
</table>

<br>
<a href="dashboard" class="back">⬅ Back to Dashboard</a>

</body>
</html>