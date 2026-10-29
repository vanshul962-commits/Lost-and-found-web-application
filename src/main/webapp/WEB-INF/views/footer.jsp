<%@ page contentType="text/html;charset=UTF-8" language="java" %>
</main>

<!-- Footer -->
<footer>
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <h5 class="text-white fw-bold d-flex align-items-center gap-2 mb-3">
                    <i class="fa-solid fa-compass-drafting text-primary"></i>
                    <span>Milgaya</span>
                </h5>
                <p class="small text-secondary">
                    Milgaya is a community-driven Lost and Found portal dedicated to reuniting lost belongings with their rightful owners safely, swiftly, and transparently.
                </p>
                <div class="d-flex gap-3 mt-3">
                    <a href="#" class="btn btn-outline-secondary btn-sm rounded-circle"><i class="fa-brands fa-x-twitter"></i></a>
                    <a href="#" class="btn btn-outline-secondary btn-sm rounded-circle"><i class="fa-brands fa-facebook-f"></i></a>
                    <a href="#" class="btn btn-outline-secondary btn-sm rounded-circle"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#" class="btn btn-outline-secondary btn-sm rounded-circle"><i class="fa-brands fa-linkedin-in"></i></a>
                </div>
            </div>

            <div class="col-lg-2 col-md-6">
                <h6 class="text-white fw-bold mb-3">Quick Links</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="<%= request.getContextPath() %>/home"><i class="fa-solid fa-angle-right me-1 text-primary"></i> Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/items?type=LOST"><i class="fa-solid fa-angle-right me-1 text-primary"></i> Lost Items</a></li>
                    <li><a href="<%= request.getContextPath() %>/items?type=FOUND"><i class="fa-solid fa-angle-right me-1 text-primary"></i> Found Items</a></li>
                    <li><a href="<%= request.getContextPath() %>/report-lost"><i class="fa-solid fa-angle-right me-1 text-primary"></i> Report Lost</a></li>
                    <li><a href="<%= request.getContextPath() %>/report-found"><i class="fa-solid fa-angle-right me-1 text-primary"></i> Report Found</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-white fw-bold mb-3">Safety & Trust</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="<%= request.getContextPath() %>/about#safety"><i class="fa-solid fa-shield-halved me-1 text-success"></i> Safety Guidelines</a></li>
                    <li><a href="<%= request.getContextPath() %>/about#how-it-works"><i class="fa-solid fa-circle-question me-1 text-info"></i> How Proof Verification Works</a></li>
                    <li><a href="<%= request.getContextPath() %>/about#faq"><i class="fa-solid fa-comments me-1 text-warning"></i> Frequently Asked Questions</a></li>
                    <li><a href="<%= request.getContextPath() %>/contact"><i class="fa-solid fa-envelope me-1 text-danger"></i> Report Inappropriate Item</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-white fw-bold mb-3">Project & Technology</h6>
                <p class="small text-secondary mb-2">
                    Built with <strong>Java / Jakarta EE (NetBeans)</strong> &amp; clean MVC architecture. Zero-setup H2 database with automatic schema migrations.
                </p>
                <div class="d-flex align-items-center gap-2 mt-2">
                    <span class="badge bg-dark border text-light"><i class="fa-brands fa-java text-warning me-1"></i> Java 11/17/21/26</span>
                    <span class="badge bg-dark border text-light">Apache Tomcat 10</span>
                </div>
            </div>
        </div>

        <div class="footer-bottom text-center text-secondary">
            <p class="mb-0">&copy; <%= java.time.Year.now().getValue() %> <strong>Milgaya Platform</strong>. All Rights Reserved. Pair programmed for Apache NetBeans.</p>
        </div>
    </div>
</footer>

<!-- Bootstrap 5.3 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Milgaya Custom JS -->
<script src="<%= request.getContextPath() %>/js/app.js"></script>

</body>
</html>
