package com.armora.dao;

import com.armora.model.Bike;
import com.armora.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    public List<Bike> getWishlistByUser(int userId) {
        List<Bike> bikes = new ArrayList<>();
        String sql = "SELECT b.* FROM wishlist w JOIN bikes b ON w.bike_id = b.bike_id "
                   + "WHERE w.user_id = ? ORDER BY w.added_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bikes.add(mapBike(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bikes;
    }

    public boolean addToWishlist(int userId, int bikeId) {
        String sql = "INSERT INTO wishlist (user_id, bike_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bikeId);
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeFromWishlist(int userId, int bikeId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND bike_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bikeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isInWishlist(int userId, int bikeId) {
        String sql = "SELECT 1 FROM wishlist WHERE user_id = ? AND bike_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bikeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Bike mapBike(ResultSet rs) throws SQLException {
        Bike bike = new Bike();
        bike.setBikeId(rs.getInt("bike_id"));
        bike.setTitle(rs.getString("title"));
        bike.setIsbnNumber(rs.getString("isbn_number"));
        bike.setGenre(rs.getString("genre"));
        bike.setAuthor(rs.getString("author"));
        bike.setStatus(rs.getString("status"));
        bike.setPricePerHour(rs.getBigDecimal("price_per_hour"));
        try {
            bike.setImageUrl(rs.getString("image_url"));
        } catch (SQLException ignored) {
            bike.setImageUrl(null);
        }
        return bike;
    }
}
