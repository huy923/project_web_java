<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Management System - Quản lý thanh toán</title>
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet"> -->
    <link href="/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="/webjars/bootstrap-icons/1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            min-height: 100vh;
        }
        
        .navbar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        
        .main-container {
            padding: 2rem 0;
        }
        
        .dashboard-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            transition: transform 0.3s ease;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        
        .btn-hotel {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-hotel:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(238, 90, 36, 0.4);
            color: white;
        }
        
        .btn-hotel-outline {
            background: transparent;
            border: 2px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-hotel-outline:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.5);
            color: white;
        }
        
        .sidebar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 1.5rem;
            height: fit-content;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .sidebar-menu li {
            margin-bottom: 0.5rem;
        }
        
        .sidebar-menu a {
            color: white;
            text-decoration: none;
            padding: 0.75rem 1rem;
            display: block;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .sidebar-menu a:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }
        
        .sidebar-menu a.active {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .status-badge {
            font-size: 0.8em;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-weight: bold;
        }
        
        .status-completed { 
            background: rgba(46, 204, 113, 0.2);
            color: #2ecc71;
        }
        
        .status-pending { 
            background: rgba(241, 196, 15, 0.2);
            color: #f1c40f;
        }
        
        .status-failed { 
            background: rgba(231, 76, 60, 0.2);
            color: #e74c3c;
        }
        
        .status-refunded { 
            background: rgba(149, 165, 166, 0.2);
            color: #95a5a6;
        }
        
        .table-dark {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            overflow: hidden;
        }
        
        .table-dark th {
            background: rgba(255, 255, 255, 0.1);
            border: none;
            font-weight: 600;
        }
        
        .table-dark td {
            border: none;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .form-control, .form-select {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }
        
        .form-control:focus, .form-select:focus {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.4);
            color: white;
            box-shadow: 0 0 0 0.2rem rgba(255, 255, 255, 0.1);
        }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }
        
        .alert {
            border: none;
            border-radius: 10px;
        }
        
        .modal-content {
            background: rgba(30, 60, 114, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .dropdown-menu {
            background: rgba(30, 60, 114, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .dropdown-item {
            color: white;
        }
        
        .dropdown-item:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }
    </style>
</head>

<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/dashboard">
                <i class="bi bi-building"></i> Hotel Management System
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text">
                    <i class="bi bi-person-circle"></i> Admin Dashboard
                </span>
            </div>
        </div>
    </nav>
    
    <div class="px-2 main-container">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-3 col-md-4 mb-4">
                <div class="sidebar">
                    <h5 class="mb-3">
                        <i class="bi bi-list-ul"></i> Menu
                    </h5>
                    <ul class="sidebar-menu">
                        <li><a href="<%= request.getContextPath() %>/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                        <li><a href="<%= request.getContextPath() %>/rooms"><i class="bi bi-door-open"></i> Room Management</a></li>
                        <li><a href="<%= request.getContextPath() %>/bookings"><i class="bi bi-calendar-check"></i> Bookings</a></li>
                        <li><a href="<%= request.getContextPath() %>/guests"><i class="bi bi-people"></i> Guests</a></li>
                        <li><a href="<%= request.getContextPath() %>/payments" class="active"><i class="bi bi-credit-card"></i> Payments</a></li>
                        <li><a href="<%= request.getContextPath() %>/reports"><i class="bi bi-graph-up"></i> Reports</a></li>
                        <li><a href="<%= request.getContextPath() %>/settings"><i class="bi bi-gear"></i> Settings</a></li>
                    </ul>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-lg-9 col-md-8">
                <!-- Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h1 class="display-6 mb-3">
                            <i class="bi bi-credit-card"></i> Quản lý thanh toán
                        </h1>
                        <p class="lead">Quản lý và theo dõi các giao dịch thanh toán của khách sạn</p>
                    </div>
                </div>

                <!-- Alert Messages -->
                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle"></i> <%= request.getAttribute("success") %>oke
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle"></i> <%= request.getAttribute("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Filter Section -->
                <div class="dashboard-card p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-funnel"></i> Bộ lọc thanh toán
                    </h5>
                    <form method="GET" class="row g-3">
                        <div class="col-md-4">
                            <select name="status" class="form-select">
                                <option value="">Tất cả trạng thái</option>
                                <option value="completed" <%= "completed".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Hoàn tất</option>
                                <option value="pending" <%= "pending".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Chờ xử lý</option>
                                <option value="failed" <%= "failed".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Thất bại</option>
                                <option value="refunded" <%= "refunded".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Hoàn tiền</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <button type="submit" class="btn-hotel">
                                <i class="bi bi-search"></i> Lọc
                            </button>
                            <a href="<%= request.getContextPath() %>/payments" class="btn-hotel-outline">
                                <i class="bi bi-x-circle"></i> Xóa bộ lọc
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Add Payment Form -->
                <div class="dashboard-card p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-plus-circle"></i> Thêm thanh toán mới
                    </h5>
                    <form method="POST" class="row g-3">
                        <input type="hidden" name="action" value="add_payment">
                        <div class="col-md-2">
                            <label class="form-label">Mã đặt phòng</label>
                            <input type="number" name="booking_id" class="form-control" placeholder="Nhập mã đặt phòng" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Số tiền</label>
                            <input type="number" name="amount" class="form-control" placeholder="Nhập số tiền" step="0.01" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Loại thanh toán</label>
                            <select name="payment_type" class="form-select" required>
                                <option value="">Chọn loại</option>
                                <option value="cash">Tiền mặt</option>
                                <option value="credit_card">Thẻ tín dụng</option>
                                <option value="debit_card">Thẻ ghi nợ</option>
                                <option value="bank_transfer">Chuyển khoản</option>
                                <option value="online">Online</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Mã giao dịch</label>
                            <input type="text" name="transaction_id" class="form-control" placeholder="Nhập mã giao dịch">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Ghi chú</label>
                            <input type="text" name="notes" class="form-control" placeholder="Nhập ghi chú">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn-hotel w-100" type="submit">
                                <i class="bi bi-plus"></i> Thêm thanh toán
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Payments Table -->
                <div class="dashboard-card p-4">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Danh sách thanh toán
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-dark table-striped">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> Mã thanh toán</th>
                                    <th><i class="bi bi-calendar-check"></i> Mã đặt phòng</th>
                                    <th><i class="bi bi-person"></i> Khách hàng</th>
                                    <th><i class="bi bi-door-open"></i> Phòng</th>
                                    <th><i class="bi bi-credit-card"></i> Loại thanh toán</th>
                                    <th><i class="bi bi-flag"></i> Trạng thái</th>
                                    <th><i class="bi bi-currency-dollar"></i> Số tiền</th>
                                    <th><i class="bi bi-clock"></i> Ngày thanh toán</th>
                                    <th><i class="bi bi-person-gear"></i> Xử lý bởi</th>
                                    <th><i class="bi bi-gear"></i> Thao tác</th>
                                </tr>
                            </thead>
                <tbody>
                    <% List<Map<String, Object>> payments = (List<Map<String, Object>>) request.getAttribute("payments");
                        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        
                        if (payments != null && !payments.isEmpty()) {
                            for (Map<String, Object> payment : payments) {
                    %>
                    <tr>
                        <td><%= payment.get("payment_id") %></td>
                        <td><%= payment.get("booking_id") %></td>
                        <td>
                            <%= payment.get("first_name") %> <%= payment.get("last_name") %><br>
                            <small class="text-muted"><%= payment.get("phone") %></small>
                        </td>
                        <td>
                            <%= payment.get("room_number") %><br>
                            <small class="text-muted"><%= payment.get("type_name") %></small>
                        </td>
                        <td>
                            <%
                                String paymentType = (String) payment.get("payment_type");
                                String typeDisplay = "";
                                if ("cash".equals(paymentType)) {
                                    typeDisplay = "Tiền mặt";
                                } else if ("credit_card".equals(paymentType)) {
                                    typeDisplay = "Thẻ tín dụng";
                                } else if ("debit_card".equals(paymentType)) {
                                    typeDisplay = "Thẻ ghi nợ";
                                } else if ("bank_transfer".equals(paymentType)) {
                                    typeDisplay = "Chuyển khoản";
                                } else if ("online".equals(paymentType)) {
                                    typeDisplay = "Online";
                                } else {
                                    typeDisplay = paymentType;
                                }
                            %>
                            <%= typeDisplay %>
                        </td>
                        <td>
                            <%
                                String status = (String) payment.get("payment_status");
                                String statusClass = "";
                                String statusDisplay = "";
                                if ("completed".equals(status)) {
                                    statusClass = "status-completed";
                                    statusDisplay = "Hoàn tất";
                                } else if ("pending".equals(status)) {
                                    statusClass = "status-pending";
                                    statusDisplay = "Chờ xử lý";
                                } else if ("failed".equals(status)) {
                                    statusClass = "status-failed";
                                    statusDisplay = "Thất bại";
                                } else if ("refunded".equals(status)) {
                                    statusClass = "status-refunded";
                                    statusDisplay = "Hoàn tiền";
                                } else {
                                    statusClass = "status-pending";
                                    statusDisplay = status;
                                }
                            %>
                            <span class="badge status-badge <%= statusClass %>"><%= statusDisplay %></span>
                        </td>
                        <td><%= currencyFormat.format(payment.get("amount")) %></td>
                        <td>
                            <%
                                java.sql.Timestamp paymentDate = (java.sql.Timestamp) payment.get("payment_date");
                                if (paymentDate != null) {
                            %>
                                <%= dateFormat.format(paymentDate) %>
                            <% } else { %>
                                -
                            <% } %>
                        </td>
                        <td>
                            <%
                                String processedByName = (String) payment.get("processed_by_name");
                                if (processedByName != null) {
                            %>
                                <%= processedByName %>
                            <% } else { %>
                                -
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group" role="group">
                                <button class="btn btn-sm btn-hotel-outline" onclick="showPaymentDetails(<%= payment.get("payment_id") %>)">
                                    <i class="bi bi-eye"></i> Chi tiết
                                </button>
                                <% if (!"completed".equals(status) && !"refunded".equals(status)) { %>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-hotel-outline dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                            <i class="bi bi-pencil"></i> Cập nhật
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#" onclick="updateStatus(<%= payment.get("payment_id") %>, 'completed')">
                                                <i class="bi bi-check-circle text-success"></i> Hoàn tất
                                            </a></li>
                                            <li><a class="dropdown-item" href="#" onclick="updateStatus(<%= payment.get("payment_id") %>, 'failed')">
                                                <i class="bi bi-x-circle text-danger"></i> Thất bại
                                            </a></li>
                                            <li><a class="dropdown-item" href="#" onclick="updateStatus(<%= payment.get("payment_id") %>, 'refunded')">
                                                <i class="bi bi-arrow-clockwise text-warning"></i> Hoàn tiền
                                            </a></li>
                                        </ul>
                                    </div>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                            <tr>
                                <td colspan="10" class="text-center py-4">
                                    <i class="bi bi-inbox display-4 text-muted"></i>
                                    <p class="text-muted mt-2">Không có dữ liệu thanh toán</p>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

    <!-- Payment Details Modal -->
    <div class="modal fade" id="paymentDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-credit-card"></i> Chi tiết thanh toán
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="paymentDetailsContent">
                    <!-- Content will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hotel-outline" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden form for status updates -->
    <form id="statusUpdateForm" method="POST" style="display: none;">
        <input type="hidden" name="action" value="update_status">
        <input type="hidden" name="payment_id" id="updatePaymentId">
        <input type="hidden" name="new_status" id="updateNewStatus">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showPaymentDetails(paymentId) {
            // This would typically make an AJAX call to get payment details
            // For now, we'll show a simple message
            document.getElementById('paymentDetailsContent').innerHTML = 
                '<p>Chi tiết thanh toán #' + paymentId + '</p><p>Chức năng này sẽ được phát triển thêm.</p>';
            
            var modal = new bootstrap.Modal(document.getElementById('paymentDetailsModal'));
            modal.show();
        }

        function updateStatus(paymentId, newStatus) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái thanh toán này?')) {
                document.getElementById('updatePaymentId').value = paymentId;
                document.getElementById('updateNewStatus').value = newStatus;
                document.getElementById('statusUpdateForm').submit();
            }
        }
    </script>
</body>

</html>