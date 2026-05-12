<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>Add Expense</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
*{ box-sizing:border-box; margin:0; padding:0; }

body{
    font-family:'Inter',sans-serif;
    background:#f4f6f9;
    display:flex;
}

/* SIDEBAR */
.sidebar{
    width:250px;
    height:100vh;
    background:linear-gradient(180deg,#2d4ea2,#1b2f6a);
    color:white;
    position:fixed;
    display:flex;
    flex-direction:column;
    justify-content:space-between;
    z-index:100;
}

.sidebar h2{
    text-align:center;
    padding:25px 15px;
    font-size:1.1rem;
    border-bottom:1px solid rgba(255,255,255,0.1);
}

.sidebar a{
    display:flex;
    align-items:center;
    gap:10px;
    color:white;
    padding:14px 25px;
    text-decoration:none;
    font-size:0.95rem;
    transition:background 0.2s;
}

.sidebar a:hover,
.sidebar a.active{
    background:rgba(255,255,255,0.12);
    border-left:4px solid #f9a826;
}

.sidebar .logout{
    background:#e74c3c;
    margin:20px;
    text-align:center;
    border-radius:8px;
    padding:12px;
    justify-content:center;
    font-weight:600;
}

.sidebar .logout:hover{ background:#c0392b; border-left:none; }

/* MAIN */
.main{
    margin-left:250px;
    width:calc(100% - 250px);
    padding:30px;
    min-height:100vh;
    display:flex;
    flex-direction:column;
    align-items:center;
}

/* HEADER */
.header-card{
    background:linear-gradient(90deg,#2d7df6,#6a9cfb);
    color:white;
    padding:25px 30px;
    border-radius:15px;
    margin-bottom:30px;
    width:100%;
    max-width:550px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.header-card h1{ font-size:1.4rem; font-weight:700; }

/* FORM CARD */
.form-card{
    background:white;
    padding:35px;
    border-radius:15px;
    box-shadow:0 4px 20px rgba(0,0,0,0.08);
    width:100%;
    max-width:550px;
}

.form-group{
    margin-bottom:20px;
}

.form-group label{
    display:block;
    font-size:0.85rem;
    font-weight:600;
    color:#444;
    margin-bottom:7px;
    text-transform:uppercase;
    letter-spacing:0.4px;
}

.form-group input,
.form-group select{
    width:100%;
    padding:12px 15px;
    border:1.5px solid #e0e0e0;
    border-radius:8px;
    font-size:0.95rem;
    font-family:'Inter',sans-serif;
    color:#333;
    transition:border-color 0.2s;
    outline:none;
}

.form-group input:focus,
.form-group select:focus{
    border-color:#2d7df6;
    box-shadow:0 0 0 3px rgba(45,125,246,0.1);
}

.submit-btn{
    width:100%;
    padding:14px;
    background:linear-gradient(90deg,#2d7df6,#6a9cfb);
    color:white;
    border:none;
    border-radius:8px;
    font-size:1rem;
    font-weight:600;
    cursor:pointer;
    margin-top:10px;
    transition:transform 0.15s, box-shadow 0.15s;
    font-family:'Inter',sans-serif;
}

.submit-btn:hover{
    transform:translateY(-1px);
    box-shadow:0 4px 15px rgba(45,125,246,0.4);
}

/* SUCCESS / ERROR BANNERS */
.success-banner{
    background:#d4f8e8;
    color:#1a7d45;
    padding:13px 18px;
    border-radius:8px;
    margin-bottom:20px;
    border-left:5px solid #2ecc71;
    font-size:0.9rem;
    width:100%;
    max-width:550px;
}

.error-banner{
    background:#fde8e8;
    color:#c0392b;
    padding:13px 18px;
    border-radius:8px;
    margin-bottom:20px;
    border-left:5px solid #e74c3c;
    font-size:0.9rem;
    width:100%;
    max-width:550px;
}
</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <div>
        <h2>LifeAdmin Manager</h2>
        <a href="dashboard">🏠 Dashboard</a>
        <a href="documents.jsp">📁 Documents</a>
        <a href="expenses.jsp" class="active">💰 Expenses</a>
        <a href="tasks.jsp">✅ Tasks</a>
        <a href="cards.jsp">💳 Cards</a>
        <a href="reminders.jsp">🔔 Reminders</a>
        <a href="settings.jsp">⚙️ Settings</a>
    </div>
    <a href="logout" class="logout">🚪 Logout</a>
</div>

<!-- MAIN -->
<div class="main">

    <div class="header-card">
        <h1>➕ Add New Expense</h1>
        <a href="expenses.jsp" style="color:white;font-size:0.9rem;">← Back</a>
    </div>

    <!-- Show success/error messages -->
    <% String success = request.getParameter("success");
       String error   = request.getParameter("error"); %>

    <% if(success != null){ %>
    <div class="success-banner">✅ <%=success%></div>
    <% } %>

    <% if(error != null){ %>
    <div class="error-banner">⚠️ <%=error%></div>
    <% } %>

    <div class="form-card">
        <form action="addExpense" method="post">

            <!-- Amount -->
            <div class="form-group">
                <label>Amount (₹)</label>
                <input type="number" step="0.01" min="0" name="amount"
                       placeholder="Enter amount" required>
            </div>

            <!-- Category -->
            <div class="form-group">
                <label>Category</label>
                <select name="category">
                    <option value="Food">🍔 Food</option>
                    <option value="Travel">✈️ Travel</option>
                    <option value="Shopping">🛒 Shopping</option>
                    <option value="Bills">📄 Bills</option>
                    <option value="Health">🏥 Health</option>
                    <option value="Education">📚 Education</option>
                    <option value="Entertainment">🎬 Entertainment</option>
                    <option value="Other">📦 Other</option>
                </select>
            </div>

            <!-- Payment Status -->
            <div class="form-group">
                <label>Payment Status</label>
                <select name="paymentStatus">
                    <option value="Paid">✅ Paid</option>
                    <option value="Pending">⏳ Pending</option>
                </select>
            </div>

            <!-- ✅ NEW: Expense Date -->
            <div class="form-group">
                <label>Expense Date</label>
                <input type="date" name="expense_date"
                       value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                       required>
            </div>

            <button type="submit" class="submit-btn">💾 Save Expense</button>

        </form>
    </div>

</div>

</body>
</html>
