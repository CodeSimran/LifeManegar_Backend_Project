package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.model.Document;
import com.util.DBConnection;

public class DocumentDAOImpl implements DocumentDAO {

    Connection con = DBConnection.getConnection();

    public boolean addDocument(Document doc) {
        try {
            String sql = "INSERT INTO documents(title,type,expiry_date,user_email) VALUES(?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, doc.getTitle());
            ps.setString(2, doc.getType());
            ps.setDate(3, doc.getExpiryDate());
            ps.setString(4, doc.getUserEmail());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Document> getDocumentsByUser(String email) {
        List<Document> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM documents WHERE user_email=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Document d = new Document();
                d.setId(rs.getInt(1));
                d.setTitle(rs.getString(2));
                d.setType(rs.getString(3));
                d.setExpiryDate(rs.getDate(4));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}