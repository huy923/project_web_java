<%-- Complaints Management Page --%>
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
                                                        <i class="bi bi-exclamation-circle"></i> Quản lý khiếu nại
                                                    </div>
                                                    <div class="page-subtitle">Tiếp nhận và xử lý khiếu nại của khách</div>
                                                </div>

                                                <!-- Statistics -->
                                                <div class="grid-4 mb-4">
                                                    <div class="stat-card">
                                                        <div class="stat-number text-danger">
                                                            <% List<Map<String, Object>> complaints = (List<Map<String,
                                                                    Object>>) request.getAttribute("complaints");
                                                                    int totalComplaints = complaints != null ?
                                                                    complaints.size() : 0;
                                                                    %>
                                                                    <%= totalComplaints %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-exclamation-circle"></i> Tổng khiếu nại
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-warning">
                                                            <% int openComplaints=0; if (complaints !=null) { for
                                                                (Map<String, Object> c : complaints) {
                                                                if ("open".equals(c.get("status"))) {
                                                                openComplaints++;
                                                                }
                                                                }
                                                                }
                                                                %>
                                                                <%= openComplaints %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-hourglass-split"></i> Đang mở
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-info">
                                                            <% int inProgressComplaints=0; if (complaints !=null) { for
                                                                (Map<String, Object> c : complaints) {
                                                                if ("in_progress".equals(c.get("status"))) {
                                                                inProgressComplaints++;
                                                                }
                                                                }
                                                                }
                                                                %>
                                                                <%= inProgressComplaints %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-arrow-repeat"></i> Đang xử lý
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-success">
                                                            <% int resolvedComplaints=0; if (complaints !=null) { for
                                                                (Map<String, Object> c : complaints) {
                                                                if ("resolved".equals(c.get("status"))) {
                                                                resolvedComplaints++;
                                                                }
                                                                }
                                                                }
                                                                %>
                                                                <%= resolvedComplaints %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-check-circle"></i> Đã giải quyết
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Add Complaint Form -->
                                                <% if (PermissionUtil.isAdmin(session)) { %>
                                                <div class="card-modern mb-4">
                                                    <h5 class="mb-3">
                                                        <i class="bi bi-plus-circle"></i> Ghi nhận khiếu nại mới
                                                    </h5>
                                                    <form action="<%= request.getContextPath() %>/complaints"
                                                        method="post" class="row g-3">
                                                        <input type="hidden" name="action" value="add">
                                                        <div class="col-md-3">
                                                            <label class="form-label">Tên khách</label>
                                                            <input type="text" name="guestName" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Số phòng</label>
                                                            <input type="text" name="roomNumber" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Danh mục</label>
                                                            <select name="category" class="form-select" required>
                                                                <option value="">Chọn danh mục</option>
                                                                <option value="cleanliness">Vệ sinh</option>
                                                                <option value="noise">Tiếng ồn</option>
                                                                <option value="service">Dịch vụ</option>
                                                                <option value="amenities">Tiện nghi</option>
                                                                <option value="other">Khác</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">&nbsp;</label>
                                                            <button class="btn-modern btn-primary w-100" type="submit">
                                                                <i class="bi bi-plus"></i> Thêm
                                                            </button>
                                                        </div>
                                                        <div class="col-12">
                                                            <label class="form-label">Mô tả</label>
                                                            <textarea name="description" class="form-control" rows="3"
                                                                placeholder="Mô tả khiếu nại..."
                                                                required></textarea>
                                                        </div>
                                                    </form>
                                                </div>
                                                <% } %>

                                                <!-- Complaints List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> Khiếu nại
                                                    </h5>
                                                    <div class="grid-2">
                                                        <% if (complaints !=null && !complaints.isEmpty()) { for
                                                            (Map<String, Object> c : complaints) {
                                                            String guestName = (String) c.get("guest_name");
                                                            String category = (String) c.get("category");
                                                            String status = (String) c.get("status");
                                                            String description = (String) c.get("description");
                                                            String date = (String) c.get("date");
                                                            String categoryText = "cleanliness".equals(category) ? "Vệ sinh" :
                                                            "noise".equals(category) ? "Tiếng ồn" :
                                                            "service".equals(category) ? "Dịch vụ" :
                                                            "amenities".equals(category) ? "Tiện nghi" :
                                                            "other".equals(category) ? "Khác" : category;
                                                            String statusText = "open".equals(status) ? "Đang mở" :
                                                            "in_progress".equals(status) ? "Đang xử lý" :
                                                            "resolved".equals(status) ? "Đã giải quyết" : status;
                                                            %>
                                                            <div class="card-compact">
                                                                <div class="mb-3">
                                                                    <div
                                                                        class="d-flex justify-content-between align-items-start">
                                                                        <div>
                                                                            <h6 class="mb-1">
                                                                                <%= guestName %>
                                                                            </h6>
                                                                            <p class="text-muted mb-0"
                                                                                style="font-size: 12px;">
                                                                                <%= categoryText %> • <%= date %>
                                                                            </p>
                                                                        </div>
                                                                        <% String badgeClass="open" .equals(status)
                                                                            ? "badge-danger" : "in_progress"
                                                                            .equals(status) ? "badge-warning"
                                                                            : "badge-success" ; %>
                                                                            <span class="badge <%= badgeClass %>">
                                                                                <%= statusText %>
                                                                            </span>
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3 pb-3 border-bottom">
                                                                    <p class="mb-0"><small>
                                                                            <%= description %>
                                                                        </small></p>
                                                                </div>
                                                                <div class="d-flex gap-2">
                                                                    <% if (PermissionUtil.isAdmin(session)) { %>
                                                                    <button
                                                                        class="btn-modern btn-ghost btn-sm flex-grow-1"
                                                                        type="button">
                                                                        <i class="bi bi-pencil"></i> Cập nhật
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
                                                                    <p class="text-muted mt-3">Chưa có khiếu nại nào</p>
                                                                </div>
                                                                <% } %>
                                                    </div>
                                                </div>
                        </div>
                    </div>
                </div>

                </body>

                </html>