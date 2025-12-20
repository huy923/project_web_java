<%-- Users Management Page --%>
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
                                                        <i class="bi bi-person-circle"></i> Quản lý người dùng
                                                    </div>
                                                    <div class="page-subtitle">Quản lý người dùng và phân quyền hệ thống</div>
                                                </div>

                                                <!-- Statistics -->
                                                <div class="grid-4 mb-4">
                                                    <div class="stat-card">
                                                        <div class="stat-number text-info">
                                                            <% List<Map<String, Object>> users = (List<Map<String,
                                                                    Object>>) request.getAttribute("users");
                                                                    int totalUsers = users != null ? users.size() : 0;
                                                                    %>
                                                                    <%= totalUsers %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-person-circle"></i> Tổng số người dùng
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-success">
                                                            <% int activeUsers=0; if (users !=null) { for (Map<String,
                                                                Object> u : users) {
                                                                if ("active".equals(u.get("status"))) {
                                                                activeUsers++;
                                                                }
                                                                }
                                                                }
                                                                %>
                                                                <%= activeUsers %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-check-circle"></i> Hoạt động
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-warning">
                                                            <% int inactiveUsers=totalUsers - activeUsers; %>
                                                                <%= inactiveUsers %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-pause-circle"></i> Ngưng hoạt động
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-primary">
                                                            0
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-shield-lock"></i> Quản trị
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Add User Form -->
                                                <% if (PermissionUtil.hasPermission(session, "users.create" )) { %>
                                                <div class="card-modern mb-4">
                                                    <h5 class="mb-3">
                                                        <i class="bi bi-plus-circle"></i> Thêm người dùng mới
                                                    </h5>
                                                    <form action="<%= request.getContextPath() %>/users" method="post"
                                                        class="row g-3">
                                                        <input type="hidden" name="action" value="add">
                                                        <div class="col-md-3">
                                                            <label class="form-label">Tên đăng nhập</label>
                                                            <input type="text" name="username" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Email</label>
                                                            <input type="email" name="email" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Vai trò</label>
                                                            <select name="role" class="form-select" required>
                                                                <option value="">Chọn vai trò</option>
                                                                <option value="admin">Quản trị</option>
                                                                <option value="manager">Quản lý</option>
                                                                <option value="staff">Nhân viên</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">&nbsp;</label>
                                                            <button class="btn-modern btn-primary w-100" type="submit">
                                                                <i class="bi bi-plus"></i> Thêm người dùng
                                                            </button>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Mật khẩu</label>
                                                            <input type="password" name="password" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Xác nhận mật khẩu</label>
                                                            <input type="password" name="confirmPassword"
                                                                class="form-control" required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Bộ phận</label>
                                                            <input type="text" name="department" class="form-control"
                                                                placeholder="Bộ phận">
                                                        </div>
                                                    </form>
                                                </div>
                                                <% } %>

                                                <!-- Users List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> Người dùng hệ thống
                                                    </h5>
                                                    <div class="grid-3">
                                                        <% if (users !=null && !users.isEmpty()) { for (Map<String,
                                                            Object> u : users) {
                                                            String username = (String) u.get("username");
                                                            String email = (String) u.get("email");
                                                            String role = (String) u.get("role");
                                                            String status = (String) u.get("status");
                                                            String roleText = "admin".equals(role) ? "Quản trị" :
                                                            "manager".equals(role) ? "Quản lý" :
                                                            "staff".equals(role) ? "Nhân viên" : role;
                                                            String statusText = "active".equals(status) ? "Hoạt động" :
                                                            "inactive".equals(status) ? "Ngưng hoạt động" : status;
                                                            %>
                                                            <div class="card-compact">
                                                                <div class="mb-3">
                                                                    <h6 class="mb-1">
                                                                        <%= username %>
                                                                    </h6>
                                                                    <p class="text-muted mb-0" style="font-size: 12px;">
                                                                        <i class="bi bi-envelope"></i>
                                                                        <%= email %>
                                                                    </p>
                                                                </div>
                                                                <div class="mb-3 pb-3 border-bottom">
                                                                    <p class="mb-1"><small
                                                                            class="text-muted">Vai trò:</small></p>
                                                                    <p class="mb-2"><small><strong>
                                                                                <%= roleText %>
                                                                            </strong></small></p>
                                                                    <p class="mb-0"><small class="text-muted">Trạng thái:
                                                                            <%= statusText %>
                                                                        </small></p>
                                                                </div>
                                                                <div class="d-flex gap-2">
                                                                    <% if (PermissionUtil.hasPermission(session, "users.edit" )) { %>
                                                                    <button
                                                                        class="btn-modern btn-ghost btn-sm flex-grow-1"
                                                                        type="button">
                                                                        <i class="bi bi-pencil"></i> Sửa
                                                                    </button>
                                                                    <% } %>
                                                                        <% if (PermissionUtil.hasPermission(session, "users.delete" )) { %>
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
                                                                    <p class="text-muted mt-3">Chưa có người dùng nào</p>
                                                                </div>
                                                                <% } %>
                                                    </div>
                                                </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

                </body>

                </html>