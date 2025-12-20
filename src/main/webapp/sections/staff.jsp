<%-- Staff Management Page --%>
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
                                                        <i class="bi bi-person-badge"></i> Quản lý nhân viên
                                                    </div>
                                                    <div class="page-subtitle">Quản lý nhân sự và nhân viên khách sạn</div>
                                                </div>

                                                <!-- Statistics -->
                                                <div class="grid-4 mb-4">
                                                    <div class="stat-card">
                                                        <div class="stat-number text-info">
                                                            <% List<Map<String, Object>> staff = (List<Map<String,
                                                                    Object>>) request.getAttribute("staff");
                                                                    int totalStaff = staff != null ? staff.size() : 0;
                                                                    %>
                                                                    <%= totalStaff %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-person-badge"></i> Tổng số nhân viên
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-success">
                                                            <% int activeStaff=0; if (staff !=null) { for (Map<String,
                                                                Object> s : staff) {
                                                                if ("active".equals(s.get("status"))) {
                                                                activeStaff++;
                                                                }
                                                                }
                                                                }
                                                                %>
                                                                <%= activeStaff %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-check-circle"></i> Đang làm
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-warning">
                                                            <% int inactiveStaff=totalStaff - activeStaff; %>
                                                                <%= inactiveStaff %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-pause-circle"></i> Ngừng làm
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-primary">
                                                            0
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-calendar-event"></i> Nghỉ phép
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Add Staff Form -->
                                                <% if (PermissionUtil.hasPermission(session, "users.create" )) { %>
                                                <div class="card-modern mb-4">
                                                    <h5 class="mb-3">
                                                        <i class="bi bi-plus-circle"></i> Thêm nhân viên mới
                                                    </h5>
                                                    <form action="<%= request.getContextPath() %>/staff" method="post"
                                                        class="row g-3">
                                                        <input type="hidden" name="action" value="add">
                                                        <div class="col-md-3">
                                                            <label class="form-label">Tên</label>
                                                            <input type="text" name="firstName" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Họ</label>
                                                            <input type="text" name="lastName" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Chức vụ</label>
                                                            <select name="position" class="form-select" required>
                                                                <option value="">Chọn chức vụ</option>
                                                                <option value="manager">Quản lý</option>
                                                                <option value="receptionist">Lễ tân</option>
                                                                <option value="housekeeping">Buồng phòng</option>
                                                                <option value="maintenance">Bảo trì</option>
                                                                <option value="chef">Đầu bếp</option>
                                                                <option value="waiter">Phục vụ</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">&nbsp;</label>
                                                            <button class="btn-modern btn-primary w-100" type="submit">
                                                                <i class="bi bi-plus"></i> Thêm
                                                            </button>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Số điện thoại</label>
                                                            <input type="tel" name="phone" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Email</label>
                                                            <input type="email" name="email" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Lương</label>
                                                            <input type="number" name="salary" class="form-control"
                                                                step="0.01">
                                                        </div>
                                                    </form>
                                                </div>
                                                <% } %>

                                                <!-- Staff List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> Danh sách nhân viên
                                                    </h5>
                                                    <div class="grid-3">
                                                        <% if (staff !=null && !staff.isEmpty()) { for (Map<String,
                                                            Object> s : staff) {
                                                            String firstName = (String) s.get("first_name");
                                                            String lastName = (String) s.get("last_name");
                                                            String position = (String) s.get("position");
                                                            String status = (String) s.get("status");
                                                            String positionText = "manager".equals(position) ? "Quản lý" :
                                                            "receptionist".equals(position) ? "Lễ tân" :
                                                            "housekeeping".equals(position) ? "Buồng phòng" :
                                                            "maintenance".equals(position) ? "Bảo trì" :
                                                            "chef".equals(position) ? "Đầu bếp" :
                                                            "waiter".equals(position) ? "Phục vụ" : position;
                                                            String statusText = "active".equals(status) ? "Đang làm" :
                                                            "inactive".equals(status) ? "Ngừng làm" : status;
                                                            %>
                                                            <div class="card-compact">
                                                                <div class="mb-3">
                                                                    <h6 class="mb-1">
                                                                        <%= firstName %>
                                                                            <%= lastName %>
                                                                    </h6>
                                                                    <p class="text-muted mb-0" style="font-size: 12px;">
                                                                        <i class="bi bi-briefcase"></i>
                                                                        <%= positionText %>
                                                                    </p>
                                                                </div>
                                                                <div class="mb-3 pb-3 border-bottom">
                                                                    <p class="mb-1"><small
                                                                            class="text-muted">Trạng thái:</small></p>
                                                                    <p class="mb-0"><small>
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
                                                                    <p class="text-muted mt-3">Chưa có nhân viên nào</p>
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