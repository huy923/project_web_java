<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.PermissionUtil" %>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="../css/modern-ui.css">
<link rel="stylesheet" href="../css/page-template.css">
<link rel="stylesheet" href="../css/theme.css">
<div class="sidebar">
        <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="mb-0"><i class="bi bi-building"></i> Quản lý khách sạn</h5>
                <button class="theme-toggle" title="Chuyển chế độ tối"><i class="bi bi-moon-fill"></i><span
                                class="d-none d-lg-inline">Tối</span></button>
        </div>
        <!-- check admin -->
        <% boolean isAdmin = PermissionUtil.isAdmin(session); %>
        
        <div class="sidebar-section">
                <h6 class="sidebar-section-title">Chính</h6>
                <ul class="sidebar-menu">
                        <% if (PermissionUtil.hasPermission(session, "dashboard.view")) { %>
                                <li><a href="<%= request.getContextPath() %>/dashboard" class="<%= request.getRequestURI().contains("/dashboard") ? "active" : "" %>"><i class="bi bi-speedometer2"></i> Bảng điều khiển</a></li>
                        <% } %>
                </ul>
        </div>
        
        <% if (!isAdmin) { %>
                <div class="sidebar-section">
                        <h6 class="sidebar-section-title">Thu ngân</h6>
                        <ul class="sidebar-menu">
                                <% if (PermissionUtil.canViewModule(session, "bookings")) { %>
                                        <li><a href="<%= request.getContextPath() %>/bookings" class="<%= request.getRequestURI().contains("/bookings") ? "active" : "" %>"><i class="bi bi-calendar-check"></i> Đặt phòng</a></li>
                                <% } %>
                                <% if (PermissionUtil.canViewModule(session, "guests")) { %>
                                        <li><a href="<%= request.getContextPath() %>/guests" class="<%= request.getRequestURI().contains("/guests") ? "active" : "" %>"><i class="bi bi-people"></i> Khách</a></li>
                                <% } %>
                                <% if (PermissionUtil.hasPermission(session, "bookings.checkout")) { %>
                                        <li><a href="<%= request.getContextPath() %>/check-out" class="<%= request.getRequestURI().contains("/check-out") ? "active" : "" %>"><i class="bi bi-door-closed"></i> Trả phòng</a></li>
                                <% } %>
                                <% if (PermissionUtil.canViewModule(session, "payments")) { %>
                                        <li><a href="<%= request.getContextPath() %>/payments" class="<%= request.getRequestURI().contains("/payments") ? "active" : "" %>"><i class="bi bi-credit-card"></i> Thanh toán</a></li>
                                <% } %>
                                <% if (PermissionUtil.hasPermission(session, "payments.view")) { %>
                                        <li><a href="<%= request.getContextPath() %>/invoices" class="<%= request.getRequestURI().contains("/invoices") ? "active" : "" %>"><i class="bi bi-receipt"></i> Hóa đơn</a></li>
                                <% } %>
                        </ul>
                </div>
        <% } else { %>
                <div class="sidebar-section">
                        <h6 class="sidebar-section-title">Vận hành</h6>
                        <ul class="sidebar-menu">
                                <% if (PermissionUtil.canViewModule(session, "rooms")) { %>
                                        <li><a href="<%= request.getContextPath() %>/rooms" class="<%= request.getRequestURI().contains("/rooms") ? "active" : "" %>"><i class="bi bi-door-open"></i> Phòng</a></li>
                                <% } %>
                                <% if (PermissionUtil.canViewModule(session, "bookings")) { %>
                                        <li><a href="<%= request.getContextPath() %>/bookings" class="<%= request.getRequestURI().contains("/bookings") ? "active" : "" %>"><i class="bi bi-calendar-check"></i> Đặt phòng</a></li>
                                <% } %>
                                <% if (PermissionUtil.canViewModule(session, "guests")) { %>
                                        <li><a href="<%= request.getContextPath() %>/guests" class="<%= request.getRequestURI().contains("/guests") ? "active" : "" %>"><i class="bi bi-people"></i> Khách</a></li>
                                <% } %>
                                <% if (PermissionUtil.hasPermission(session, "bookings.checkin")) { %>
                                        <li><a href="<%= request.getContextPath() %>/check-in" class="<%= request.getRequestURI().contains("/check-in") ? "active" : "" %>"><i class="bi bi-door-open"></i> Nhận phòng</a></li>
                                <% } %>
                                <% if (PermissionUtil.hasPermission(session, "bookings.checkout")) { %>
                                        <li><a href="<%= request.getContextPath() %>/check-out" class="<%= request.getRequestURI().contains("/check-out") ? "active" : "" %>"><i class="bi bi-door-closed"></i> Trả phòng</a></li>
                                <% } %>
                        </ul>
                </div>
                
                <div class="sidebar-section">
                        <h6 class="sidebar-section-title">Tài chính</h6>
                        <ul class="sidebar-menu">
                                <% if (PermissionUtil.canViewModule(session, "payments")) { %>
                                        <li><a href="<%= request.getContextPath() %>/payments" class="<%= request.getRequestURI().contains("/payments") ? "active" : "" %>"><i class="bi bi-credit-card"></i> Thanh toán</a></li>
                                <% } %>
                                <% if (PermissionUtil.hasPermission(session, "payments.view") || PermissionUtil.hasPermission(session, "reports.view")) { %>
                                        <li><a href="<%= request.getContextPath() %>/invoices" class="<%= request.getRequestURI().contains("/invoices") ? "active" : "" %>"><i class="bi bi-receipt"></i> Hóa đơn</a></li>
                                <% } %>
                                <% if (PermissionUtil.canViewModule(session, "reports")) { %>
                                        <li><a href="<%= request.getContextPath() %>/reports" class="<%= request.getRequestURI().contains("/reports") ? "active" : "" %>"><i class="bi bi-graph-up"></i> Báo cáo</a></li>
                                <% } %>
                        </ul>
                </div>
        <% } %>

        <div class="sidebar-section">
                <h6 class="sidebar-section-title">Quản trị</h6>
                <ul class="sidebar-menu">
                        <% if (PermissionUtil.canViewModule(session, "services")) { %>
                                <li><a href="<%= request.getContextPath() %>/services" class="<%= request.getRequestURI().contains("/services") ? "active" : "" %>"><i class="bi bi-cup-straw"></i> Dịch vụ</a></li>
                        <% } %>
                        <% if (PermissionUtil.canViewModule(session, "maintenance")) { %>
                                <li><a href="<%= request.getContextPath() %>/maintenance" class="<%= request.getRequestURI().contains("/maintenance") ? "active" : "" %>"><i class="bi bi-tools"></i> Bảo trì</a></li>
                        <% } %>
                        <% if (PermissionUtil.canViewModule(session, "inventory")) { %>
                                <li><a href="<%= request.getContextPath() %>/inventory" class="<%= request.getRequestURI().contains("/inventory") ? "active" : "" %>"><i class="bi bi-box2"></i> Kho</a></li>
                        <% } %>
                        <% if (PermissionUtil.canViewModule(session, "users")) { %>
                                <li><a href="<%= request.getContextPath() %>/staff" class="<%= request.getRequestURI().contains("/staff") ? "active" : "" %>"><i class="bi bi-person-badge"></i> Nhân viên</a></li>
                        <% } %>
                </ul>
        </div>

        <div class="sidebar-section">
                <h6 class="sidebar-section-title">Khách hàng</h6>
                <ul class="sidebar-menu">
                        <% if (PermissionUtil.canViewModule(session, "reviews")) { %>
                                <li><a href="<%= request.getContextPath() %>/reviews" class="<%= request.getRequestURI().contains("/reviews") ? "active" : "" %>"><i class="bi bi-star"></i> Đánh giá</a></li>
                        <% } %>
                        <% if (PermissionUtil.hasPermission(session, "dashboard.view")) { %>
                                <li><a href="<%= request.getContextPath() %>/feedback" class="<%= request.getRequestURI().contains("/feedback") ? "active" : "" %>"><i class="bi bi-chat-dots"></i> Phản hồi</a></li>
                                <li><a href="<%= request.getContextPath() %>/complaints" class="<%= request.getRequestURI().contains("/complaints") ? "active" : "" %>"><i class="bi bi-exclamation-circle"></i> Khiếu nại</a></li>
                        <% } %>
                </ul>
        </div>

        <div class="sidebar-section">
                <h6 class="sidebar-section-title">Cài đặt</h6>
                <ul class="sidebar-menu">
                        <% if (PermissionUtil.hasPermission(session, "settings.view")) { %>
                                <li><a href="<%= request.getContextPath() %>/settings" class="<%= request.getRequestURI().contains("/settings") ? "active" : "" %>"><i class="bi bi-gear"></i> Cài đặt</a></li>
                        <% } %>
                        <% if (PermissionUtil.canViewModule(session, "users")) { %>
                                <li><a href="<%= request.getContextPath() %>/users" class="<%= request.getRequestURI().contains("/users") ? "active" : "" %>"><i class="bi bi-person-circle"></i> Người dùng</a></li>
                        <% } %>
                        <% if (PermissionUtil.hasPermission(session, "settings.system")) { %>
                                <li><a href="<%= request.getContextPath() %>/backup" class="<%= request.getRequestURI().contains("/backup") ? "active" : "" %>"><i class="bi bi-cloud-download"></i> Sao lưu</a></li>
                        <% } %>
                </ul>
        </div>
</div>