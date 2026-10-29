<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.mycompany.milgaya.model.Item" %>
<%@ page import="com.mycompany.milgaya.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    List<Item> items = (List<Item>) request.getAttribute("items");
    List<User> users = (List<User>) request.getAttribute("users");
%>
<jsp:include page="/WEB-INF/views/header.jsp">
    <jsp:param name="pageTitle" value="Admin Console - Milgaya" />
</jsp:include>

<!-- Admin Banner -->
<div class="bg-dark text-white py-4 mb-4">
    <div class="container">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="badge bg-danger text-uppercase px-3 py-1 rounded-pill mb-2">Restricted Access</span>
                <h3 class="fw-bold mb-0"><i class="fa-solid fa-shield-halved text-warning me-2"></i> Milgaya Administration Console</h3>
                <p class="text-secondary small mb-0">System statistics, user accounts, and listing moderation</p>
            </div>
            <div class="d-flex gap-2">
                <form action="<%= request.getContextPath() %>/admin" method="post" onsubmit="return confirm('Verify and ensure database tables and seed sample data?');">
                    <input type="hidden" name="action" value="resetDemoData">
                    <button type="submit" class="btn btn-outline-warning btn-sm rounded-pill px-3 fw-bold">
                        <i class="fa-solid fa-database me-1"></i> Verify / Re-seed DB
                    </button>
                </form>
                <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline-light btn-sm rounded-pill px-3">
                    <i class="fa-solid fa-user me-1"></i> My Dashboard
                </a>
            </div>
        </div>
    </div>
</div>

<div class="container pb-5">
    
    <!-- Admin Stat Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3 col-6">
            <div class="stat-box">
                <div class="stat-number text-primary"><%= stats != null ? stats.get("total") : 0 %></div>
                <div class="stat-label">Total Listings</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-box">
                <div class="stat-number text-danger"><%= stats != null ? stats.get("lost") : 0 %></div>
                <div class="stat-label">Lost Reports</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-box">
                <div class="stat-number text-success"><%= stats != null ? stats.get("found") : 0 %></div>
                <div class="stat-label">Found Reports</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-box">
                <div class="stat-number text-info"><%= stats != null ? stats.get("totalUsers") : 0 %></div>
                <div class="stat-label">Total Users</div>
            </div>
        </div>
    </div>

    <!-- Admin Navigation Tabs -->
    <ul class="nav nav-tabs mb-4" id="adminTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active fw-bold" id="items-tab" data-bs-toggle="tab" data-bs-target="#admin-items" type="button" role="tab">
                <i class="fa-solid fa-list-check me-2"></i> Manage Listings (<%= items != null ? items.size() : 0 %>)
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link fw-bold" id="users-tab" data-bs-toggle="tab" data-bs-target="#admin-users" type="button" role="tab">
                <i class="fa-solid fa-users-gear me-2"></i> Manage Users (<%= users != null ? users.size() : 0 %>)
            </button>
        </li>
    </ul>

    <div class="tab-content" id="adminTabsContent">
        
        <!-- Tab 1: Manage Listings -->
        <div class="tab-pane fade show active" id="admin-items" role="tabpanel">
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Item Title</th>
                                <th>Type</th>
                                <th>Category</th>
                                <th>City / Location</th>
                                <th>Reported By</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (items != null) {
                                for (Item it : items) { %>
                                    <tr>
                                        <td><%= it.getId() %></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="<%= it.getImageUrl() != null ? it.getImageUrl() : "https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=600&auto=format&fit=crop&q=80" %>" class="rounded" style="width: 38px; height: 38px; object-fit: cover;" alt="">
                                                <a href="<%= request.getContextPath() %>/item?id=<%= it.getId() %>" class="fw-bold text-dark text-decoration-none">
                                                    <%= it.getTitle() %>
                                                </a>
                                            </div>
                                        </td>
                                        <td>
                                            <% if ("LOST".equalsIgnoreCase(it.getType())) { %>
                                                <span class="badge bg-danger">LOST</span>
                                            <% } else { %>
                                                <span class="badge bg-success">FOUND</span>
                                            <% } %>
                                        </td>
                                        <td><%= it.getCategoryName() %></td>
                                        <td><%= it.getCity() %></td>
                                        <td><%= it.getUserName() %></td>
                                        <td>
                                            <% if (it.isResolved()) { %>
                                                <span class="badge bg-secondary">RESOLVED</span>
                                            <% } else { %>
                                                <span class="badge bg-success-subtle text-success">OPEN</span>
                                            <% } %>
                                        </td>
                                        <td class="text-end">
                                            <div class="btn-group btn-group-sm">
                                                <a href="<%= request.getContextPath() %>/item?id=<%= it.getId() %>" class="btn btn-outline-secondary" title="View"><i class="fa-solid fa-eye"></i></a>
                                                <% if (!it.isResolved()) { %>
                                                    <form action="<%= request.getContextPath() %>/item-action" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="resolve">
                                                        <input type="hidden" name="id" value="<%= it.getId() %>">
                                                        <button type="submit" class="btn btn-outline-success" title="Mark Resolved"><i class="fa-solid fa-check"></i></button>
                                                    </form>
                                                <% } %>
                                                <form action="<%= request.getContextPath() %>/item-action" method="post" class="d-inline" onsubmit="return confirm('Admin: Permanently delete this listing?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="<%= it.getId() %>">
                                                    <button type="submit" class="btn btn-outline-danger" title="Delete"><i class="fa-solid fa-trash"></i></button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                            <%  }
                               } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Tab 2: Manage Users -->
        <div class="tab-pane fade" id="admin-users" role="tabpanel">
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>City</th>
                                <th>Role</th>
                                <th>Joined</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (users != null) {
                                for (User u : users) { %>
                                    <tr>
                                        <td><%= u.getId() %></td>
                                        <td class="fw-bold"><%= u.getFullName() %></td>
                                        <td><%= u.getEmail() %></td>
                                        <td><%= u.getPhone() %></td>
                                        <td><%= u.getCity() %></td>
                                        <td>
                                            <% if (u.isAdmin()) { %>
                                                <span class="badge bg-danger"><i class="fa-solid fa-shield-halved me-1"></i> ADMIN</span>
                                            <% } else { %>
                                                <span class="badge bg-primary-subtle text-primary">USER</span>
                                            <% } %>
                                        </td>
                                        <td><%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0, 10) : "" %></td>
                                        <td class="text-end">
                                            <% if (u.getId() != currentUser.getId()) { %>
                                                <form action="<%= request.getContextPath() %>/admin" method="post" class="d-inline" onsubmit="return confirm('Delete this user account?');">
                                                    <input type="hidden" name="action" value="deleteUser">
                                                    <input type="hidden" name="userId" value="<%= u.getId() %>">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                                                        <i class="fa-solid fa-user-xmark me-1"></i> Delete
                                                    </button>
                                                </form>
                                            <% } else { %>
                                                <span class="badge bg-light text-muted border">Current User</span>
                                            <% } %>
                                        </td>
                                    </tr>
                            <%  }
                               } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
