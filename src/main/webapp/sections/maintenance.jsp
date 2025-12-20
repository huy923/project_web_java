<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.util.Map" %>
            <%@ page import="util.PermissionUtil" %>

<jsp:include page="/includes/header.jsp" />
    <div class="px-2 main-container">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-3 col-md-4 mb-4">
                <jsp:include page="/includes/sidebar.jsp" />
            </div>
            
            <!-- Main Content -->
            <div class="col-lg-9 col-md-8">
                <!-- Messages -->
                <% String successMessage=(String) request.getAttribute("successMessage"); String errorMessage=(String)
                    request.getAttribute("errorMessage"); %>
                    <% if (successMessage !=null) { %>
                    <div class="alert-modern alert-success">
                        <i class="bi bi-check-circle"></i>
                        <span><strong>Thành công!</strong>
                            <%= successMessage %>
                        </span>
                        </div>
                        <% } %>
                            <% if (errorMessage !=null) { %>
                    <div class="alert-modern alert-danger">
                        <i class="bi bi-exclamation-circle"></i>
                        <span><strong>Lỗi!</strong>
                            <%= errorMessage %>
                        </span>
                        </div>
                        <% } %>

                <!-- Header -->
                <div class="page-header">
                    <div class="page-title">
                        <i class="bi bi-tools"></i> Quản lý bảo trì
                    </div>
                    <div class="page-subtitle">Quản lý và theo dõi các yêu cầu/bản ghi bảo trì</div>
                </div>

                <!-- Statistics -->
                <% List<Map<String, Object>> records = (List<Map<String, Object>>) request.getAttribute("records");
                        int reported = 0, inProgress = 0, completed = 0, cancelled = 0;
                        if (records != null) {
                        for (Map<String, Object> record : records) {
                            String status = (String) record.get("status");
                            if ("reported".equals(status)) reported++;
                            else if ("in-progress".equals(status)) inProgress++;
                            else if ("completed".equals(status)) completed++;
                            else if ("cancelled".equals(status)) cancelled++;
                            }
                            }
                            %>
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-warning">
                                <%= reported %>
                            </div>
                            <div class="stats-label"><i class="bi bi-exclamation-circle"></i> Đã báo cáo</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-info">
                                <%= inProgress %>
                            </div>
                            <div class="stats-label"><i class="bi bi-hourglass-split"></i> Đang xử lý</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-success">
                                <%= completed %>
                            </div>
                            <div class="stats-label"><i class="bi bi-check-circle"></i> Hoàn thành</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-danger">
                                <%= cancelled %>
                            </div>
                            <div class="stats-label"><i class="bi bi-x-circle"></i> Đã hủy</div>
                        </div>
                    </div>
                </div>

                <!-- Add Maintenance Form -->
                <% if (PermissionUtil.canCreate(session, "maintenance" )) { %>
                    <div class="card-modern mb-4">
                        <h5 class="mb-3">
                            <i class="bi bi-plus-circle"></i> Báo cáo sự cố bảo trì mới
                            </h5>
                            <form method="post" action="<%= request.getContextPath() %>/maintenance">
                                <input type="hidden" name="action" value="add">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                    <label class="form-label">Số phòng</label>
                                    <input type="number" name="roomId" class="form-control" placeholder="Nhập ID phòng" required>
                                    </div>
                                    <div class="col-md-4">
                                    <label class="form-label">Mức ưu tiên</label>
                                    <select name="priority" class="form-select" required>
                                        <option value="">Chọn mức ưu tiên</option>
                                        <option value="low">Thấp</option>
                                        <option value="medium">Trung bình</option>
                                        <option value="high">Cao</option>
                                        <option value="urgent">Khẩn cấp</option>
                                        </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">&nbsp;</label>
                                    <button type="submit" class="btn-modern btn-primary w-100">
                                        <i class="bi bi-plus"></i> Báo cáo
                                    </button>
                                    </div>
                                    <div class="col-12">
                                    <label class="form-label">Mô tả sự cố</label>
                                    <textarea name="issueDescription" class="form-control" rows="3" placeholder="Mô tả vấn đề bảo trì" required></textarea>
                                    </div>
                                    </div>
                                    </form>
                                    </div>
                <% } %>

                <!-- Maintenance Records Table -->
                <div class="card-modern">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Danh sách bảo trì
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> ID</th>
                                    <th><i class="bi bi-door-open"></i> Phòng</th>
                                    <th><i class="bi bi-chat-square-text"></i> Sự cố</th>
                                    <th><i class="bi bi-flag"></i> Ưu tiên</th>
                                    <th><i class="bi bi-hourglass"></i> Trạng thái</th>
                                    <th><i class="bi bi-gear"></i> Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (records !=null && !records.isEmpty()) { for (Map<String, Object> record : records) {
                                    %>
                                    <tr>
                                        <td>
                                            <%= record.get("maintenance_id") %>
                                        </td>
                                        <td>
                                            <%= record.get("room_number") %>
                                        </td>
                                        <td>
                                            <%= record.get("issue_description") %>
                                        </td>
                                        <td>
                                            <% String priority=(String) record.get("priority"); String priorityText="low" .equals(priority) ? "Thấp" : "medium"
                                                .equals(priority) ? "Trung bình" : "high" .equals(priority) ? "Cao" : "urgent" .equals(priority) ? "Khẩn cấp" :
                                                priority; %>
                                            <span class="badge <%= " urgent".equals(record.get("priority")) ? "bg-danger" : "high"
                                                .equals(record.get("priority")) ? "bg-warning" : "medium" .equals(record.get("priority")) ? "bg-info"
                                                : "bg-secondary" %>">
                                                <%= priorityText %>
                                            </span>
                                        </td>
                                        <td>
                                            <% String status=(String) record.get("status"); String statusText="reported" .equals(status) ? "Đã báo cáo"
                                                : "in-progress" .equals(status) ? "Đang xử lý" : "completed" .equals(status) ? "Hoàn thành" : "cancelled"
                                                .equals(status) ? "Đã hủy" : status; %>
                                            <span class="badge <%= " completed".equals(record.get("status")) ? "bg-success" : "in-progress"
                                                .equals(record.get("status")) ? "bg-primary" : "reported" .equals(record.get("status")) ? "bg-warning"
                                                : "bg-secondary" %>">
                                                <%= statusText %>
                                            </span>
                                        </td>
                                        <td>
                                            <% if (PermissionUtil.canDelete(session, "maintenance" )) { %>
                                                <form method="post" action="<%= request.getContextPath() %>/maintenance" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="maintenanceId" value="<%= record.get(" maintenance_id") %>">
                                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn không?')">
                                                        <i class="bi bi-trash"></i> Xóa
                                                    </button>
                                                    </form>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">Không có bản ghi bảo trì</p>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    
</body>
</html>
