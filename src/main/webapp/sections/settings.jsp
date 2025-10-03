<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Management System - Cài đặt hệ thống</title>
    <link href="/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="/webjars/bootstrap-icons/1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"> -->
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet"> -->
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
        
        .settings-section {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .settings-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
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
        
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }
        
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(255, 255, 255, 0.2);
            transition: .4s;
            border-radius: 34px;
        }
        
        .slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .slider {
            background-color: #ff6b6b;
        }
        
        input:checked + .slider:before {
            transform: translateX(26px);
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
                        <li><a href="<%= request.getContextPath() %>/guests"><i class="bi bi-people"></i> Guests</a></li>
                        <li><a href="<%= request.getContextPath() %>/payments"><i class="bi bi-credit-card"></i> Payments</a></li>
                        <li><a href="<%= request.getContextPath() %>/reports"><i class="bi bi-graph-up"></i> Reports</a></li>
                        <li><a href="<%= request.getContextPath() %>/settings" class="active"><i class="bi bi-gear"></i> Settings</a></li>
                    </ul>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-lg-9 col-md-8">
                <!-- Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h1 class="display-6 mb-3">
                            <i class="bi bi-gear"></i> Cài đặt hệ thống
                        </h1>
                        <p class="lead">Quản lý cấu hình và thiết lập hệ thống khách sạn</p>
                    </div>
                </div>

                <!-- Alert Messages -->
                <div id="alertContainer"></div>

                <!-- Hotel Information Settings -->
                <div class="settings-section">
                    <div class="d-flex align-items-center mb-4">
                        <div class="settings-icon text-primary">
                            <i class="bi bi-building"></i>
                        </div>
                        <div class="ms-3">
                            <h4 class="mb-1">Thông tin khách sạn</h4>
                            <p class="text-muted mb-0">Cấu hình thông tin cơ bản của khách sạn</p>
                        </div>
                    </div>
                    
                    <form id="hotelInfoForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Tên khách sạn</label>
                                <input type="text" class="form-control" placeholder="Nhập tên khách sạn" value="Hotel Paradise">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email liên hệ</label>
                                <input type="email" class="form-control" placeholder="Nhập email liên hệ" value="contact@hotelparadise.com">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" placeholder="Nhập số điện thoại" value="+84 123 456 789">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" placeholder="Nhập địa chỉ" value="123 Đường ABC, Quận 1, TP.HCM">
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">Mô tả</label>
                                <textarea class="form-control" rows="3" placeholder="Nhập mô tả khách sạn">Khách sạn sang trọng với dịch vụ chuyên nghiệp, tọa lạc tại trung tâm thành phố.</textarea>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn-hotel">
                                    <i class="bi bi-check-circle"></i> Lưu thông tin
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- System Settings -->
                <div class="settings-section">
                    <div class="d-flex align-items-center mb-4">
                        <div class="settings-icon text-success">
                            <i class="bi bi-sliders"></i>
                        </div>
                        <div class="ms-3">
                            <h4 class="mb-1">Cài đặt hệ thống</h4>
                            <p class="text-muted mb-0">Cấu hình các tham số hoạt động của hệ thống</p>
                        </div>
                    </div>
                    
                    <form id="systemSettingsForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Múi giờ</label>
                                <select class="form-select">
                                    <option value="Asia/Ho_Chi_Minh" selected>Asia/Ho_Chi_Minh (GMT+7)</option>
                                    <option value="UTC">UTC (GMT+0)</option>
                                    <option value="America/New_York">America/New_York (GMT-5)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ngôn ngữ</label>
                                <select class="form-select">
                                    <option value="vi" selected>Tiếng Việt</option>
                                    <option value="en">English</option>
                                    <option value="zh">中文</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Đơn vị tiền tệ</label>
                                <select class="form-select">
                                    <option value="VND" selected>Việt Nam Đồng (VNĐ)</option>
                                    <option value="USD">US Dollar ($)</option>
                                    <option value="EUR">Euro (€)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Định dạng ngày</label>
                                <select class="form-select">
                                    <option value="dd/MM/yyyy" selected>dd/MM/yyyy</option>
                                    <option value="MM/dd/yyyy">MM/dd/yyyy</option>
                                    <option value="yyyy-MM-dd">yyyy-MM-dd</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn-hotel">
                                    <i class="bi bi-check-circle"></i> Lưu cài đặt
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Notification Settings -->
                <div class="settings-section">
                    <div class="d-flex align-items-center mb-4">
                        <div class="settings-icon text-warning">
                            <i class="bi bi-bell"></i>
                        </div>
                        <div class="ms-3">
                            <h4 class="mb-1">Cài đặt thông báo</h4>
                            <p class="text-muted mb-0">Quản lý các thông báo và cảnh báo hệ thống</p>
                        </div>
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <label class="form-label mb-1">Thông báo email</label>
                                    <p class="text-muted small mb-0">Nhận thông báo qua email</p>
                                </div>
                                <label class="toggle-switch">
                                    <input type="checkbox" checked>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <label class="form-label mb-1">Thông báo SMS</label>
                                    <p class="text-muted small mb-0">Nhận thông báo qua tin nhắn</p>
                                </div>
                                <label class="toggle-switch">
                                    <input type="checkbox">
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <label class="form-label mb-1">Cảnh báo bảo trì</label>
                                    <p class="text-muted small mb-0">Thông báo khi phòng cần bảo trì</p>
                                </div>
                                <label class="toggle-switch">
                                    <input type="checkbox" checked>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <label class="form-label mb-1">Cảnh báo thanh toán</label>
                                    <p class="text-muted small mb-0">Thông báo khi có giao dịch mới</p>
                                </div>
                                <label class="toggle-switch">
                                    <input type="checkbox" checked>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Security Settings -->
                <div class="settings-section">
                    <div class="d-flex align-items-center mb-4">
                        <div class="settings-icon text-danger">
                            <i class="bi bi-shield-lock"></i>
                        </div>
                        <div class="ms-3">
                            <h4 class="mb-1">Bảo mật</h4>
                            <p class="text-muted mb-0">Cài đặt bảo mật và quyền truy cập</p>
                        </div>
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Thay đổi mật khẩu</label>
                            <input type="password" class="form-control" placeholder="Nhập mật khẩu hiện tại">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mật khẩu mới</label>
                            <input type="password" class="form-control" placeholder="Nhập mật khẩu mới">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Xác nhận mật khẩu</label>
                            <input type="password" class="form-control" placeholder="Nhập lại mật khẩu mới">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn-hotel-outline w-100" onclick="changePassword()">
                                <i class="bi bi-key"></i> Đổi mật khẩu
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Database Settings -->
                <div class="settings-section">
                    <div class="d-flex align-items-center mb-4">
                        <div class="settings-icon text-info">
                            <i class="bi bi-database"></i>
                        </div>
                        <div class="ms-3">
                            <h4 class="mb-1">Cài đặt cơ sở dữ liệu</h4>
                            <p class="text-muted mb-0">Quản lý và sao lưu dữ liệu hệ thống</p>
                        </div>
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-md-4">
                            <button class="btn-hotel-outline w-100" onclick="backupDatabase()">
                                <i class="bi bi-download"></i> Sao lưu dữ liệu
                            </button>
                        </div>
                        <div class="col-md-4">
                            <button class="btn-hotel-outline w-100" onclick="restoreDatabase()">
                                <i class="bi bi-upload"></i> Khôi phục dữ liệu
                            </button>
                        </div>
                        <div class="col-md-4">
                            <button class="btn-hotel-outline w-100" onclick="optimizeDatabase()">
                                <i class="bi bi-gear"></i> Tối ưu hóa
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showAlert(message, type = 'success') {
            const alertContainer = document.getElementById('alertContainer');
            const alertHtml = `
                <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    <i class="bi bi-${type === 'success' ? 'check-circle' : 'exclamation-triangle'}"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            alertContainer.innerHTML = alertHtml;
            
            // Auto dismiss after 5 seconds
            setTimeout(() => {
                const alert = alertContainer.querySelector('.alert');
                if (alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            }, 5000);
        }

        // Hotel Info Form
        document.getElementById('hotelInfoForm').addEventListener('submit', function(e) {
            e.preventDefault();
            showAlert('Thông tin khách sạn đã được cập nhật thành công!');
        });

        // System Settings Form
        document.getElementById('systemSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            showAlert('Cài đặt hệ thống đã được lưu thành công!');
        });

        function changePassword() {
            showAlert('Mật khẩu đã được thay đổi thành công!');
        }

        function backupDatabase() {
            showAlert('Đang tạo bản sao lưu dữ liệu...', 'info');
            setTimeout(() => {
                showAlert('Sao lưu dữ liệu hoàn tất!');
            }, 2000);
        }

        function restoreDatabase() {
            if (confirm('Bạn có chắc chắn muốn khôi phục dữ liệu? Thao tác này sẽ ghi đè dữ liệu hiện tại.')) {
                showAlert('Đang khôi phục dữ liệu...', 'info');
                setTimeout(() => {
                    showAlert('Khôi phục dữ liệu hoàn tất!');
                }, 2000);
            }
        }

        function optimizeDatabase() {
            showAlert('Đang tối ưu hóa cơ sở dữ liệu...', 'info');
            setTimeout(() => {
                showAlert('Tối ưu hóa cơ sở dữ liệu hoàn tất!');
            }, 2000);
        }

        // Toggle switch functionality
        document.querySelectorAll('.toggle-switch input').forEach(toggle => {
            toggle.addEventListener('change', function() {
                const setting = this.closest('.col-md-6').querySelector('.form-label').textContent;
                const status = this.checked ? 'bật' : 'tắt';
                showAlert(`Đã ${status} ${setting.toLowerCase()}`);
            });
        });
    </script>
</body>

</html>