<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bootstrap WebJars Demo</title>
    
    <!-- Bootstrap CSS từ WebJars (Local) -->
    <link href="/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons từ WebJars (Local) -->
    <link href="/webjars/bootstrap-icons/1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        
        .webjar-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        
        .status-badge {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            border: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="webjar-container p-5">
                    <div class="text-center mb-4">
                        <h1 class="display-4 text-primary">
                            <i class="bi bi-archive-fill"></i> WebJars Demo
                        </h1>
                        <p class="lead text-muted">Bootstrap được tải về local thông qua WebJars</p>
                        <span class="badge status-badge fs-6">
                            <i class="bi bi-check-circle-fill"></i> Bootstrap Local Ready!
                        </span>
                    </div>

                    <!-- Info Cards -->
                    <div class="row mb-4">
                        <div class="col-md-4 mb-3">
                            <div class="card border-primary">
                                <div class="card-body text-center">
                                    <i class="bi bi-download display-4 text-primary"></i>
                                    <h5 class="card-title mt-3">Local Files</h5>
                                    <p class="card-text">Bootstrap files được tải về và lưu trong project</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card border-success">
                                <div class="card-body text-center">
                                    <i class="bi bi-wifi-off display-4 text-success"></i>
                                    <h5 class="card-title mt-3">Offline Ready</h5>
                                    <p class="card-text">Hoạt động không cần internet</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card border-info">
                                <div class="card-body text-center">
                                    <i class="bi bi-gear-fill display-4 text-info"></i>
                                    <h5 class="card-title mt-3">Maven Managed</h5>
                                    <p class="card-text">Quản lý version thông qua Maven</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- WebJars Info Table -->
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="bi bi-info-circle"></i> Thông tin WebJars</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Library</th>
                                            <th>Version</th>
                                            <th>Path</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><i class="bi bi-bootstrap"></i> Bootstrap CSS</td>
                                            <td>5.3.2</td>
                                            <td><code>/webjars/bootstrap/5.3.2/css/bootstrap.min.css</code></td>
                                            <td><span class="badge bg-success">Active</span></td>
                                        </tr>
                                        <tr>
                                            <td><i class="bi bi-bootstrap"></i> Bootstrap JS</td>
                                            <td>5.3.2</td>
                                            <td><code>/webjars/bootstrap/5.3.2/js/bootstrap.bundle.min.js</code></td>
                                            <td><span class="badge bg-success">Active</span></td>
                                        </tr>
                                        <tr>
                                            <td><i class="bi bi-ui-checks"></i> Bootstrap Icons</td>
                                            <td>1.11.1</td>
                                            <td><code>/webjars/bootstrap-icons/1.11.1/font/bootstrap-icons.css</code></td>
                                            <td><span class="badge bg-success">Active</span></td>
                                        </tr>
                                        <tr>
                                            <td><i class="bi bi-code-slash"></i> jQuery</td>
                                            <td>3.7.1</td>
                                            <td><code>/webjars/jquery/3.7.1/jquery.min.js</code></td>
                                            <td><span class="badge bg-success">Ready</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Demo Components -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h4 class="text-center mb-3">🧪 Test Bootstrap Components</h4>
                        </div>
                        <div class="col-md-6 mb-3">
                            <button type="button" class="btn btn-primary w-100" data-bs-toggle="modal" data-bs-target="#testModal">
                                <i class="bi bi-window-plus"></i> Test Modal
                            </button>
                        </div>
                        <div class="col-md-6 mb-3">
                            <button type="button" class="btn btn-success w-100" onclick="showAlert()">
                                <i class="bi bi-bell"></i> Test Alert
                            </button>
                        </div>
                    </div>

                    <!-- Alert Container -->
                    <div id="alertContainer"></div>

                    <!-- Navigation Links -->
                    <div class="text-center">
                        <div class="btn-group" role="group">
                            <a href="index.jsp" class="btn btn-outline-primary">
                                <i class="bi bi-house"></i> Trang chủ
                            </a>
                            <a href="form.jsp" class="btn btn-outline-secondary">
                                <i class="bi bi-file-text"></i> Form Demo
                            </a>
                            <a href="components.jsp" class="btn btn-outline-info">
                                <i class="bi bi-grid"></i> Components
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Test Modal -->
    <div class="modal fade" id="testModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-check-circle text-success"></i> WebJars Test
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-success" role="alert">
                        <h4 class="alert-heading">Thành công! 🎉</h4>
                        <p>Bootstrap đã được tải về local thành công thông qua WebJars.</p>
                        <hr>
                        <p class="mb-0">Modal này hoạt động bằng Bootstrap JS local.</p>
                    </div>
                    
                    <h6>Ưu điểm của WebJars:</h6>
                    <ul>
                        <li>✅ Không phụ thuộc internet</li>
                        <li>✅ Version được quản lý bởi Maven</li>
                        <li>✅ Tự động download khi build</li>
                        <li>✅ Có thể cache hiệu quả</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS từ WebJars (Local) -->
    <script src="/webjars/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery từ WebJars (Local) -->
    <script src="/webjars/jquery/3.7.1/jquery.min.js"></script>
    
    <script>
        function showAlert() {
            const alertHtml = `
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <i class="bi bi-info-circle-fill"></i>
                    <strong>WebJars Alert!</strong> Đây là alert được tạo bằng Bootstrap local.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            document.getElementById('alertContainer').innerHTML = alertHtml;
        }

        // Test jQuery
        $(document).ready(function() {
            console.log('✅ jQuery từ WebJars hoạt động!');
            console.log('✅ Bootstrap từ WebJars hoạt động!');
        });
    </script>
</body>
</html>