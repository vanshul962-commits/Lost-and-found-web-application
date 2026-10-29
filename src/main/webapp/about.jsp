<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/header.jsp">
    <jsp:param name="pageTitle" value="About Us & Safety Guidelines - Milgaya" />
</jsp:include>

<!-- Banner -->
<div class="py-5" style="background: linear-gradient(135deg, #312e81, #4338ca); color: white;">
    <div class="container text-center py-3">
        <h1 class="fw-bold mb-2">About Milgaya</h1>
        <p class="lead opacity-90 max-w-lg mx-auto">
            A community-first platform bringing honesty, technology, and empathy together to return lost valuables.
        </p>
    </div>
</div>

<div class="container py-5">
    <div class="row g-5 align-items-center mb-5">
        <div class="col-lg-6">
            <span class="text-primary fw-bold text-uppercase small tracking-wide">Our Mission</span>
            <h2 class="fw-bold mb-3">Reconnecting People With What Matters Most</h2>
            <p class="text-secondary leading-relaxed">
                Losing an essential item—whether it is a smartphone with cherished memories, a wallet with identification documents, a set of vehicle keys, or a beloved pet—causes immense anxiety and helplessness.
            </p>
            <p class="text-secondary leading-relaxed">
                <strong>Milgaya</strong> was conceptualized to eliminate this friction. We provide a centralized, secure, and user-friendly portal where anyone who loses an item can broadcast details, and finders can report what they found safely without compromising their personal security.
            </p>
        </div>
        <div class="col-lg-6">
            <div class="card border-0 shadow rounded-4 p-4 bg-light">
                <div class="row g-3">
                    <div class="col-6">
                        <div class="p-3 bg-white rounded-3 shadow-sm text-center">
                            <i class="fa-solid fa-lock fa-2x text-primary mb-2"></i>
                            <h6 class="fw-bold mb-1">Ownership Proof</h6>
                            <p class="text-muted small mb-0">Security questions protect items from false claims.</p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="p-3 bg-white rounded-3 shadow-sm text-center">
                            <i class="fa-solid fa-user-shield fa-2x text-success mb-2"></i>
                            <h6 class="fw-bold mb-1">Privacy Masking</h6>
                            <p class="text-muted small mb-0">Mask phone and email to avoid spam or misuse.</p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="p-3 bg-white rounded-3 shadow-sm text-center">
                            <i class="fa-solid fa-bolt fa-2x text-warning mb-2"></i>
                            <h6 class="fw-bold mb-1">Instant Match</h6>
                            <p class="text-muted small mb-0">Search by city, landmark, date, and category.</p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="p-3 bg-white rounded-3 shadow-sm text-center">
                            <i class="fa-solid fa-award fa-2x text-danger mb-2"></i>
                            <h6 class="fw-bold mb-1">Reward System</h6>
                            <p class="text-muted small mb-0">Incentivize finders with optional rewards.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Safety Guidelines -->
    <div id="safety" class="card border-0 shadow-sm rounded-4 p-4 p-md-5 mb-5 bg-white">
        <div class="d-flex align-items-center gap-3 mb-4">
            <div class="rounded-circle bg-success-subtle text-success d-flex align-items-center justify-content-center" style="width: 50px; height: 50px; font-size: 1.5rem;">
                <i class="fa-solid fa-shield-halved"></i>
            </div>
            <div>
                <h3 class="fw-bold mb-0">Handover Safety &amp; Best Practices</h3>
                <p class="text-muted small mb-0">Follow these recommendations when meeting someone to hand over or reclaim items.</p>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="p-3 border rounded-3 h-100">
                    <h6 class="fw-bold text-dark"><i class="fa-solid fa-building-columns text-primary me-2"></i> Meet in Public Places</h6>
                    <p class="text-muted small mb-0">Always arrange handovers during daylight in crowded, well-lit public spots such as metro station customer care counters, police assistance booths, or shopping mall helpdesks.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-3 border rounded-3 h-100">
                    <h6 class="fw-bold text-dark"><i class="fa-solid fa-fingerprint text-primary me-2"></i> Demand Verifiable Proof</h6>
                    <p class="text-muted small mb-0">Before handing over valuables (laptops, phones, jewelry), require the claimant to unlock the device, show a purchase invoice, or confirm distinguishing marks.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-3 border rounded-3 h-100">
                    <h6 class="fw-bold text-dark"><i class="fa-solid fa-circle-exclamation text-primary me-2"></i> Never Pay in Advance</h6>
                    <p class="text-muted small mb-0">Never wire money or courier fees upfront to strangers claiming to have your item. Verify physical possession in person first.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- FAQ Accordion -->
    <div id="faq" class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">
        <h3 class="fw-bold mb-4 text-center">Frequently Asked Questions</h3>

        <div class="accordion accordion-flush" id="faqAccordion">
            <div class="accordion-item">
                <h2 class="accordion-header" id="faq1">
                    <button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapse1">
                        Is Milgaya completely free to use?
                    </button>
                </h2>
                <div id="collapse1" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body text-secondary">
                        Yes, Milgaya is 100% free for everyone. Reporting lost or found items and connecting with owners carries zero charges.
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="faq2">
                    <button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapse2">
                        How does the Security Verification Question work?
                    </button>
                </h2>
                <div id="collapse2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body text-secondary">
                        When someone posts a found item, they can set a secret question (such as "What is on the lock screen wallpaper?" or "What initials are in the wallet?"). Anyone claiming the item must answer this question to prove they are the true owner.
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="faq3">
                    <button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapse3">
                        How can I mark my item as returned once reunited?
                    </button>
                </h2>
                <div id="collapse3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body text-secondary">
                        Go to your <strong>Dashboard</strong>, find the item under "My Lost Items" or "My Found Items", and click the green <strong>"Mark as Resolved / Reunited"</strong> button. This updates the listing status to Resolved.
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
