<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    <link href="/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="/webjars/bootstrap-icons/1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .error-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            padding: 3rem;
            text-align: center;
            max-width: 600px;
        }
        
        .error-icon {
            font-size: 5rem;
            color: #ff6b6b;
            margin-bottom: 1rem;
        }
        
        .error-title {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }
        
        .error-message {
            font-size: 1.1rem;
            margin-bottom: 2rem;
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
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">
            <i class="bi bi-exclamation-triangle"></i>
        </div>
        <div class="error-title">Oops! An Error Occurred</div>
        <p class="error-message">
            <% 
                String message = request.getParameter("message");
                if (message == null || message.isEmpty()) {
                    message = "An unexpected error occurred. Please try again later.";
                }
            %>
            <%= message %>
        </p>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn-hotel">
            <i class="bi bi-house"></i> Go to Dashboard
        </a>
    </div>
</body>
</html>
