<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý khách hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-dark text-white">
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4>Quản lý khách hàng</h4>
                <a class="btn btn-secondary" href="<%= request.getContextPath() %>/dashboard">Quay lại</a>
            </div>
            <div class="card bg-secondary bg-opacity-25 p-3">
                <form class="row g-3">
                    <div class="col-md-4"><input class="form-control" placeholder="Họ tên"></div>
                    <div class="col-md-4"><input class="form-control" placeholder="CMND/CCCD"></div>
                    <div class="col-md-4"><button class="btn btn-primary w-100" type="button">Thêm</button></div>
                </form>
            </div>
            <div class="mt-4">
                <table class="table table-dark table-striped">
                    <thead>
                        <tr>
                            <th>Họ tên</th>
                            <th>CMND</th>
                            <th>SĐT</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Nguyễn Văn A</td>
                            <td>123456789</td>
                            <td>0123456789</td>
                            <td><button class="btn btn-sm btn-outline-light">Sửa</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </body>

    </html>