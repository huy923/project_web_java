<%-- Backup Management Page --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.util.Map" %>
                <%@ page import="util.PermissionUtil" %>
                <jsp:include page="/includes/header.jsp" />

                <div class="px-2 main-container">
                    <div class="row">
                        <div class="col-lg-3 col-md-4 mb-4">
                            <jsp:include page="/includes/sidebar.jsp" />
                        </div>

                        <div class="col-lg-9 col-md-8">
                            <!-- Messages -->
                            <% String successMessage=(String) request.getAttribute("successMessage"); String
                                errorMessage=(String) request.getAttribute("errorMessage"); %>
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
                                                        <i class="bi bi-cloud-download"></i> Sao lưu & Khôi phục
                                                    </div>
                                                    <div class="page-subtitle">Quản lý sao lưu cơ sở dữ liệu và các
                                                        điểm khôi phục</div>
                                                </div>

                                                <!-- Statistics -->
                                                <div class="grid-4 mb-4">
                                                    <div class="stat-card">
                                                        <div class="stat-number text-info">
                                                            <% List<Map<String, Object>> backups = (List<Map<String,
                                                                    Object>>) request.getAttribute("backups");
                                                                    int totalBackups = backups != null ? backups.size()
                                                                    : 0;
                                                                    %>
                                                                    <%= totalBackups %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-cloud-download"></i> Tổng số bản sao lưu
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-success">
                                                            0
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-check-circle"></i> Thành công
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-warning">
                                                            0
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-exclamation-triangle"></i> Thất bại
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-primary">
                                                            0 GB
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-hdd"></i> Tổng dung lượng
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Backup Actions -->
                                                <% if (PermissionUtil.hasPermission(session, "settings.system" )) { %>
                                                <div class="card-modern mb-4">
                                                    <h5 class="mb-3">
                                                        <i class="bi bi-gear"></i> Tác vụ sao lưu
                                                    </h5>
                                                    <div class="row g-3">
                                                        <div class="col-md-6">
                                                            <form action="<%= request.getContextPath() %>/backup"
                                                                method="post" class="d-flex gap-2">
                                                                <input type="hidden" name="action" value="create">
                                                                <input type="text" name="backupName"
                                                                    class="form-control"
                                                                    placeholder="Tên bản sao lưu (tùy chọn)">
                                                                <button class="btn-modern btn-success" type="submit">
                                                                    <i class="bi bi-cloud-upload"></i> Tạo sao lưu
                                                                </button>
                                                            </form>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <form action="<%= request.getContextPath() %>/backup"
                                                                method="post" class="d-flex gap-2">
                                                                <input type="hidden" name="action" value="schedule">
                                                                <select name="scheduleType" class="form-select">
                                                                    <option value="">Chọn lịch</option>
                                                                    <option value="daily">Hàng ngày</option>
                                                                    <option value="weekly">Hàng tuần</option>
                                                                    <option value="monthly">Hàng tháng</option>
                                                                </select>
                                                                <button class="btn-modern btn-info" type="submit">
                                                                    <i class="bi bi-calendar-event"></i> Lên lịch
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Backups List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> Lịch sử sao lưu
                                                    </h5>
                                                    <div class="grid-2">
                                                        <% if (backups !=null && !backups.isEmpty()) { for (Map<String,
                                                            Object> b : backups) {
                                                            String backupName = (String) b.get("backup_name");
                                                            String date = (String) b.get("date");
                                                            String size = (String) b.get("size");
                                                            String status = (String) b.get("status");
                                                            String statusText = "success".equals(status) ? "Thành công" :
                                                            "failed".equals(status) ? "Thất bại" : status;
                                                            %>
                                                            <div class="card-compact">
                                                                <div class="mb-3">
                                                                    <div
                                                                        class="d-flex justify-content-between align-items-start">
                                                                        <div>
                                                                            <h6 class="mb-1">
                                                                                <%= backupName %>
                                                                            </h6>
                                                                            <p class="text-muted mb-0"
                                                                                style="font-size: 12px;">
                                                                                <%= date %>
                                                                            </p>
                                                                        </div>
                                                                        <% String badgeClass="success" .equals(status)
                                                                            ? "badge-success" : "badge-danger" ; %>
                                                                            <span class="badge <%= badgeClass %>">
                                                                                <%= statusText %>
                                                                            </span>
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3 pb-3 border-bottom">
                                                                    <p class="mb-1"><small
                                                                            class="text-muted">Dung lượng:</small></p>
                                                                    <p class="mb-0"><small><strong>
                                                                                <%= size %>
                                                                            </strong></small></p>
                                                                </div>
                                                                <div class="d-flex gap-2">
                                                                    <% if (PermissionUtil.hasPermission(session, "settings.system" )) { %>
                                                                    <button
                                                                        class="btn-modern btn-ghost btn-sm flex-grow-1"
                                                                        type="button">
                                                                        <i class="bi bi-arrow-counterclockwise"></i>
                                                                        Khôi phục
                                                                    </button>
                                                                    <button class="btn-modern btn-danger btn-sm"
                                                                        type="button">
                                                                        <i class="bi bi-trash"></i>
                                                                    </button>
                                                                    <% } %>
                                                                </div>
                                                            </div>
                                                            <% } } else { %>
                                                                <div class="col-12 text-center py-5">
                                                                    <i class="bi bi-inbox"
                                                                        style="font-size: 3rem; color: var(--text-secondary);"></i>
                                                                    <p class="text-muted mt-3">Chưa có bản sao lưu nào</p>
                                                                </div>
                                                                <% } %>
                                                    </div>
                                                </div>
                                                <% } %>
                        </div>
                    </div>
                </div>

                </body>

                </html>