package com.controller;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.util.DBConnection;

@WebServlet("/updateExpense")
public class UpdateExpenseServlet extends HttpServlet {

protected void doPost(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {

int id = Integer.parseInt(request.getParameter("expense_id"));
double amount = Double.parseDouble(request.getParameter("amount"));
String category = request.getParameter("category");
String status = request.getParameter("payment_status");

try{

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
"UPDATE expenses SET amount=?,category=?,payment_status=? WHERE expense_id=?");

ps.setDouble(1,amount);
ps.setString(2,category);
ps.setString(3,status);
ps.setInt(4,id);

ps.executeUpdate();

response.sendRedirect("expenses.jsp");

}catch(Exception e){
e.printStackTrace();
}

}

}