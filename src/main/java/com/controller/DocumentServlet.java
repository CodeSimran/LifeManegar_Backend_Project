package com.controller;

import java.io.IOException;
import java.util.List;

import com.dao.DocumentDAO;
import com.dao.DocumentDAOImpl;
import com.model.Document;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/documents")
public class DocumentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("us");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        DocumentDAO dao = new DocumentDAOImpl();
        List<Document> docs = dao.getDocumentsByUser(user.getEmail());

        req.setAttribute("docs", docs);
        req.getRequestDispatcher("documents.jsp").forward(req, resp);
    }
}