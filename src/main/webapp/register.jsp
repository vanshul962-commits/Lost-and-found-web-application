<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String fullName = (String) request.getAttribute("fullName");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    String city = (String) request.getAttribute("city");
%>
<jsp:include page="/WEB-INF/views/header.jsp">
    <jsp:param name="pageTitle" value="Create Account - Milgaya" />
</jsp:include>

<div class="container py-5 my-auto">
    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            
            <div class="card border-0 shadow rounded-4 overflow-hidden">
                <div class="p-4 text-center bg-white border-bottom">
                    <div class="rounded-circle bg-success-subtle text-success d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px; font-size: 1.5rem;">
                        <i class="fa-solid fa-user-plus"></i>
                    </div>
                    <h3 class="fw-bold mb-1">Join the Milgaya Community</h3>
                    <p class="text-muted small mb-0">Help reunite lost belongings with their owners</p>
                </div>

                <div class="p-4 p-md-5 bg-white">
                    <% if (errorMessage != null) { %>
                        <div class="alert alert-danger rounded-3 small mb-4">
                            <i class="fa-solid fa-circle-exclamation me-1"></i> <%= errorMessage %>
                        </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/register" method="post">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold small">Full Name <span class="text-danger">*</span></label>
                            <input type="text" name="fullName" class="form-control" placeholder="e.g. Siddharth Malhotra" value="<%= fullName != null ? fullName : "" %>" required>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Email Address <span class="text-danger">*</span></label>
                                <input type="email" name="email" class="form-control" placeholder="sid@example.com" value="<%= email != null ? email : "" %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Phone Number <span class="text-danger">*</span></label>
                                <input type="text" name="phone" class="form-control" placeholder="+91 9876543210" value="<%= phone != null ? phone : "" %>" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small">Your City <span class="text-danger">*</span></label>
                            <input type="text" name="city" class="form-control" placeholder="e.g. New Delhi, Bengaluru, Mumbai" value="<%= city != null ? city : "" %>" required>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Password <span class="text-danger">*</span></label>
                                <input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Confirm Password <span class="text-danger">*</span></label>
                                <input type="password" name="confirmPassword" class="form-control" placeholder="Repeat password" required>
                            </div>
                        </div>

                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill fw-bold py-2 shadow-sm">
                                Register &amp; Get Started
                            </button>
                        </div>
                    </form>

                    <div class="text-center small text-muted mt-4">
                        Already have an account? 
                        <a href="<%= request.getContextPath() %>/login" class="fw-bold text-primary text-decoration-none">Sign In here</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
