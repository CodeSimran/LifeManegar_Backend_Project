<%@ page import="java.sql.*" %>

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/lifemanager",
"root",
"april"
);

String action = request.getParameter("action");

if("add".equals(action)){

    int userId = 1;

    String cardName = request.getParameter("card_name");
    String bankName = request.getParameter("bank_name");
    String cardType = request.getParameter("card_type");
    String lastFour = request.getParameter("last_four_digits");
    String expiry = request.getParameter("expiry_date");

    String sql = "insert into cards(id,card_name,bank_name,card_type,last_four_digits,expiry_date) values(?,?,?,?,?,?)";

    ps = con.prepareStatement(sql);

    ps.setInt(1,userId);
    ps.setString(2,cardName);
    ps.setString(3,bankName);
    ps.setString(4,cardType);
    ps.setString(5,lastFour);
    ps.setString(6,expiry);

    ps.executeUpdate();

    response.sendRedirect("cards.jsp");
}

}catch(Exception e){
e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Cards - LifeManager</title>

<style>

body{
margin:0;
font-family:Segoe UI;
background:#f5f6fa;
}

.dashboard{
display:flex;
}

/* Sidebar */

.sidebar{
width:220px;
background:#2f3e75;
height:100vh;
padding:20px;
color:white;
}

.sidebar h2{
margin-bottom:30px;
}

.sidebar a{
display:block;
color:white;
padding:10px;
text-decoration:none;
border-radius:5px;
margin-bottom:10px;
}

.sidebar a:hover{
background:#4455aa;
}

.active{
background:#4455aa;
}

/* Main content */

.main-content{
flex:1;
padding:40px;
}

.card-box{
background:white;
padding:25px;
border-radius:10px;
margin-bottom:30px;
box-shadow:0 5px 15px rgba(0,0,0,0.1);
}

/* Form */

input,select{
width:100%;
padding:10px;
margin:10px 0;
border:1px solid #ccc;
border-radius:5px;
}

button{
background:#2ecc71;
color:white;
border:none;
padding:10px 20px;
border-radius:5px;
cursor:pointer;
}

button:hover{
background:#27ae60;
}

/* Card UI */

.cards-container{
display:flex;
flex-wrap:wrap;
gap:20px;
margin-top:20px;
}

.credit-card{

width:300px;
height:180px;
padding:20px;
border-radius:15px;

background: linear-gradient(135deg,#6b4226,#c19a6b);

color:white;

box-shadow:0 10px 25px rgba(0,0,0,0.3);

display:flex;
flex-direction:column;
justify-content:space-between;

}

.bank-name{
font-size:18px;
font-weight:bold;
}

.card-number{
font-size:20px;
letter-spacing:2px;
}

.card-footer{
display:flex;
justify-content:space-between;
}

.delete-btn{
margin-top:10px;
background:#e74c3c;
color:white;
border:none;
padding:6px 12px;
border-radius:5px;
cursor:pointer;
}

.delete-btn:hover{
background:#c0392b;
}

</style>

</head>

<body>

<div class="dashboard">

<!-- Sidebar -->

<div class="sidebar">

<h2>LifeManager</h2>

<a href="dashboard.jsp">Dashboard</a>
<a href="documents.jsp">Documents</a>
<a href="expenses.jsp">Expenses</a>
<a href="tasks.jsp">Tasks</a>
<a href="cards.jsp" class="active">Cards</a>
<a href="reminders.jsp">Reminders</a>
<a href="settings.jsp">Settings</a>

</div>

<!-- Main Content -->

<div class="main-content">

<h1>Cards</h1>

<!-- Add Card -->

<div class="card-box">

<h2>Add Card</h2>

<form method="post" action="cards.jsp">

<input type="hidden" name="action" value="add">

<input type="text" name="card_name" placeholder="Card Name" required>

<input type="text" name="bank_name" placeholder="Bank Name" required>

<select name="card_type">
<option>Credit</option>
<option>Debit</option>
</select>

<input type="text" name="last_four_digits" placeholder="Last 4 Digits" required>

<input type="date" name="expiry_date" required>

<button type="submit">Add Card</button>

</form>

</div>

<!-- Display Cards -->

<div class="card-box">

<h2>Your Cards</h2>

<div class="cards-container">

<%

try{

String sql2="select * from cards";

ps = con.prepareStatement(sql2);

rs = ps.executeQuery();

while(rs.next()){

%>

<div class="credit-card">

<div class="bank-name">
<%=rs.getString("bank_name")%>
</div>

<div class="card-number">
**** **** **** <%=rs.getString("last_four_digits")%>
</div>

<div class="card-footer">

<span>
<%=rs.getString("card_type")%>
</span>

<span>
<%=rs.getDate("expiry_date")%>
</span>

</div>

<form method="post" action="deletecard.jsp">

<input type="hidden" name="card_id" value="<%=rs.getInt("cards_id")%>">

<button class="delete-btn">Delete</button>

</form>

</div>

<%

}

}catch(Exception e){
e.printStackTrace();
}

%>

</div>

</div>

</div>

</div>

</body>
</html>