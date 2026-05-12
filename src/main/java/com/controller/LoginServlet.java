package com.controller;

import java.io.IOException;

import com.dao.UserDAOImpl;
import com.model.User;
import com.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String email=req.getParameter("email");
		String password=req.getParameter("password");
		
		UserDAO udao=new UserDAOImpl();
		User user=udao.loginUser(email, password);
		
		
		HttpSession session=req.getSession();
		if(user!=null) {
			session.setAttribute("us", user);
			resp.sendRedirect("dashboard");
		}
		else {
			resp.sendRedirect("login.jsp");
		}
		
		
		
	}

}