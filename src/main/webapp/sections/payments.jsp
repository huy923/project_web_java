<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý thanh toán</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-dark text-white">
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4>Quản lý thanh toán</h4>
                <a class="btn btn-secondary" href="<%= request.getContextPath() %>/dashboard">Quay lại</a>
            </div>
            <div class="card bg-secondary bg-opacity-25 p-3">
                <form class="row g-3">
                    <div class="col-md-4"><input class="form-control" placeholder="Mã đặt phòng"></div>
                    <div class="col-md-4"><input class="form-control" placeholder="Số tiền"></div>
                    <div class="col-md-4"><button class="btn btn-primary w-100" type="button">Thêm thanh toán</button>
                    </div>
                </form>
            </div>
            <div class="mt-4">
                <table class="table table-dark table-striped">
                    <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Loại</th>
                            <th>Trạng thái</th>
                            <th>Số tiền</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>PMT001</td>
                            <td>Credit Card</td>
                            <td>Hoàn tất</td>
                            <td>1,800,000</td>
                            <td><button class="btn btn-sm btn-outline-light">Chi tiết</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </body>

    </html>