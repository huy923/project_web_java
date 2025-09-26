<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Web App - Trang chủ</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.1);
            padding: 40px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }
        
        h1 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
        }
        
        .welcome-text {
            text-align: center;
            font-size: 1.2em;
            margin-bottom: 30px;
        }
        
        .links {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            transition: all 0.3s ease;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }
        
        .btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }
        
        .info {
            margin-top: 30px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            text-align: center;
        }
        
        .status {
            color: #90EE90;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="main-container p-5">
            <div class="row">
                <div class="col-12 text-center">
                    <h1 class="display-4 mb-4">🚀 My Web Application</h1>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <div class="welcome-text text-center mb-4">
                        <p class="lead">Chào mừng bạn đến với ứng dụng web Java của tôi!</p>
                        <p class="status">✅ Ứng dụng đang chạy với Bootstrap + Hot reload</p>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-12 text-center mb-4">
                    <div class="d-flex justify-content-center gap-3 flex-wrap">
                        <a href="hello" class="btn btn-custom btn-lg">
                            <i class="bi bi-file-text"></i> 📝 Xem Hello Servlet
                        </a>
                        <a href="form.jsp" class="btn btn-custom btn-lg">
                            📋 Bootstrap Form Demo
                        </a>
                        <a href="components.jsp" class="btn btn-custom btn-lg">
                            🎨 Bootstrap Components
                        </a>
                        <button onclick="location.reload();" class="btn btn-custom btn-lg">
                            <i class="bi bi-arrow-clockwise"></i> 🔄 Refresh trang
                        </button>
                        <button class="btn btn-success btn-lg" data-bs-toggle="modal" data-bs-target="#infoModal">
                            📊 Thông tin hệ thống
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Bootstrap Cards -->
            <div class="row mt-4">
                <div class="col-md-4 mb-3">
                    <div class="card info-card text-white">
                        <div class="card-body text-center">
                            <h5 class="card-title">⚡ Performance</h5>
                            <p class="card-text">Hot reload enabled</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="card info-card text-white">
                        <div class="card-body text-center">
                            <h5 class="card-title">🎨 Bootstrap</h5>
                            <p class="card-text">v5.3.2 ready!</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="card info-card text-white">
                        <div class="card-body text-center">
                            <h5 class="card-title">☕ Java</h5>
                            <p class="card-text">Modern web app</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row mt-4">
                <div class="col-12 text-center">
                    <small class="text-light">💡 Thử sửa file này và xem trang tự động cập nhật!</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Modal -->
    <div class="modal fade" id="infoModal" tabindex="-1">
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

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>