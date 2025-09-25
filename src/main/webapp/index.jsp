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
        <h1>🚀 My Web Appl</h1>
        
        <div class="welcome-text">
            <p>Chào mừng bạn đến với ứng dụng web Java của tôi!</p>
            <p class="status">✅ Ứng dụng đang chạy với hot reload</p>
        </div>
        
        <div class="links">
            <a href="hello" class="btn">📝 Xem Hello Servlet</a>
            <a href="#" class="btn" onclick="location.reload();">🔄 Refresh trang</a>
        </div>
        
        <div class="info">
            <h3>📊 Thông tin hệ thống:</h3>
            <p><strong>Thời gian:</strong> <%= new Date() %></p>
            <p><strong>Server Info:</strong> <%= application.getServerInfo() %></p>
            <p><strong>Java Version:</strong> <%= System.getProperty("java.version") %></p>
        </div>
        
        <div style="margin-top: 20px; text-align: center; font-size: 0.9em; opacity: 0.8;">
            <p>💡 Thử sửa file này và xem trang tự động cập nhật!</p>
        </div>
    </div>
</body>
</html>