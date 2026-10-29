<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.milgaya.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError = (String) session.getAttribute("flashError");
    String flashInfo = (String) session.getAttribute("flashInfo");

    // Remove flash messages from session after reading once
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError != null) session.removeAttribute("flashError");
    if (flashInfo != null) session.removeAttribute("flashInfo");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle != null ? param.pageTitle : "Milgaya - Lost and Found Platform"}</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- FontAwesome 6 Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Milgaya Custom CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/home">
            <i class="fa-solid fa-compass-drafting text-primary"></i>
            <span>Milgaya</span>
            <span class="brand-badge">Lost &amp; Found</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent"
                aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3">
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/home">
                        <i class="fa-solid fa-house me-1"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/items">
                        <i class="fa-solid fa-list-ul me-1"></i> Browse Items
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/about">
                        <i class="fa-solid fa-circle-info me-1"></i> About
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/contact">
                        <i class="fa-solid fa-headset me-1"></i> Help & Contact
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-2">
                <a href="<%= request.getContextPath() %>/report-lost" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-bold">
                    <i class="fa-solid fa-bullhorn me-1"></i> Lost Something?
                </a>
                <a href="<%= request.getContextPath() %>/report-found" class="btn btn-success btn-sm rounded-pill px-3 fw-bold">
                    <i class="fa-solid fa-hand-holding-heart me-1"></i> Found Something?
                </a>

                <% if (currentUser != null) { %>
                    <div class="dropdown ms-2">
                        <button class="btn btn-light rounded-pill dropdown-toggle d-flex align-items-center gap-2 border px-3 py-1" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <span class="rounded-circle bg-primary text-white d-inline-flex justify-content-center align-items-center" style="width: 28px; height: 28px; font-size: 0.8rem;">
                                <%= currentUser.getFullName().substring(0, 1).toUpperCase() %>
                            </span>
                            <span class="fw-semibold text-truncate" style="max-width: 110px;"><%= currentUser.getFullName() %></span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2 p-2" style="border-radius: 12px; min-width: 220px;">
                            <li class="px-3 py-2 border-bottom">
                                <div class="fw-bold"><%= currentUser.getFullName() %></div>
                                <div class="text-muted small text-truncate"><%= currentUser.getEmail() %></div>
                                <span class="badge bg-primary-subtle text-primary mt-1"><%= currentUser.getRole() %></span>
                            </li>
                            <li><a class="dropdown-item py-2" href="<%= request.getContextPath() %>/dashboard"><i class="fa-solid fa-gauge-high me-2 text-primary"></i> My Dashboard</a></li>
                            <li><a class="dropdown-item py-2" href="<%= request.getContextPath() %>/report-lost"><i class="fa-solid fa-circle-exclamation me-2 text-danger"></i> Report Lost Item</a></li>
                            <li><a class="dropdown-item py-2" href="<%= request.getContextPath() %>/report-found"><i class="fa-solid fa-circle-check me-2 text-success"></i> Report Found Item</a></li>
                            <% if (currentUser.isAdmin()) { %>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2 text-primary fw-bold" href="<%= request.getContextPath() %>/admin"><i class="fa-solid fa-shield-halved me-2"></i> Admin Panel</a></li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item py-2 text-danger" href="<%= request.getContextPath() %>/logout"><i class="fa-solid fa-right-from-bracket me-2"></i> Sign Out</a></li>
                        </ul>
                    </div>
                <% } else { %>
                    <div class="d-flex align-items-center gap-2 ms-2">
                        <a href="<%= request.getContextPath() %>/login" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-semibold">
                            <i class="fa-solid fa-right-to-bracket me-1"></i> Sign In
                        </a>
                        <a href="<%= request.getContextPath() %>/register" class="btn btn-primary btn-sm rounded-pill px-3 fw-semibold">
                            Register
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<!-- Global Toast / Flash Messages -->
<div class="container mt-3">
    <% if (flashSuccess != null) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 d-flex align-items-center gap-2" role="alert">
            <i class="fa-solid fa-circle-check fa-lg"></i>
            <div><%= flashSuccess %></div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
    <% if (flashError != null) { %>
        <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 d-flex align-items-center gap-2" role="alert">
            <i class="fa-solid fa-triangle-exclamation fa-lg"></i>
            <div><%= flashError %></div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
    <% if (flashInfo != null) { %>
        <div class="alert alert-info alert-dismissible fade show shadow-sm border-0 d-flex align-items-center gap-2" role="alert">
            <i class="fa-solid fa-circle-info fa-lg"></i>
            <div><%= flashInfo %></div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
</div>

<main>
