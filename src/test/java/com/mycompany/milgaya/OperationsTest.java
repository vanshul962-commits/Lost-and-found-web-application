package com.mycompany.milgaya;

import com.mycompany.milgaya.config.DBConnection;
import com.mycompany.milgaya.dao.CategoryDAO;
import com.mycompany.milgaya.dao.ClaimDAO;
import com.mycompany.milgaya.dao.ItemDAO;
import com.mycompany.milgaya.dao.UserDAO;
import com.mycompany.milgaya.model.Claim;
import com.mycompany.milgaya.model.Item;
import com.mycompany.milgaya.model.User;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class OperationsTest {

    private static UserDAO userDAO;
    private static ItemDAO itemDAO;
    private static CategoryDAO categoryDAO;
    private static ClaimDAO claimDAO;

    @BeforeAll
    public static void setup() {
        DBConnection.initDatabase();
        userDAO = new UserDAO();
        itemDAO = new ItemDAO();
        categoryDAO = new CategoryDAO();
        claimDAO = new ClaimDAO();
    }

    @Test
    public void testAuthentication() {
        User admin = userDAO.authenticate("admin@milgaya.com", "admin123");
        assertNotNull(admin, "Admin should authenticate successfully");
        assertTrue(admin.isAdmin(), "Admin should have ADMIN role");

        User user = userDAO.authenticate("rahul@example.com", "user123");
        assertNotNull(user, "User should authenticate successfully");
    }

    @Test
    public void testReportLostAndRetrieve() {
        Item item = new Item();
        item.setType("LOST");
        item.setTitle("Test Lost Watch - Automated Test");
        item.setCategoryId(6); // Jewelry & Watches
        item.setDescription("Black dial watch with steel strap");
        item.setLocation("Central Library Gate");
        item.setCity("Mumbai");
        item.setDateEvent(new Date(System.currentTimeMillis()));
        item.setRewardAmount(new BigDecimal("500.00"));
        item.setImageUrl("https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600");
        item.setStatus("OPEN");
        item.setUserId(2);
        item.setContactPhone("+91 9811223344");
        item.setContactEmail("rahul@example.com");
        item.setContactVisible(true);

        boolean created = itemDAO.create(item);
        assertTrue(created, "Item report should be created successfully");
        assertTrue(item.getId() > 0, "Created item should have a valid positive ID");

        Item retrieved = itemDAO.findById(item.getId());
        assertNotNull(retrieved, "Retrieved item must not be null");
        assertEquals("Test Lost Watch - Automated Test", retrieved.getTitle());
        assertEquals("Jewelry & Watches", retrieved.getCategoryName());

        // Cleanup
        itemDAO.delete(item.getId());
    }

    @Test
    public void testReportFoundAndClaimFlow() {
        Item found = new Item();
        found.setType("FOUND");
        found.setTitle("Test Found Umbrella - Automated Test");
        found.setCategoryId(9);
        found.setDescription("Red folding umbrella");
        found.setLocation("Bus Stop #4");
        found.setCity("Delhi");
        found.setDateEvent(new Date(System.currentTimeMillis()));
        found.setSecurityQuestion("What brand is on the handle?");
        found.setStatus("OPEN");
        found.setUserId(3); // Priya
        found.setContactPhone("+91 9722334455");
        found.setContactEmail("priya@example.com");

        boolean created = itemDAO.create(found);
        assertTrue(created, "Found item should be created");

        // Submit claim from Amit (user 4)
        Claim claim = new Claim();
        claim.setItemId(found.getId());
        claim.setClaimantId(4);
        claim.setClaimMessage("I forgot my red umbrella on the bench!");
        claim.setClaimProof("Handle has 'Duckback' logo etched on it.");
        claim.setClaimantContact("+91 9988776655");
        claim.setStatus("PENDING");

        boolean claimSaved = claimDAO.create(claim);
        assertTrue(claimSaved, "Claim should be submitted successfully");
        assertTrue(claim.getId() > 0, "Claim ID should be valid");

        // Owner accepts claim
        boolean updated = claimDAO.updateStatus(claim.getId(), "ACCEPTED", "Verified, please collect from bus depot.");
        assertTrue(updated, "Claim should be accepted");

        itemDAO.updateStatus(found.getId(), "RESOLVED");
        Item after = itemDAO.findById(found.getId());
        assertEquals("RESOLVED", after.getStatus(), "Item should be marked resolved");

        // Cleanup
        itemDAO.delete(found.getId());
    }

    @Test
    public void testSearchAndFilter() {
        List<Item> results = itemDAO.searchItems("iPhone", "ALL", null, null, "ALL", 0, 10);
        assertNotNull(results);
        assertFalse(results.isEmpty(), "Search for 'iPhone' should return seeded iPhone item");

        int count = itemDAO.countFilteredItems("iPhone", "ALL", null, null, "ALL");
        assertTrue(count >= 1, "Count should be at least 1");
    }

    @Test
    public void testUserRegistrationAndDuplicateHandling() {
        String testEmail = "testuser_" + System.currentTimeMillis() + "@milgaya.com";
        User newUser = new User();
        newUser.setFullName("Test User Registration");
        newUser.setEmail(testEmail);
        newUser.setPhone("+91 9123456789");
        newUser.setPasswordHash(com.mycompany.milgaya.util.PasswordUtil.hashPassword("secret123"));
        newUser.setCity("Pune");
        newUser.setRole("USER");

        boolean created = userDAO.create(newUser);
        assertTrue(created, "User registration should succeed");
        assertTrue(newUser.getId() > 0, "Registered user should get auto-generated ID");

        // Authenticate with new user
        User auth = userDAO.authenticate(testEmail, "secret123");
        assertNotNull(auth, "Newly registered user should authenticate successfully");

        // Duplicate email check
        assertNotNull(userDAO.findByEmail(testEmail), "Email should be detected as existing");

        // Cleanup
        userDAO.deleteUser(newUser.getId());
    }

    @Test
    public void testCategoriesLoaded() {
        List<com.mycompany.milgaya.model.Category> categories = categoryDAO.listAll();
        assertNotNull(categories, "Categories list should not be null");
        assertFalse(categories.isEmpty(), "Categories should be pre-seeded");
        assertTrue(categories.size() >= 8, "There should be at least 8 categories seeded");
    }
}
