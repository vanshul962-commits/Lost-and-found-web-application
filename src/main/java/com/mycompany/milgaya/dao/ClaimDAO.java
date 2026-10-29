package com.mycompany.milgaya.dao;

import com.mycompany.milgaya.config.DBConnection;
import com.mycompany.milgaya.model.Claim;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ClaimDAO {

    public boolean create(Claim claim) {
        String sql = "INSERT INTO claims (item_id, claimant_id, claim_message, claim_proof, claimant_contact, status, owner_reply) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, claim.getItemId());
            ps.setInt(2, claim.getClaimantId());
            ps.setString(3, claim.getClaimMessage());
            ps.setString(4, claim.getClaimProof());
            ps.setString(5, claim.getClaimantContact());
            ps.setString(6, claim.getStatus() != null ? claim.getStatus() : "PENDING");
            ps.setString(7, claim.getOwnerReply());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        claim.setId(rs.getInt(1));
                    }
                } catch (Exception ignored) {}

                if (claim.getId() <= 0) {
                    try (Statement st = conn.createStatement();
                         ResultSet rs2 = st.executeQuery("SELECT MAX(id) FROM claims")) {
                        if (rs2.next()) {
                            claim.setId(rs2.getInt(1));
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

    public List<Claim> findByItemId(int itemId) {
        List<Claim> list = new ArrayList<>();
        String sql = "SELECT cl.*, u.full_name AS claimant_name, u.email AS claimant_email, "
                   + "i.title AS item_title, i.type AS item_type, i.image_url AS item_image_url "
                   + "FROM claims cl "
                   + "JOIN users u ON cl.claimant_id = u.id "
                   + "JOIN items i ON cl.item_id = i.id "
                   + "WHERE cl.item_id = ? ORDER BY cl.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaim(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Claim> findByClaimantId(int claimantId) {
        List<Claim> list = new ArrayList<>();
        String sql = "SELECT cl.*, u.full_name AS claimant_name, u.email AS claimant_email, "
                   + "i.title AS item_title, i.type AS item_type, i.image_url AS item_image_url "
                   + "FROM claims cl "
                   + "JOIN users u ON cl.claimant_id = u.id "
                   + "JOIN items i ON cl.item_id = i.id "
                   + "WHERE cl.claimant_id = ? ORDER BY cl.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, claimantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaim(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Claim> findByItemOwnerId(int ownerUserId) {
        List<Claim> list = new ArrayList<>();
        String sql = "SELECT cl.*, u.full_name AS claimant_name, u.email AS claimant_email, "
                   + "i.title AS item_title, i.type AS item_type, i.image_url AS item_image_url "
                   + "FROM claims cl "
                   + "JOIN users u ON cl.claimant_id = u.id "
                   + "JOIN items i ON cl.item_id = i.id "
                   + "WHERE i.user_id = ? ORDER BY cl.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaim(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Claim findById(int id) {
        String sql = "SELECT cl.*, u.full_name AS claimant_name, u.email AS claimant_email, "
                   + "i.title AS item_title, i.type AS item_type, i.image_url AS item_image_url "
                   + "FROM claims cl "
                   + "JOIN users u ON cl.claimant_id = u.id "
                   + "JOIN items i ON cl.item_id = i.id "
                   + "WHERE cl.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapClaim(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStatus(int claimId, String status, String ownerReply) {
        String sql = "UPDATE claims SET status = ?, owner_reply = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, ownerReply);
            ps.setInt(3, claimId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Claim mapClaim(ResultSet rs) throws SQLException {
        Claim c = new Claim();
        c.setId(rs.getInt("id"));
        c.setItemId(rs.getInt("item_id"));
        c.setItemTitle(rs.getString("item_title"));
        c.setItemType(rs.getString("item_type"));
        c.setItemImageUrl(rs.getString("item_image_url"));
        c.setClaimantId(rs.getInt("claimant_id"));
        c.setClaimantName(rs.getString("claimant_name"));
        c.setClaimantEmail(rs.getString("claimant_email"));
        c.setClaimMessage(rs.getString("claim_message"));
        c.setClaimProof(rs.getString("claim_proof"));
        c.setClaimantContact(rs.getString("claimant_contact"));
        c.setStatus(rs.getString("status"));
        c.setOwnerReply(rs.getString("owner_reply"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        return c;
    }
}
