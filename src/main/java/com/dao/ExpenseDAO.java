package com.dao;

import com.model.Expense;
import java.util.List;

public interface ExpenseDAO {

    // Save an expense
    boolean saveExpense(Expense expense);

    // Optional: Get all expenses for a specific user
    List<Expense> getExpensesByUserId(int userId);

    // Optional: Delete an expense by ID
    boolean deleteExpense(int expenseId);

    // Optional: Update an expense
    boolean updateExpense(Expense expense);
}