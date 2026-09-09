package com.armora.dao;

import com.armora.model.User;
import com.armora.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /**
     * Registers a new user in the database.
     * Returns true if successful, false if email or phone already exists.
     */
    public boolean registerUser(User user) throws SQLException {
        String query = "INSERT INTO users (first_name, last_name, email, phone, password_hash, role, course, level, is_approved) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
             
            pstmt.setString(1, user.getFirstName());
            pstmt.setString(2, user.getLastName());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getPasswordHash());
            pstmt.setString(6, user.getRole());
            pstmt.setString(7, user.getCourse());
            pstmt.setString(8, user.getLevel());
            pstmt.setBoolean(9, user.isApproved());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLIntegrityConstraintViolationException e) {
            // Handle unique constraint violations (duplicate email or phone)
            return false; 
        }
    }

    /**
     * Authenticates a user by email/phone and returns the User object if successful.
     */
    public User authenticateUser(String identifier, String passwordHash) {
        // Query checks either email or phone
        String query = "SELECT * FROM users WHERE (email = ? OR phone = ?) AND password_hash = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
             
            pstmt.setString(1, identifier);
            pstmt.setString(2, identifier);
            pstmt.setString(3, passwordHash);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                    user.setCourse(rs.getString("course"));
                    user.setLevel(rs.getString("level"));
                    user.setProfilePicture(rs.getString("profile_picture"));
                    user.setApproved(rs.getBoolean("is_approved"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Authentication failed
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public List<User> getApprovedUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users WHERE is_approved = TRUE AND role = 'USER' ORDER BY first_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean updateProfile(int userId, String firstName, String lastName, String phone, String course, String level, String profilePicture) {
        String query = "UPDATE users SET first_name = ?, last_name = ?, phone = ?, course = ?, level = ?, profile_picture = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, phone);
            pstmt.setString(4, course);
            pstmt.setString(5, level);
            pstmt.setString(6, profilePicture);
            pstmt.setInt(7, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean approveUser(int userId) {
        String query = "UPDATE users SET is_approved = TRUE WHERE user_id = ? AND role = 'USER'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean pauseUser(int userId) {
        String query = "UPDATE users SET is_approved = FALSE WHERE user_id = ? AND role = 'USER'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(int userId) {
        String query = "DELETE FROM users WHERE user_id = ? AND role = 'USER'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countApprovedUsers() {
        return countQuery("SELECT COUNT(*) FROM users WHERE is_approved = TRUE AND role = 'USER'");
    }

    public int countPendingApprovals() {
        return countQuery("SELECT COUNT(*) FROM users WHERE is_approved = FALSE AND role = 'USER'");
    }

    private int countQuery(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getString("role"));
        user.setCourse(rs.getString("course"));
        user.setLevel(rs.getString("level"));
        user.setProfilePicture(rs.getString("profile_picture"));
        user.setApproved(rs.getBoolean("is_approved"));
        return user;
    }
}
