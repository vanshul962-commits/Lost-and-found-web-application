<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.milgaya.model.Item" %>
<%@ page import="com.mycompany.milgaya.model.Claim" %>
<%@ page import="com.mycompany.milgaya.model.User" %>
<%
    Item item = (Item) request.getAttribute("item");
    if (item == null) {
        response.sendRedirect(request.getContextPath() + "/items");
        return;
    }

    boolean isOwner = request.getAttribute("isOwner") != null && (Boolean) request.getAttribute("isOwner");
    List<Claim> claims = (List<Claim>) request.getAttribute("claims");
    User currentUser = (User) session.getAttribute("currentUser");
%>
<jsp:include page="/WEB-INF/views/header.jsp">
    <jsp:param name="pageTitle" value="Item Details - Milgaya" />
</jsp:include>

<!-- Breadcrumb -->
<div class="bg-white border-bottom py-3 mb-4">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0 small">
                <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/home">Home</a></li>
                <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/items">Browse Items</a></li>
                <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/items?type=<%= item.getType() %>"><%= item.getType() %></a></li>
                <li class="breadcrumb-item active" aria-current="page"><%= item.getTitle() %></li>
            </ol>
        </nav>
    </div>
</div>

<div class="container pb-5">
    <div class="row g-4">
        
        <!-- Left: Image & Quick Meta -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                <div style="height: 380px; background-color: #f1f5f9; position: relative;">
                    <img src="<%= item.getImageUrl() != null ? item.getImageUrl() : "https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=600&auto=format&fit=crop&q=80" %>" 
                         alt="<%= item.getTitle() %>" 
                         style="width: 100%; height: 100%; object-fit: cover;">

                    <div class="position-absolute top-0 start-0 m-3 d-flex flex-wrap gap-2">
                        <% if ("LOST".equalsIgnoreCase(item.getType())) { %>
                            <span class="badge badge-lost fs-6"><i class="fa-solid fa-bullhorn me-1"></i> LOST</span>
                        <% } else { %>
                            <span class="badge badge-found fs-6"><i class="fa-solid fa-circle-check me-1"></i> FOUND</span>
                        <% } %>

                        <% if (item.isResolved()) { %>
                            <span class="badge badge-resolved fs-6"><i class="fa-solid fa-check-double me-1"></i> RESOLVED / REUNITED</span>
                        <% } %>
                    </div>

                    <% if (item.getRewardAmount() != null && item.getRewardAmount().doubleValue() > 0) { %>
                        <div class="position-absolute bottom-0 start-0 m-3">
                            <span class="badge badge-reward fs-6 shadow">
                                <i class="fa-solid fa-award me-1"></i> Reward: Rs. <%= item.getRewardAmount() %>
                            </span>
                        </div>
                    <% } %>
                </div>

                <div class="card-body p-4 bg-light">
                    <h6 class="fw-bold text-uppercase small text-muted mb-3">Item Key Details</h6>
                    <div class="d-flex flex-column gap-2 small">
                        <div class="d-flex justify-content-between">
                            <span class="text-muted"><i class="fa-solid <%= item.getCategoryIcon() != null ? item.getCategoryIcon() : "fa-tag" %> me-2 text-primary"></i> Category</span>
                            <span class="fw-semibold"><%= item.getCategoryName() %></span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span class="text-muted"><i class="fa-solid fa-calendar me-2 text-primary"></i> Date Reported</span>
                            <span class="fw-semibold"><%= item.getDateEvent() %></span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span class="text-muted"><i class="fa-solid fa-city me-2 text-primary"></i> City</span>
                            <span class="fw-semibold"><%= item.getCity() %></span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span class="text-muted"><i class="fa-solid fa-location-dot me-2 text-danger"></i> Specific Location</span>
                            <span class="fw-semibold text-end" style="max-width: 220px;"><%= item.getLocation() %></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Share & Safety Card -->
            <div class="card border-0 shadow-sm rounded-4 p-4 text-center">
                <h6 class="fw-bold mb-2">Help Spread the Word</h6>
                <p class="text-muted small mb-3">Sharing this listing with friends or local groups increases reunion chances by 70%!</p>
                <div class="d-flex justify-content-center gap-2">
                    <button class="btn btn-outline-primary btn-sm rounded-pill px-3" onclick="copyShareLink(window.location.href)">
                        <i class="fa-solid fa-link me-1"></i> Copy Link
                    </button>
                    <a href="https://api.whatsapp.com/send?text=<%= item.getTitle() %> reported on Milgaya: <%= request.getRequestURL() %>" target="_blank" class="btn btn-outline-success btn-sm rounded-pill px-3">
                        <i class="fa-brands fa-whatsapp me-1"></i> WhatsApp
                    </a>
                </div>
            </div>
        </div>

        <!-- Right: Details, Security Question, Contact, & Claim -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <span class="badge bg-light text-muted border mb-2"><i class="fa-solid fa-hashtag me-1"></i> Listing #<%= item.getId() %></span>
                        <h2 class="fw-bold mb-1"><%= item.getTitle() %></h2>
                        <div class="text-muted small">
                            Reported on <%= item.getCreatedAt() != null ? item.getCreatedAt().toString().substring(0, 10) : "Recently" %>
                        </div>
                    </div>
                    <% if (item.isResolved()) { %>
                        <span class="badge bg-secondary-subtle text-secondary px-3 py-2 rounded-pill fw-bold">Case Closed</span>
                    <% } else { %>
                        <span class="badge bg-success-subtle text-success px-3 py-2 rounded-pill fw-bold">Active Case</span>
                    <% } %>
                </div>

                <hr>

                <div class="mb-4">
                    <h5 class="fw-bold mb-2">Description &amp; Marks</h5>
                    <p class="text-secondary leading-relaxed" style="white-space: pre-line;"><%= item.getDescription() %></p>
                </div>

                <!-- Security Verification for Found Items -->
                <% if (item.getSecurityQuestion() != null && !item.getSecurityQuestion().trim().isEmpty()) { %>
                    <div class="alert alert-warning border-0 rounded-3 p-3 mb-4">
                        <div class="d-flex gap-2">
                            <i class="fa-solid fa-shield-halved fa-lg text-warning mt-1"></i>
                            <div>
                                <h6 class="fw-bold mb-1">Security Verification Question</h6>
                                <p class="small mb-1">To ensure this item reaches its rightful owner, the finder has set a verification question:</p>
                                <blockquote class="blockquote mb-0 fs-6 fw-semibold text-dark">
                                    "<%= item.getSecurityQuestion() %>"
                                </blockquote>
                                <small class="text-muted">Please provide your answer and proof when submitting a claim below.</small>
                            </div>
                        </div>
                    </div>
                <% } %>

                <!-- Reporter Contact Info -->
                <div class="bg-light rounded-4 p-3 mb-4 border">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted small text-uppercase fw-bold">Posted By</span>
                            <h6 class="fw-bold mb-0"><%= item.getUserName() %></h6>
                            <% if (item.isContactVisible()) { %>
                                <div class="small text-muted mt-1">
                                    <span><i class="fa-solid fa-phone me-1 text-primary"></i> <%= item.getContactPhone() %></span>
                                    <span class="ms-3"><i class="fa-solid fa-envelope me-1 text-primary"></i> <%= item.getContactEmail() %></span>
                                </div>
                            <% } else { %>
                                <div class="small text-muted mt-1">
                                    <i class="fa-solid fa-user-shield text-info me-1"></i> Contact details masked for privacy. Use the claim portal below.
                                </div>
                            <% } %>
                        </div>
                        <span class="rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center" style="width: 44px; height: 44px; font-weight: bold;">
                            <%= item.getUserName() != null ? item.getUserName().substring(0, 1).toUpperCase() : "U" %>
                        </span>
                    </div>
                </div>

                <!-- Action Button for Claim / Inquire -->
                <% if (!isOwner) { %>
                    <% if (item.isResolved()) { %>
                        <div class="alert alert-secondary text-center rounded-3">
                            <i class="fa-solid fa-check-circle me-1"></i> This item has been reunited and the case is now resolved.
                        </div>
                    <% } else if (currentUser != null) { %>
                        <button type="button" class="btn btn-primary btn-lg w-100 rounded-pill fw-bold py-3 shadow" data-bs-toggle="modal" data-bs-target="#claimModal">
                            <i class="fa-solid fa-hand-holding-hand me-2"></i> 
                            <%= "FOUND".equalsIgnoreCase(item.getType()) ? "Claim This Item (Prove Ownership)" : "I Have Found This Item (Contact Reporter)" %>
                        </button>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/login?redirect=<%= request.getContextPath() %>/item?id=<%= item.getId() %>" class="btn btn-outline-primary btn-lg w-100 rounded-pill fw-bold py-3">
                            <i class="fa-solid fa-right-to-bracket me-2"></i> Sign In to Claim / Contact Reporter
                        </a>
                    <% } %>
                <% } else { %>
                    <!-- Owner Tools -->
                    <div class="card border border-primary-subtle bg-primary-subtle bg-opacity-10 rounded-4 p-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6 class="fw-bold text-primary mb-0"><i class="fa-solid fa-gear me-1"></i> Listing Owner Actions</h6>
                            <span class="badge bg-primary text-white">Your Listing</span>
                        </div>
                        <p class="small text-muted mb-3">You posted this listing. You can mark it as resolved once reunited or remove it.</p>
                        <div class="d-flex flex-wrap gap-2">
                            <% if (!item.isResolved()) { %>
                                <form action="<%= request.getContextPath() %>/item-action" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="resolve">
                                    <input type="hidden" name="id" value="<%= item.getId() %>">
                                    <button type="submit" class="btn btn-success btn-sm rounded-pill px-3 fw-bold">
                                        <i class="fa-solid fa-circle-check me-1"></i> Mark as Resolved / Reunited
                                    </button>
                                </form>
                            <% } else { %>
                                <form action="<%= request.getContextPath() %>/item-action" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="reopen">
                                    <input type="hidden" name="id" value="<%= item.getId() %>">
                                    <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-bold">
                                        <i class="fa-solid fa-arrow-rotate-left me-1"></i> Reopen Case
                                    </button>
                                </form>
                            <% } %>

                            <form action="<%= request.getContextPath() %>/item-action" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this listing?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= item.getId() %>">
                                <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                                    <i class="fa-solid fa-trash me-1"></i> Delete
                                </button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- If owner, display received claims for this item -->
            <% if (isOwner) { %>
                <div class="card border-0 shadow-sm rounded-4 p-4">
                    <h5 class="fw-bold mb-3 d-flex align-items-center justify-content-between">
                        <span><i class="fa-solid fa-inbox me-2 text-primary"></i> Claims &amp; Inquiries Received</span>
                        <span class="badge bg-primary rounded-pill"><%= claims != null ? claims.size() : 0 %></span>
                    </h5>

                    <% if (claims != null && !claims.isEmpty()) { %>
                        <div class="d-flex flex-column gap-3">
                            <% for (Claim cl : claims) { %>
                                <div class="border rounded-3 p-3 bg-light">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div>
                                            <h6 class="fw-bold mb-0"><%= cl.getClaimantName() %></h6>
                                            <small class="text-muted"><i class="fa-solid fa-phone me-1"></i> <%= cl.getClaimantContact() %> &bull; <i class="fa-solid fa-envelope me-1"></i> <%= cl.getClaimantEmail() %></small>
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
                                    <div class="small mb-2">
                                        <strong>Claim Message:</strong> <%= cl.getClaimMessage() %>
                                    </div>
                                    <% if (cl.getClaimProof() != null && !cl.getClaimProof().isEmpty()) { %>
                                        <div class="small mb-3 bg-white p-2 rounded border">
                                            <strong>Proof / Distinguishing Marks:</strong> <%= cl.getClaimProof() %>
                                        </div>
                                    <% } %>

                                    <% if ("PENDING".equals(cl.getStatus())) { %>
                                        <div class="d-flex gap-2 pt-2 border-top">
                                            <form action="<%= request.getContextPath() %>/claim" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="accept">
                                                <input type="hidden" name="claimId" value="<%= cl.getId() %>">
                                                <button type="submit" class="btn btn-success btn-sm rounded-pill px-3">
                                                    <i class="fa-solid fa-check me-1"></i> Accept Claim &amp; Resolve Item
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
                        <p class="text-muted small mb-0">No claims or inquiries received yet for this listing.</p>
                    <% } %>
                </div>
            <% } %>

        </div>
    </div>
</div>

<!-- Claim / Inquire Modal -->
<% if (currentUser != null && !isOwner) { %>
<div class="modal fade" id="claimModal" tabindex="-1" aria-labelledby="claimModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-bold" id="claimModalLabel">
                    <i class="fa-solid fa-shield-halved text-primary me-2"></i>
                    <%= "FOUND".equalsIgnoreCase(item.getType()) ? "Claim Ownership of this Item" : "Report That You Found This Item" %>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/claim" method="post">
                <input type="hidden" name="action" value="submit">
                <input type="hidden" name="itemId" value="<%= item.getId() %>">

                <div class="modal-body p-4">
                    <% if (item.getSecurityQuestion() != null && !item.getSecurityQuestion().trim().isEmpty()) { %>
                        <div class="alert alert-warning small p-3 rounded-3 mb-3">
                            <strong>Security Question from Finder:</strong><br>
                            <em>"<%= item.getSecurityQuestion() %>"</em>
                        </div>
                    <% } %>

                    <div class="mb-3">
                        <label class="form-label fw-bold small">Explanation &amp; Identifying Details *</label>
                        <textarea name="claimMessage" rows="3" class="form-control" placeholder="Explain why this item belongs to you, when you lost it, or answer the security question..." required></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small">Proof of Ownership / Distinguishing Marks (Optional)</label>
                        <input type="text" name="claimProof" class="form-control" placeholder="Serial numbers, wallpaper details, scratches, bill/invoice info...">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small">Your Direct Contact Phone Number *</label>
                        <input type="text" name="claimantContact" class="form-control" value="<%= currentUser.getPhone() %>" required>
                    </div>
                </div>

                <div class="modal-footer border-top bg-light rounded-bottom-4">
                    <button type="button" class="btn btn-light rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Submit to Reporter</button>
                </div>
            </form>
        </div>
    </div>
</div>
<% } %>

<jsp:include page="/WEB-INF/views/footer.jsp" />
