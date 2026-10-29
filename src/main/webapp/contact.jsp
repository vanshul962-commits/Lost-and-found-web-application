<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.milgaya.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
%>
<jsp:include page="/WEB-INF/views/header.jsp">
    <jsp:param name="pageTitle" value="Help & Contact - Milgaya" />
</jsp:include>

<div class="py-5" style="background: linear-gradient(135deg, #1e293b, #0f172a); color: white;">
    <div class="container text-center py-3">
        <h1 class="fw-bold mb-2">Need Help or Have Inquiries?</h1>
        <p class="lead opacity-90 max-w-lg mx-auto">
            Our team is committed to assisting you in every step of the reunion process.
        </p>
    </div>
</div>

<div class="container py-5">
    <div class="row g-5 justify-content-center">
        
        <div class="col-lg-5 col-md-6">
            <h3 class="fw-bold mb-3">Get in Touch</h3>
            <p class="text-secondary mb-4">
                Have questions about recovering an item, need to report suspicious claims, or have feature suggestions? We'd love to hear from you.
            </p>

            <div class="d-flex flex-column gap-3 mb-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center" style="width: 46px; height: 46px;">
                        <i class="fa-solid fa-envelope"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Support Email</div>
                        <div class="fw-bold">support@milgaya.com</div>
                    </div>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-success-subtle text-success d-flex align-items-center justify-content-center" style="width: 46px; height: 46px;">
                        <i class="fa-solid fa-phone"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Community Helpline</div>
                        <div class="fw-bold">+91 1800-MILGAYA (Toll Free)</div>
                    </div>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle bg-warning-subtle text-warning d-flex align-items-center justify-content-center" style="width: 46px; height: 46px;">
                        <i class="fa-solid fa-clock"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Operating Hours</div>
                        <div class="fw-bold">24 / 7 Community Support</div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 p-4 bg-light">
                <h6 class="fw-bold mb-1"><i class="fa-solid fa-triangle-exclamation text-danger me-2"></i> Report Fraud or Abuse</h6>
                <p class="text-muted small mb-0">
                    If someone is attempting extortion or demanding unreasonable ransoms for returning items, please notify us immediately with the listing number.
                </p>
            </div>
        </div>

        <div class="col-lg-6 col-md-6">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">
                <h4 class="fw-bold mb-3">Send Us a Message</h4>
                
                <form action="<%= request.getContextPath() %>/contact" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Your Name</label>
                        <input type="text" name="name" class="form-control" value="<%= currentUser != null ? currentUser.getFullName() : "" %>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small">Your Email</label>
                        <input type="email" name="email" class="form-control" value="<%= currentUser != null ? currentUser.getEmail() : "" %>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small">Subject</label>
                        <select name="subject" class="form-select" required>
                            <option value="General Inquiry">General Inquiry</option>
                            <option value="Report False Claim">Report False / Suspicious Claim</option>
                            <option value="Item Retrieval Assistance">Item Retrieval Assistance</option>
                            <option value="Technical Bug">Technical Bug / Feedback</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold small">Message</label>
                        <textarea name="message" rows="4" class="form-control" placeholder="Describe your question or issue in detail..." required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg rounded-pill fw-bold w-100 shadow-sm py-2">
                        <i class="fa-solid fa-paper-plane me-2"></i> Send Message
                    </button>
                </form>
            </div>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
