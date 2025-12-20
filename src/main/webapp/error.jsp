<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - Hệ thống quản lý khách sạn</title>
    <link href="<%= request.getContextPath() %>/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/webjars/bootstrap-icons/1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/modern-ui.css">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .error-container {
            background: white;
            border-radius: 16px;
            padding: 60px 40px;
            text-align: center;
            max-width: 600px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            animation: slideUp 0.5s ease;
        }
        
        .error-icon {
            font-size: 80px;
            color: #ef4444;
            margin-bottom: 20px;
            animation: pulse 2s infinite;
        }
        
        .error-title {
            font-size: 32px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 15px;
        }
        
        .error-code {
            font-size: 14px;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 20px;
        }
        
        .error-message {
            font-size: 16px;
            color: #6b7280;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .error-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.7;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">
            <i class="bi bi-exclamation-triangle"></i>
        </div>
        <div class="error-code">🖕</div>
        <div class="error-title">Lỗi rồi sửa đi</div>
        <p class="error-message">
            <% 
                String message = (String) request.getAttribute("message");
                if (message == null || message.isEmpty()) {
                    message = request.getParameter("message");
                }
                if (message == null || message.isEmpty()) {
                    message = "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau hoặc liên hệ bộ phận hỗ trợ.";
                }
            %>
            <%= message %>
        </p>
        <div class="error-actions">
            <a href="<%= request.getContextPath() %>/dashboard" class="btn-modern btn-primary">
                <i class="bi bi-house"></i> Bảng điều khiển
            </a>
            <a href="javascript:history.back()" class="btn-modern btn-ghost">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
        </div>
    </div>
</body>
</html>
