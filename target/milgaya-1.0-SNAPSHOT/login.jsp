<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String enteredEmail = (String) request.getAttribute("enteredEmail");
    String redirect = request.getParameter("redirect");
%>
<jsp:include page="/WEB-INF/views/header.jsp">
    <jsp:param name="pageTitle" value="Sign In - Milgaya" />
</jsp:include>

<div class="container py-5 my-auto">
    <div class="row justify-content-center">
        <div class="col-lg-5 col-md-7">
            
            <div class="card border-0 shadow rounded-4 overflow-hidden">
                <div class="p-4 text-center bg-white border-bottom">
                    <div class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px; font-size: 1.5rem;">
                        <i class="fa-solid fa-lock"></i>
                    </div>
                    <h3 class="fw-bold mb-1">Welcome Back</h3>
                    <p class="text-muted small mb-0">Sign in to report lost or found items and manage your listings</p>
                </div>

                <div class="p-4 p-md-5 bg-white">
                    <% if (errorMessage != null) { %>
                        <div class="alert alert-danger rounded-3 small mb-4">
                            <i class="fa-solid fa-circle-exclamation me-1"></i> <%= errorMessage %>
                        </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/login" method="post">
                        <% if (redirect != null && !redirect.isEmpty()) { %>
                            <input type="hidden" name="redirect" value="<%= redirect %>">
                        <% } %>

                        <div class="mb-3">
                            <label class="form-label fw-bold small">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-envelope"></i></span>
                                <input type="email" id="loginEmail" name="email" class="form-control border-start-0" placeholder="name@example.com" value="<%= enteredEmail != null ? enteredEmail : "" %>" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label fw-bold small mb-0">Password</label>
                            </div>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted border-end-0"><i class="fa-solid fa-key"></i></span>
                                <input type="password" id="loginPassword" name="password" class="form-control border-start-0" placeholder="••••••••" required>
                            </div>
                        </div>

                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill fw-bold py-2 shadow-sm">
                                Sign In <i class="fa-solid fa-arrow-right ms-2"></i>
                            </button>
                        </div>
                    </form>

                    <!-- Quick Demo Credentials Fill -->
                    <div class="p-3 bg-light rounded-4 border my-4">
                        <div class="small fw-bold text-muted text-uppercase mb-2 text-center">
                            <i class="fa-solid fa-bolt text-warning me-1"></i> Quick Demo Login
                        </div>
                        <div class="d-flex justify-content-center gap-2">
                            <button type="button" class="btn btn-outline-dark btn-sm rounded-pill px-3" onclick="fillDemoCredentials('admin')">
                                <i class="fa-solid fa-user-shield me-1"></i> Admin
                            </button>
                            <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3" onclick="fillDemoCredentials('user')">
                                <i class="fa-solid fa-user me-1"></i> User
                            </button>
                        </div>
                        <div class="text-center text-muted mt-2" style="font-size: 0.75rem;">
                            Clicking pre-fills credentials (Password: <code>admin123</code> / <code>user123</code>)
                        </div>
                    </div>

                    <div class="text-center small text-muted">
                        Don't have an account? 
                        <a href="<%= request.getContextPath() %>/register" class="fw-bold text-primary text-decoration-none">Create Account</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
