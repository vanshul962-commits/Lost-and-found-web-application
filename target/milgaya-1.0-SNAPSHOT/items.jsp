<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.milgaya.model.Item" %>
<%@ page import="com.mycompany.milgaya.model.Category" %>
<%
    List<Item> items = (List<Item>) request.getAttribute("items");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<String> cities = (List<String>) request.getAttribute("cities");

    int totalCount = request.getAttribute("totalCount") != null ? (Integer) request.getAttribute("totalCount") : 0;
    int currentPage = request.getAttribute("currentPage") != null ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = request.getAttribute("totalPages") != null ? (Integer) request.getAttribute("totalPages") : 1;

    String selectedQuery = (String) request.getAttribute("selectedQuery");
    String selectedType = (String) request.getAttribute("selectedType");
    int selectedCategoryId = request.getAttribute("selectedCategoryId") != null ? (Integer) request.getAttribute("selectedCategoryId") : 0;
    String selectedCity = (String) request.getAttribute("selectedCity");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
%>
<jsp:include page="/WEB-INF/views/header.jsp">
    <jsp:param name="pageTitle" value="Browse Lost and Found Items - Milgaya" />
</jsp:include>

<div class="bg-white border-bottom py-4 mb-4">
    <div class="container">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <h2 class="fw-bold mb-1">Browse Lost &amp; Found Directory</h2>
                <p class="text-muted small mb-0">Search through live listings or filter by city, category, and report status.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="<%= request.getContextPath() %>/report-lost" class="btn btn-danger btn-sm rounded-pill px-3 fw-bold">
                    <i class="fa-solid fa-bullhorn me-1"></i> Report Lost
                </a>
                <a href="<%= request.getContextPath() %>/report-found" class="btn btn-success btn-sm rounded-pill px-3 fw-bold">
                    <i class="fa-solid fa-hand-holding-heart me-1"></i> Report Found
                </a>
            </div>
        </div>
    </div>
</div>

<div class="container pb-5">
    <div class="row g-4">
        
        <!-- Filter Sidebar -->
        <div class="col-lg-3 col-md-4">
            <div class="card border-0 shadow-sm rounded-4 p-4 sticky-top" style="top: 90px;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0"><i class="fa-solid fa-sliders me-2 text-primary"></i> Filters</h5>
                    <a href="<%= request.getContextPath() %>/items" class="btn btn-link text-decoration-none small p-0 text-muted">Clear All</a>
                </div>

                <form action="<%= request.getContextPath() %>/items" method="get">
                    <!-- Search Keyword -->
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase">Keywords</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" name="q" class="form-control border-start-0" placeholder="Wallet, iPhone..." value="<%= selectedQuery %>">
                        </div>
                    </div>

                    <!-- Type Filter -->
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase">Report Type</label>
                        <select name="type" class="form-select bg-light">
                            <option value="ALL" <%= "ALL".equals(selectedType) ? "selected" : "" %>>All (Lost &amp; Found)</option>
                            <option value="LOST" <%= "LOST".equals(selectedType) ? "selected" : "" %>>🔍 Lost Items</option>
                            <option value="FOUND" <%= "FOUND".equals(selectedType) ? "selected" : "" %>>🎁 Found Items (Milgaya)</option>
                        </select>
                    </div>

                    <!-- Category Filter -->
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase">Category</label>
                        <select name="category" class="form-select bg-light">
                            <option value="">All Categories</option>
                            <% if (categories != null) {
                                for (Category cat : categories) { %>
                                    <option value="<%= cat.getId() %>" <%= selectedCategoryId == cat.getId() ? "selected" : "" %>>
                                        <%= cat.getName() %> (<%= cat.getItemCount() %>)
                                    </option>
                            <%  }
                               } %>
                        </select>
                    </div>

                    <!-- City Filter -->
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase">City / Region</label>
                        <select name="city" class="form-select bg-light">
                            <option value="ALL" <%= "ALL".equals(selectedCity) ? "selected" : "" %>>All Cities</option>
                            <% if (cities != null) {
                                for (String c : cities) { %>
                                    <option value="<%= c %>" <%= c.equalsIgnoreCase(selectedCity) ? "selected" : "" %>><%= c %></option>
                            <%  }
                               } %>
                        </select>
                    </div>

                    <!-- Status Filter -->
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted text-uppercase">Status</label>
                        <select name="status" class="form-select bg-light">
                            <option value="ALL" <%= "ALL".equals(selectedStatus) ? "selected" : "" %>>All Statuses</option>
                            <option value="OPEN" <%= "OPEN".equals(selectedStatus) ? "selected" : "" %>>Open / Active</option>
                            <option value="RESOLVED" <%= "RESOLVED".equals(selectedStatus) ? "selected" : "" %>>Reunited / Resolved</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 fw-bold py-2">
                        Apply Filters
                    </button>
                </form>
            </div>
        </div>

        <!-- Items Results Grid -->
        <div class="col-lg-9 col-md-8">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="text-muted small">
                    Showing <strong><%= items != null ? items.size() : 0 %></strong> of <strong><%= totalCount %></strong> listings
                </span>
                <% if (selectedQuery != null && !selectedQuery.isEmpty()) { %>
                    <span class="badge bg-primary-subtle text-primary">Filtered by "<%= selectedQuery %>"</span>
                <% } %>
            </div>

            <div class="row g-4">
                <% if (items != null && !items.isEmpty()) {
                    for (Item item : items) { %>
                        <div class="col-lg-4 col-md-6">
                            <div class="item-card">
                                <div class="card-img-wrapper">
                                    <img src="<%= item.getImageUrl() != null ? item.getImageUrl() : "https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=600&auto=format&fit=crop&q=80" %>" alt="<%= item.getTitle() %>">
                                    <div class="position-absolute top-0 start-0 m-3 d-flex gap-2">
                                        <% if ("LOST".equalsIgnoreCase(item.getType())) { %>
                                            <span class="badge badge-lost"><i class="fa-solid fa-bullhorn me-1"></i> LOST</span>
                                        <% } else { %>
                                            <span class="badge badge-found"><i class="fa-solid fa-circle-check me-1"></i> FOUND</span>
                                        <% } %>

                                        <% if (item.isResolved()) { %>
                                            <span class="badge badge-resolved"><i class="fa-solid fa-check-double me-1"></i> RESOLVED</span>
                                        <% } %>

                                        <% if (item.getRewardAmount() != null && item.getRewardAmount().doubleValue() > 0) { %>
                                            <span class="badge badge-reward"><i class="fa-solid fa-award me-1"></i> Rs. <%= item.getRewardAmount() %></span>
                                        <% } %>
                                    </div>
                                    <div class="position-absolute bottom-0 start-0 m-3">
                                        <span class="badge bg-dark bg-opacity-75 text-white">
                                            <i class="fa-solid <%= item.getCategoryIcon() != null ? item.getCategoryIcon() : "fa-tag" %> me-1"></i> <%= item.getCategoryName() %>
                                        </span>
                                    </div>
                                </div>
                                <div class="p-3 d-flex flex-column flex-grow-1">
                                    <h6 class="fw-bold mb-1 text-truncate" title="<%= item.getTitle() %>">
                                        <a href="<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="text-dark text-decoration-none">
                                            <%= item.getTitle() %>
                                        </a>
                                    </h6>
                                    <p class="text-muted small mb-2 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                        <%= item.getDescription() %>
                                    </p>
                                    <div class="text-muted small mb-3">
                                        <div class="d-flex align-items-center text-truncate mb-1">
                                            <i class="fa-solid fa-location-dot me-1 text-danger"></i> <%= item.getLocation() %>, <%= item.getCity() %>
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <i class="fa-solid fa-calendar me-1 text-muted"></i> <%= item.getDateEvent() %>
                                        </div>
                                    </div>
                                    <div class="pt-2 border-top mt-auto">
                                        <a href="<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="btn btn-outline-primary btn-sm w-100 rounded-pill fw-semibold">
                                            View Details &amp; Connect <i class="fa-solid fa-arrow-right ms-1"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                <%  }
                   } else { %>
                    <div class="col-12 text-center py-5">
                        <div class="card border-0 shadow-sm rounded-4 p-5">
                            <i class="fa-solid fa-box-open fa-3x text-muted mb-3"></i>
                            <h4 class="fw-bold">No Matching Listings Found</h4>
                            <p class="text-muted">Try adjusting your filters or search keywords, or report a new item.</p>
                            <div class="mt-3">
                                <a href="<%= request.getContextPath() %>/items" class="btn btn-outline-primary rounded-pill px-4">Reset All Filters</a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Pagination -->
            <% if (totalPages > 1) { %>
                <nav class="mt-5 d-flex justify-content-center">
                    <ul class="pagination">
                        <li class="page-item <%= currentPage <= 1 ? "disabled" : "" %>">
                            <a class="page-link" href="<%= request.getContextPath() %>/items?page=<%= currentPage - 1 %>&q=<%= selectedQuery %>&type=<%= selectedType %>&category=<%= selectedCategoryId %>&city=<%= selectedCity %>&status=<%= selectedStatus %>">Previous</a>
                        </li>
                        <% for (int p = 1; p <= totalPages; p++) { %>
                            <li class="page-item <%= p == currentPage ? "active" : "" %>">
                                <a class="page-link" href="<%= request.getContextPath() %>/items?page=<%= p %>&q=<%= selectedQuery %>&type=<%= selectedType %>&category=<%= selectedCategoryId %>&city=<%= selectedCity %>&status=<%= selectedStatus %>"><%= p %></a>
                            </li>
                        <% } %>
                        <li class="page-item <%= currentPage >= totalPages ? "disabled" : "" %>">
                            <a class="page-link" href="<%= request.getContextPath() %>/items?page=<%= currentPage + 1 %>&q=<%= selectedQuery %>&type=<%= selectedType %>&category=<%= selectedCategoryId %>&city=<%= selectedCity %>&status=<%= selectedStatus %>">Next</a>
                        </li>
                    </ul>
                </nav>
            <% } %>

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
