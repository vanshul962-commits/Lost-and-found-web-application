package com.mycompany.milgaya.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Database Connection Manager for Milgaya Lost & Found platform.
 * Supports embedded zero-configuration H2 database (default)
 * as well as MySQL database via db.properties configuration.
 */
public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    private static final Properties properties = new Properties();
    private static volatile boolean initialized = false;

    private static String dbType = "h2";
    private static String jdbcUrl;
    private static String dbUser;
    private static String dbPassword;

    static {
        loadConfiguration();
    }

    private static void loadConfiguration() {
        try (InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                properties.load(is);
                dbType = properties.getProperty("db.type", "h2").trim().toLowerCase();
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "db.properties not found or failed to load. Falling back to default H2 database.", e);
        }

        if ("mysql".equals(dbType)) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                LOGGER.log(Level.SEVERE, "MySQL Driver not found, falling back to H2", e);
                dbType = "h2";
            }
            jdbcUrl = properties.getProperty("db.mysql.url", "jdbc:mysql://localhost:3306/milgaya_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
            dbUser = properties.getProperty("db.mysql.user", "root");
            dbPassword = properties.getProperty("db.mysql.password", "");
        }

        if ("h2".equals(dbType)) {
            try {
                Class.forName("org.h2.Driver");
            } catch (ClassNotFoundException e) {
                LOGGER.log(Level.SEVERE, "H2 Driver not found!", e);
            }
            // User home directory or project directory persistent database
            String userHome = System.getProperty("user.home").replace("\\", "/");
            jdbcUrl = properties.getProperty("db.h2.url", "jdbc:h2:" + userHome + "/.milgaya/milgaya_db;AUTO_SERVER=TRUE;DB_CLOSE_DELAY=-1;MODE=MySQL");
            dbUser = properties.getProperty("db.h2.user", "sa");
            dbPassword = properties.getProperty("db.h2.password", "");
        }
    }

    public static Connection getConnection() throws SQLException {
        if (!initialized) {
            synchronized (DBConnection.class) {
                if (!initialized) {
                    initDatabase();
                    initialized = true;
                }
            }
        }
        return DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
    }

    /**
     * Initializes database tables and seed data if not present.
     */
    public static synchronized void initDatabase() {
        LOGGER.info("Initializing Milgaya Database on: " + jdbcUrl);
        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
             Statement stmt = conn.createStatement()) {

            // Create USERS Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "full_name VARCHAR(100) NOT NULL, "
                    + "email VARCHAR(120) NOT NULL UNIQUE, "
                    + "phone VARCHAR(30) NOT NULL, "
                    + "password_hash VARCHAR(128) NOT NULL, "
                    + "city VARCHAR(80) DEFAULT 'New Delhi', "
                    + "role VARCHAR(20) NOT NULL DEFAULT 'USER', "
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                    + ")");

            // Create CATEGORIES Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS categories ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "name VARCHAR(80) NOT NULL, "
                    + "icon VARCHAR(60) NOT NULL, "
                    + "description VARCHAR(255)"
                    + ")");

            // Create ITEMS Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS items ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "type VARCHAR(10) NOT NULL, "
                    + "title VARCHAR(180) NOT NULL, "
                    + "category_id INT NOT NULL, "
                    + "description TEXT NOT NULL, "
                    + "location VARCHAR(200) NOT NULL, "
                    + "city VARCHAR(80) NOT NULL, "
                    + "date_event DATE NOT NULL, "
                    + "reward_amount DECIMAL(10,2) DEFAULT 0.00, "
                    + "security_question VARCHAR(255), "
                    + "image_url VARCHAR(500), "
                    + "status VARCHAR(20) NOT NULL DEFAULT 'OPEN', "
                    + "user_id INT NOT NULL, "
                    + "contact_phone VARCHAR(30), "
                    + "contact_email VARCHAR(120), "
                    + "contact_visible BOOLEAN DEFAULT TRUE, "
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                    + "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                    + ")");

            // Create CLAIMS Table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS claims ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "item_id INT NOT NULL, "
                    + "claimant_id INT NOT NULL, "
                    + "claim_message TEXT NOT NULL, "
                    + "claim_proof TEXT, "
                    + "claimant_contact VARCHAR(80) NOT NULL, "
                    + "status VARCHAR(20) NOT NULL DEFAULT 'PENDING', "
                    + "owner_reply TEXT, "
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                    + ")");

            // Check if categories need to be seeded
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM categories")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    seedCategories(stmt);
                }
            }

            // Check if users need to be seeded
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    seedUsers(stmt);
                }
            }

            // Check if items need to be seeded
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM items")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    seedItems(stmt);
                }
            }

            LOGGER.info("Milgaya Database initialization and seeding completed successfully.");
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to initialize Milgaya database", ex);
        }
    }

    private static void seedCategories(Statement stmt) throws SQLException {
        stmt.executeUpdate("INSERT INTO categories (id, name, icon, description) VALUES "
                + "(1, 'Electronics & Gadgets', 'fa-laptop', 'Smartphones, Laptops, Earbuds, Smartwatches, Chargers'), "
                + "(2, 'Wallets & Bags', 'fa-wallet', 'Purses, Wallets, Backpacks, Handbags, Luggage'), "
                + "(3, 'Identity & Documents', 'fa-id-card', 'Aadhaar, PAN Card, Driving License, Passports, College IDs'), "
                + "(4, 'Keys & Locks', 'fa-key', 'Car keys, Bike keys, Home & Office keychains'), "
                + "(5, 'Pets & Animals', 'fa-paw', 'Lost or rescued Dogs, Cats, Birds and other pets'), "
                + "(6, 'Jewelry & Watches', 'fa-gem', 'Rings, Gold chains, Luxury wristwatches, Bracelets'), "
                + "(7, 'Clothing & Accessories', 'fa-tshirt', 'Jackets, Caps, Designer Sunglasses, Scarves'), "
                + "(8, 'Books & Study Material', 'fa-book', 'Notebooks, Textbooks, Certificates, Files'), "
                + "(9, 'Other Valuable Items', 'fa-box-open', 'Musical instruments, Sports gear, Tools, Miscellaneous')");
    }

    private static void seedUsers(Statement stmt) throws SQLException {
        // SHA-256 for admin123: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
        // SHA-256 for user123:  e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446
        stmt.executeUpdate("INSERT INTO users (id, full_name, email, phone, password_hash, city, role) VALUES "
                + "(1, 'System Administrator', 'admin@milgaya.com', '+91 9876543210', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'New Delhi', 'ADMIN'), "
                + "(2, 'Rahul Sharma', 'rahul@example.com', '+91 9811223344', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', 'Mumbai', 'USER'), "
                + "(3, 'Priya Patel', 'priya@example.com', '+91 9722334455', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', 'Bangalore', 'USER'), "
                + "(4, 'Amit Verma', 'amit@example.com', '+91 9988776655', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', 'Delhi', 'USER')");
    }

    private static void seedItems(Statement stmt) throws SQLException {
        stmt.executeUpdate("INSERT INTO items (id, type, title, category_id, description, location, city, date_event, reward_amount, security_question, image_url, status, user_id, contact_phone, contact_email, contact_visible) VALUES "
                + "(1, 'LOST', 'Apple iPhone 15 Pro (Blue Titanium)', 1, 'Lost my blue iPhone 15 Pro with a transparent Spigen case. Lock screen has a picture of a golden retriever puppy. Critical work data inside.', 'Rajiv Chowk Metro Station Gate 3', 'Delhi', '2026-10-12', 3000.00, NULL, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600&auto=format&fit=crop&q=80', 'OPEN', 2, '+91 9811223344', 'rahul@example.com', TRUE), "
                + "(2, 'FOUND', 'Brown Leather Tommy Hilfiger Wallet', 2, 'Found a brown genuine leather wallet on table #4 at Starbucks. Contains some cash and cards. Safely kept with manager.', 'Starbucks, Bandra West', 'Mumbai', '2026-10-14', 0.00, 'What is the initials stamped on the debit card inside?', 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600&auto=format&fit=crop&q=80', 'OPEN', 3, '+91 9722334455', 'priya@example.com', TRUE), "
                + "(3, 'LOST', 'Dell XPS 15 Laptop in Grey Targus Bag', 1, 'Left my Targus laptop backpack containing Dell XPS 15 laptop, charger, and project notebook in an Uber cab.', 'Koramangala 5th Block', 'Bangalore', '2026-10-11', 5000.00, NULL, 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=600&auto=format&fit=crop&q=80', 'OPEN', 4, '+91 9988776655', 'amit@example.com', TRUE), "
                + "(4, 'FOUND', 'Set of Royal Enfield Bike Keys with Silver Skull Ring', 4, 'Found a Royal Enfield motorcycle key with a silver skull ring attached in the food court seating area.', 'Phoenix Marketcity Mall Food Court', 'Pune', '2026-10-13', 0.00, 'What number is etched on the back of the key tag?', 'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600&auto=format&fit=crop&q=80', 'OPEN', 2, '+91 9811223344', 'rahul@example.com', TRUE), "
                + "(5, 'LOST', 'Indian Passport & Singapore Visa Papers', 3, 'Lost a blue folder with Indian Passport (Name: Amit Verma) and visa documents on the terminal shuttle bus.', 'IGI Airport Terminal 3 Shuttle', 'New Delhi', '2026-10-10', 2000.00, NULL, 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=600&auto=format&fit=crop&q=80', 'OPEN', 4, '+91 9988776655', 'amit@example.com', TRUE), "
                + "(6, 'FOUND', 'Titan Edge Golden Wristwatch', 6, 'Found a slim gold-tone Titan Edge watch near the bench in Central Park during morning walk. Very clean condition.', 'Cubbon Park near Bandstand', 'Bangalore', '2026-10-14', 0.00, 'What is engraved on the caseback?', 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600&auto=format&fit=crop&q=80', 'OPEN', 3, '+91 9722334455', 'priya@example.com', TRUE), "
                + "(7, 'FOUND', 'Golden Retriever Pup (Male, Red Collar)', 5, 'Found a friendly young Golden Retriever wandering near the supermarket. Wearing a red nylon collar with no tag. Given food and currently at my residence.', 'Indiranagar 100ft Road', 'Bangalore', '2026-10-15', 0.00, 'What special spot marking is near his left ear?', 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=600&auto=format&fit=crop&q=80', 'OPEN', 3, '+91 9722334455', 'priya@example.com', TRUE), "
                + "(8, 'LOST', 'Bose QuietComfort 45 Headphones (Black)', 1, 'Left my Bose noise-cancelling headphones in its black zipper case on the metro seat.', 'Blue Line Metro, towards Noida', 'Noida', '2026-10-09', 1500.00, NULL, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80', 'RESOLVED', 2, '+91 9811223344', 'rahul@example.com', TRUE)");

        stmt.executeUpdate("INSERT INTO claims (id, item_id, claimant_id, claim_message, claim_proof, claimant_contact, status, owner_reply) VALUES "
                + "(1, 2, 4, 'Hello, I lost my brown Tommy Hilfiger wallet at Starbucks yesterday! It has my ICICI debit card and metro smartcard.', 'Debit card has name Amit Verma, last 4 digits are 8821.', '+91 9988776655', 'PENDING', 'Under verification with Starbucks branch manager')");
    }
}
