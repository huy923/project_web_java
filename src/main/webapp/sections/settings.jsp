<%-- Settings Management Page --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
    <jsp:include page="/includes/header.jsp" />
    <div class="px-2 main-container">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-3 col-md-4 mb-4">
                <jsp:include page="/includes/sidebar.jsp" />
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