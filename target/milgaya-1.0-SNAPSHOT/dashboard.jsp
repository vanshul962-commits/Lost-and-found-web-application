<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.milgaya.model.Item" %>
<%@ page import="com.mycompany.milgaya.model.Claim" %>
<%@ page import="com.mycompany.milgaya.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<Item> myLostItems = (List<Item>) request.getAttribute("myLostItems");
    List<Item> myFoundItems = (List<Item>) request.getAttribute("myFoundItems");
    List<Claim> claimsReceived = (List<Claim>) request.getAttribute("claimsReceived");
    List<Claim> mySubmittedClaims = (List<Claim>) request.getAttribute("mySubmittedClaims");

    int lostCount = myLostItems != null ? myLostItems.size() : 0;
    int foundCount = myFoundItems != null ? myFoundItems.size() : 0;
    int claimsReceivedCount = claimsReceived != null ? claimsReceived.size() : 0;
    int mySubmittedClaimsCount = mySubmittedClaims != null ? mySubmittedClaims.size() : 0;
%>
<jsp:include page="/WEB-INF/views/header.jsp">
    <jsp:param name="pageTitle" value="My Dashboard - Milgaya" />
</jsp:include>

<!-- Dashboard Header -->
<div class="bg-white border-bottom py-4 mb-4">
    <div class="container">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div class="d-flex align-items-center gap-3">
                <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center shadow" style="width: 54px; height: 54px; font-size: 1.5rem; font-weight: bold;">
                    <%= currentUser.getFullName().substring(0, 1).toUpperCase() %>
                </div>
                <div>
                    <h3 class="fw-bold mb-0">Hello, <%= currentUser.getFullName() %>!</h3>
                    <p class="text-muted small mb-0">
                        <i class="fa-solid fa-envelope me-1"></i> <%= currentUser.getEmail() %> &bull; 
                        <i class="fa-solid fa-location-dot me-1 text-danger"></i> <%= currentUser.getCity() %> &bull;
                        <span class="badge bg-primary-subtle text-primary"><%= currentUser.getRole() %></span>
                    </p>
                </div>
            </div>

            <div class="d-flex gap-2">
                <a href="<%= request.getContextPath() %>/report-lost" class="btn btn-danger btn-sm rounded-pill px-3 fw-bold">
                    <i class="fa-solid fa-bullhorn me-1"></i> Post Lost Item
                </a>
                <a href="<%= request.getContextPath() %>/report-found" class="btn btn-success btn-sm rounded-pill px-3 fw-bold">
                    <i class="fa-solid fa-hand-holding-heart me-1"></i> Post Found Item
                </a>
                <% if (currentUser.isAdmin()) { %>
                    <a href="<%= request.getContextPath() %>/admin" class="btn btn-dark btn-sm rounded-pill px-3 fw-bold">
                        <i class="fa-solid fa-shield-halved me-1 text-warning"></i> Admin Panel
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</div>

<div class="container pb-5">
    
    <!-- Navigation Tabs -->
    <ul class="nav nav-pills mb-4 gap-2" id="dashboardTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active rounded-pill px-3 py-2 fw-semibold" id="lost-tab" data-bs-toggle="pill" data-bs-target="#lost-pane" type="button" role="tab">
                <i class="fa-solid fa-bullhorn me-1 text-danger"></i> My Lost Items (<%= lostCount %>)
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link rounded-pill px-3 py-2 fw-semibold" id="found-tab" data-bs-toggle="pill" data-bs-target="#found-pane" type="button" role="tab">
                <i class="fa-solid fa-circle-check me-1 text-success"></i> My Found Items (<%= foundCount %>)
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link rounded-pill px-3 py-2 fw-semibold" id="claims-tab" data-bs-toggle="pill" data-bs-target="#claims-pane" type="button" role="tab">
                <i class="fa-solid fa-inbox me-1 text-primary"></i> Claims Received (<%= claimsReceivedCount %>)
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link rounded-pill px-3 py-2 fw-semibold" id="myclaims-tab" data-bs-toggle="pill" data-bs-target="#myclaims-pane" type="button" role="tab">
                <i class="fa-solid fa-paper-plane me-1 text-info"></i> Claims I Submitted (<%= mySubmittedClaimsCount %>)
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link rounded-pill px-3 py-2 fw-semibold" id="profile-tab" data-bs-toggle="pill" data-bs-target="#profile-pane" type="button" role="tab">
                <i class="fa-solid fa-user-gear me-1 text-secondary"></i> Profile Settings
            </button>
        </li>
    </ul>

    <!-- Tab Content -->
    <div class="tab-content" id="dashboardTabsContent">
        
        <!-- Tab 1: My Lost Items -->
        <div class="tab-pane fade show active" id="lost-pane" role="tabpanel">
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0">Items You Reported as Lost</h5>
                    <a href="<%= request.getContextPath() %>/report-lost" class="btn btn-outline-danger btn-sm rounded-pill">+ New Lost Report</a>
                </div>

                <% if (myLostItems != null && !myLostItems.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Item</th>
                                    <th>Category</th>
                                    <th>Date Lost</th>
                                    <th>Location</th>
                                    <th>Reward</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Item item : myLostItems) { %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="<%= item.getImageUrl() != null ? item.getImageUrl() : "https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=600&auto=format&fit=crop&q=80" %>" alt="" class="rounded" style="width: 44px; height: 44px; object-fit: cover;">
                                                <div>
                                                    <a href="<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="fw-bold text-dark text-decoration-none">
                                                        <%= item.getTitle() %>
                                                    </a>
                                                    <div class="text-muted small">#<%= item.getId() %></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border"><%= item.getCategoryName() %></span></td>
                                        <td><%= item.getDateEvent() %></td>
                                        <td><%= item.getLocation() %>, <%= item.getCity() %></td>
                                        <td>
                                            <% if (item.getRewardAmount() != null && item.getRewardAmount().doubleValue() > 0) { %>
                                                <span class="text-warning fw-bold">Rs. <%= item.getRewardAmount() %></span>
                                            <% } else { %>
                                                <span class="text-muted small">None</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (item.isResolved()) { %>
                                                <span class="badge bg-success-subtle text-success">Reunited</span>
                                            <% } else { %>
                                                <span class="badge bg-danger-subtle text-danger">Seeking</span>
                                            <% } %>
                                        </td>
                                        <td class="text-end">
                                            <div class="btn-group btn-group-sm">
                                                <a href="<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="btn btn-outline-secondary" title="View"><i class="fa-solid fa-eye"></i></a>
                                                <% if (!item.isResolved()) { %>
                                                    <form action="<%= request.getContextPath() %>/item-action" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="resolve">
                                                        <input type="hidden" name="id" value="<%= item.getId() %>">
                                                        <button type="submit" class="btn btn-outline-success" title="Mark Reunited"><i class="fa-solid fa-check"></i></button>
                                                    </form>
                                                <% } %>
                                                <form action="<%= request.getContextPath() %>/item-action" method="post" class="d-inline" onsubmit="return confirm('Delete this listing?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="<%= item.getId() %>">
                                                    <button type="submit" class="btn btn-outline-danger" title="Delete"><i class="fa-solid fa-trash"></i></button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-5 text-muted">
                        <i class="fa-solid fa-folder-open fa-2x mb-2"></i>
                        <p>You haven't reported any lost items yet.</p>
                        <a href="<%= request.getContextPath() %>/report-lost" class="btn btn-danger btn-sm rounded-pill px-3">Report a Lost Item</a>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Tab 2: My Found Items -->
        <div class="tab-pane fade" id="found-pane" role="tabpanel">
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0">Items You Found (Milgaya)</h5>
                    <a href="<%= request.getContextPath() %>/report-found" class="btn btn-outline-success btn-sm rounded-pill">+ New Found Report</a>
                </div>

                <% if (myFoundItems != null && !myFoundItems.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Item</th>
                                    <th>Category</th>
                                    <th>Date Found</th>
                                    <th>Where Kept</th>
                                    <th>Security Q</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Item item : myFoundItems) { %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="<%= item.getImageUrl() != null ? item.getImageUrl() : "https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=600&auto=format&fit=crop&q=80" %>" alt="" class="rounded" style="width: 44px; height: 44px; object-fit: cover;">
                                                <div>
                                                    <a href="<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="fw-bold text-dark text-decoration-none">
                                                        <%= item.getTitle() %>
                                                    </a>
                                                    <div class="text-muted small">#<%= item.getId() %></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border"><%= item.getCategoryName() %></span></td>
                                        <td><%= item.getDateEvent() %></td>
                                        <td><%= item.getLocation() %>, <%= item.getCity() %></td>
                                        <td>
                                            <% if (item.getSecurityQuestion() != null && !item.getSecurityQuestion().isEmpty()) { %>
                                                <span class="badge bg-info-subtle text-info"><i class="fa-solid fa-lock me-1"></i> Yes</span>
                                            <% } else { %>
                                                <span class="text-muted small">None</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (item.isResolved()) { %>
                                                <span class="badge bg-success-subtle text-success">Claimed / Reunited</span>
                                            <% } else { %>
                                                <span class="badge bg-primary-subtle text-primary">Open for Claims</span>
                                            <% } %>
                                        </td>
                                        <td class="text-end">
                                            <div class="btn-group btn-group-sm">
                                                <a href="<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="btn btn-outline-secondary" title="View"><i class="fa-solid fa-eye"></i></a>
                                                <% if (!item.isResolved()) { %>
                                                    <form action="<%= request.getContextPath() %>/item-action" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="resolve">
                                                        <input type="hidden" name="id" value="<%= item.getId() %>">
                                                        <button type="submit" class="btn btn-outline-success" title="Mark Handed Over"><i class="fa-solid fa-check"></i></button>
                                                    </form>
                                                <% } %>
                                                <form action="<%= request.getContextPath() %>/item-action" method="post" class="d-inline" onsubmit="return confirm('Delete this listing?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="<%= item.getId() %>">
                                                    <button type="submit" class="btn btn-outline-danger" title="Delete"><i class="fa-solid fa-trash"></i></button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-5 text-muted">
                        <i class="fa-solid fa-hand-holding-heart fa-2x mb-2"></i>
                        <p>You haven't reported finding any items yet.</p>
                        <a href="<%= request.getContextPath() %>/report-found" class="btn btn-success btn-sm rounded-pill px-3">Report a Found Item</a>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Tab 3: Claims Received -->
        <div class="tab-pane fade" id="claims-pane" role="tabpanel">
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <h5 class="fw-bold mb-3">Claims &amp; Ownership Inquiries on Your Listings</h5>

                <% if (claimsReceived != null && !claimsReceived.isEmpty()) { %>
                    <div class="d-flex flex-column gap-3">
                        <% for (Claim cl : claimsReceived) { %>
                            <div class="border rounded-4 p-3 bg-light">
                                <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-2">
                                    <div>
                                        <h6 class="fw-bold mb-0">Claim on: <a href="<%= request.getContextPath() %>/item?id=<%= cl.getItemId() %>" class="text-primary text-decoration-none"><%= cl.getItemTitle() %></a></h6>
                                        <small class="text-muted">
                                            From: <strong><%= cl.getClaimantName() %></strong> &bull; Contact: <strong><%= cl.getClaimantContact() %></strong> (<%= cl.getClaimantEmail() %>)
                                        </small>
                                    </div>
                                    <div>
                                        <% if ("ACCEPTED".equals(cl.getStatus())) { %>
                                            <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i> Accepted</span>
                                        <% } else if ("REJECTED".equals(cl.getStatus())) { %>
                                            <span class="badge bg-danger"><i class="fa-solid fa-xmark me-1"></i> Rejected</span>
                                        <% } else { %>
                                            <span class="badge bg-warning text-dark"><i class="fa-solid fa-clock me-1"></i> Pending Verification</span>
                                        <% } %>
                                    </div>
                                </div>

                                <div class="p-3 bg-white rounded-3 border mb-3 small">
                                    <div class="mb-1"><strong>Claimant's Explanation:</strong> <%= cl.getClaimMessage() %></div>
                                    <% if (cl.getClaimProof() != null && !cl.getClaimProof().isEmpty()) { %>
                                        <div><strong>Proof / Answer to Security Q:</strong> <%= cl.getClaimProof() %></div>
                                    <% } %>
                                </div>

                                <% if ("PENDING".equals(cl.getStatus())) { %>
                                    <div class="d-flex gap-2">
                                        <form action="<%= request.getContextPath() %>/claim" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="accept">
                                            <input type="hidden" name="claimId" value="<%= cl.getId() %>">
                                            <button type="submit" class="btn btn-success btn-sm rounded-pill px-3">
                                                <i class="fa-solid fa-check me-1"></i> Accept Claim &amp; Mark Reunited
                                            </button>
                                        </form>
                                        <form action="<%= request.getContextPath() %>/claim" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="claimId" value="<%= cl.getId() %>">
                                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                                                <i class="fa-solid fa-xmark me-1"></i> Reject
                                            </button>
                                        </form>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="text-center py-5 text-muted">
                        <i class="fa-solid fa-inbox fa-2x mb-2"></i>
                        <p>No claims or inquiries received yet.</p>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Tab 4: Claims I Submitted -->
        <div class="tab-pane fade" id="myclaims-pane" role="tabpanel">
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <h5 class="fw-bold mb-3">Claims You Submitted on Other Listings</h5>

                <% if (mySubmittedClaims != null && !mySubmittedClaims.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Item</th>
                                    <th>Your Explanation</th>
                                    <th>Date Sent</th>
                                    <th>Status</th>
                                    <th class="text-end">View Item</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Claim cl : mySubmittedClaims) { %>
                                    <tr>
                                        <td>
                                            <a href="<%= request.getContextPath() %>/item?id=<%= cl.getItemId() %>" class="fw-bold text-dark text-decoration-none">
                                                <%= cl.getItemTitle() %>
                                            </a>
                                        </td>
                                        <td class="small text-truncate" style="max-width: 280px;"><%= cl.getClaimMessage() %></td>
                                        <td><%= cl.getCreatedAt() != null ? cl.getCreatedAt().toString().substring(0, 10) : "" %></td>
                                        <td>
                                            <% if ("ACCEPTED".equals(cl.getStatus())) { %>
                                                <span class="badge bg-success">Accepted &bull; Reunited!</span>
                                            <% } else if ("REJECTED".equals(cl.getStatus())) { %>
                                                <span class="badge bg-danger">Rejected</span>
                                            <% } else { %>
                                                <span class="badge bg-warning text-dark">Under Review</span>
                                            <% } %>
                                        </td>
                                        <td class="text-end">
                                            <a href="<%= request.getContextPath() %>/item?id=<%= cl.getItemId() %>" class="btn btn-outline-primary btn-sm rounded-pill">
                                                View <i class="fa-solid fa-arrow-right ms-1"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-5 text-muted">
                        <i class="fa-solid fa-paper-plane fa-2x mb-2"></i>
                        <p>You haven't submitted any claims yet.</p>
                        <a href="<%= request.getContextPath() %>/items" class="btn btn-primary btn-sm rounded-pill px-3">Browse Items</a>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Tab 5: Profile Settings -->
        <div class="tab-pane fade" id="profile-pane" role="tabpanel">
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm rounded-4 p-4">
                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-user-pen text-primary me-2"></i> Update Profile Details</h5>
                        <form action="<%= request.getContextPath() %>/dashboard" method="post">
                            <input type="hidden" name="action" value="updateProfile">

                            <div class="mb-3">
                                <label class="form-label fw-bold small">Full Name</label>
                                <input type="text" name="fullName" class="form-control" value="<%= currentUser.getFullName() %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold small">Email Address</label>
                                <input type="email" class="form-control" value="<%= currentUser.getEmail() %>" disabled>
                                <div class="form-text">Email address cannot be modified.</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold small">Phone Number</label>
                                <input type="text" name="phone" class="form-control" value="<%= currentUser.getPhone() %>" required>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold small">City</label>
                                <input type="text" name="city" class="form-control" value="<%= currentUser.getCity() %>" required>
                            </div>

                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Save Changes</button>
                        </form>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card border-0 shadow-sm rounded-4 p-4">
                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-key text-warning me-2"></i> Change Password</h5>
                        <form action="<%= request.getContextPath() %>/dashboard" method="post">
                            <input type="hidden" name="action" value="changePassword">

                            <div class="mb-3">
                                <label class="form-label fw-bold small">Current Password</label>
                                <input type="password" name="currentPassword" class="form-control" placeholder="••••••••" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold small">New Password</label>
                                <input type="password" name="newPassword" class="form-control" placeholder="Minimum 6 characters" required>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold small">Confirm New Password</label>
                                <input type="password" name="confirmPassword" class="form-control" placeholder="Repeat new password" required>
                            </div>

                            <button type="submit" class="btn btn-warning rounded-pill px-4 fw-bold">Update Password</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
