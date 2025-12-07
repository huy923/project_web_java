package dao;

import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReviewDao {

    public List<Map<String, Object>> getAllReviews() throws SQLException {
        String sql = "SELECT r.review_id, r.booking_id, r.rating, r.comment, r.title, r.is_public, r.created_at, " +
                "g.first_name, g.last_name, g.email " +
                "FROM reviews r " +
                "JOIN bookings b ON r.booking_id = b.booking_id " +
                "JOIN guests g ON b.guest_id = g.guest_id " +
                "ORDER BY r.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> reviews = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> review = new HashMap<>();
                review.put("review_id", rs.getInt("review_id"));
                review.put("booking_id", rs.getInt("booking_id"));
                review.put("rating", rs.getInt("rating"));
                review.put("title", rs.getString("title"));
                review.put("comment", rs.getString("comment"));
                review.put("is_public", rs.getBoolean("is_public"));
                review.put("guest_name", rs.getString("first_name") + " " + rs.getString("last_name"));
                review.put("guest_email", rs.getString("email"));
                review.put("created_at", rs.getTimestamp("created_at"));
                reviews.add(review);
            }
            return reviews;
        }
    }

    public List<Map<String, Object>> getPublicReviews() throws SQLException {
        String sql = "SELECT r.review_id, r.booking_id, r.rating, r.title, r.comment, r.created_at, " +
                "g.first_name, g.last_name " +
                "FROM reviews r " +
                "JOIN bookings b ON r.booking_id = b.booking_id " +
                "JOIN guests g ON b.guest_id = g.guest_id " +
                "WHERE r.is_public = TRUE " +
                "ORDER BY r.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            List<Map<String, Object>> reviews = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> review = new HashMap<>();
                review.put("review_id", rs.getInt("review_id"));
                review.put("guest_name", rs.getString("first_name") + " " + rs.getString("last_name"));
                review.put("rating", rs.getInt("rating"));
                review.put("title", rs.getString("title"));
                review.put("comment", rs.getString("comment"));
                review.put("created_at", rs.getTimestamp("created_at"));
                reviews.add(review);
            }
            return reviews;
        }
    }

    public List<Map<String, Object>> getReviewsByBookingId(int bookingId) throws SQLException {
        String sql = "SELECT * FROM reviews WHERE booking_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> reviews = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> review = new HashMap<>();
                    review.put("review_id", rs.getInt("review_id"));
                    review.put("booking_id", rs.getInt("booking_id"));
                    review.put("rating", rs.getInt("rating"));
                    review.put("title", rs.getString("title"));
                    review.put("comment", rs.getString("comment"));
                    review.put("is_public", rs.getBoolean("is_public"));
                    review.put("created_at", rs.getTimestamp("created_at"));
                    reviews.add(review);
                }
                return reviews;
            }
        }
    }

    public List<Map<String, Object>> getReviewsByRating(int minRating, int maxRating) throws SQLException {
        String sql = "SELECT r.*, g.first_name, g.last_name FROM reviews r " +
                "JOIN bookings b ON r.booking_id = b.booking_id " +
                "JOIN guests g ON b.guest_id = g.guest_id " +
                "WHERE r.rating BETWEEN ? AND ? AND r.is_public = TRUE " +
                "ORDER BY r.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, minRating);
            ps.setInt(2, maxRating);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> reviews = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> review = new HashMap<>();
                    review.put("review_id", rs.getInt("review_id"));
                    review.put("guest_name", rs.getString("first_name") + " " + rs.getString("last_name"));
                    review.put("rating", rs.getInt("rating"));
                    review.put("title", rs.getString("title"));
                    review.put("comment", rs.getString("comment"));
                    reviews.add(review);
                }
                return reviews;
            }
        }
    }

    public boolean addReview(int bookingId, int rating, String title, String comment, boolean isPublic)
            throws SQLException {
        String sql = "INSERT INTO reviews (booking_id, rating, title, comment, is_public) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, rating);
            ps.setString(3, title);
            ps.setString(4, comment);
            ps.setBoolean(5, isPublic);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateReview(int reviewId, int rating, String title, String comment, boolean isPublic)
            throws SQLException {
        String sql = "UPDATE reviews SET rating = ?, title = ?, comment = ?, is_public = ? WHERE review_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setString(2, title);
            ps.setString(3, comment);
            ps.setBoolean(4, isPublic);
            ps.setInt(5, reviewId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean toggleReviewVisibility(int reviewId) throws SQLException {
        String sql = "UPDATE reviews SET is_public = !is_public WHERE review_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean deleteReview(int reviewId) throws SQLException {
        String sql = "DELETE FROM reviews WHERE review_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() == 1;
        }
    }

    public Map<String, Object> getReviewById(int reviewId) throws SQLException {
        String sql = "SELECT r.*, g.first_name, g.last_name FROM reviews r " +
                "JOIN bookings b ON r.booking_id = b.booking_id " +
                "JOIN guests g ON b.guest_id = g.guest_id WHERE r.review_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> review = new HashMap<>();
                    review.put("review_id", rs.getInt("review_id"));
                    review.put("booking_id", rs.getInt("booking_id"));
                    review.put("guest_name", rs.getString("first_name") + " " + rs.getString("last_name"));
                    review.put("rating", rs.getInt("rating"));
                    review.put("title", rs.getString("title"));
                    review.put("comment", rs.getString("comment"));
                    review.put("is_public", rs.getBoolean("is_public"));
                    review.put("created_at", rs.getTimestamp("created_at"));
                    return review;
                }
            }
        }
        return null;
    }

    public double getAverageRating() throws SQLException {
        String sql = "SELECT AVG(rating) as avg_rating FROM reviews WHERE is_public = TRUE";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        }
        return 0.0;
    }

    public int getTotalReviews() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM reviews";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    public int getPublicReviewsCount() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM reviews WHERE is_public = TRUE";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }

    public Map<Integer, Integer> getRatingDistribution() throws SQLException {
        String sql = "SELECT rating, COUNT(*) as count FROM reviews WHERE is_public = TRUE GROUP BY rating ORDER BY rating";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            Map<Integer, Integer> distribution = new HashMap<>();
            while (rs.next()) {
                distribution.put(rs.getInt("rating"), rs.getInt("count"));
            }
            return distribution;
        }
    }
}
