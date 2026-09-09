package com.armora.dao;

import com.armora.model.Issue;
import com.armora.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IssueDAO {

    public List<Issue> getAllIssues() {
        List<Issue> issues = new ArrayList<>();
        String sql = "SELECT i.issue_id, i.user_id, i.bike_id, i.issue_date, i.due_date, i.return_date, i.status, "
                   + "CONCAT(u.first_name, ' ', u.last_name) AS user_name, b.title AS bike_title "
                   + "FROM issues i "
                   + "JOIN users u ON i.user_id = u.user_id "
                   + "JOIN bikes b ON i.bike_id = b.bike_id "
                   + "ORDER BY i.issue_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                issues.add(mapIssue(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return issues;
    }

    public List<Issue> getActiveIssues() {
        List<Issue> issues = new ArrayList<>();
        String sql = "SELECT i.issue_id, i.user_id, i.bike_id, i.issue_date, i.due_date, i.return_date, i.status, "
                   + "CONCAT(u.first_name, ' ', u.last_name) AS user_name, b.title AS bike_title "
                   + "FROM issues i "
                   + "JOIN users u ON i.user_id = u.user_id "
                   + "JOIN bikes b ON i.bike_id = b.bike_id "
                   + "WHERE i.status = 'ACTIVE' "
                   + "ORDER BY i.due_date ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                issues.add(mapIssue(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return issues;
    }

    public boolean issueBike(int userId, int bikeId, Date dueDate) {
        String insertIssue = "INSERT INTO issues (user_id, bike_id, issue_date, due_date, status) VALUES (?, ?, CURDATE(), ?, 'ACTIVE')";
        String updateBike = "UPDATE bikes SET status = 'ISSUED' WHERE bike_id = ? AND status = 'AVAILABLE'";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement bikePs = conn.prepareStatement(updateBike)) {
                bikePs.setInt(1, bikeId);
                if (bikePs.executeUpdate() != 1) {
                    conn.rollback();
                    return false;
                }
            }
            try (PreparedStatement issuePs = conn.prepareStatement(insertIssue)) {
                issuePs.setInt(1, userId);
                issuePs.setInt(2, bikeId);
                issuePs.setDate(3, dueDate);
                if (issuePs.executeUpdate() != 1) {
                    conn.rollback();
                    return false;
                }
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean returnBike(int issueId) {
        String findBike = "SELECT bike_id FROM issues WHERE issue_id = ? AND status = 'ACTIVE'";
        String updateIssue = "UPDATE issues SET return_date = CURDATE(), status = 'RETURNED' WHERE issue_id = ?";
        String updateBike = "UPDATE bikes SET status = 'AVAILABLE' WHERE bike_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            int bikeId = -1;
            try (PreparedStatement findPs = conn.prepareStatement(findBike)) {
                findPs.setInt(1, issueId);
                try (ResultSet rs = findPs.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                    bikeId = rs.getInt("bike_id");
                }
            }
            try (PreparedStatement issuePs = conn.prepareStatement(updateIssue)) {
                issuePs.setInt(1, issueId);
                if (issuePs.executeUpdate() != 1) {
                    conn.rollback();
                    return false;
                }
            }
            try (PreparedStatement bikePs = conn.prepareStatement(updateBike)) {
                bikePs.setInt(1, bikeId);
                bikePs.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countActiveIssues() {
        return countQuery("SELECT COUNT(*) FROM issues WHERE status = 'ACTIVE'");
    }

    public int countReturnedIssues() {
        return countQuery("SELECT COUNT(*) FROM issues WHERE status = 'RETURNED'");
    }

    public List<Issue> getIssuesByUser(int userId) {
        List<Issue> issues = new ArrayList<>();
        String sql = "SELECT i.issue_id, i.user_id, i.bike_id, i.issue_date, i.due_date, i.return_date, i.status, "
                   + "CONCAT(u.first_name, ' ', u.last_name) AS user_name, b.title AS bike_title, b.genre AS bike_genre "
                   + "FROM issues i "
                   + "JOIN users u ON i.user_id = u.user_id "
                   + "JOIN bikes b ON i.bike_id = b.bike_id "
                   + "WHERE i.user_id = ? "
                   + "ORDER BY i.issue_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    issues.add(mapIssueWithGenre(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return issues;
    }

    public Issue getActiveIssueByUser(int userId) {
        String sql = "SELECT i.issue_id, i.user_id, i.bike_id, i.issue_date, i.due_date, i.return_date, i.status, "
                   + "CONCAT(u.first_name, ' ', u.last_name) AS user_name, b.title AS bike_title, b.genre AS bike_genre "
                   + "FROM issues i "
                   + "JOIN users u ON i.user_id = u.user_id "
                   + "JOIN bikes b ON i.bike_id = b.bike_id "
                   + "WHERE i.user_id = ? AND i.status = 'ACTIVE' "
                   + "ORDER BY i.issue_id DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapIssueWithGenre(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countIssuesByUser(int userId) {
        return countQuery("SELECT COUNT(*) FROM issues WHERE user_id = ?", userId);
    }

    public int countActiveIssuesByUser(int userId) {
        return countQuery("SELECT COUNT(*) FROM issues WHERE user_id = ? AND status = 'ACTIVE'", userId);
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

    private int countQuery(String sql, int userId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
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

    private Issue mapIssue(ResultSet rs) throws SQLException {
        Issue issue = new Issue();
        issue.setIssueId(rs.getInt("issue_id"));
        issue.setUserId(rs.getInt("user_id"));
        issue.setBikeId(rs.getInt("bike_id"));
        issue.setUserName(rs.getString("user_name"));
        issue.setBikeTitle(rs.getString("bike_title"));
        issue.setIssueDate(rs.getDate("issue_date"));
        issue.setDueDate(rs.getDate("due_date"));
        issue.setReturnDate(rs.getDate("return_date"));
        issue.setStatus(rs.getString("status"));
        return issue;
    }

    private Issue mapIssueWithGenre(ResultSet rs) throws SQLException {
        Issue issue = mapIssue(rs);
        try {
            issue.setBikeGenre(rs.getString("bike_genre"));
        } catch (SQLException ignored) {
            issue.setBikeGenre(null);
        }
        return issue;
    }
}
