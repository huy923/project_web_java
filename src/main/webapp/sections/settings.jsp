<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cài đặt</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-dark text-white">
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4>Cài đặt hệ thống</h4>
                <a class="btn btn-secondary" href="<%= request.getContextPath() %>/dashboard">Quay lại</a>
            </div>
            <div class="card bg-secondary bg-opacity-25 p-3">
                <form class="row g-3">
                    <div class="col-md-6"><input class="form-control" placeholder="Tên khách sạn"></div>
                    <div class="col-md-6"><input class="form-control" placeholder="Email liên hệ"></div>
                    <div class="col-md-12"><button class="btn btn-primary" type="button">Lưu</button></div>
                </form>
            </div>
        </div>
    </body>

    </html>