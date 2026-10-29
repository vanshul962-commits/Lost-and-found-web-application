<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.milgaya.model.Category" %>
<%@ page import="com.mycompany.milgaya.model.User" %>
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    User currentUser = (User) session.getAttribute("currentUser");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<jsp:include page="/WEB-INF/views/header.jsp">
    <jsp:param name="pageTitle" value="Report a Lost Item - Milgaya" />
</jsp:include>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="p-4" style="background: linear-gradient(135deg, #ef4444, #dc2626); color: white;">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-white text-danger d-flex align-items-center justify-content-center" style="width: 50px; height: 50px; font-size: 1.5rem;">
                            <i class="fa-solid fa-bullhorn"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-1">Report a Lost Item</h3>
                            <p class="mb-0 opacity-90 small">Help our community identify and return your missing belongings.</p>
                        </div>
                    </div>
                </div>

                <div class="p-4 p-md-5 bg-white">
                    <% if (errorMessage != null) { %>
                        <div class="alert alert-danger rounded-3 mb-4">
                            <i class="fa-solid fa-circle-exclamation me-2"></i> <%= errorMessage %>
                        </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/report-lost" method="post">
                        
                        <!-- Item Title -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Item Name / Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control form-control-lg" placeholder="e.g. Blue Dell XPS 15 Laptop in Grey Bag" required>
                            <div class="form-text">Include brand, model, and primary color for quick search matching.</div>
                        </div>

                        <div class="row g-3 mb-4">
                            <!-- Category -->
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Category <span class="text-danger">*</span></label>
                                <select name="categoryId" id="itemCategorySelect" class="form-select" required>
                                    <option value="">Select Category...</option>
                                    <% if (categories != null) {
                                        for (Category cat : categories) { %>
                                            <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
                                    <%  }
                                       } %>
                                </select>
                            </div>

                            <!-- Date Lost -->
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Date Lost <span class="text-danger">*</span></label>
                                <input type="date" name="dateEvent" class="form-control" value="<%= java.time.LocalDate.now().toString() %>" required>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <!-- City -->
                            <div class="col-md-6">
                                <label class="form-label fw-bold">City / Town <span class="text-danger">*</span></label>
                                <input type="text" name="city" class="form-control" placeholder="e.g. New Delhi, Mumbai, Bengaluru" value="<%= currentUser != null && currentUser.getCity() != null ? currentUser.getCity() : "" %>" required>
                            </div>

                            <!-- Specific Location -->
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Specific Location / Landmark <span class="text-danger">*</span></label>
                                <input type="text" name="location" class="form-control" placeholder="e.g. Rajiv Chowk Metro Gate 3, Uber Cab" required>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Detailed Description &amp; Marks <span class="text-danger">*</span></label>
                            <textarea name="description" rows="4" class="form-control" placeholder="Describe unique features, scratches, stickers, wallpaper, or what was inside the bag..." required></textarea>
                        </div>

                        <!-- Optional Reward -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Reward for Finder (Optional)</label>
                            <div class="input-group">
                                <span class="input-group-text">Rs.</span>
                                <input type="number" step="100" min="0" name="rewardAmount" class="form-control" placeholder="0.00">
                            </div>
                            <div class="form-text">Offering an optional monetary incentive encourages finders to check and return items promptly.</div>
                        </div>

                        <!-- Image URL with Preview -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Item Photo (Image URL)</label>
                            <input type="url" name="imageUrl" id="itemImageUrl" class="form-control" placeholder="Paste an image URL (selecting a category auto-suggests a representative image)">
                            <div class="mt-2 text-center">
                                <img id="imagePreview" src="" alt="Preview" class="rounded-3 shadow-sm" style="max-height: 180px; display: none;">
                            </div>
                        </div>

                        <hr class="my-4">

                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-address-book text-danger me-2"></i> Your Contact Preferences</h5>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Contact Phone Number</label>
                                <input type="text" name="contactPhone" class="form-control" value="<%= currentUser != null ? currentUser.getPhone() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Contact Email</label>
                                <input type="email" name="contactEmail" class="form-control" value="<%= currentUser != null ? currentUser.getEmail() : "" %>">
                            </div>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" name="contactVisible" value="true" id="contactVisibleCheck" checked>
                            <label class="form-check-label small text-muted" for="contactVisibleCheck">
                                Display my contact phone &amp; email publicly on the listing so finders can reach me immediately.
                            </label>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-danger btn-lg rounded-pill fw-bold py-3 shadow">
                                <i class="fa-solid fa-bullhorn me-2"></i> Publish Lost Item Report
                            </button>
                            <a href="<%= request.getContextPath() %>/home" class="btn btn-light rounded-pill py-2 text-muted">Cancel</a>
                        </div>

                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
