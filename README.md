# 🌟 Milgaya - Lost & Found Management Platform

> **"Recover What You Lost, Return What You Found"**  
> *A Modern, Secure, and Community-Driven Web Platform Built in Java (Jakarta EE / Apache NetBeans)*

---

## 📌 Project Overview
**Milgaya** is a complete, full-stack Lost and Found web portal built in **Java / Jakarta EE 10** following the Model-View-Controller (MVC) architectural pattern. It bridges the gap between individuals who have lost valuable items and honest citizens or organizations who find them.

The platform includes full authentication, role-based access control, item reporting with category tagging and photo integration, reward offerings, an anti-fraud security question verification system, claim management with proof submission, user dashboards, and an administration console.

---

## 🚀 Key Features

### 1. 🔍 Browse & Advanced Search Directory
- Search listings by keyword (item title, brand, description, landmark).
- Filter by report type (**Lost**, **Found**, or **All**).
- Filter by category (**Electronics & Gadgets**, **Wallets & Bags**, **Identity & Documents**, **Keys & Locks**, **Pets & Animals**, **Jewelry & Watches**, **Clothing**, etc.).
- Filter by city/region and case status (**Open** vs **Reunited / Resolved**).
- Multi-page responsive pagination.

### 2. 📢 Report Lost & Found Items
- **Report Lost Item**: Include item name, category, date lost, city, exact landmark, reward offer (optional), photo preview, and privacy masking preferences.
- **Report Found Item**: Includes an innovative **Security Verification Question** (e.g. *"What picture is on the lock screen?"* or *"What initials are in the wallet?"*) to prevent fraudulent claims.

### 3. 🛡️ Claim & Proof-of-Ownership System
- Found an item or seeking a lost one? Submit a claim detailing proof of ownership and direct contact information.
- Listing owners receive claim submissions on their dashboard with the ability to **Accept** or **Reject** claims with one click.
- Accepting a claim automatically marks the item as **Resolved / Reunited**.

### 4. 👤 User Dashboard & Profile Management
- **My Lost Items**: View, edit, resolve, or remove reported lost items.
- **My Found Items**: Manage items safely kept and coordinate returns.
- **Claims Received**: Review ownership claims sent by community members.
- **Claims I Submitted**: Track status (Pending, Accepted, Rejected) of claims filed.
- **Profile & Password Settings**: Update contact details and change credentials.

### 5. 🛡️ Administrative Console
- Restricted to users with the `ADMIN` role.
- Real-time statistics: Total items, active lost items, found items, reunions, registered users.
- Listing moderation: View, resolve, or remove flagged/inappropriate listings.
- User management: Oversee accounts and permissions.
- Database integrity & re-seed tool.

---

## 🗄️ Database Architecture

The project features a **Dual Database Engine**:

1. **Embedded H2 Database (Default - Zero Configuration)**:
   - Works immediately out of the box on any system with no database installation required.
   - Automatically initializes tables and seeds realistic categories, sample users, and lost & found listings upon first connection.
   - Data persists across server restarts in `~/.milgaya/milgaya_db`.

2. **MySQL Database Support (Optional)**:
   - A complete production-ready SQL script is provided in `database/milgaya_schema.sql`.
   - To use MySQL:
     1. Import `database/milgaya_schema.sql` in MySQL Workbench or phpMyAdmin.
     2. Open `src/main/resources/db.properties`.
     3. Change `db.type=mysql` and update your MySQL username and password.

---

## 🔑 Default Credentials (Ready for Testing)

The database automatically seeds test accounts:

| Role | Email | Password | Purpose |
| :--- | :--- | :--- | :--- |
| **System Admin** | `admin@milgaya.com` | `admin123` | Access admin console, moderate listings & users |
| **User (Demo)** | `rahul@example.com` | `user123` | Report & manage lost items, view claims |
| **User (Demo)** | `priya@example.com` | `user123` | Report & manage found items, evaluate claims |
| **User (Demo)** | `amit@example.com` | `user123` | Test submitting claims on listings |

*Tip: The login page includes a convenient **"Quick Demo Login"** button that fills these credentials in one click!*

---

## 💻 How to Run the Project

### Option A: In Apache NetBeans IDE
1. Open **Apache NetBeans**.
2. Click **File** $\to$ **Open Project...**
3. Select the `milgaya` directory. NetBeans recognizes it as a Maven Web Application.
4. Right-click the `milgaya` project and select **Run** (or press `F6`). NetBeans deploys the WAR onto your configured server (Apache Tomcat or GlassFish).
5. The application will open in your browser at:  
   `http://localhost:8080/milgaya`

### Option B: Standalone One-Click Run (Windows)
1. Double-click the included `run.bat` file in the project root directory.
2. The script compiles the code and starts the embedded server.
3. Open your browser and go to:  
   `http://localhost:8080/milgaya` or `http://localhost:8080/`

### Option C: From Command Line / Terminal
```bash
# Inside the milgaya project folder:
mvn compile exec:java
```

---

## 📂 Project Structure

```
milgaya/
├── pom.xml                               # Maven project configuration & dependencies
├── nb-configuration.xml                  # Apache NetBeans configuration
├── run.bat                               # Windows 1-click execution script
├── database/
│   └── milgaya_schema.sql                # Complete MySQL DDL & seed data script
└── src/
    └── main/
        ├── java/
        │   └── com/mycompany/milgaya/
        │       ├── config/
        │       │   └── DBConnection.java # Dual H2/MySQL connection & auto-schema init
        │       ├── model/
        │       │   ├── User.java
        │       │   ├── Item.java
        │       │   ├── Category.java
        │       │   └── Claim.java
        │       ├── dao/
        │       │   ├── UserDAO.java
        │       │   ├── ItemDAO.java
        │       │   ├── CategoryDAO.java
        │       │   └── ClaimDAO.java
        │       ├── servlet/
        │       │   ├── HomeServlet.java
        │       │   ├── BrowseItemsServlet.java
        │       │   ├── ItemDetailServlet.java
        │       │   ├── ReportItemServlet.java
        │       │   ├── DashboardServlet.java
        │       │   ├── ClaimServlet.java
        │       │   ├── ItemActionServlet.java
        │       │   ├── LoginServlet.java
        │       │   ├── RegisterServlet.java
        │       │   ├── LogoutServlet.java
        │       │   ├── AdminServlet.java
        │       │   ├── AboutContactServlet.java
        │       │   └── ApiServlet.java
        │       ├── util/
        │       │   └── PasswordUtil.java # SHA-256 password hashing & verification
        │       └── server/
        │           └── MilgayaLauncher.java # Embedded server runner
        ├── resources/
        │   └── db.properties             # Database switch & configuration
        └── webapp/
            ├── css/
            │   └── style.css             # Custom modern styling & animations
            ├── js/
            │   └── app.js                # Frontend interactions, modals, demo fill
            ├── WEB-INF/
            │   ├── web.xml               # Deployment descriptor
            │   └── views/
            │       ├── header.jsp        # Reusable navigation bar & flash alerts
            │       └── footer.jsp        # Reusable footer & scripts
            ├── index.jsp                 # Home page
            ├── items.jsp                 # Browse & filter listings
            ├── item-details.jsp          # Single item details & claim modal
            ├── report-lost.jsp           # Report lost item form
            ├── report-found.jsp          # Report found item form
            ├── login.jsp                 # Sign in page
            ├── register.jsp              # Sign up page
            ├── dashboard.jsp             # User dashboard & claims
            ├── admin.jsp                 # Admin management console
            ├── about.jsp                 # About platform & safety guidelines
            └── contact.jsp               # Support & contact form
```

---
*Built with ❤️ for Apache NetBeans & Java Web Development.*
