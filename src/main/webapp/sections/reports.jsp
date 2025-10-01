<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Báo cáo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-dark text-white">
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4>Báo cáo</h4>
                <a class="btn btn-secondary" href="<%= request.getContextPath() %>/dashboard">Quay lại</a>
            </div>
            <div class="card bg-secondary bg-opacity-25 p-3">
                <div class="row g-3">
                    <div class="col-md-4"><button class="btn btn-outline-light w-100">Báo cáo công suất phòng</button>
                    </div>
                    <div class="col-md-4"><button class="btn btn-outline-light w-100">Báo cáo doanh thu</button></div>
                    <div class="col-md-4"><button class="btn btn-outline-light w-100">Phân tích khách</button></div>
                </div>
            </div>
            <div class="mt-4">
                <div class="card bg-secondary bg-opacity-25 p-3">
                    <p>Chọn loại báo cáo để xem.</p>
                </div>
            </div>
        </div>
    </body>

    </html>