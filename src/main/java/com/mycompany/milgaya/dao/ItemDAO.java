package com.mycompany.milgaya.dao;

import com.mycompany.milgaya.config.DBConnection;
import com.mycompany.milgaya.model.Item;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ItemDAO {

    public boolean create(Item item) {
        String sql = "INSERT INTO items (type, title, category_id, description, location, city, "
                   + "date_event, reward_amount, security_question, image_url, status, user_id, "
                   + "contact_phone, contact_email, contact_visible) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, item.getType());
            ps.setString(2, item.getTitle());
            ps.setInt(3, item.getCategoryId());
            ps.setString(4, item.getDescription());
            ps.setString(5, item.getLocation());
            ps.setString(6, item.getCity());
            ps.setDate(7, item.getDateEvent() != null ? item.getDateEvent() : new Date(System.currentTimeMillis()));
            ps.setBigDecimal(8, item.getRewardAmount() != null ? item.getRewardAmount() : java.math.BigDecimal.ZERO);
            ps.setString(9, item.getSecurityQuestion());
            ps.setString(10, item.getImageUrl());
            ps.setString(11, item.getStatus() != null ? item.getStatus() : "OPEN");
            ps.setInt(12, item.getUserId());
            ps.setString(13, item.getContactPhone());
            ps.setString(14, item.getContactEmail());
            ps.setBoolean(15, item.isContactVisible());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        item.setId(rs.getInt(1));
                    }
                } catch (Exception ignored) {}

                if (item.getId() <= 0) {
                    try (Statement st = conn.createStatement();
                         ResultSet rs2 = st.executeQuery("SELECT MAX(id) FROM items")) {
                        if (rs2.next()) {
                            item.setId(rs2.getInt(1));
                        }
                    } catch (Exception ignored) {}
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Item item) {
        String sql = "UPDATE items SET title = ?, category_id = ?, description = ?, location = ?, "
                   + "city = ?, date_event = ?, reward_amount = ?, security_question = ?, image_url = ?, "
                   + "status = ?, contact_phone = ?, contact_email = ?, contact_visible = ?, updated_at = CURRENT_TIMESTAMP "
                   + "WHERE id = ? AND (user_id = ? OR ? = TRUE)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getTitle());
            ps.setInt(2, item.getCategoryId());
            ps.setString(3, item.getDescription());
            ps.setString(4, item.getLocation());
            ps.setString(5, item.getCity());
            ps.setDate(6, item.getDateEvent());
            ps.setBigDecimal(7, item.getRewardAmount());
            ps.setString(8, item.getSecurityQuestion());
            ps.setString(9, item.getImageUrl());
            ps.setString(10, item.getStatus());
            ps.setString(11, item.getContactPhone());
            ps.setString(12, item.getContactEmail());
            ps.setBoolean(13, item.isContactVisible());
            ps.setInt(14, item.getId());
            ps.setInt(15, item.getUserId());
            ps.setBoolean(16, true); // Allows admin / owner check
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE items SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM items WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Item findById(int id) {
        String sql = "SELECT i.*, c.name AS category_name, c.icon AS category_icon, u.full_name AS user_name, u.email AS user_email "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE i.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapItem(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Item> findRecentLost(int limit) {
        return findRecentByType("LOST", limit);
    }

    public List<Item> findRecentFound(int limit) {
        return findRecentByType("FOUND", limit);
    }

    private List<Item> findRecentByType(String type, int limit) {
        List<Item> list = new ArrayList<>();
        String sql = "SELECT i.*, c.name AS category_name, c.icon AS category_icon, u.full_name AS user_name, u.email AS user_email "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE i.type = ? "
                   + "ORDER BY i.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Item> findByUserId(int userId) {
        List<Item> list = new ArrayList<>();
        String sql = "SELECT i.*, c.name AS category_name, c.icon AS category_icon, u.full_name AS user_name, u.email AS user_email "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE i.user_id = ? "
                   + "ORDER BY i.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Item> listAll() {
        List<Item> list = new ArrayList<>();
        String sql = "SELECT i.*, c.name AS category_name, c.icon AS category_icon, u.full_name AS user_name, u.email AS user_email "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "ORDER BY i.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Item> searchItems(String query, String type, Integer categoryId, String city, String status, int offset, int limit) {
        List<Item> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT i.*, c.name AS category_name, c.icon AS category_icon, u.full_name AS user_name, u.email AS user_email "
                + "FROM items i "
                + "LEFT JOIN categories c ON i.category_id = c.id "
                + "LEFT JOIN users u ON i.user_id = u.id "
                + "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(i.title) LIKE ? OR LOWER(i.description) LIKE ? OR LOWER(i.location) LIKE ? OR LOWER(i.city) LIKE ?) ");
            String q = "%" + query.trim().toLowerCase() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
            params.add(q);
        }

        if (type != null && !type.trim().isEmpty() && !"ALL".equalsIgnoreCase(type)) {
            sql.append("AND i.type = ? ");
            params.add(type.toUpperCase());
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND i.category_id = ? ");
            params.add(categoryId);
        }

        if (city != null && !city.trim().isEmpty() && !"ALL".equalsIgnoreCase(city)) {
            sql.append("AND LOWER(i.city) = LOWER(?) ");
            params.add(city.trim());
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND i.status = ? ");
            params.add(status.toUpperCase());
        }

        sql.append("ORDER BY i.created_at DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countFilteredItems(String query, String type, Integer categoryId, String city, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM items i WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(i.title) LIKE ? OR LOWER(i.description) LIKE ? OR LOWER(i.location) LIKE ? OR LOWER(i.city) LIKE ?) ");
            String q = "%" + query.trim().toLowerCase() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
            params.add(q);
        }

        if (type != null && !type.trim().isEmpty() && !"ALL".equalsIgnoreCase(type)) {
            sql.append("AND i.type = ? ");
            params.add(type.toUpperCase());
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND i.category_id = ? ");
            params.add(categoryId);
        }

        if (city != null && !city.trim().isEmpty() && !"ALL".equalsIgnoreCase(city)) {
            sql.append("AND LOWER(i.city) = LOWER(?) ");
            params.add(city.trim());
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND i.status = ? ");
            params.add(status.toUpperCase());
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
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

    public List<String> listDistinctCities() {
        List<String> cities = new ArrayList<>();
        String sql = "SELECT DISTINCT city FROM items WHERE city IS NOT NULL AND TRIM(city) <> '' ORDER BY city ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                cities.add(rs.getString("city"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cities;
    }

    public Map<String, Integer> getStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", 0);
        stats.put("lost", 0);
        stats.put("found", 0);
        stats.put("resolved", 0);

        String sql = "SELECT "
                   + "COUNT(*) AS total, "
                   + "SUM(CASE WHEN type = 'LOST' THEN 1 ELSE 0 END) AS lost_count, "
                   + "SUM(CASE WHEN type = 'FOUND' THEN 1 ELSE 0 END) AS found_count, "
                   + "SUM(CASE WHEN status IN ('RESOLVED', 'CLAIMED') THEN 1 ELSE 0 END) AS resolved_count "
                   + "FROM items";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                stats.put("total", rs.getInt("total"));
                stats.put("lost", rs.getInt("lost_count"));
                stats.put("found", rs.getInt("found_count"));
                stats.put("resolved", rs.getInt("resolved_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    private Item mapItem(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setId(rs.getInt("id"));
        item.setType(rs.getString("type"));
        item.setTitle(rs.getString("title"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setCategoryName(rs.getString("category_name"));
        item.setCategoryIcon(rs.getString("category_icon"));
        item.setDescription(rs.getString("description"));
        item.setLocation(rs.getString("location"));
        item.setCity(rs.getString("city"));
        item.setDateEvent(rs.getDate("date_event"));
        item.setRewardAmount(rs.getBigDecimal("reward_amount"));
        item.setSecurityQuestion(rs.getString("security_question"));
        item.setImageUrl(rs.getString("image_url"));
        item.setStatus(rs.getString("status"));
        item.setUserId(rs.getInt("user_id"));
        item.setUserName(rs.getString("user_name"));
        item.setUserEmail(rs.getString("user_email"));
        item.setContactPhone(rs.getString("contact_phone"));
        item.setContactEmail(rs.getString("contact_email"));
        item.setContactVisible(rs.getBoolean("contact_visible"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        item.setUpdatedAt(rs.getTimestamp("updated_at"));
        return item;
    }
}
