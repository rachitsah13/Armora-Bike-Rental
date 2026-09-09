package com.armora.dao;

import com.armora.model.Bike;
import com.armora.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BikeDAO {

    public List<Bike> getAllBikes() {
        List<Bike> bikes = new ArrayList<>();
        String sql = "SELECT * FROM bikes";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                bikes.add(mapBike(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bikes;
    }

    public List<Bike> getAvailableBikes() {
        List<Bike> bikes = new ArrayList<>();
        String sql = "SELECT * FROM bikes WHERE status = 'AVAILABLE' ORDER BY title";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                bikes.add(mapBike(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bikes;
    }

    public boolean addBike(String title, String isbn, String genre, String author, java.math.BigDecimal price) {
        String sql = "INSERT INTO bikes (title, isbn_number, genre, author, price_per_hour, status) VALUES (?, ?, ?, ?, ?, 'AVAILABLE')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, isbn);
            ps.setString(3, genre);
            ps.setString(4, author);
            ps.setBigDecimal(5, price);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(int bikeId, String status) {
        String sql = "UPDATE bikes SET status = ? WHERE bike_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bikeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countAll() {
        return countQuery("SELECT COUNT(*) FROM bikes");
    }

    public int countByStatus(String status) {
        return countQuery("SELECT COUNT(*) FROM bikes WHERE status = ?", status);
    }

    private int countQuery(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private int countQuery(String sql, String param) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, param);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
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
