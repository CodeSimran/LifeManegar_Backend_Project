package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.model.User;
import com.util.DBConnection;

public class UserDAOImpl implements UserDAO {
	Connection con= DBConnection.getConnection();

	
	@Override
	public boolean register(User user) {
		try {
			
			
			String sql= "INSERT INTO users(name,email,password,phone) VALUES(?,?,?,?)";
			
			PreparedStatement ps=con.prepareStatement(sql);
			ps.setString(1, user.getName());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getPassword());
			ps.setLong(4, user.getPhone());
			
			ps.executeUpdate();
			return true;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	@Override
	public User loginUser(String email, String password) {
		// TODO Auto-generated method stub
		
		String login="select*from users where email=? and password=?";
		User user=null;

		try {
			PreparedStatement pstmt=con.prepareStatement(login);
			pstmt.setString(1, email);
			pstmt.setString(2, password);
			ResultSet rs=pstmt.executeQuery();
			if(rs.next()) {
				user=new User();
				user.setName(rs.getString(2));
				user.setEmail(rs.getString(3));
				user.setPassword(rs.getString(4));
				user.setPhone(rs.getLong(5));
				return user;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

	@Override
	public List<User> getAllUsers() {
		String allusers="Select * from users";
		List<User> ulist=new ArrayList<>();
		try {
			PreparedStatement pstmt=con.prepareStatement(allusers);
			ResultSet rs=pstmt.executeQuery();
			while(rs.next())
			{
				User user=new User();//create a new object for each and every
				user.setName(rs.getString(2));
				user.setEmail(rs.getString(3));
				user.setPassword(rs.getString(5));
				user.setPhone(rs.getLong(5));
				ulist.add(user);//adding new user into the collection
			}

			return ulist;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
}