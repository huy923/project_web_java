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
                            <i class="bi bi-gear"></i> System Settings
                        </h1>
                        <p class="lead">Manage configuration and hotel system settings</p>
                    </div>
                </div>

                <!-- Alert Messages -->
                <div id="alertContainer"></div>

                <!-- Hotel Information Settings -->
                <div class="settings-section card-modern">
                    <div class="d-flex align-items-center mb-4">
                        <div class="settings-icon text-primary">
                            <i class="bi bi-building"></i>
                        </div>
                        <div class="ms-3">
                            <h4 class="mb-1">Hotel Information</h4>
                            <p class="text-muted mb-0">Configure basic hotel information</p>
                        </div>
                    </div>
                    
                    <form id="hotelInfoForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Hotel Name</label>
                                <input type="text" class="form-control" placeholder="Enter hotel name" value="Hotel Paradise">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Contact Email</label>
                                <input type="email" class="form-control" placeholder="Enter contact email" value="contact@hotelparadise.com">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" placeholder="Enter phone number" value="+84 123 456 789">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Address</label>
                                <input type="text" class="form-control" placeholder="Enter address" value="123 ABC Street, District 1, HCMC">
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" rows="3" placeholder="Enter hotel description">A luxury hotel with professional services, located in the city center.</textarea>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle"></i> Save Information
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- System Settings -->
                <div class="settings-section card-modern">
                    <div class="d-flex align-items-center mb-4">
                        <div class="settings-icon text-success">
                            <i class="bi bi-sliders"></i>
                        </div>
                        <div class="ms-3">
                            <h4 class="mb-1">System Settings</h4>
                            <p class="text-muted mb-0">Configure system operation parameters</p>
                        </div>
                    </div>
                    
                    <form id="systemSettingsForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Timezone</label>
                                <select class="form-select">
                                    <option value="Asia/Ho_Chi_Minh" selected>Asia/Ho_Chi_Minh (GMT+7)</option>
                                    <option value="UTC">UTC (GMT+0)</option>
                                    <option value="America/New_York">America/New_York (GMT-5)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Language</label>
                                <select class="form-select">
                                    <option value="en" selected>English</option>
                                    <option value="vi">Tiếng Việt</option>
                                    <option value="zh">中文</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Currency</label>
                                <select class="form-select">
                                    <option value="VND" selected>Vietnamese Dong (VNĐ)</option>
                                    <option value="USD">US Dollar ($)</option>
                                    <option value="EUR">Euro (€)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Date Format</label>
                                <select class="form-select">
                                    <option value="dd/MM/yyyy" selected>dd/MM/yyyy</option>
                                    <option value="MM/dd/yyyy">MM/dd/yyyy</option>
                                    <option value="yyyy-MM-dd">yyyy-MM-dd</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle"></i> Save Settings
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Notification Settings -->
                <div class="settings-section card-modern">
                    <div class="d-flex align-items-center mb-4">
                        <div class="settings-icon text-warning">
                            <i class="bi bi-bell"></i>
                        </div>
                        <div class="ms-3">
                            <h4 class="mb-1">Notification Settings</h4>
                            <p class="text-muted mb-0">Manage system notifications and alerts</p>
                        </div>
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <label class="form-label mb-1">Email Notifications</label>
                                    <p class="text-muted small mb-0">Receive notifications via email</p>
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
                                    <label class="form-label mb-1">SMS Notifications</label>
                                    <p class="text-muted small mb-0">Receive notifications via SMS</p>
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
                                    <label class="form-label mb-1">Maintenance Alerts</label>
                                    <p class="text-muted small mb-0">Alert when room needs maintenance</p>
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
                                    <label class="form-label mb-1">Payment Alerts</label>
                                    <p class="text-muted small mb-0">Alert when new transaction occurs</p>
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
                            <h4 class="mb-1">Security</h4>
                            <p class="text-muted mb-0">Security settings and access permissions</p>
                        </div>
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Change Password</label>
                            <input type="password" class="form-control" placeholder="Enter current password">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">New Password</label>
                            <input type="password" class="form-control" placeholder="Enter new password">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Confirm Password</label>
                            <input type="password" class="form-control" placeholder="Re-enter new password">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn-hotel-outline w-100" onclick="changePassword()">
                                <i class="bi bi-key"></i> Change Password
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
                            <h4 class="mb-1">Database Settings</h4>
                            <p class="text-muted mb-0">Manage and backup system data</p>
                        </div>
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-md-4">
                            <button class="btn-hotel-outline w-100" onclick="backupDatabase()">
                                <i class="bi bi-download"></i> Backup Data
                            </button>
                        </div>
                        <div class="col-md-4">
                            <button class="btn-hotel-outline w-100" onclick="restoreDatabase()">
                                <i class="bi bi-upload"></i> Restore Data
                            </button>
                        </div>
                        <div class="col-md-4">
                            <button class="btn-hotel-outline w-100" onclick="optimizeDatabase()">
                                <i class="bi bi-gear"></i> Optimize
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
            showAlert('Hotel information updated successfully!');
        });

        // System Settings Form
        document.getElementById('systemSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            showAlert('System settings saved successfully!');
        });

        function changePassword() {
            showAlert('Password changed successfully!');
        }

        function backupDatabase() {
            showAlert('Creating data backup...', 'info');
            setTimeout(() => {
                showAlert('Data backup completed!');
            }, 2000);
        }

        function restoreDatabase() {
            if (confirm('Are you sure you want to restore data? This will overwrite current data.')) {
                showAlert('Restoring data...', 'info');
                setTimeout(() => {
                    showAlert('Data restore completed!');
                }, 2000);
            }
        }

        function optimizeDatabase() {
            showAlert('Optimizing database...', 'info');
            setTimeout(() => {
                showAlert('Database optimization completed!');
            }, 2000);
        }

        // Toggle switch functionality
        document.querySelectorAll('.toggle-switch input').forEach(toggle => {
            toggle.addEventListener('change', function() {
                const setting = this.closest('.col-md-6').querySelector('.form-label').textContent;
                const status = this.checked ? 'enabled' : 'disabled';
                showAlert(`${setting} ${status}`);
            });
        });
    </script>
</body>

</html>