<%-- Users Management Page --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.util.Map" %>
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
                                        <span><strong>Success!</strong>
                                            <%= successMessage %>
                                        </span>
                                    </div>
                                    <% } %>
                                        <% if (errorMessage !=null) { %>
                                            <div class="alert-modern alert-danger">
                                                <i class="bi bi-exclamation-circle"></i>
                                                <span><strong>Error!</strong>
                                                    <%= errorMessage %>
                                                </span>
                                            </div>
                                            <% } %>

                                                <!-- Header -->
                                                <div class="page-header">
                                                    <div class="page-title">
                                                        <i class="bi bi-person-circle"></i> User Management
                                                    </div>
                                                    <div class="page-subtitle">Manage system users and permissions</div>
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
                                                            <i class="bi bi-person-circle"></i> Total Users
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
                                                            <i class="bi bi-check-circle"></i> Active
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-warning">
                                                            <% int inactiveUsers=totalUsers - activeUsers; %>
                                                                <%= inactiveUsers %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-pause-circle"></i> Inactive
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-primary">
                                                            0
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-shield-lock"></i> Admins
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Add User Form -->
                                                <div class="card-modern mb-4">
                                                    <h5 class="mb-3">
                                                        <i class="bi bi-plus-circle"></i> Add New User
                                                    </h5>
                                                    <form action="<%= request.getContextPath() %>/users" method="post"
                                                        class="row g-3">
                                                        <input type="hidden" name="action" value="add">
                                                        <div class="col-md-3">
                                                            <label class="form-label">Username</label>
                                                            <input type="text" name="username" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Email</label>
                                                            <input type="email" name="email" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Role</label>
                                                            <select name="role" class="form-select" required>
                                                                <option value="">Select role</option>
                                                                <option value="admin">Admin</option>
                                                                <option value="manager">Manager</option>
                                                                <option value="staff">Staff</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">&nbsp;</label>
                                                            <button class="btn-modern btn-primary w-100" type="submit">
                                                                <i class="bi bi-plus"></i> Add User
                                                            </button>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Password</label>
                                                            <input type="password" name="password" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Confirm Password</label>
                                                            <input type="password" name="confirmPassword"
                                                                class="form-control" required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Department</label>
                                                            <input type="text" name="department" class="form-control"
                                                                placeholder="Department">
                                                        </div>
                                                    </form>
                                                </div>

                                                <!-- Users List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> System Users
                                                    </h5>
                                                    <div class="grid-3">
                                                        <% if (users !=null && !users.isEmpty()) { for (Map<String,
                                                            Object> u : users) {
                                                            String username = (String) u.get("username");
                                                            String email = (String) u.get("email");
                                                            String role = (String) u.get("role");
                                                            String status = (String) u.get("status");
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
                                                                            class="text-muted">Role:</small></p>
                                                                    <p class="mb-2"><small><strong>
                                                                                <%= role %>
                                                                            </strong></small></p>
                                                                    <p class="mb-0"><small class="text-muted">Status:
                                                                            <%= status %></small></p>
                                                                </div>
                                                                <div class="d-flex gap-2">
                                                                    <button
                                                                        class="btn-modern btn-ghost btn-sm flex-grow-1"
                                                                        type="button">
                                                                        <i class="bi bi-pencil"></i> Edit
                                                                    </button>
                                                                    <button class="btn-modern btn-danger btn-sm"
                                                                        type="button">
                                                                        <i class="bi bi-trash"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                            <% } } else { %>
                                                                <div class="col-12 text-center py-5">
                                                                    <i class="bi bi-inbox"
                                                                        style="font-size: 3rem; color: var(--text-secondary);"></i>
                                                                    <p class="text-muted mt-3">No users available</p>
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