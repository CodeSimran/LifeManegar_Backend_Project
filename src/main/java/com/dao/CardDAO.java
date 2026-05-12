package com.dao;

import java.util.List;
import com.model.Card;

public interface CardDAO {

    boolean addCard(Card card);

    List<Card> getCardsByUser(int userId);

}