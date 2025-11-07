<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đặt phòng - Hotel Management System</title>
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
            transform: translateY(-2px);
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
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        
        .status-confirmed {
            background: rgba(52, 152, 219, 0.2);
            color: #3498db;
        }
        
        .status-checked_in {
            background: rgba(46, 204, 113, 0.2);
            color: #2ecc71;
        }
        
        .status-checked_out {
            background: rgba(149, 165, 166, 0.2);
            color: #95a5a6;
        }
        
        .status-cancelled {
            background: rgba(231, 76, 60, 0.2);
            color: #e74c3c;
        }
        
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }
        
        .table-dark {
            --bs-table-bg: rgba(255, 255, 255, 0.05);
            --bs-table-striped-bg: rgba(255, 255, 255, 0.1);
            --bs-table-hover-bg: rgba(255, 255, 255, 0.15);
        }
        
        .filter-section {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stats-row {
            margin-bottom: 2rem;
        }
        
        .stat-card {
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
                        <li><a href="<%= request.getContextPath() %>/bookings" class="active"><i class="bi bi-calendar-check"></i> Bookings</a></li>
                        <li><a href="<%= request.getContextPath() %>/guests"><i class="bi bi-people"></i> Guests</a></li>
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
                            <i class="bi bi-calendar-check"></i> Quản lý đặt phòng
                        </h1>
                        <p class="lead">Quản lý và theo dõi tất cả các đặt phòng của khách sạn</p>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row stats-row">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-info">
                                <% 
                                List<Map<String, Object>> bookings = (List<Map<String, Object>>) request.getAttribute("bookings");
                                int totalBookings = bookings != null ? bookings.size() : 0;
                                %>
                                <%= totalBookings %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-calendar-plus"></i> Tổng đặt phòng
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-warning">
                                <% 
                                int confirmedCount = 0;
                                if (bookings != null) {
                                    for (Map<String, Object> booking : bookings) {
                                        if ("confirmed".equals(booking.get("status"))) {
                                            confirmedCount++;
                                        }
                                    }
                                }
                                %>
                                <%= confirmedCount %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-clock"></i> Chờ nhận phòng
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-success">
                                <% 
                                int checkedInCount = 0;
                                if (bookings != null) {
                                    for (Map<String, Object> booking : bookings) {
                                        if ("checked_in".equals(booking.get("status"))) {
                                            checkedInCount++;
                                        }
                                    }
                                }
                                %>
                                <%= checkedInCount %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-person-check"></i> Đang ở
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-secondary">
                                <% 
                                int checkedOutCount = 0;
                                if (bookings != null) {
                                    for (Map<String, Object> booking : bookings) {
                                        if ("checked_out".equals(booking.get("status"))) {
                                            checkedOutCount++;
                                        }
                                    }
                                }
                                %>
                                <%= checkedOutCount %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-person-dash"></i> Đã trả phòng
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Filter and Search Section -->
                <div class="filter-section">
                    <div class="row align-items-end">
                        <div class="col-md-3 mb-3">
                            <label class="form-label">Tìm kiếm khách hàng</label>
                            <input type="text" class="form-control text-white border-secondary" 
                                   placeholder="Nhập tên khách hàng" id="guestSearch">
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select border-secondary" id="statusFilter">
                                <option value="">Tất cả</option>
                                <option value="confirmed">Chờ nhận phòng</option>
                                <option value="checked_in">Đang ở</option>
                                <option value="checked_out">Đã trả phòng</option>
                                <option value="cancelled">Đã hủy</option>
                            </select>
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label">Từ ngày</label>
                            <input type="date" class="form-control border-secondary" id="fromDate">
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label">Đến ngày</label>
                            <input type="date" class="form-control border-secondary" id="toDate">
                        </div>
                        <div class="col-md-3 mb-3">
                            <button class="btn-hotel me-2" onclick="filterBookings()">
                                <i class="bi bi-search"></i> Lọc
                            </button>
                            <button class="btn-hotel-outline" data-bs-toggle="modal" data-bs-target="#newBookingModal">
                                <i class="bi bi-plus"></i> Đặt phòng mới
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Bookings Table -->
                <div class="dashboard-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">
                            <i class="bi bi-table"></i> Danh sách đặt phòng
                        </h5>
                        <div class="d-flex gap-2">
                            <button class="btn btn-sm btn-outline-light" onclick="exportBookings()">
                                <i class="bi bi-download"></i> Xuất Excel
                            </button>
                            <button class="btn btn-sm btn-outline-light" onclick="refreshBookings()">
                                <i class="bi bi-arrow-clockwise"></i> Làm mới
                            </button>
                        </div>
                    </div>
                    
                    <div class="table-responsive overflow-x-auto" style="max-height: 500px;">
                        <table class="table table-dark table-striped table-hover" id="bookingsTable">
                            <thead>
                                <tr>
                                    <th>Mã đặt phòng</th>
                                    <th>Khách hàng</th>
                                    <th>Số điện thoại</th>
                                    <th>Phòng</th>
                                    <th>Ngày nhận</th>
                                    <th>Ngày trả</th>
                                    <th>Số đêm</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                if (bookings != null && !bookings.isEmpty()) {
                                    for (Map<String, Object> booking : bookings) {
                                        String bookingId = String.valueOf(booking.get("booking_id"));
                                        String guestName = booking.get("first_name") + " " + booking.get("last_name");
                                        String phone = (String) booking.get("phone");
                                        String roomNumber = (String) booking.get("room_number");
                                        String checkInDate = booking.get("check_in_date") != null ? booking.get("check_in_date").toString() : "";
                                        String checkOutDate = booking.get("check_out_date") != null ? booking.get("check_out_date").toString() : "";
                                        String totalAmount = booking.get("total_amount") != null ? booking.get("total_amount").toString() : "0";
                                        String status = (String) booking.get("status");
                                        
                                        // Calculate nights
                                        int nights = 1;
                                        if (!checkInDate.isEmpty() && !checkOutDate.isEmpty()) {
                                            try {
                                                java.sql.Date checkIn = java.sql.Date.valueOf(checkInDate);
                                                java.sql.Date checkOut = java.sql.Date.valueOf(checkOutDate);
                                                long diffInMillies = checkOut.getTime() - checkIn.getTime();
                                                nights = (int) (diffInMillies / (1000 * 60 * 60 * 24));
                                                if (nights <= 0) nights = 1;
                                            } catch (Exception e) {
                                                nights = 1;
                                            }
                                        }
                                        
                                        String statusClass = "status-" + status;
                                        String statusText = "";
                                        String statusIcon = "";
                                        
                                        if ("confirmed".equals(status)) {
                                            statusText = "Chờ nhận phòng";
                                            statusIcon = "bi-clock";
                                        } else if ("checked_in".equals(status)) {
                                            statusText = "Đang ở";
                                            statusIcon = "bi-person-check";
                                        } else if ("checked_out".equals(status)) {
                                            statusText = "Đã trả phòng";
                                            statusIcon = "bi-person-dash";
                                        } else if ("cancelled".equals(status)) {
                                            statusText = "Đã hủy";
                                            statusIcon = "bi-x-circle";
                                        } else {
                                            statusText = status;
                                            statusIcon = "bi-question-circle";
                                        }
                                %>
                                <tr>
                                    <td><strong>BK<%= String.format("%03d", Integer.parseInt(bookingId)) %></strong></td>
                                    <td><%= guestName %></td>
                                    <td><%= phone != null ? phone : "N/A" %></td>
                                    <td><span class="badge bg-info">Phòng <%= roomNumber %></span></td>
                                    <td><%= checkInDate %></td>
                                    <td><%= checkOutDate %></td>
                                    <td><%= nights %> đêm</td>
                                    <td><strong><%= String.format("%,.0f", Double.parseDouble(totalAmount)) %> VNĐ</strong></td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>">
                                            <i class="bi <%= statusIcon %>"></i> <%= statusText %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-primary" onclick="viewBookingDetails('<%= bookingId %>')" title="Xem chi tiết">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <% if ("confirmed".equals(status)) { %>
                                            <button class="btn btn-sm btn-outline-success" onclick="checkInBooking('<%= bookingId %>')" title="Check-in">
                                                <i class="bi bi-person-plus"></i>
                                            </button>
                                            <% } else if ("checked_in".equals(status)) { %>
                                            <button class="btn btn-sm btn-outline-warning" onclick="checkOutBooking('<%= bookingId %>')" title="Check-out">
                                                <i class="bi bi-person-dash"></i>
                                            </button>
                                            <% } %>
                                            <button class="btn btn-sm btn-outline-danger" onclick="cancelBooking('<%= bookingId %>')" title="Hủy đặt phòng">
                                                <i class="bi bi-x-circle"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% 
                                    }
                                } else { 
                                %>
                                <tr>
                                    <td colspan="10" class="text-center text-muted py-4">
                                        <i class="bi bi-calendar-x" style="font-size: 2rem;"></i>
                                        <br>Không có đặt phòng nào
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

    <!-- New Booking Modal -->
    <div class="modal fade" id="newBookingModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-calendar-plus"></i> Đặt phòng mới
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%= request.getContextPath() %>/bookings" method="post" id="newBookingForm">
                        <input type="hidden" name="action" value="create">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Họ tên khách hàng</label>
                                <input type="text" name="firstName" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Họ</label>
                                <input type="text" name="lastName" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" name="phone" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control text-white border-secondary">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">CMND/CCCD</label>
                                <input type="text" name="idNumber" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Phòng</label>
                                <select name="roomId" class="form-select text-white border-secondary" required>
                                    <option value="">Chọn phòng</option>
                                    <% 
                                    List<Map<String, Object>> availableRooms = (List<Map<String, Object>>) request.getAttribute("availableRooms");
                                    if (availableRooms != null) {
                                        for (Map<String, Object> room : availableRooms) {
                                    %>
                                    <option value="<%= room.get("room_id") %>">
                                        Phòng <%= room.get("room_number") %> - <%= room.get("type_name") %> 
                                        (<%= String.format("%,d", ((java.math.BigDecimal) room.get("base_price")).longValue()) %> VNĐ/đêm)
                                    </option>
                                    <% 
                                        }
                                    } 
                                    %>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ngày nhận phòng</label>
                                <input type="date" name="checkInDate" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ngày trả phòng</label>
                                <input type="date" name="checkOutDate" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số người lớn</label>
                                <input type="number" name="adults" class="form-control text-white border-secondary" value="1" min="1" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số trẻ em</label>
                                <input type="number" name="children" class="form-control text-white border-secondary" value="0" min="0">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" form="newBookingForm" class="btn-hotel">Tạo đặt phòng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Booking Details Modal -->
    <div class="modal fade" id="bookingDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-calendar-check"></i> Chi tiết đặt phòng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="bookingDetailsContent">
                    <!-- Content will be loaded dynamically -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Filter bookings function
        function filterBookings() {
            const guestSearch = document.getElementById('guestSearch').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            const fromDate = document.getElementById('fromDate').value;
            const toDate = document.getElementById('toDate').value;
            
            const table = document.getElementById('bookingsTable');
            const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const guestName = row.cells[1].textContent.toLowerCase();
                const status = row.cells[8].textContent.toLowerCase();
                const checkInDate = row.cells[4].textContent;
                
                let showRow = true;
                
                // Guest name filter
                if (guestSearch && !guestName.includes(guestSearch)) {
                    showRow = false;
                }
                
                // Status filter
                if (statusFilter) {
                    const statusText = row.cells[8].textContent.toLowerCase();
                    if (!statusText.includes(statusFilter)) {
                        showRow = false;
                    }
                }
                
                // Date range filter
                if (fromDate && checkInDate < fromDate) {
                    showRow = false;
                }
                if (toDate && checkInDate > toDate) {
                    showRow = false;
                }
                
                row.style.display = showRow ? '' : 'none';
            }
        }
        
        // View booking details
        function viewBookingDetails(bookingId) {
            // This would typically make an AJAX call to get booking details
            const modal = new bootstrap.Modal(document.getElementById('bookingDetailsModal'));
            document.getElementById('bookingDetailsContent').innerHTML = `
                <div class="text-center">
                    <i class="bi bi-hourglass-split" style="font-size: 3rem;"></i>
                    <p class="mt-3">Đang tải thông tin đặt phòng...</p>
                </div>
            `;
            modal.show();
            
            // Simulate loading
            setTimeout(() => {
                document.getElementById('bookingDetailsContent').innerHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Thông tin khách hàng</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Mã đặt phòng:</strong></td><td>BK${bookingId.padStart(3, '0')}</td></tr>
                                <tr><td><strong>Tên khách:</strong></td><td>Nguyễn Văn A</td></tr>
                                <tr><td><strong>SĐT:</strong></td><td>0123456789</td></tr>
                                <tr><td><strong>Email:</strong></td><td>guest@example.com</td></tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>Thông tin phòng</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Phòng:</strong></td><td>102</td></tr>
                                <tr><td><strong>Loại:</strong></td><td>Standard</td></tr>
                                <tr><td><strong>Ngày nhận:</strong></td><td>2024-01-15</td></tr>
                                <tr><td><strong>Ngày trả:</strong></td><td>2024-01-18</td></tr>
                                <tr><td><strong>Tổng tiền:</strong></td><td>3,600,000 VNĐ</td></tr>
                            </table>
                        </div>
                    </div>
                `;
            }, 1000);
        }
        
        // Check-in booking
        function checkInBooking(bookingId) {
            if (confirm('Xác nhận check-in cho đặt phòng này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/bookings';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'checkin';
                form.appendChild(actionInput);
                
                const bookingIdInput = document.createElement('input');
                bookingIdInput.type = 'hidden';
                bookingIdInput.name = 'bookingId';
                bookingIdInput.value = bookingId;
                form.appendChild(bookingIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Check-out booking
        function checkOutBooking(bookingId) {
            if (confirm('Xác nhận check-out cho đặt phòng này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/bookings';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'checkout';
                form.appendChild(actionInput);
                
                const bookingIdInput = document.createElement('input');
                bookingIdInput.type = 'hidden';
                bookingIdInput.name = 'bookingId';
                bookingIdInput.value = bookingId;
                form.appendChild(bookingIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Cancel booking
        function cancelBooking(bookingId) {
            if (confirm('Bạn có chắc chắn muốn hủy đặt phòng này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/bookings';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'cancel';
                form.appendChild(actionInput);
                
                const bookingIdInput = document.createElement('input');
                bookingIdInput.type = 'hidden';
                bookingIdInput.name = 'bookingId';
                bookingIdInput.value = bookingId;
                form.appendChild(bookingIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Export bookings
        function exportBookings() {
            alert('Tính năng xuất Excel đang được phát triển!');
        }
        
        // Refresh bookings
        function refreshBookings() {
            location.reload();
        }
        
        // Auto-refresh every 30 seconds
        setInterval(function() {
            console.log('Auto-refreshing bookings...');
        }, 30000);
        
        // Initialize date inputs with today's date
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('fromDate').value = today;
            document.getElementById('toDate').value = today;
        });
    </script>
</body>
</html>
