package com.controller;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.util.DBConnection;

@WebServlet("/editExpense")
public class EditExpenseServlet extends HttpServlet {

protected void doGet(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {

int id = Integer.parseInt(request.getParameter("expense_id"));

try{

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
"SELECT * FROM expenses WHERE expense_id=?");

ps.setInt(1,id);

ResultSet rs = ps.executeQuery();

if(rs.next()){

request.setAttribute("expense", rs);

RequestDispatcher rd = request.getRequestDispatcher("editExpense.jsp");

rd.forward(request,response);

}

}catch(Exception e){
e.printStackTrace();
}

}

}