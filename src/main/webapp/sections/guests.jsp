<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Management System - Quản lý khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
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
        
        .stats-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 1.5rem;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
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
    
    <div class="container main-container">
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
                        <li><a href="<%= request.getContextPath() %>/guests" class="active"><i class="bi bi-people"></i> Guests</a></li>
                        <li><a href="<%= request.getContextPath() %>/payments"><i class="bi bi-credit-card"></i> Payments</a></li>
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
                            <i class="bi bi-people"></i> Quản lý khách hàng
                        </h1>
                        <p class="lead">Quản lý thông tin khách hàng và lịch sử đặt phòng</p>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-info">
                                <% 
                                List<Map<String, Object>> guests = (List<Map<String, Object>>) request.getAttribute("guests");
                                int totalGuests = guests != null ? guests.size() : 0;
                                %>
                                <%= totalGuests %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-people"></i> Tổng khách hàng
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-success">
                                <% 
                                int activeGuests = 0;
                                if (guests != null) {
                                    for (Map<String, Object> guest : guests) {
                                        if (guest.get("booking_status") != null) {
                                            activeGuests++;
                                        }
                                    }
                                }
                                %>
                                <%= activeGuests %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-person-check"></i> Đang ở
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-warning">
                                <% 
                                int vipGuests = 0;
                                if (guests != null) {
                                    for (Map<String, Object> guest : guests) {
                                        // Simple VIP logic based on booking count
                                        if (guest.get("booking_count") != null && 
                                            Integer.parseInt(guest.get("booking_count").toString()) > 2) {
                                            vipGuests++;
                                        }
                                    }
                                }
                                %>
                                <%= vipGuests %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-star"></i> Khách VIP
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-primary">
                                <% 
                                int newGuests = 0;
                                if (guests != null) {
                                    for (Map<String, Object> guest : guests) {
                                        if (guest.get("booking_count") != null && 
                                            Integer.parseInt(guest.get("booking_count").toString()) == 1) {
                                            newGuests++;
                                        }
                                    }
                                }
                                %>
                                <%= newGuests %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-person-plus"></i> Khách mới
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add Guest Form -->
                <div class="dashboard-card p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-person-plus"></i> Thêm khách hàng mới
                    </h5>
                    <form action="<%= request.getContextPath() %>/guest-management" method="post" class="row g-3">
                        <input type="hidden" name="action" value="add">
                        <div class="col-md-3">
                            <label class="form-label">Họ tên</label>
                            <input type="text" name="firstName" class="form-control" placeholder="Nhập họ tên" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Họ</label>
                            <input type="text" name="lastName" class="form-control" placeholder="Nhập họ" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" name="phone" class="form-control" placeholder="Nhập SĐT" required>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn-hotel" type="submit">
                                <i class="bi bi-plus"></i> Thêm khách
                            </button>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" placeholder="Nhập email">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">CMND/CCCD</label>
                            <input type="text" name="idNumber" class="form-control" placeholder="Nhập CMND/CCCD" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Quốc tịch</label>
                            <input type="text" name="nationality" class="form-control" placeholder="Nhập quốc tịch" value="Việt Nam">
                        </div>
                    </form>
                </div>

                <!-- Search and Filter -->
                <div class="dashboard-card p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-search"></i> Tìm kiếm và lọc
                    </h5>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <input type="text" class="form-control" placeholder="Tìm theo tên hoặc SĐT" id="guestSearch">
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="statusFilter">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active">Đang ở</option>
                                <option value="inactive">Không có phòng</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex">
                            <button class="btn btn-hotel d-flex" onclick="filterGuests()">
                                <i class="bi bi-funnel mr-2"></i> Lọc
                            </button>
                            <button class="btn-hotel-outline d-flex" onclick="clearFilters()">
                                <i class="bi bi-x-circle pr-2"></i> Xóa bộ lọc
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Guests Table -->
                <div class="dashboard-card p-4">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Danh sách khách hàng
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-dark table-striped" id="guestsTable">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> ID</th>
                                    <th><i class="bi bi-person"></i> Họ tên</th>
                                    <th><i class="bi bi-card-text"></i> CMND/CCCD</th>
                                    <th><i class="bi bi-telephone"></i> SĐT</th>
                                    <th><i class="bi bi-envelope"></i> Email</th>
                                    <th><i class="bi bi-globe"></i> Quốc tịch</th>
                                    <th><i class="bi bi-door-open"></i> Phòng hiện tại</th>
                                    <th><i class="bi bi-flag"></i> Trạng thái</th>
                                    <th><i class="bi bi-gear"></i> Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                if (guests != null && !guests.isEmpty()) {
                                    for (Map<String, Object> guest : guests) {
                                        String guestId = String.valueOf(guest.get("guest_id"));
                                        String fullName = guest.get("first_name") + " " + guest.get("last_name");
                                        String idNumber = (String) guest.get("id_number");
                                        String phone = (String) guest.get("phone");
                                        String email = (String) guest.get("email");
                                        String nationality = (String) guest.get("nationality");
                                        String roomNumber = (String) guest.get("room_number");
                                        String bookingStatus = (String) guest.get("booking_status");
                                        
                                        String statusClass = bookingStatus != null ? "bg-success" : "bg-secondary";
                                        String statusText = bookingStatus != null ? "Đang ở" : "Không có phòng";
                                %>
                                <tr>
                                    <td><strong>#<%= guestId %></strong></td>
                                    <td><%= fullName %></td>
                                    <td><%= idNumber != null ? idNumber : "N/A" %></td>
                                    <td><%= phone != null ? phone : "N/A" %></td>
                                    <td><%= email != null ? email : "N/A" %></td>
                                    <td><%= nationality != null ? nationality : "N/A" %></td>
                                    <td>
                                        <% if (roomNumber != null) { %>
                                            <span class="badge bg-info">Phòng <%= roomNumber %></span>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="badge <%= statusClass %>">
                                            <%= statusText %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-hotel-outline" onclick="viewGuestDetails('<%= guestId %>')" title="Xem chi tiết">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-hotel-outline" onclick="editGuest('<%= guestId %>')" title="Sửa thông tin">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-hotel-outline" onclick="deleteGuest('<%= guestId %>')" title="Xóa khách hàng">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% 
                                    }
                                } else { 
                                %>
                                <tr>
                                    <td colspan="9" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">Không có dữ liệu khách hàng</p>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Guest Details Modal -->
    <div class="modal fade" id="guestDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-person"></i> Chi tiết khách hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="guestDetailsContent">
                    <!-- Content will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hotel-outline" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Guest Modal -->
    <div class="modal fade" id="editGuestModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-pencil"></i> Sửa thông tin khách hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%= request.getContextPath() %>/guest-management" method="post" id="editGuestForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="guestId" id="editGuestId">
                        <div class="mb-3">
                            <label class="form-label">Họ tên</label>
                            <input type="text" name="firstName" id="editFirstName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Họ</label>
                            <input type="text" name="lastName" id="editLastName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" id="editEmail" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" name="phone" id="editPhone" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">CMND/CCCD</label>
                            <input type="text" name="idNumber" id="editIdNumber" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Quốc tịch</label>
                            <input type="text" name="nationality" id="editNationality" class="form-control">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hotel-outline" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" form="editGuestForm" class="btn-hotel">Cập nhật</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterGuests() {
            const searchTerm = document.getElementById('guestSearch').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            const table = document.getElementById('guestsTable');
            const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const guestName = row.cells[1].textContent.toLowerCase();
                const phone = row.cells[3].textContent.toLowerCase();
                const status = row.cells[7].textContent.toLowerCase();
                
                let showRow = true;
                
                if (searchTerm && !guestName.includes(searchTerm) && !phone.includes(searchTerm)) {
                    showRow = false;
                }
                
                if (statusFilter) {
                    if (statusFilter === 'active' && !status.includes('đang ở')) {
                        showRow = false;
                    } else if (statusFilter === 'inactive' && !status.includes('không có phòng')) {
                        showRow = false;
                    }
                }
                
                row.style.display = showRow ? '' : 'none';
            }
        }
        
        function clearFilters() {
            document.getElementById('guestSearch').value = '';
            document.getElementById('statusFilter').value = '';
            filterGuests();
        }
        
        function viewGuestDetails(guestId) {
            const modal = new bootstrap.Modal(document.getElementById('guestDetailsModal'));
            document.getElementById('guestDetailsContent').innerHTML = `
                <div class="text-center">
                    <i class="bi bi-hourglass-split" style="font-size: 3rem;"></i>
                    <p class="mt-3">Đang tải thông tin khách hàng...</p>
                </div>
            `;
            modal.show();
            
            setTimeout(() => {
                document.getElementById('guestDetailsContent').innerHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Thông tin cá nhân</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>ID:</strong></td><td>#${guestId}</td></tr>
                                <tr><td><strong>Tên:</strong></td><td>Nguyễn Văn A</td></tr>
                                <tr><td><strong>SĐT:</strong></td><td>0123456789</td></tr>
                                <tr><td><strong>Email:</strong></td><td>guest@example.com</td></tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>Lịch sử đặt phòng</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Tổng đặt phòng:</strong></td><td>3 lần</td></tr>
                                <tr><td><strong>Lần cuối:</strong></td><td>2024-01-15</td></tr>
                                <tr><td><strong>Phòng hiện tại:</strong></td><td>102</td></tr>
                                <tr><td><strong>Trạng thái:</strong></td><td>Đang ở</td></tr>
                            </table>
                        </div>
                    </div>
                `;
            }, 1000);
        }
        
        function editGuest(guestId) {
            const modal = new bootstrap.Modal(document.getElementById('editGuestModal'));
            document.getElementById('editGuestId').value = guestId;
            modal.show();
        }
        
        function deleteGuest(guestId) {
            if (confirm('Bạn có chắc chắn muốn xóa khách hàng này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/guest-management';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                
                const guestIdInput = document.createElement('input');
                guestIdInput.type = 'hidden';
                guestIdInput.name = 'guestId';
                guestIdInput.value = guestId;
                form.appendChild(guestIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>

</html>