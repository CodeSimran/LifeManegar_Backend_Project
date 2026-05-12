
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.util.DBConnection" %>

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

Map<String,Double> paidTotals    = new LinkedHashMap<>();
Map<String,Double> pendingTotals = new LinkedHashMap<>();
List<Map<String,Object>> expensesList = new ArrayList<>();

double totalPaid      = 0.0;
double totalPending   = 0.0;
double thisMonthTotal = 0.0;

// Monthly breakdown (last 6 months)
Map<String,Double> monthlyTotals = new LinkedHashMap<>();

// Current month name e.g. "March 2026"
String currentMonthName = new java.text.SimpleDateFormat("MMMM yyyy").format(new java.util.Date());

String errorMsg = null;

try {
    con = DBConnection.getConnection();

    // ── 1. All expenses ──────────────────────────────────────────────────
    ps = con.prepareStatement("SELECT * FROM expenses ORDER BY expense_id DESC");
    rs = ps.executeQuery();

    while(rs.next()){
        int    expenseId = rs.getInt("expense_id");
        double amount    = rs.getDouble("amount");

        String category = rs.getString("category");
        if(category == null || category.trim().isEmpty()) category = "Uncategorized";

        String status = rs.getString("payment_status");
        if(status == null || status.trim().isEmpty()) status = "Pending";

        if(status.equalsIgnoreCase("Paid")){
            paidTotals.put(category, paidTotals.getOrDefault(category, 0.0) + amount);
            totalPaid += amount;
        } else {
            pendingTotals.put(category, pendingTotals.getOrDefault(category, 0.0) + amount);
            totalPending += amount;
        }

        Map<String,Object> row = new HashMap<>();
        row.put("expense_id",     expenseId);
        row.put("amount",         amount);
        row.put("category",       category);
        row.put("payment_status", status);

        // expense_date (may be null for old rows)
		java.sql.Date expDate = rs.getDate("expense_date");
        row.put("expense_date", expDate != null ? expDate.toString() : "-");

        expensesList.add(row);
    }
    rs.close(); ps.close();

    // ── 2. This month total ──────────────────────────────────────────────
    ps = con.prepareStatement(
        "SELECT COALESCE(SUM(amount), 0) AS month_total FROM expenses " +
        "WHERE MONTH(expense_date) = MONTH(CURDATE()) " +
        "AND   YEAR(expense_date)  = YEAR(CURDATE())"
    );
    rs = ps.executeQuery();
    if(rs.next()) thisMonthTotal = rs.getDouble("month_total");
    rs.close(); ps.close();

    // ── 3. Last 6 months breakdown ───────────────────────────────────────
    ps = con.prepareStatement(
        "SELECT DATE_FORMAT(expense_date, '%b %Y') AS month, " +
        "       DATE_FORMAT(expense_date, '%Y-%m') AS sort_month, " +
        "       COALESCE(SUM(amount), 0) AS total " +
        "FROM expenses " +
        "WHERE expense_date IS NOT NULL " +
        "GROUP BY DATE_FORMAT(expense_date, '%Y-%m'), DATE_FORMAT(expense_date, '%b %Y') " +
        "ORDER BY sort_month DESC " +
        "LIMIT 6"
    );
    rs = ps.executeQuery();
    while(rs.next()){
        monthlyTotals.put(rs.getString("month"), rs.getDouble("total"));
    }
    rs.close(); ps.close();

} catch(Exception e){
    errorMsg = e.getMessage();
    e.printStackTrace();
} finally {
    if(rs  != null) try{ rs.close();  } catch(Exception ignored){}
    if(ps  != null) try{ ps.close();  } catch(Exception ignored){}
    if(con != null) try{ con.close(); } catch(Exception ignored){}
}

// ── Chart data for category bar chart ────────────────────────────────────
Set<String> allCategories = new LinkedHashSet<>();
allCategories.addAll(paidTotals.keySet());
allCategories.addAll(pendingTotals.keySet());

StringBuilder categoriesJS = new StringBuilder("[");
StringBuilder paidJS       = new StringBuilder("[");
StringBuilder pendingJS    = new StringBuilder("[");

for(String c : allCategories){
    String safeC = c.replace("'", "\\'");
    categoriesJS.append("'").append(safeC).append("',");
    paidJS.append(paidTotals.getOrDefault(c, 0.0)).append(",");
    pendingJS.append(pendingTotals.getOrDefault(c, 0.0)).append(",");
}

if(categoriesJS.length() > 1) categoriesJS.setLength(categoriesJS.length()-1);
if(paidJS.length()       > 1) paidJS.setLength(paidJS.length()-1);
if(pendingJS.length()    > 1) pendingJS.setLength(pendingJS.length()-1);

categoriesJS.append("]");
paidJS.append("]");
pendingJS.append("]");

// ── Chart data for monthly line chart ────────────────────────────────────
StringBuilder monthsJS  = new StringBuilder("[");
StringBuilder monthlyJS = new StringBuilder("[");

for(Map.Entry<String,Double> entry : monthlyTotals.entrySet()){
    String safeM = entry.getKey().replace("'", "\\'");
    monthsJS.append("'").append(safeM).append("',");
    monthlyJS.append(entry.getValue()).append(",");
}

if(monthsJS.length()  > 1) monthsJS.setLength(monthsJS.length()-1);
if(monthlyJS.length() > 1) monthlyJS.setLength(monthlyJS.length()-1);

monthsJS.append("]");
monthlyJS.append("]");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Expenses Dashboard</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>

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
}

/* HEADER */
.header-card{
    background:linear-gradient(90deg,#2d7df6,#6a9cfb);
    color:white;
    padding:25px 30px;
    border-radius:15px;
    margin-bottom:25px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.header-card h1{ font-size:1.6rem; font-weight:700; }

.add-btn{
    background:linear-gradient(90deg,#f9a826,#f78c1e);
    color:white;
    border:none;
    padding:12px 22px;
    border-radius:8px;
    cursor:pointer;
    font-size:0.95rem;
    font-weight:600;
    transition:transform 0.15s, box-shadow 0.15s;
    font-family:'Inter',sans-serif;
}

.add-btn:hover{
    transform:translateY(-1px);
    box-shadow:0 4px 15px rgba(249,168,38,0.4);
}

/* SUMMARY CARDS */
.summary-row{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:20px;
    margin-bottom:25px;
}

.summary-card{
    background:white;
    border-radius:12px;
    padding:20px 22px;
    box-shadow:0 4px 15px rgba(0,0,0,0.06);
    border-left:5px solid #ddd;
}

.summary-card.total   { border-color:#2d7df6; }
.summary-card.paid    { border-color:#2ecc71; }
.summary-card.pending { border-color:#e74c3c; }
.summary-card.monthly { border-color:#f9a826; }

.summary-card .label{
    font-size:0.78rem;
    color:#888;
    text-transform:uppercase;
    letter-spacing:0.5px;
    margin-bottom:8px;
    font-weight:600;
}

.summary-card .value{
    font-size:1.5rem;
    font-weight:700;
    color:#1b2f6a;
}

.summary-card.paid    .value{ color:#27ae60; }
.summary-card.pending .value{ color:#e74c3c; }
.summary-card.monthly .value{ color:#e67e22; }

/* CARD */
.card{
    background:white;
    padding:25px;
    border-radius:15px;
    box-shadow:0 4px 20px rgba(0,0,0,0.06);
    margin-bottom:25px;
}

.card h2{
    font-size:1.1rem;
    color:#1b2f6a;
    margin-bottom:15px;
    font-weight:600;
}

/* MONTHLY GRID */
.month-grid{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:15px;
}

.month-card{
    background:#f8f9fc;
    border-radius:10px;
    padding:18px 20px;
    border-left:4px solid #2d7df6;
    transition:transform 0.2s, box-shadow 0.2s;
}

.month-card:hover{
    transform:translateY(-3px);
    box-shadow:0 6px 20px rgba(0,0,0,0.08);
}

.month-card .month-name{
    font-size:0.8rem;
    color:#888;
    text-transform:uppercase;
    letter-spacing:0.5px;
    margin-bottom:8px;
    font-weight:600;
}

.month-card .month-total{
    font-size:1.4rem;
    font-weight:700;
    color:#1b2f6a;
}

/* CHART */
.chart-container{
    background:#f8f9fc;
    padding:20px;
    border-radius:12px;
    max-height:350px;
    display:flex;
    justify-content:center;
}

/* TABLE */
.table-wrapper{ overflow-x:auto; }

table{
    width:100%;
    border-collapse:collapse;
    margin-top:5px;
    font-size:0.9rem;
}

th{
    background:#2d4ea2;
    color:white;
    padding:13px 15px;
    text-align:center;
    font-weight:600;
    white-space:nowrap;
}

th:first-child{ border-radius:8px 0 0 8px; }
th:last-child { border-radius:0 8px 8px 0; }

td{
    padding:12px 15px;
    text-align:center;
    border-bottom:1px solid #f0f0f0;
    color:#333;
}

tr:hover td{ background:#f0f5ff; }

/* STATUS FORM */
.status-form{ display:flex; gap:12px; justify-content:center; align-items:center; }

.status-form label{
    display:flex;
    align-items:center;
    gap:5px;
    cursor:pointer;
    font-size:0.85rem;
    font-weight:500;
}

/* ACTION BUTTONS */
.edit-btn,
.delete-btn{
    border:none;
    padding:7px 14px;
    border-radius:6px;
    cursor:pointer;
    font-size:0.82rem;
    font-weight:600;
    transition:opacity 0.15s;
}

.edit-btn  { background:#3498db; color:white; }
.delete-btn{ background:#e74c3c; color:white; margin-left:6px; }

.edit-btn:hover,
.delete-btn:hover{ opacity:0.85; }

/* BANNERS */
.success-banner{
    background:#d4f8e8;
    color:#1a7d45;
    padding:13px 18px;
    border-radius:8px;
    margin-bottom:20px;
    border-left:5px solid #2ecc71;
    font-size:0.9rem;
}

.error-banner{
    background:#fde8e8;
    color:#c0392b;
    padding:15px 20px;
    border-radius:10px;
    margin-bottom:20px;
    border-left:5px solid #e74c3c;
    font-size:0.9rem;
}

/* EMPTY STATE */
.empty-state{
    text-align:center;
    padding:50px 20px;
    color:#aaa;
}

.empty-state p{ font-size:1rem; margin-top:10px; }
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

    <!-- Header -->
    <div class="header-card">
        <h1>💰 Expenses Dashboard</h1>
        <a href="addExpense.jsp">
            <button class="add-btn">+ Add Expense</button>
        </a>
    </div>

    <!-- Success / Error banners -->
    <% String successMsg = request.getParameter("success");
       String errParam   = request.getParameter("error"); %>

    <% if(successMsg != null){ %>
    <div class="success-banner">✅ <%=successMsg%></div>
    <% } %>

    <% if(errorMsg != null){ %>
    <div class="error-banner">⚠️ Database error: <%=errorMsg%></div>
    <% } %>

    <% if(errParam != null){ %>
    <div class="error-banner">⚠️ <%=errParam%></div>
    <% } %>

    <!-- Summary Cards (4 cards including this month) -->
    <div class="summary-row">
        <div class="summary-card total">
            <div class="label">Total Expenses</div>
            <div class="value">₹ <%=String.format("%.2f", totalPaid + totalPending)%></div>
        </div>
        <div class="summary-card paid">
            <div class="label">Total Paid</div>
            <div class="value">₹ <%=String.format("%.2f", totalPaid)%></div>
        </div>
        <div class="summary-card pending">
            <div class="label">Total Pending</div>
            <div class="value">₹ <%=String.format("%.2f", totalPending)%></div>
        </div>
        <div class="summary-card monthly">
            <div class="label"><%=currentMonthName%></div>
            <div class="value">₹ <%=String.format("%.2f", thisMonthTotal)%></div>
        </div>
    </div>

    <!-- Monthly Breakdown -->
    <% if(!monthlyTotals.isEmpty()){ %>
    <div class="card">
        <h2>📅 Monthly Breakdown (Last 6 Months)</h2>
        <div class="month-grid">
            <% for(Map.Entry<String,Double> entry : monthlyTotals.entrySet()){ %>
            <div class="month-card">
                <div class="month-name"><%=entry.getKey()%></div>
                <div class="month-total">₹ <%=String.format("%.2f", entry.getValue())%></div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>

    <!-- Monthly Trend Chart -->
    <% if(!monthlyTotals.isEmpty()){ %>
    <div class="card">
        <h2>📈 Monthly Trend</h2>
        <div class="chart-container">
            <canvas id="monthlyChart"></canvas>
        </div>
    </div>
    <% } %>

    <!-- Category Bar Chart -->
    <% if(!expensesList.isEmpty()){ %>
    <div class="card">
        <h2>📊 Expenses by Category</h2>
        <div class="chart-container">
            <canvas id="expenseChart"></canvas>
        </div>
    </div>
    <% } %>

    <!-- All Expenses Table -->
    <div class="card">
        <h2>📋 All Expenses</h2>

        <% if(expensesList.isEmpty()){ %>
        <div class="empty-state">
            <div style="font-size:3rem;">💸</div>
            <p>No expenses found. Click <strong>+ Add Expense</strong> to get started.</p>
        </div>
        <% } else { %>

        <div class="table-wrapper">
        <table>
            <tr>
                <th>#</th>
                <th>Amount</th>
                <th>Category</th>
                <th>Date</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>

            <%
            int rowNum = 1;
            for(Map<String,Object> e : expensesList){
                String rowStatus = String.valueOf(e.get("payment_status"));
            %>
            <tr>
                <td><%=rowNum++%></td>
                <td><strong>₹ <%=String.format("%.2f", (Double)e.get("amount"))%></strong></td>
                <td><%=e.get("category")%></td>
                <td><%=e.get("expense_date")%></td>
                <td>
                    <form action="updateStatus" method="post" class="status-form">
                        <input type="hidden" name="expense_id" value="<%=e.get("expense_id")%>">
                        <label>
                            <input type="radio" name="status" value="Paid"
                                <% if("Paid".equalsIgnoreCase(rowStatus)){ %>checked<% } %>
                                onchange="this.form.submit()"> Paid
                        </label>
                        <label>
                            <input type="radio" name="status" value="Pending"
                                <% if("Pending".equalsIgnoreCase(rowStatus)){ %>checked<% } %>
                                onchange="this.form.submit()"> Pending
                        </label>
                    </form>
                </td>
                <td>
                    <a href="editExpense?expense_id=<%=e.get("expense_id")%>">
                        <button class="edit-btn">✏️ Edit</button>
                    </a>
                    <a href="deleteExpense?expense_id=<%=e.get("expense_id")%>"
                       onclick="return confirm('Are you sure you want to delete this expense?')">
                        <button class="delete-btn">🗑️ Delete</button>
                    </a>
                </td>
            </tr>
            <% } %>
        </table>
        </div>

        <% } %>
    </div>

</div><!-- /main -->


<!-- CHARTS -->
<% if(!expensesList.isEmpty()){ %>
<script>
// Category Bar Chart
const ctx1 = document.getElementById('expenseChart').getContext('2d');
new Chart(ctx1, {
    type: 'bar',
    data: {
        labels: <%=categoriesJS.toString()%>,
        datasets: [
            {
                label: 'Paid',
                data: <%=paidJS.toString()%>,
                backgroundColor: '#2ecc71',
                borderRadius: 6,
                barThickness: 60,
                maxBarThickness: 80
            },
            {
                label: 'Pending',
                data: <%=pendingJS.toString()%>,
                backgroundColor: '#e74c3c',
                borderRadius: 6,
                barThickness: 60,
                maxBarThickness: 80
            }
        ]
    },
    options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
            legend: { position: 'top' },
            datalabels: {
                color: '#fff',
                anchor: 'center',
                align: 'center',
                font: { weight: 'bold', size: 12 },
                formatter: function(value){
                    return value > 0 ? '₹' + value.toFixed(0) : '';
                }
            }
        },
        scales: {
            x: { stacked: true },
            y: { stacked: true, beginAtZero: true }
        }
    },
    plugins: [ChartDataLabels]
});
</script>
<% } %>

<% if(!monthlyTotals.isEmpty()){ %>
<script>
// Monthly Line Chart
const ctx2 = document.getElementById('monthlyChart').getContext('2d');
new Chart(ctx2, {
    type: 'line',
    data: {
        labels: <%=monthsJS.toString()%>,
        datasets: [
            {
                label: 'Monthly Expenses',
                data: <%=monthlyJS.toString()%>,
                borderColor: '#2d7df6',
                backgroundColor: 'rgba(45,125,246,0.1)',
                tension: 0.4,
                fill: true,
                pointRadius: 6,
                pointBackgroundColor: '#2d7df6',
                pointHoverRadius: 8
            }
        ]
    },
    options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
            legend: { position: 'top' },
            tooltip: {
                callbacks: {
                    label: function(context){
                        return 'Total: ₹' + context.parsed.y.toFixed(2);
                    }
                }
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    callback: function(value){ return '₹' + value; }
                }
            }
        }
    }
});
</script>
<% } %>

</body>
</html>
