package com.model;

public class Expense {

    private int expenseId;
    private int userId;
    private double amount;
    private String category;
    private String paymentStatus;
    private java.sql.Date expenseDate; // ✅ NEW

    // ── expenseId ──
    public int getExpenseId() { return expenseId; }
    public void setExpenseId(int expenseId) { this.expenseId = expenseId; }

    // ── userId ──
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    // ── amount ──
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    // ── category ──
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    // ── paymentStatus ──
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    // ── expenseDate ✅ NEW ──
    public java.sql.Date getExpenseDate() { return expenseDate; }
    public void setExpenseDate(java.sql.Date expenseDate) { this.expenseDate = expenseDate; }
}
