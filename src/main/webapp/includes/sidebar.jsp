<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <link rel="stylesheet" href="../css/theme.css">
    <link rel="stylesheet" href="../css/modern-ui.css">
    <link rel="stylesheet" href="../css/page-template.css">
    <link rel="stylesheet" href="style.css">
<div class="sidebar">
        <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="mb-0"><i class="bi bi-building"></i> Hotel Manager</h5><button class="theme-toggle"
                        title="Toggle dark mode"><i class="bi bi-moon-fill"></i><span
                                class="d-none d-lg-inline">Dark</span></button>
        </div>
        <div class="sidebar-section">
                <h6 class="sidebar-section-title">Main</h6>
                <ul class="sidebar-menu">
                        <li><a href="<%= request.getContextPath() %>/dashboard"
                                        class="<%= request.getRequestURI().contains(" dashboard") ? "active" : ""
                                        %>"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                </ul>
        </div>
        <div class="sidebar-section">
          
                <h6 class="sidebar-section-title">Operations</h6>
                <ul class="sidebar-menu">
                        <li><a href="<%= request.getContextPath() %>/rooms"
                                        class="<%= request.getRequestURI().contains(" rooms") ? "active" : "" %>"><i
                                                class="bi bi-door-open"></i> Rooms</a></li>
                        <li><a href="<%= request.getContextPath() %>/bookings"
                                        class="<%= request.getRequestURI().contains(" bookings") ? "active" : "" %>"><i
                                                class="bi bi-calendar-check"></i> Bookings</a></li>
                        <li><a href="<%= request.getContextPath() %>/guests"
                                        class="<%= request.getRequestURI().contains(" guests") ? "active" : "" %>"><i
                                                class="bi bi-people"></i> Guests</a></li>
                        <li><a href="<%= request.getContextPath() %>/check-in"
                                        class="<%= request.getRequestURI().contains(" check-in") ? "active" : "" %>"><i
                                                class="bi bi-door-open"></i> Check-in</a></li>
                        <li><a href="<%= request.getContextPath() %>/check-out"
                                        class="<%= request.getRequestURI().contains(" check-out") ? "active" : ""
                                        %>"><i class="bi bi-door-closed"></i> Check-out</a></li>
                </ul>
        </div>
        <div class="sidebar-section">
                <h6 class="sidebar-section-title">Finance</h6>
                <ul class="sidebar-menu">
                        <li><a href="<%= request.getContextPath() %>/payments"
                                        class="<%= request.getRequestURI().contains(" payments") ? "active" : "" %>"><i
                                                class="bi bi-credit-card"></i> Payments</a></li>
                        <li><a href="<%= request.getContextPath() %>/invoices"
                                        class="<%= request.getRequestURI().contains(" invoices") ? "active" : "" %>"><i
                                                class="bi bi-receipt"></i> Invoices</a></li>
                        <li><a href="<%= request.getContextPath() %>/reports"
                                        class="<%= request.getRequestURI().contains(" reports") ? "active" : "" %>"><i
                                                class="bi bi-graph-up"></i> Reports</a></li>
                </ul>
        </div>
        <div class="sidebar-section">
                <h6 class="sidebar-section-title">Management</h6>
                <ul class="sidebar-menu">
                        <li><a href="<%= request.getContextPath() %>/services"
                                        class="<%= request.getRequestURI().contains(" services") ? "active" : "" %>"><i
                                                class="bi bi-cup-straw"></i> Services</a></li>
                        <li><a href="<%= request.getContextPath() %>/maintenance"
                                        class="<%= request.getRequestURI().contains(" maintenance") ? "active" : ""
                                        %>"><i class="bi bi-tools"></i> Maintenance</a></li>
                        <li><a href="<%= request.getContextPath() %>/inventory"
                                        class="<%= request.getRequestURI().contains(" inventory") ? "active" : ""
                                        %>"><i class="bi bi-box2"></i> Inventory</a></li>
                        <li><a href="<%= request.getContextPath() %>/staff"
                                        class="<%= request.getRequestURI().contains(" staff") ? "active" : "" %>"><i
                                                class="bi bi-person-badge"></i> Staff</a></li>
                </ul>
        </div>
        <div class="sidebar-section">
                <h6 class="sidebar-section-title">Customer</h6>
                <ul class="sidebar-menu">
                        <li><a href="<%= request.getContextPath() %>/reviews"
                                        class="<%= request.getRequestURI().contains(" reviews") ? "active" : "" %>"><i
                                                class="bi bi-star"></i> Reviews</a></li>
                        <li><a href="<%= request.getContextPath() %>/feedback"
                                        class="<%= request.getRequestURI().contains(" feedback") ? "active" : "" %>"><i
                                                class="bi bi-chat-dots"></i> Feedback</a></li>
                        <li><a href="<%= request.getContextPath() %>/complaints"
                                        class="<%= request.getRequestURI().contains(" complaints") ? "active" : ""
                                        %>"><i class="bi bi-exclamation-circle"></i> Complaints</a></li>
                </ul>
        </div>
        <div class="sidebar-section">
                <h6 class="sidebar-section-title">Settings</h6>
                <ul class="sidebar-menu">
                        <li><a href="<%= request.getContextPath() %>/settings"
                                        class="<%= request.getRequestURI().contains(" settings") ? "active" : "" %>"><i
                                                class="bi bi-gear"></i> Settings</a></li>
                        <li><a href="<%= request.getContextPath() %>/users"
                                        class="<%= request.getRequestURI().contains(" users") ? "active" : "" %>"><i
                                                class="bi bi-person-circle"></i> Users</a></li>
                        <li><a href="<%= request.getContextPath() %>/backup"
                                        class="<%= request.getRequestURI().contains(" backup") ? "active" : "" %>"><i
                                                class="bi bi-cloud-download"></i> Backup</a></li>
                </ul>
        </div>
</div>
