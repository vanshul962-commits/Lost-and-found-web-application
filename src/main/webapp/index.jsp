<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.mycompany.milgaya.model.Item" %>
<%@ page import="com.mycompany.milgaya.model.Category" %>
<%
    // If accessed directly without HomeServlet forward, redirect through servlet
    if (request.getAttribute("stats") == null) {
        request.getRequestDispatcher("/home").forward(request, response);
        return;
    }

    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    List<Item> recentLost = (List<Item>) request.getAttribute("recentLost");
    List<Item> recentFound = (List<Item>) request.getAttribute("recentFound");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<String> cities = (List<String>) request.getAttribute("cities");
%>
<jsp:include page="/WEB-INF/views/header.jsp">
    <jsp:param name="pageTitle" value="Milgaya - Reconnecting People with What They Lost" />
</jsp:include>

<!-- Hero Section -->
<section class="hero-section text-center">
    <div class="container position-relative" style="z-index: 2;">
        <span class="badge bg-white text-primary px-3 py-2 rounded-pill fw-bold mb-3 shadow-sm">
            <i class="fa-solid fa-sparkles text-warning me-1"></i> India's Premier Lost & Found Portal
        </span>
        <h1 class="hero-title mb-3">
            Recover What You Lost,<br>
            <span class="text-warning">Return What You Found</span>
        </h1>
        <p class="hero-subtitle mx-auto mb-4">
            Milgaya bridges the gap between those who lost valuables and good samaritans who found them. Simple, secure, and built for everyone.
        </p>

        <div class="d-flex flex-wrap justify-content-center gap-3">
            <a href="<%= request.getContextPath() %>/report-lost" class="btn btn-danger btn-lg rounded-pill px-4 py-3 fw-bold shadow">
                <i class="fa-solid fa-bullhorn me-2"></i> Report a Lost Item
            </a>
            <a href="<%= request.getContextPath() %>/report-found" class="btn btn-success btn-lg rounded-pill px-4 py-3 fw-bold shadow">
                <i class="fa-solid fa-hand-holding-heart me-2"></i> Report a Found Item
            </a>
            <a href="<%= request.getContextPath() %>/items" class="btn btn-outline-light btn-lg rounded-pill px-4 py-3 fw-bold">
                <i class="fa-solid fa-magnifying-glass me-2"></i> Search Listings
            </a>
        </div>
    </div>
</section>

<!-- Search Filter Card Container -->
<div class="container">
    <div class="search-banner-card">
        <form action="<%= request.getContextPath() %>/items" method="get">
            <div class="row g-2 align-items-center">
                <div class="col-lg-4 col-md-12">
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input type="text" name="q" class="form-control border-start-0" placeholder="Search by item name, brand, or landmark...">
                    </div>
                </div>
                <div class="col-lg-2 col-md-4">
                    <select name="type" class="form-select bg-light">
                        <option value="ALL">All Types (Lost & Found)</option>
                        <option value="LOST">🔍 Lost Only</option>
                        <option value="FOUND">🎁 Found Only</option>
                    </select>
                </div>
                <div class="col-lg-3 col-md-4">
                    <select name="category" class="form-select bg-light">
                        <option value="">All Categories</option>
                        <% if (categories != null) { 
                            for (Category cat : categories) { %>
                                <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
                        <%  } 
                           } %>
                    </select>
                </div>
                <div class="col-lg-2 col-md-4">
                    <select name="city" class="form-select bg-light">
                        <option value="ALL">All Cities</option>
                        <% if (cities != null) { 
                            for (String city : cities) { %>
                                <option value="<%= city %>"><%= city %></option>
                        <%  } 
                           } %>
                    </select>
                </div>
                <div class="col-lg-1 col-md-12">
                    <button type="submit" class="btn btn-primary w-100 fw-bold py-2">
                        Find
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Live Statistics Section -->
<section class="py-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-3 col-6">
                <div class="stat-box">
                    <div class="stat-number"><%= stats != null ? stats.get("total") : 0 %></div>
                    <div class="stat-label"><i class="fa-solid fa-layer-group text-primary me-1"></i> Total Reports</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-box">
                    <div class="stat-number text-danger"><%= stats != null ? stats.get("lost") : 0 %></div>
                    <div class="stat-label"><i class="fa-solid fa-circle-exclamation text-danger me-1"></i> Lost Items</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-box">
                    <div class="stat-number text-success"><%= stats != null ? stats.get("found") : 0 %></div>
                    <div class="stat-label"><i class="fa-solid fa-circle-check text-success me-1"></i> Found Items</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-box">
                    <div class="stat-number text-info"><%= stats != null ? stats.get("resolved") : 0 %></div>
                    <div class="stat-label"><i class="fa-solid fa-handshake-angle text-info me-1"></i> Reunited &amp; Resolved</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Categories Section -->
<section class="py-5 bg-white border-top border-bottom">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="text-primary fw-bold text-uppercase small tracking-wide">Explore Items</span>
                <h2 class="fw-bold mb-0">Browse by Category</h2>
            </div>
            <a href="<%= request.getContextPath() %>/items" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                View All Items <i class="fa-solid fa-arrow-right ms-1"></i>
            </a>
        </div>

        <div class="row g-3">
            <% if (categories != null) {
                for (Category cat : categories) { %>
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <a href="<%= request.getContextPath() %>/items?category=<%= cat.getId() %>" class="category-card">
                            <div class="category-icon">
                                <i class="fa-solid <%= cat.getIcon() %>"></i>
                            </div>
                            <h6 class="fw-bold mb-1"><%= cat.getName() %></h6>
                            <span class="badge bg-light text-muted border"><%= cat.getItemCount() %> listings</span>
                        </a>
                    </div>
            <%  }
               } %>
        </div>
    </div>
</section>

<!-- Recent Lost Items Section -->
<section class="py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="badge bg-danger-subtle text-danger px-3 py-1 rounded-pill fw-bold mb-1">Needs Help</span>
                <h2 class="fw-bold mb-0">Recently Lost Items</h2>
            </div>
            <a href="<%= request.getContextPath() %>/items?type=LOST" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                See All Lost Items <i class="fa-solid fa-arrow-right ms-1"></i>
            </a>
        </div>

        <div class="row g-4">
            <% if (recentLost != null && !recentLost.isEmpty()) {
                for (Item item : recentLost) { %>
                    <div class="col-lg-4 col-md-6">
                        <div class="item-card">
                            <div class="card-img-wrapper">
                                <img src="<%= item.getImageUrl() != null ? item.getImageUrl() : "https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=600&auto=format&fit=crop&q=80" %>" alt="<%= item.getTitle() %>">
                                <div class="position-absolute top-0 start-0 m-3 d-flex gap-2">
                                    <span class="badge badge-lost"><i class="fa-solid fa-bullhorn me-1"></i> LOST</span>
                                    <% if (item.getRewardAmount() != null && item.getRewardAmount().doubleValue() > 0) { %>
                                        <span class="badge badge-reward"><i class="fa-solid fa-award me-1"></i> Rs. <%= item.getRewardAmount() %> Reward</span>
                                    <% } %>
                                </div>
                                <div class="position-absolute bottom-0 start-0 m-3">
                                    <span class="badge bg-dark bg-opacity-75 text-white"><i class="fa-solid <%= item.getCategoryIcon() != null ? item.getCategoryIcon() : "fa-tag" %> me-1"></i> <%= item.getCategoryName() %></span>
                                </div>
                            </div>
                            <div class="p-4 d-flex flex-column flex-grow-1">
                                <h5 class="fw-bold mb-2 text-truncate" title="<%= item.getTitle() %>">
                                    <a href="<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="text-dark text-decoration-none"><%= item.getTitle() %></a>
                                </h5>
                                <p class="text-muted small mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    <%= item.getDescription() %>
                                </p>
                                <div class="d-flex align-items-center text-muted small mb-3 gap-3">
                                    <span><i class="fa-solid fa-location-dot text-danger me-1"></i> <%= item.getLocation() %>, <%= item.getCity() %></span>
                                    <span><i class="fa-solid fa-calendar me-1"></i> <%= item.getDateEvent() %></span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-auto">
                                    <span class="small text-muted">Reported by <strong><%= item.getUserName() %></strong></span>
                                    <a href="<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                                        I Found This <i class="fa-solid fa-angle-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <p class="text-muted">No lost items listed yet.</p>
                </div>
            <% } %>
        </div>
    </div>
</section>

<!-- Recent Found Items Section -->
<section class="py-5 bg-white border-top">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="badge bg-success-subtle text-success px-3 py-1 rounded-pill fw-bold mb-1">Found &amp; Kept Safe</span>
                <h2 class="fw-bold mb-0">Recently Found Items (Milgaya!)</h2>
            </div>
            <a href="<%= request.getContextPath() %>/items?type=FOUND" class="btn btn-outline-success btn-sm rounded-pill px-3">
                See All Found Items <i class="fa-solid fa-arrow-right ms-1"></i>
            </a>
        </div>

        <div class="row g-4">
            <% if (recentFound != null && !recentFound.isEmpty()) {
                for (Item item : recentFound) { %>
                    <div class="col-lg-4 col-md-6">
                        <div class="item-card">
                            <div class="card-img-wrapper">
                                <img src="<%= item.getImageUrl() != null ? item.getImageUrl() : "https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=600&auto=format&fit=crop&q=80" %>" alt="<%= item.getTitle() %>">
                                <div class="position-absolute top-0 start-0 m-3">
                                    <span class="badge badge-found"><i class="fa-solid fa-circle-check me-1"></i> FOUND</span>
                                </div>
                                <div class="position-absolute bottom-0 start-0 m-3">
                                    <span class="badge bg-dark bg-opacity-75 text-white"><i class="fa-solid <%= item.getCategoryIcon() != null ? item.getCategoryIcon() : "fa-tag" %> me-1"></i> <%= item.getCategoryName() %></span>
                                </div>
                            </div>
                            <div class="p-4 d-flex flex-column flex-grow-1">
                                <h5 class="fw-bold mb-2 text-truncate" title="<%= item.getTitle() %>">
                                    <a href="<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="text-dark text-decoration-none"><%= item.getTitle() %></a>
                                </h5>
                                <p class="text-muted small mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    <%= item.getDescription() %>
                                </p>
                                <div class="d-flex align-items-center text-muted small mb-3 gap-3">
                                    <span><i class="fa-solid fa-location-dot text-success me-1"></i> <%= item.getLocation() %>, <%= item.getCity() %></span>
                                    <span><i class="fa-solid fa-calendar me-1"></i> <%= item.getDateEvent() %></span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-auto">
                                    <span class="small text-muted">Found by <strong><%= item.getUserName() %></strong></span>
                                    <a href="<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="btn btn-outline-success btn-sm rounded-pill px-3">
                                        Claim This <i class="fa-solid fa-angle-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
            <%  }
               } else { %>
                <div class="col-12 text-center py-5">
                    <p class="text-muted">No found items listed yet.</p>
                </div>
            <% } %>
        </div>
    </div>
</section>

<!-- How It Works Section -->
<section class="py-5 bg-light border-top">
    <div class="container py-4">
        <div class="text-center max-w-xl mx-auto mb-5">
            <span class="text-primary fw-bold text-uppercase small tracking-wide">Simple &amp; Secure</span>
            <h2 class="fw-bold">How Milgaya Works</h2>
            <p class="text-muted">Three straightforward steps to reconnect people with their valuable possessions.</p>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="card h-100 border-0 shadow-sm p-4 text-center rounded-4">
                    <div class="step-num">1</div>
                    <h5 class="fw-bold mb-2">Publish a Report</h5>
                    <p class="text-muted small mb-0">
                        Post details about what you lost or found. Add photos, exact location, date, and security verification questions.
                    </p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 border-0 shadow-sm p-4 text-center rounded-4">
                    <div class="step-num">2</div>
                    <h5 class="fw-bold mb-2">Verify Ownership</h5>
                    <p class="text-muted small mb-0">
                        Claimants submit proof of ownership (serial numbers, invoice, or secret distinguishing details) through the portal.
                    </p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 border-0 shadow-sm p-4 text-center rounded-4">
                    <div class="step-num">3</div>
                    <h5 class="fw-bold mb-2">Reunite Safely!</h5>
                    <p class="text-muted small mb-0">
                        Once verified, connect via masked contact or secure meetup at police booths/public places, and celebrate the reunion!
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action Banner -->
<section class="py-5" style="background: linear-gradient(135deg, #4338ca, #6366f1); color: white;">
    <div class="container text-center py-3">
        <h2 class="fw-bold mb-3">Have You Lost or Found Something Today?</h2>
        <p class="lead opacity-90 mb-4 max-w-lg mx-auto">
            Every minute matters. The sooner an item is reported, the higher the chances of getting it back.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="<%= request.getContextPath() %>/report-lost" class="btn btn-danger btn-lg rounded-pill px-4 fw-bold shadow">
                Post Lost Item
            </a>
            <a href="<%= request.getContextPath() %>/report-found" class="btn btn-success btn-lg rounded-pill px-4 fw-bold shadow">
                Post Found Item
            </a>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/footer.jsp" />
