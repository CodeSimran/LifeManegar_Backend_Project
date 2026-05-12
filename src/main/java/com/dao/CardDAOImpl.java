package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.model.Card;
import com.util.DBConnection;

public class CardDAOImpl implements CardDAO {

    Connection con = DBConnection.getConnection();

    public boolean addCard(Card card) {
        boolean status = false;

        try {

            String sql = "insert into cards(id,card_name,bank_name,card_type,last_four_digits,expiry_date) values(?,?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, card.getId());
            ps.setString(2, card.getCard_name());
            ps.setString(3, card.getBank_name());
            ps.setString(4, card.getCard_type());
            ps.setString(5, card.getLast_four_digits());
            ps.setString(6, card.getExpiry_date());

            int i = ps.executeUpdate();

            if (i > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    public List<Card> getCardsByUser(int userId) {

        List<Card> list = new ArrayList<>();

        try {

            String sql = "select * from cards where id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Card c = new Card();

                c.setCards_id(rs.getInt("cards_id"));
                c.setCard_name(rs.getString("card_name"));
                c.setBank_name(rs.getString("bank_name"));
                c.setCard_type(rs.getString("card_type"));
                c.setLast_four_digits(rs.getString("last_four_digits"));
                c.setExpiry_date(rs.getString("expiry_date"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}