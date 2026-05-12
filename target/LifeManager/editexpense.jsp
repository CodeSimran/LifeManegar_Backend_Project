<%@ page import="java.sql.ResultSet" %>

<%
ResultSet expense = (ResultSet) request.getAttribute("expense");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Expense</title>

<style>

body{
    font-family: Arial, sans-serif;
    background:#4e73df;
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    margin:0;
}

.container{
    background:white;
    padding:30px 40px;
    border-radius:10px;
    width:350px;
    box-shadow:0 8px 20px rgba(0,0,0,0.2);
}

h2{
    text-align:center;
    margin-bottom:20px;
}

input{
    width:100%;
    padding:10px;
    margin-top:5px;
    margin-bottom:15px;
    border-radius:6px;
    border:1px solid #ccc;
    box-sizing:border-box;
}

select{
    width:100%;
    padding:10px;
    border-radius:6px;
    border:1px solid #ccc;
    margin-top:5px;
    margin-bottom:15px;
    box-sizing:border-box;
}

button{
    width:100%;
    padding:10px;
    border:none;
    border-radius:6px;
    background:#2575fc;
    color:white;
    font-size:16px;
    cursor:pointer;
    margin-top:10px;
}

button:hover{
    background:#1b5edb;
}

label{
    font-weight:bold;
}

</style>

</head>

<body>

<div class="container">

<h2>Edit Expense</h2>

<form action="updateExpense" method="post">

    <input type="hidden" name="expense_id"
    value="<%=expense.getInt("expense_id")%>">

    <label>Amount</label>
    <input type="number" step="0.01"
    name="amount"
    value="<%=expense.getDouble("amount")%>">

    <label>Category</label>
    <select name="category">
        <option value="Food" <%=expense.getString("category").equals("Food")?"selected":""%>>Food</option>
        <option value="Shopping" <%=expense.getString("category").equals("Shopping")?"selected":""%>>Shopping</option>
        <option value="Travel" <%=expense.getString("category").equals("Travel")?"selected":""%>>Travel</option>
        <option value="Bills" <%=expense.getString("category").equals("Bills")?"selected":""%>>Bills</option>
        <option value="Health" <%=expense.getString("category").equals("Health")?"selected":""%>>Health</option>
        <option value="Education" <%=expense.getString("category").equals("Education")?"selected":""%>>Education</option>
        <option value="Entertainment" <%=expense.getString("category").equals("Entertainment")?"selected":""%>>Entertainment</option>
        <option value="Other" <%=expense.getString("category").equals("Other")?"selected":""%>>Other</option>
    </select>

    <button type="submit">Save Expense</button>

</form>

</div>

</body>
