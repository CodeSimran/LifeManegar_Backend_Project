package com.controller;

import java.io.IOException;
import com.dao.ExpenseDAO;
import com.dao.ExpenseDAOImpl;
import com.model.Expense;
import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addExpense")
public class AddExpenseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("us") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user   = (User) session.getAttribute("us");
        int userId  = user.getUserId();

        // 2. Get amount
        double amount = 0;
        try {
            amount = Double.parseDouble(request.getParameter("amount"));
        } catch (NumberFormatException e) {
            response.sendRedirect("addExpense.jsp?error=Invalid+amount");
            return;
        }

        // 3. Get category and status (null-safe)
        String category      = request.getParameter("category");
        String paymentStatus = request.getParameter("paymentStatus");

        if (category      == null || category.trim().isEmpty())      category      = "Other";
        if (paymentStatus == null || paymentStatus.trim().isEmpty()) paymentStatus = "Pending";

        // 4. Get expense date (null-safe — fallback to today)
        String expenseDateStr = request.getParameter("expense_date");
        java.sql.Date expenseDate;
        try {
            if (expenseDateStr != null && !expenseDateStr.trim().isEmpty()) {
                expenseDate = java.sql.Date.valueOf(expenseDateStr); // expects yyyy-MM-dd
            } else {
                expenseDate = new java.sql.Date(System.currentTimeMillis()); // today
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect("addExpense.jsp?error=Invalid+date+format");
            return;
        }

        // 5. Build Expense object
        Expense expense = new Expense();
        expense.setUserId(userId);
        expense.setAmount(amount);
        expense.setCategory(category);
        expense.setPaymentStatus(paymentStatus);
        expense.setExpenseDate(expenseDate); // ✅ NEW field

        // 6. Save to DB
        ExpenseDAO dao  = new ExpenseDAOImpl();
        boolean saved   = dao.saveExpense(expense);

        // 7. Redirect
        if (saved) {
            response.sendRedirect("expenses.jsp?success=Expense+added+successfully");
        } else {
            response.sendRedirect("addExpense.jsp?error=Failed+to+add+expense");
        }
    }
}