package com.controller;

import java.io.IOException;

import com.dao.CardDAO;
import com.dao.CardDAOImpl;
import com.model.Card;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/addCard")
public class AddCardServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        try {

            int userId = 1; // later get from session

            String cardName = req.getParameter("card_name");
            String bankName = req.getParameter("bank_name");
            String cardType = req.getParameter("card_type");
            String last4 = req.getParameter("last_four_digits");
            String expiry = req.getParameter("expiry_date");

            Card card = new Card();

            card.setId(userId);
            card.setCard_name(cardName);
            card.setBank_name(bankName);
            card.setCard_type(cardType);
            card.setLast_four_digits(last4);
            card.setExpiry_date(expiry);

            CardDAO dao = new CardDAOImpl();

            if (dao.addCard(card)) {

                resp.sendRedirect("cards.jsp");

            } else {

                resp.sendRedirect("add_card.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}