package com.dao;

import java.util.List;

import com.model.User;

public interface UserDAO {
	public boolean register(User user);
	public User loginUser(String email, String password);
	public List<User> getAllUsers();
	 
}