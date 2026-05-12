
package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateStatus")
public class UpdateStatusServlet extends HttpServlet {

protected void doPost(HttpServletRequest req, HttpServletResponse resp)
throws ServletException, IOException {

int id = Integer.parseInt(req.getParameter("expense_id"));
String status = req.getParameter("status");

try {

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
"UPDATE expenses SET payment_status=? WHERE expense_id=?");

ps.setString(1, status);
ps.setInt(2, id);

ps.executeUpdate();

resp.sendRedirect("expenses.jsp");

} catch(Exception e) {
e.printStackTrace();
}

}
}