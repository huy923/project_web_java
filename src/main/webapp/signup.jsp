<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    </head>

    <body class="bg-dark text-white">
        <div class="container min-vh-100 d-flex align-items-center justify-content-center">
            <div class="card bg-secondary bg-opacity-25 p-4" style="min-width: 420px;">
                <h4 class="mb-3">Đăng ký tài khoản</h4>
                <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                    <div class="alert alert-danger">
                        <%= error %>
                    </div>
                    <% } %>
                        <form action="<%= request.getContextPath() %>/signup" method="post">
                            <div class="mb-3">
                                <label class="form-label">Họ tên</label>
                                <input class="form-control" name="fullName" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <input class="form-control" name="phone">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Tài khoản</label>
                                <input class="form-control" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mật khẩu</label>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                            <button class="btn btn-primary w-100" type="submit">Đăng ký</button>
                        </form>
                        <div class="mt-3 text-center">
                            <a class="text-white" href="<%= request.getContextPath() %>/login">Đã có tài khoản? Đăng
                                nhập</a>
                        </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>