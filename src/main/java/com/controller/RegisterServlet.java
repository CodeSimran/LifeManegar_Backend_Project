package com.controller;

import java.io.IOException;

import com.dao.UserDAO;
import com.dao.UserDAOImpl;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet{

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String name=req.getParameter("name");
		String email=req.getParameter("email");
		String password=req.getParameter("password");
		String phoneStr = req.getParameter("phone");
		Long phone = Long.parseLong(phoneStr);
		
		User user=new User();
		user.setName(name);
		user.setEmail(email);
		user.setPassword(password);
		user.setPhone(phone);
		
		UserDAO dao=new UserDAOImpl();
		
		if(dao.register(user)) {
			resp.sendRedirect("login.jsp");
		}
		else {
			resp.sendRedirect("register.jsp");
		}
		
	}
	

}