<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý khách sạn - Đăng nhập</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        /* Animated background elements */
        body::before {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -100px;
            left: -100px;
            animation: float 6s ease-in-out infinite;
        }

        body::after {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            bottom: -50px;
            right: -50px;
            animation: float 8s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(20px);
            }
        }

        .login-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 420px;
            padding: 20px;
        }

        .login-card {
            background: white; /* Fully opaque white */
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 50px 40px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .login-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 30px;
            color: white;
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }

       .login-header h1 {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            margin-bottom: 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .login-header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            font-size: 14px;
            display: block;
        }

        .form-control {
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            width: 100%;
        }

        .form-control:focus {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 0 rgba(102, 126, 234, 0.1);
            outline: none;
        }

        .form-control::placeholder {
            color: #999;
        }

        .input-group-text {
            background: transparent;
            border: 2px solid #e0e0e0;
            border-right: none;
            color: #667eea;
        }

        .input-group .form-control {
            border-left: none;
        }

        .alert {
            border-radius: 10px;
            border: none;
            margin-bottom: 25px;
            padding: 12px 16px;
            font-size: 14px;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .alert-danger {
            background: #fee;
            color: #c33;
            border-left: 4px solid #c33;
        }

        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px 20px;
            font-weight: 600;
            font-size: 15px;
            color: white;
            width: 100%;
            transition: all 0.3s ease;
            margin-top: 10px;
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .login-footer {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            color: #999;
            font-size: 13px;
        }

        .login-footer i {
            color: #667eea;
            margin-right: 5px;
        }
        .btn-demo {
            background: #f5f5f5;
            color: #333;
            border: none;
            border-radius: 8px;
            padding: 12px 20px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .btn-demo:hover {
            background: #e8e8e8;
            color: #333;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .demo-section {
            text-align: center;
            margin-top: 20px;
        }

        .demo-section p {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .btn-group-demo {
            display: flex;
            gap: 10px;
            justify-content: space-between;
        }
    </style>
</head>

<body>
        <div class="login-card">
            <div class="login-header">
                <div class="login-icon">
                    <i class="bi bi-building"></i>
                </div>
                <h1 >Chào mừng bạn quay lại</h1>
                <p>Hệ thống quản lý khách sạn</p>
            </div>

            <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                <div class="alert alert-danger" role="alert">
                    <i class="bi bi-exclamation-circle"></i> <%= error %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="post">
                <div class="form-group">
                    <label class="form-label" for="username">
                        <i class="bi bi-person"></i> Tên đăng nhập
                    </label>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">
                        <i class="bi bi-lock"></i> Mật khẩu
                    </label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                </div>
                    <button class="btn btn-login" type="submit">
                        <i class="bi bi-box-arrow-in-right"></i> Đăng nhập
                    </button>
            </form>
            <br>
            <hr style="background-color: rgb(99, 99, 99); height: 2px; border: none;">            <!-- demo acc -->
            <div style="text-align: center; color: #666;" class="border-top">
                <p>Tài khoản demo</p>
            </div>
            <div style="display: flex; justify-content: center; gap: 10px; margin-top: 10px;">
             <button type="button" class="btn btn-demo" onclick="accadmin()">
                <strong>Admin</strong><br>
            </button>
        <button type="button" class="btn btn-demo" onclick="accreception()">
            <strong>Reception</strong><br>
        </button>
        </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function accadmin() {
            document.getElementById("username").value = "admin";
            document.getElementById("password").value = "password";
        }
        function accreception() {
            document.getElementById("username").value = "reception";
            document.getElementById("password").value = "password";
        }
    </script>
</body>

</html>