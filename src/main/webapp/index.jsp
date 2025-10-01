<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
    <%@ page import="java.util.ArrayList" %>
        <%@ page import="java.util.HashMap" %>
            <%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Management System - Dashboard</title>
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
        
        .stats-card {
            text-align: center;
            padding: 2rem;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .stats-label {
            font-size: 1rem;
            opacity: 0.9;
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
        
        .room-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .room-status {
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
        
        .recent-activity {
            max-height: 300px;
            overflow-y: auto;
        }
        
        .activity-item {
            padding: 0.75rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }
        
        .icon-checkin {
            background: rgba(46, 204, 113, 0.2);
            color: #2ecc71;
        }
        
        .icon-checkout {
            background: rgba(231, 76, 60, 0.2);
            color: #e74c3c;
        }
        
        .icon-booking {
            background: rgba(52, 152, 219, 0.2);
            color: #3498db;
        }
        
        .icon-maintenance {
            background: rgba(241, 196, 15, 0.2);
            color: #f1c40f;
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
            <a class="navbar-brand" href="#">
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
                        <li><a href="<%= request.getContextPath() %>/dashboard" class="active"><i class="bi bi-speedometer2"></i>
                                Dashboard</a></li>
                        <li><a href="<%= request.getContextPath() %>/rooms"><i class="bi bi-door-open"></i> Room Management</a></li>
                        <li><a href="<%= request.getContextPath() %>/bookings"><i class="bi bi-calendar-check"></i> Bookings</a>
                        </li>
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
                            <i class="bi bi-house-door"></i> Hotel Dashboard
                        </h1>
                        <p class="lead">Chào mừng đến với hệ thống quản lý khách sạn</p>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-success">24</div>
                            <div class="stats-label">
                                <i class="bi bi-door-open"></i> Phòng trống
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-warning">16</div>
                            <div class="stats-label">
                                <i class="bi bi-person-fill"></i> Đang ở
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-info">8</div>
                            <div class="stats-label">
                                <i class="bi bi-calendar-plus"></i> Đặt trước
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stats-number text-danger">2</div>
                            <div class="stats-label">
                                <i class="bi bi-tools"></i> Bảo trì
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="dashboard-card p-4">
                            <h5 class="mb-3">
                                <i class="bi bi-lightning"></i> Thao tác nhanh
                            </h5>
                            <div class="d-flex gap-3 flex-wrap">
                                <a href="#" class="btn-hotel" data-bs-toggle="modal" data-bs-target="#checkInModal">
                                    <i class="bi bi-person-plus"></i> Check-in
                                </a>
                                <a href="#" class="btn-hotel-outline" data-bs-toggle="modal" data-bs-target="#checkOutModal">
                                    <i class="bi bi-person-dash"></i> Check-out
                                </a>
                                <a href="#" class="btn-hotel-outline" data-bs-toggle="modal" data-bs-target="#bookingModal">
                                    <i class="bi bi-calendar-plus"></i> Đặt phòng
                                </a>
                                <a href="#" class="btn-hotel-outline" data-bs-toggle="modal" data-bs-target="#roomModal">
                                    <i class="bi bi-door-open"></i> Quản lý phòng
                                </a>
                                <a href="#" class="btn-hotel-outline" data-bs-toggle="modal" data-bs-target="#guestModal">
                                    <i class="bi bi-people"></i> Khách hàng
                                </a>
                                </div>
                                </div>
                                </div>
                                </div>
                                <div class="row">
                                    <!-- Room Status -->
                                    <div class="col-lg-8 mb-4">
                                        <div class="dashboard-card p-4">
                                            <h5 class="mb-3">
                                                <i class="bi bi-grid-3x3"></i> Trạng thái phòng
                                            </h5>
                                            <div class="row">
                                                <% java.util.List<java.util.Map<String, Object>> roomStatus = (java.util.List<java.util.Map<String,
                                                        Object>>) request.getAttribute("roomStatus");
                                                        if (roomStatus != null) {
                                                        for (java.util.Map<String, Object> row : roomStatus) {
                                                            String roomNumber = String.valueOf(row.get("room_number"));
                                                            String status = String.valueOf(row.get("status"));
                                                            String statusClass = "status-" + status;
                                                            String statusText = status.equals("available") ? "Trống" :
                                                            status.equals("occupied") ? "Có khách" :
                                                            status.equals("maintenance") ? "Bảo trì" : "Dọn phòng";
                                                            String statusIcon = status.equals("available") ? "bi-check-circle" :
                                                            status.equals("occupied") ? "bi-person-fill" :
                                                            status.equals("maintenance") ? "bi-tools" : "bi-brush";
                                                            %>
                                                            <div class="col-md-3 col-sm-4 col-6 mb-3">
                                                                <div class="room-card text-center">
                                                                    <h6 class="mb-2">Phòng <%= roomNumber %>
                                                                    </h6>
                                                                    <span class="room-status <%= statusClass %>">
                                                                        <i class="bi <%= statusIcon %>"></i>
                                                                        <%= statusText %>
                                                                    </span>
                                                                </div>
                                                            </div>
                                                            <% } } else { %>
                                                                <div class="text-muted">Không có dữ liệu phòng. Hãy đăng nhập.</div>
                                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Recent Activity -->
                                    <div class="col-lg-4 mb-4">
                                        <div class="dashboard-card p-4">
                                            <h5 class="mb-3">
                                                <i class="bi bi-clock-history"></i> Hoạt động gần đây
                                            </h5>
                                            <div class="recent-activity">
                                                <div class="activity-item">
                                                    <div class="activity-icon icon-checkin">
                                                        <i class="bi bi-person-plus"></i>
                                                    </div>
                                                    <div>
                                                        <div class="fw-bold">Check-in Phòng 205</div>
                                                        <small class="text-muted">Nguyễn Văn A - 10:30</small>
                                                    </div>
                                                </div>
                                                <div class="activity-item">
                                                    <div class="activity-icon icon-checkout">
                                                        <i class="bi bi-person-dash"></i>
                                                    </div>
                                                    <div>
                                                        <div class="fw-bold">Check-out Phòng 103</div>
                                                        <small class="text-muted">Trần Thị B - 09:15</small>
                                                    </div>
                                                </div>
                                                <div class="activity-item">
                                                    <div class="activity-icon icon-booking">
                                                        <i class="bi bi-calendar-plus"></i>
                                                    </div>
                                    <div>
                                        <div class="fw-bold">Đặt phòng 201</div>
                                        <small class="text-muted">Lê Văn C - 08:45</small>
                                    </div>
                                    </div>
                                <div class="activity-item">
                                    <div class="activity-icon icon-maintenance">
                                        <i class="bi bi-tools"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold">Bảo trì Phòng 105</div>
                                        <small class="text-muted">Nhân viên kỹ thuật - 07:20</small>
                                    </div>
                                    </div>
                                    </div>
                                    </div>
                                    </div>
                                    </div>

                <!-- System Info -->
                <div class="row">
                    <div class="col-12">
                        <div class="dashboard-card p-4">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h6 class="mb-1">
                                        <i class="bi bi-info-circle"></i> Thông tin hệ thống
                                    </h6>
                                    <small class="text-muted">
                                        Server: <%= application.getServerInfo() %> |
                                            Java: <%= System.getProperty("java.version") %> |
                                                Thời gian: <%= new Date() %>
                                    </small>
                                </div>
                                <div class="col-md-4 text-end">
                                    <button class="btn-hotel-outline btn-sm" data-bs-toggle="modal" data-bs-target="#systemInfoModal">
                                        <i class="bi bi-gear"></i> Chi tiết
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- System Info Modal -->
    <div class="modal fade" id="systemInfoModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">📊 Thông tin hệ thống</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-dark table-striped">
                        <tr>
                            <td><strong>Thời gian:</strong></td>
                            <td><%= new Date() %></td>
                        </tr>
                        <tr>
                            <td><strong>Server Info:</strong></td>
                            <td><%= application.getServerInfo() %></td>
                        </tr>
                        <tr>
                            <td><strong>Java Version:</strong></td>
                            <td><%= System.getProperty("java.version") %></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Check-in Modal -->
    <div class="modal fade" id="checkInModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-person-plus"></i> Check-in khách hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Họ tên khách</label>
                                <input type="text" class="form-control bg-dark text-white border-secondary"
                                    placeholder="Nhập họ tên">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">CMND/CCCD</label>
                                <input type="text" class="form-control bg-dark text-white border-secondary"
                                    placeholder="Nhập số CMND">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control bg-dark text-white border-secondary"
                                    placeholder="Nhập SĐT">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Phòng</label>
                                <select class="form-select bg-dark text-white border-secondary">
                                    <option>Chọn phòng</option>
                                    <option>101 - Standard</option>
                                    <option>102 - Standard</option>
                                    <option>201 - Deluxe</option>
                                    <option>202 - Deluxe</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ngày nhận phòng</label>
                                <input type="date" class="form-control bg-dark text-white border-secondary">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ngày trả phòng</label>
                                <input type="date" class="form-control bg-dark text-white border-secondary">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn-hotel">Check-in</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Check-out Modal -->
    <div class="modal fade" id="checkOutModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-person-dash"></i> Check-out khách hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Chọn phòng</label>
                        <select class="form-select bg-dark text-white border-secondary">
                            <option>Phòng 102 - Nguyễn Văn A</option>
                            <option>Phòng 105 - Trần Thị B</option>
                            <option>Phòng 201 - Lê Văn C</option>
                            <option>Phòng 203 - Phạm Thị D</option>
                        </select>
                    </div>
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle"></i> Tổng tiền: <strong>2,500,000 VNĐ</strong>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn-hotel">Check-out</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Booking Modal -->
    <div class="modal fade" id="bookingModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-calendar-plus"></i> Đặt phòng mới
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Họ tên</label>
                                <input type="text" class="form-control bg-dark text-white border-secondary">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control bg-dark text-white border-secondary">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Loại phòng</label>
                                <select class="form-select bg-dark text-white border-secondary">
                                    <option>Standard - 1,200,000 VNĐ/đêm</option>
                                    <option>Deluxe - 1,800,000 VNĐ/đêm</option>
                                    <option>Suite - 2,500,000 VNĐ/đêm</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số đêm</label>
                                <input type="number" class="form-control bg-dark text-white border-secondary" value="1">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ngày nhận phòng</label>
                                <input type="date" class="form-control bg-dark text-white border-secondary">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số người</label>
                                <input type="number" class="form-control bg-dark text-white border-secondary" value="1">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn-hotel">Đặt phòng</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Room Management Modal -->
    <div class="modal fade" id="roomModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-door-open"></i> Quản lý phòng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Thêm phòng mới</h6>
                            <form>
                                <div class="mb-3">
                                    <label class="form-label">Số phòng</label>
                                    <input type="text" class="form-control bg-dark text-white border-secondary">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Loại phòng</label>
                                    <select class="form-select bg-dark text-white border-secondary">
                                        <option>Standard</option>
                                        <option>Deluxe</option>
                                        <option>Suite</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Giá/đêm (VNĐ)</label>
                                    <input type="number" class="form-control bg-dark text-white border-secondary">
                                </div>
                                <button type="button" class="btn-hotel">Thêm phòng</button>
                            </form>
                        </div>
                        <div class="col-md-6">
                            <h6>Danh sách phòng</h6>
                            <div class="list-group">
                                <div
                                    class="list-group-item bg-dark text-white border-secondary d-flex justify-content-between">
                                    <span>Phòng 101 - Standard</span>
                                    <span class="badge bg-success">Trống</span>
                                </div>
                                <div
                                    class="list-group-item bg-dark text-white border-secondary d-flex justify-content-between">
                                    <span>Phòng 102 - Standard</span>
                                    <span class="badge bg-warning">Có khách</span>
                                </div>
                                <div
                                    class="list-group-item bg-dark text-white border-secondary d-flex justify-content-between">
                                    <span>Phòng 201 - Deluxe</span>
                                    <span class="badge bg-danger">Bảo trì</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Guest Management Modal -->
    <div class="modal fade" id="guestModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-people"></i> Quản lý khách hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="table-responsive">
                        <table class="table table-dark table-striped">
                            <thead>
                                <tr>
                                    <th>Họ tên</th>
                                    <th>CMND</th>
                                    <th>SĐT</th>
                                    <th>Phòng</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Nguyễn Văn A</td>
                                    <td>123456789</td>
                                    <td>0123456789</td>
                                    <td>102</td>
                                    <td><span class="badge bg-warning">Đang ở</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">Sửa</button>
                                        <button class="btn btn-sm btn-outline-danger">Xóa</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Trần Thị B</td>
                                    <td>987654321</td>
                                    <td>0987654321</td>
                                    <td>105</td>
                                    <td><span class="badge bg-warning">Đang ở</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">Sửa</button>
                                        <button class="btn btn-sm btn-outline-danger">Xóa</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-refresh dashboard every 30 seconds
        setInterval(function () {
            // You can add AJAX calls here to refresh data
            console.log('Dashboard auto-refresh...');
        }, 30000);

        // Add some interactive functionality
        document.addEventListener('DOMContentLoaded', function () {
            // Room status click handlers
            document.querySelectorAll('.room-card').forEach(function (card) {
                card.addEventListener('click', function () {
                    const roomNumber = this.querySelector('h6').textContent;
                    alert('Thông tin phòng: ' + roomNumber);
                });
            });

            // Stats card animations
            document.querySelectorAll('.stats-number').forEach(function (element) {
                const finalNumber = parseInt(element.textContent);
                let currentNumber = 0;
                const increment = finalNumber / 50;

                const timer = setInterval(function () {
                    currentNumber += increment;
                    if (currentNumber >= finalNumber) {
                        element.textContent = finalNumber;
                        clearInterval(timer);
                    } else {
                        element.textContent = Math.floor(currentNumber);
                    }
                }, 30);
            });

            // Quick action buttons functionality
            document.querySelectorAll('.btn-hotel, .btn-hotel-outline').forEach(function (btn) {
                btn.addEventListener('click', function (e) {
                    if (this.getAttribute('href') === '#') {
                        e.preventDefault();
                        // Add your functionality here
                        console.log('Button clicked: ' + this.textContent.trim());
                    }
                });
            });

            // Sidebar menu functionality (only prevent default for '#')
            document.querySelectorAll('.sidebar-menu a').forEach(function (link) {
                link.addEventListener('click', function (e) {
                    const href = this.getAttribute('href');
                    if (!href || href === '#') {
                        e.preventDefault();
                        // Toggle active state for non-navigation links
                        document.querySelectorAll('.sidebar-menu a').forEach(function (l) {
                            l.classList.remove('active');
                        });
                        this.classList.add('active');
                        console.log('Menu clicked: ' + this.textContent.trim());
                    }
                    // Otherwise, allow navigation to proceed
                });
            });
        });

        // Hotel management functions
        function checkIn() {
            alert('Check-in functionality - Connect to backend!');
        }

        function checkOut() {
            alert('Check-out functionality - Connect to backend!');
        }

        function makeBooking() {
            alert('Booking functionality - Connect to backend!');
        }

        function manageRooms() {
            alert('Room management - Connect to backend!');
        }

        function manageGuests() {
            alert('Guest management - Connect to backend!');
        }
    </script>
</body>
</html>