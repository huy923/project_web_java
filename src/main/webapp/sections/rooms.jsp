<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Management System - Quản lý phòng</title>
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"> -->
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet"> -->
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
        
        .room-status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        
        .status-available {
            background: rgba(46, 204, 113, 0.2);
            color: #2ecc71;
        }
        
        .status-occupied {
            background: rgba(231, 76, 60, 0.2);
            color: #e74c3c;
        }
        
        .status-maintenance {
            background: rgba(241, 196, 15, 0.2);
            color: #f1c40f;
        }
        
        .status-cleaning {
            background: rgba(149, 165, 166, 0.2);
            color: #95a5a6;
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
                        <li><a href="<%= request.getContextPath() %>/rooms" class="active"><i class="bi bi-door-open"></i> Room Management</a></li>
                        <li><a href="<%= request.getContextPath() %>/bookings"><i class="bi bi-calendar-check"></i> Bookings</a></li>
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
                            <i class="bi bi-door-open"></i> Quản lý phòng
                        </h1>
                        <p class="lead">Quản lý thông tin phòng và theo dõi trạng thái sử dụng</p>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-success">
                                <% 
                                List<Map<String, Object>> rooms = (List<Map<String, Object>>) request.getAttribute("rooms");
                                int availableRooms = 0;
                                if (rooms != null) {
                                    for (Map<String, Object> room : rooms) {
                                        if ("available".equals(room.get("status"))) {
                                            availableRooms++;
                                        }
                                    }
                                }
                                %>
                                <%= availableRooms %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-check-circle"></i> Phòng trống
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-warning">
                                <% 
                                int occupiedRooms = 0;
                                if (rooms != null) {
                                    for (Map<String, Object> room : rooms) {
                                        if ("occupied".equals(room.get("status"))) {
                                            occupiedRooms++;
                                        }
                                    }
                                }
                                %>
                                <%= occupiedRooms %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-person-fill"></i> Có khách
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-danger">
                                <% 
                                int maintenanceRooms = 0;
                                if (rooms != null) {
                                    for (Map<String, Object> room : rooms) {
                                        if ("maintenance".equals(room.get("status"))) {
                                            maintenanceRooms++;
                                        }
                                    }
                                }
                                %>
                                <%= maintenanceRooms %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-tools"></i> Bảo trì
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-info">
                                <% 
                                int totalRooms = rooms != null ? rooms.size() : 0;
                                %>
                                <%= totalRooms %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-door-open"></i> Tổng phòng
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Add Room Form -->
                <div class="dashboard-card p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-plus-circle"></i> Thêm phòng mới
                    </h5>
                    <form action="<%= request.getContextPath() %>/room-management" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Số phòng</label>
                                <input type="text" name="roomNumber" class="form-control" placeholder="Nhập số phòng" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Loại phòng</label>
                                <select name="roomTypeId" class="form-select" required>
                                    <option value="">Chọn loại phòng</option>
                                    <% 
                                    List<Map<String, Object>> roomTypes = (List<Map<String, Object>>) request.getAttribute("roomTypes");
                                    if (roomTypes != null) {
                                        for (Map<String, Object> type : roomTypes) {
                                    %>
                                    <option value="<%= type.get("room_type_id") %>">
                                        <%= type.get("type_name") %> - <%= String.format("%,d", ((java.math.BigDecimal) type.get("base_price")).longValue()) %> VNĐ/đêm
                                    </option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Tầng</label>
                                <input type="number" name="floorNumber" class="form-control" placeholder="Nhập tầng" min="1" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">&nbsp;</label>
                                <button class="btn-hotel w-100" type="submit">
                                    <i class="bi bi-plus"></i> Thêm phòng
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Rooms Table -->
                <div class="dashboard-card p-4">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Danh sách phòng
                    </h5>
                    <div class="table-responsive border-radius-5">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> Số phòng</th>
                                    <th><i class="bi bi-house"></i> Loại phòng</th>
                                    <th><i class="bi bi-flag"></i> Trạng thái</th>
                                    <th><i class="bi bi-currency-dollar"></i> Giá/đêm</th>
                                    <th><i class="bi bi-building"></i> Tầng</th>
                                    <th><i class="bi bi-gear"></i> Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                if (rooms != null && !rooms.isEmpty()) {
                                    for (Map<String, Object> room : rooms) {
                                        String status = (String) room.get("status");
                                        String statusClass = "";
                                        String statusText = "";
                                        String statusIcon = "";
                                        
                                        if ("available".equals(status)) {
                                            statusClass = "status-available";
                                            statusText = "Trống";
                                            statusIcon = "bi-check-circle";
                                        } else if ("occupied".equals(status)) {
                                            statusClass = "status-occupied";
                                            statusText = "Có khách";
                                            statusIcon = "bi-person-fill";
                                        } else if ("maintenance".equals(status)) {
                                            statusClass = "status-maintenance";
                                            statusText = "Bảo trì";
                                            statusIcon = "bi-tools";
                                        } else if ("cleaning".equals(status)) {
                                            statusClass = "status-cleaning";
                                            statusText = "Dọn phòng";
                                            statusIcon = "bi-brush";
                                        }
                                %>
                                <tr>
                                    <td>
                                        <strong>Phòng <%= room.get("room_number") %></strong>
                                    </td>
                                    <td>
                                        <%= room.get("type_name") %>
                                    </td>
                                    <td>
                                        <span class="room-status-badge <%= statusClass %>">
                                            <i class="bi <%= statusIcon %>"></i> <%= statusText %>
                                        </span>
                                    </td>
                                    <td>
                                        <strong><%= String.format("%,d", ((java.math.BigDecimal) room.get("base_price")).longValue()) %> VNĐ</strong>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">Tầng <%= room.get("floor_number") %></span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <form action="<%= request.getContextPath() %>/room-management" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="roomId" value="<%= room.get("room_id") %>">
                                                <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                                                    <option value="available" <%=status.equals("available") ? "selected" : "" %>>Trống</option>
                                                    <option value="occupied" <%=status.equals("occupied") ? "selected" : "" %>>Có khách</option>
                                                    <option value="maintenance" <%=status.equals("maintenance") ? "selected" : "" %>>Bảo trì</option>
                                                    <option value="cleaning" <%=status.equals("cleaning") ? "selected" : "" %>>Dọn phòng</option>
                                                </select>
                                            </form>
                                            <button class="btn btn-sm btn-hotel-outline ms-2" onclick="viewRoomDetails('<%= room.get("room_id") %>')" title="Xem chi tiết">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <form action="<%= request.getContextPath() %>/room-management" method="post" class="d-inline ms-1">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="roomId" value="<%= room.get("room_id") %>">
                                                <button type="submit" class="btn btn-sm btn-hotel-outline" onclick="return confirm('Xóa phòng này?')" title="Xóa phòng">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <% 
                                    }
                                } else { 
                                %>
                                <tr>
                                    <td colspan="6" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">Không có dữ liệu phòng</p>
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

    <!-- Room Details Modal -->
    <div class="modal fade" id="roomDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-door-open"></i> Chi tiết phòng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="roomDetailsContent">
                    <!-- Content will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hotel-outline" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function viewRoomDetails(roomId) {
            const modal = new bootstrap.Modal(document.getElementById('roomDetailsModal'));
            document.getElementById('roomDetailsContent').innerHTML = `
                <div class="text-center">
                    <i class="bi bi-hourglass-split" style="font-size: 3rem;"></i>
                    <p class="mt-3">Đang tải thông tin phòng...</p>
                </div>
            `;
            modal.show();
            
            setTimeout(() => {
                document.getElementById('roomDetailsContent').innerHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Thông tin phòng</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Số phòng:</strong></td><td>${roomId}</td></tr>
                                <tr><td><strong>Loại:</strong></td><td>Standard</td></tr>
                                <tr><td><strong>Tầng:</strong></td><td>1</td></tr>
                                <tr><td><strong>Giá/đêm:</strong></td><td>1,200,000 VNĐ</td></tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>Trạng thái hiện tại</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Trạng thái:</strong></td><td><span class="badge bg-success">Trống</span></td></tr>
                                <tr><td><strong>Lần dọn cuối:</strong></td><td>2024-01-15 10:30</td></tr>
                                <tr><td><strong>Ghi chú:</strong></td><td>Phòng sạch sẽ, sẵn sàng đón khách</td></tr>
                            </table>
                        </div>
                    </div>
                `;
            }, 1000);
        }
    </script>
</body>
</html>


