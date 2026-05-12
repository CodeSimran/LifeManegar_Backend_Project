package com.controller;

import java.io.IOException;
import java.util.List;



import com.dao.UserDAO;
import com.dao.UserDAOImpl;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		UserDAO udao=new UserDAOImpl();
		List<User> ulist = udao.getAllUsers();
		if(!ulist.isEmpty()) {
			req.setAttribute("userlist", ulist);
			req.getRequestDispatcher("dashboard.jsp").forward(req,resp);
		}
	}

	

}