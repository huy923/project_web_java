<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bootstrap Components Demo</title>
    
    <!-- Bootstrap CSS -->
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"> -->
    <!-- Bootstrap Icons -->
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet"> -->
    <!-- Custom CSS -->
    <link href="css/custom.css" rel="stylesheet">
    <link href="/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="/webjars/bootstrap-icons/1.11.1/font/bootstrap-icons.css" rel="stylesheet">    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .demo-section {
            margin-bottom: 3rem;
        }
        .section-title {
            color: white;
            margin-bottom: 1.5rem;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-glass fixed-top">
        <div class="container">
            <a class="navbar-brand text-white fw-bold" href="#">
                <i class="bi bi-bootstrap-fill"></i> Bootstrap Demo
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="index.jsp">
                            <i class="bi bi-house"></i> Trang chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="form.jsp">
                            <i class="bi bi-file-text"></i> Form
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white active" href="components.jsp">
                            <i class="bi bi-grid"></i> Components
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5 pt-5">
        <!-- Header -->
        <div class="text-center text-white mb-5 fade-in-up">
            <h1 class="display-3 fw-bold">🎨 Bootstrap Components</h1>
            <p class="lead">Khám phá các thành phần Bootstrap trong Java Web App</p>
        </div>

        <!-- Alerts Section -->
        <div class="demo-section">
            <h2 class="section-title">📢 Alerts</h2>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill"></i>
                        <strong>Thành công!</strong> Bạn đã kết nối Bootstrap thành công.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="alert alert-info" role="alert">
                        <i class="bi bi-info-circle-fill"></i>
                        <strong>Thông tin:</strong> Đây là alert với Bootstrap Icons.
                    </div>
                </div>
            </div>
        </div>

        <!-- Cards Section -->
        <div class="demo-section">
            <h2 class="section-title">🃏 Cards</h2>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card glass-card text-white hover-lift">
                        <div class="card-body text-center">
                            <i class="bi bi-speedometer2 display-4 mb-3"></i>
                            <h5 class="card-title">Performance</h5>
                            <p class="card-text">Ứng dụng được tối ưu hóa cho hiệu suất cao.</p>
                            <button class="btn btn-gradient-primary">Xem chi tiết</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card glass-card text-white hover-lift">
                        <div class="card-body text-center">
                            <i class="bi bi-shield-check display-4 mb-3"></i>
                            <h5 class="card-title">Security</h5>
                            <p class="card-text">Bảo mật cao với các tiêu chuẩn hiện đại.</p>
                            <button class="btn btn-gradient-success">Tìm hiểu</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card glass-card text-white hover-lift">
                        <div class="card-body text-center">
                            <i class="bi bi-phone display-4 mb-3"></i>
                            <h5 class="card-title">Responsive</h5>
                            <p class="card-text">Giao diện thích ứng mọi thiết bị.</p>
                            <button class="btn btn-gradient-primary">Khám phá</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Progress Bars -->
        <div class="demo-section">
            <h2 class="section-title">📊 Progress Bars</h2>
            <div class="glass-card p-4">
                <div class="row">
                    <div class="col-md-6">
                        <label class="text-white fw-bold">Java Development</label>
                        <div class="progress mb-3" style="height: 20px;">
                            <div class="progress-bar progress-gradient" style="width: 85%">85%</div>
                        </div>
                        
                        <label class="text-white fw-bold">Bootstrap CSS</label>
                        <div class="progress mb-3" style="height: 20px;">
                            <div class="progress-bar bg-success" style="width: 90%">90%</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-white fw-bold">JSP/Servlet</label>
                        <div class="progress mb-3" style="height: 20px;">
                            <div class="progress-bar bg-info" style="width: 75%">75%</div>
                        </div>
                        
                        <label class="text-white fw-bold">Maven</label>
                        <div class="progress mb-3" style="height: 20px;">
                            <div class="progress-bar bg-warning" style="width: 80%">80%</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Badges and Buttons -->
        <div class="demo-section">
            <h2 class="section-title">🏷️ Badges & Buttons</h2>
            <div class="glass-card p-4 text-center">
                <h4 class="text-white mb-3">
                    Java Web App 
                    <span class="badge badge-gradient">v1.0</span>
                    <span class="badge bg-success">Active</span>
                </h4>
                
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-gradient-primary">
                        <i class="bi bi-play-fill"></i> Start
                    </button>
                    <button type="button" class="btn btn-outline-light">
                        <i class="bi bi-pause-fill"></i> Pause
                    </button>
                    <button type="button" class="btn btn-outline-danger">
                        <i class="bi bi-stop-fill"></i> Stop
                    </button>
                </div>
                
                <div class="mt-3">
                    <button class="btn btn-gradient-success btn-lg me-2">
                        <i class="bi bi-download"></i> Download
                    </button>
                    <button class="btn btn-outline-light btn-lg">
                        <i class="bi bi-share"></i> Share
                    </button>
                </div>
            </div>
        </div>

        <!-- Accordion -->
        <div class="demo-section">
            <h2 class="section-title">📋 Accordion</h2>
            <div class="accordion" id="demoAccordion">
                <div class="accordion-item glass-card-dark">
                    <h2 class="accordion-header">
                        <button class="accordion-button glass-card-dark" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne">
                            <i class="bi bi-gear-fill me-2"></i> Cấu hình hệ thống
                        </button>
                    </h2>
                    <div id="collapseOne" class="accordion-collapse collapse show" data-bs-parent="#demoAccordion">
                        <div class="accordion-body">
                            Ứng dụng Java Web được cấu hình với Maven, Tomcat, và Bootstrap. 
                            Hot reload được bật để phát triển nhanh chóng.
                        </div>
                    </div>
                </div>
                <div class="accordion-item glass-card-dark">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed glass-card-dark" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo">
                            <i class="bi bi-code-slash me-2"></i> Công nghệ sử dụng
                        </button>
                    </h2>
                    <div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="#demoAccordion">
                        <div class="accordion-body">
                            <ul>
                                <li>Java Servlet & JSP</li>
                                <li>Bootstrap 5.3.2</li>
                                <li>Bootstrap Icons</li>
                                <li>Maven</li>
                                <li>Apache Tomcat</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="accordion-item glass-card-dark">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed glass-card-dark" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree">
                            <i class="bi bi-lightbulb-fill me-2"></i> Tính năng
                        </button>
                    </h2>
                    <div id="collapseThree" class="accordion-collapse collapse" data-bs-parent="#demoAccordion">
                        <div class="accordion-body">
                            Responsive design, hot reload, form validation, glassmorphism effects, 
                            và các component Bootstrap đầy đủ.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Toast Demo -->
        <div class="demo-section">
            <h2 class="section-title">🍞 Toast Notifications</h2>
            <div class="glass-card p-4 text-center">
                <button type="button" class="btn btn-gradient-primary" onclick="showToast()">
                    <i class="bi bi-bell"></i> Hiển thị Toast
                </button>
            </div>
        </div>

        <!-- Footer -->
        <div class="text-center text-white mt-5 mb-4">
            <p>&copy; 2024 Java Web App với Bootstrap. Made with ❤️</p>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="liveToast" class="toast" role="alert">
            <div class="toast-header">
                <i class="bi bi-check-circle-fill text-success me-2"></i>
                <strong class="me-auto">Thông báo</strong>
                <small>Vừa xong</small>
                <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body">
                🎉 Toast notification với Bootstrap hoạt động tốt!
            </div>
        </div>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function showToast() {
            const toast = new bootstrap.Toast(document.getElementById('liveToast'));
            toast.show();
        }
        
        // Auto-show toast on page load
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(showToast, 1000);
        });
    </script>
</body>
</html>