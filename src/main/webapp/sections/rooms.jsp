<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý phòng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>Quản lý phòng</h4>
        <a class="btn btn-secondary" href="<%= request.getContextPath() %>/dashboard">Quay lại</a>
    </div>
    <!-- Add Room Form -->
    <div class="card bg-secondary bg-opacity-25 p-3 mb-4">
        <h6>Thêm phòng mới</h6>
        <form action="<%= request.getContextPath() %>/room-management" method="post">
            <input type="hidden" name="action" value="add">
            <div class="row g-3">
                <div class="col-md-3">
                    <input type="text" name="roomNumber" class="form-control bg-dark text-white border-secondary"
                        placeholder="Số phòng" required>
                </div>
                <div class="col-md-3">
                    <select name="roomTypeId" class="form-select bg-dark text-white border-secondary" required>
                        <option value="">Chọn loại phòng</option>
                        <% java.util.List<java.util.Map<String, Object>> roomTypes =
                            (java.util.List<java.util.Map<String, Object>>) request.getAttribute("roomTypes");
                                if (roomTypes != null) {
                                for (java.util.Map<String, Object> type : roomTypes) {
                                    %>
                                    <option value="<%= type.get(" room_type_id") %>">
                                        <%= type.get("type_name") %> - <%= type.get("base_price") %> VNĐ/đêm
                                    </option>
                                    <% } } %>
                    </select>
                </div>
                <div class="col-md-3">
                    <input type="number" name="floorNumber" class="form-control bg-dark text-white border-secondary"
                        placeholder="Tầng" min="1" required>
                </div>
                <div class="col-md-3">
                    <button class="btn btn-primary w-100" type="submit">Thêm phòng</button>
                </div>
            </div>
        </form>
    </div>
    <!-- Rooms Table -->
    <div class="card bg-secondary bg-opacity-25 p-3">
        <h6>Danh sách phòng</h6>
        <div class="table-responsive">
            <table class="table table-dark table-striped">
                <thead>
                    <tr>
                        <th>Phòng</th>
                        <th>Loại</th>
                        <th>Trạng thái</th>
                        <th>Giá/đêm</th>
                        <th>Tầng</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% java.util.List<java.util.Map<String, Object>> rooms =
                        (java.util.List<java.util.Map<String, Object>>) request.getAttribute("rooms");
                            if (rooms != null && !rooms.isEmpty()) {
                            for (java.util.Map<String, Object> room : rooms) {
                                String status = (String) room.get("status");
                                String statusClass = status.equals("available") ? "bg-success" :
                                status.equals("occupied") ? "bg-warning" :
                                status.equals("maintenance") ? "bg-danger" : "bg-secondary";
                                String statusText = status.equals("available") ? "Trống" :
                                status.equals("occupied") ? "Có khách" :
                                status.equals("maintenance") ? "Bảo trì" : "Dọn phòng";
                                %>
                                <tr>
                                    <td>
                                        <%= room.get("room_number") %>
                                    </td>
                                    <td>
                                        <%= room.get("type_name") %>
                                    </td>
                                    <td><span class="badge <%= statusClass %>">
                                            <%= statusText %>
                                        </span></td>
                                    <td>
                                        <%= room.get("base_price") %> VNĐ
                                    </td>
                                    <td>
                                        <%= room.get("floor_number") %>
                                    </td>
                                    <td>
                                        <form action="<%= request.getContextPath() %>/room-management" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="roomId" value="<%= room.get(" room_id") %>">
                                            <select name="status" class="form-select form-select-sm bg-dark text-white border-secondary"
                                                onchange="this.form.submit()">
                                                <option value="available" <%=status.equals("available") ? "selected" : "" %>>Trống</option>
                                                <option value="occupied" <%=status.equals("occupied") ? "selected" : "" %>>Có khách</option>
                                                <option value="maintenance" <%=status.equals("maintenance") ? "selected" : "" %>>Bảo trì
                                                </option>
                                                <option value="cleaning" <%=status.equals("cleaning") ? "selected" : "" %>>Dọn phòng
                                                </option>
                                            </select>
                                        </form>
                                        <form action="<%= request.getContextPath() %>/room-management" method="post" class="d-inline ms-1">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="roomId" value="<%= room.get(" room_id") %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger"
                                                onclick="return confirm('Xóa phòng này?')">Xóa</button>
                                        </form>
                                    </td>
                                </tr>
                                <% } } else { %>
                                    <tr>
                                        <td colspan="6" class="text-center text-muted">Không có dữ liệu phòng</td>
                                    </tr>
                                    <% } %>
                                        </tbody>
                                        </table>
        </div>
    </div>
</div>
</body>
</html>


