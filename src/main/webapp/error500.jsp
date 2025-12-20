<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Lỗi máy chủ</title>
    <link href="<%= request.getContextPath() %>/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
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
        
        .error-code {
            font-size: 120px;
            font-weight: 900;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
            line-height: 1;
        }
        
        .error-title {
            font-size: 32px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 15px;
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
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">500</div>
        <div class="error-title">Lỗi máy chủ</div>
        <p class="error-message">
            Đã xảy ra lỗi nội bộ máy chủ. Đội ngũ của chúng tôi đã nhận được thông báo và sẽ khắc phục sớm. Vui lòng thử lại sau.
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
