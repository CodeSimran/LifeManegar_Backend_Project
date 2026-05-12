package com.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.model.Expense;
import com.util.DBConnection;

public class ExpenseDAOImpl implements ExpenseDAO {

    // ✅ FIX: Don't store connection as a field — get a fresh one per method
    // A single shared connection causes issues after timeout or errors

    @Override
    public boolean saveExpense(Expense expense) {
        String sql = "INSERT INTO expenses(user_id, amount, category, payment_status, expense_date) VALUES(?,?,?,?,?)";
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, expense.getUserId());
            ps.setDouble(2, expense.getAmount());
            ps.setString(3, expense.getCategory());
            ps.setString(4, expense.getPaymentStatus());
            // ✅ NEW: save expense_date, fallback to today if null
            if (expense.getExpenseDate() != null) {
                ps.setDate(5, expense.getExpenseDate());
            } else {
                ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
            }
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
        return false;
    }

    @Override
    public List<Expense> getExpensesByUserId(int userId) {
        List<Expense> expenses = new ArrayList<>();
        String sql = "SELECT * FROM expenses WHERE user_id=? ORDER BY expense_date DESC";
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Expense e = new Expense();
                e.setExpenseId(rs.getInt("expense_id"));
                e.setUserId(rs.getInt("user_id"));
                e.setAmount(rs.getDouble("amount"));
                e.setCategory(rs.getString("category"));
                e.setPaymentStatus(rs.getString("payment_status"));
                e.setExpenseDate(rs.getDate("expense_date")); // ✅ NEW
                expenses.add(e);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
        return expenses;
    }

    @Override
    public boolean deleteExpense(int expenseId) {
        String sql = "DELETE FROM expenses WHERE expense_id=?";
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, expenseId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
        return false;
    }

    @Override
    public boolean updateExpense(Expense expense) {
        // ✅ Also update expense_date when editing
        String sql = "UPDATE expenses SET amount=?, category=?, payment_status=?, expense_date=? WHERE expense_id=?";
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDouble(1, expense.getAmount());
            ps.setString(2, expense.getCategory());
            ps.setString(3, expense.getPaymentStatus());
            if (expense.getExpenseDate() != null) {
                ps.setDate(4, expense.getExpenseDate());
            } else {
                ps.setDate(4, new java.sql.Date(System.currentTimeMillis()));
            }
            ps.setInt(5, expense.getExpenseId());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
        return false;
    }
}