
package com.controller;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.util.DBConnection;

@WebServlet("/deleteExpense")
public class DeleteExpenseServlet extends HttpServlet {

protected void doGet(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {

int id = Integer.parseInt(request.getParameter("expense_id"));

try{

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
"DELETE FROM expenses WHERE expense_id=?");

ps.setInt(1,id);

ps.executeUpdate();

response.sendRedirect("expenses.jsp");

}catch(Exception e){
e.printStackTrace();
}

}

}