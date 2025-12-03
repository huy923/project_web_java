<%-- Sidebar Component --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="sidebar">
    <h5 class="mb-3">
        <i class="bi bi-list-ul"></i> Menu
    </h5>
    <ul class="sidebar-menu">
        <li><a href="<%= request.getContextPath() %>/dashboard" class="<%= request.getRequestURI().contains("dashboard") ? "active" : "" %>"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li><a href="<%= request.getContextPath() %>/rooms" class="<%= request.getRequestURI().contains("rooms") ? "active" : "" %>"><i class="bi bi-door-open"></i> Rooms</a></li>
        <li><a href="<%= request.getContextPath() %>/bookings" class="<%= request.getRequestURI().contains("bookings") ? "active" : "" %>"><i class="bi bi-calendar-check"></i> Bookings</a></li>
        <li><a href="<%= request.getContextPath() %>/guests" class="<%= request.getRequestURI().contains("guests") ? "active" : "" %>"><i class="bi bi-people"></i> Guests</a></li>
        <li><a href="<%= request.getContextPath() %>/payments" class="<%= request.getRequestURI().contains("payments") ? "active" : "" %>"><i class="bi bi-credit-card"></i> Payments</a></li>
        <li><a href="<%= request.getContextPath() %>/reports" class="<%= request.getRequestURI().contains("reports") ? "active" : "" %>"><i class="bi bi-graph-up"></i> Reports</a></li>
        <li><a href="<%= request.getContextPath() %>/maintenance" class="<%= request.getRequestURI().contains("maintenance") ? "active" : "" %>"><i class="bi bi-tools"></i> Maintenance</a></li>
        <li><a href="<%= request.getContextPath() %>/services" class="<%= request.getRequestURI().contains("services") ? "active" : "" %>"><i class="bi bi-cup-straw"></i> Services</a></li>
        <li><a href="<%= request.getContextPath() %>/inventory" class="<%= request.getRequestURI().contains("inventory") ? "active" : "" %>"><i class="bi bi-box2"></i> Inventory</a></li>
        <li><a href="<%= request.getContextPath() %>/reviews" class="<%= request.getRequestURI().contains("reviews") ? "active" : "" %>"><i class="bi bi-star"></i> Reviews</a></li>
        <li><a href="<%= request.getContextPath() %>/settings" class="<%= request.getRequestURI().contains("settings") ? "active" : "" %>"><i class="bi bi-gear"></i> Settings</a></li>
    </ul>
</div>
