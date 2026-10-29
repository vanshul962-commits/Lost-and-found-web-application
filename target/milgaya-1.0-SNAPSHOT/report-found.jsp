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
    <jsp:param name="pageTitle" value="Report a Found Item - Milgaya" />
</jsp:include>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="p-4" style="background: linear-gradient(135deg, #10b981, #059669); color: white;">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-white text-success d-flex align-items-center justify-content-center" style="width: 50px; height: 50px; font-size: 1.5rem;">
                            <i class="fa-solid fa-hand-holding-heart"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-1">Report a Found Item</h3>
                            <p class="mb-0 opacity-90 small">Thank you for being a good samaritan! Help us return this item to its rightful owner.</p>
                        </div>
                    </div>
                </div>

                <div class="p-4 p-md-5 bg-white">
                    <% if (errorMessage != null) { %>
                        <div class="alert alert-danger rounded-3 mb-4">
                            <i class="fa-solid fa-circle-exclamation me-2"></i> <%= errorMessage %>
                        </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/report-found" method="post">
                        
                        <!-- Item Title -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Item Name / Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control form-control-lg" placeholder="e.g. Set of Royal Enfield Keys with Keychain" required>
                            <div class="form-text">Keep the title general so the true owner can prove specific details.</div>
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

                            <!-- Date Found -->
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Date Found <span class="text-danger">*</span></label>
                                <input type="date" name="dateEvent" class="form-control" value="<%= java.time.LocalDate.now().toString() %>" required>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <!-- City -->
                            <div class="col-md-6">
                                <label class="form-label fw-bold">City / Town <span class="text-danger">*</span></label>
                                <input type="text" name="city" class="form-control" placeholder="e.g. Bengaluru, Pune, Delhi" value="<%= currentUser != null && currentUser.getCity() != null ? currentUser.getCity() : "" %>" required>
                            </div>

                            <!-- Specific Location -->
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Where Found &amp; Safely Kept <span class="text-danger">*</span></label>
                                <input type="text" name="location" class="form-control" placeholder="e.g. Phoenix Mall Food Court, handed to Helpdesk" required>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Item Condition &amp; General Appearance <span class="text-danger">*</span></label>
                            <textarea name="description" rows="3" class="form-control" placeholder="Describe the item generally (color, brand). Avoid revealing secret identifying marks that only the owner would know!" required></textarea>
                        </div>

                        <!-- Security Verification Question -->
                        <div class="mb-4 p-3 bg-light rounded-4 border border-warning-subtle">
                            <label class="form-label fw-bold text-dark d-flex align-items-center gap-2">
                                <i class="fa-solid fa-shield-halved text-warning"></i>
                                Security Verification Question (Recommended)
                            </label>
                            <input type="text" name="securityQuestion" class="form-control" placeholder="e.g. What is the keychain shape? What name is on the gym card inside?">
                            <div class="form-text text-muted">
                                Claimants will be required to answer this question to prove ownership before you hand over the item.
                            </div>
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

                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-address-book text-success me-2"></i> Finder's Contact Info</h5>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Your Phone Number</label>
                                <input type="text" name="contactPhone" class="form-control" value="<%= currentUser != null ? currentUser.getPhone() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Your Email</label>
                                <input type="email" name="contactEmail" class="form-control" value="<%= currentUser != null ? currentUser.getEmail() : "" %>">
                            </div>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" name="contactVisible" value="true" id="contactVisibleCheck" checked>
                            <label class="form-check-label small text-muted" for="contactVisibleCheck">
                                Display my contact information publicly so the verified owner can coordinate handover.
                            </label>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success btn-lg rounded-pill fw-bold py-3 shadow">
                                <i class="fa-solid fa-hand-holding-heart me-2"></i> Publish Found Item Report
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
