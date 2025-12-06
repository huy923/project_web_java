<%-- Staff Management Page --%>
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
                                                        <i class="bi bi-person-badge"></i> Staff Management
                                                    </div>
                                                    <div class="page-subtitle">Manage hotel staff and employees</div>
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
                                                            <i class="bi bi-person-badge"></i> Total Staff
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
                                                            <i class="bi bi-check-circle"></i> Active
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-warning">
                                                            <% int inactiveStaff=totalStaff - activeStaff; %>
                                                                <%= inactiveStaff %>
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
                                                            <i class="bi bi-calendar-event"></i> On Leave
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Add Staff Form -->
                                                <div class="card-modern mb-4">
                                                    <h5 class="mb-3">
                                                        <i class="bi bi-plus-circle"></i> Add New Staff
                                                    </h5>
                                                    <form action="<%= request.getContextPath() %>/staff" method="post"
                                                        class="row g-3">
                                                        <input type="hidden" name="action" value="add">
                                                        <div class="col-md-3">
                                                            <label class="form-label">First Name</label>
                                                            <input type="text" name="firstName" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Last Name</label>
                                                            <input type="text" name="lastName" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Position</label>
                                                            <select name="position" class="form-select" required>
                                                                <option value="">Select position</option>
                                                                <option value="manager">Manager</option>
                                                                <option value="receptionist">Receptionist</option>
                                                                <option value="housekeeping">Housekeeping</option>
                                                                <option value="maintenance">Maintenance</option>
                                                                <option value="chef">Chef</option>
                                                                <option value="waiter">Waiter</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">&nbsp;</label>
                                                            <button class="btn-modern btn-primary w-100" type="submit">
                                                                <i class="bi bi-plus"></i> Add
                                                            </button>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Phone</label>
                                                            <input type="tel" name="phone" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Email</label>
                                                            <input type="email" name="email" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Salary</label>
                                                            <input type="number" name="salary" class="form-control"
                                                                step="0.01">
                                                        </div>
                                                    </form>
                                                </div>

                                                <!-- Staff List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> Staff Members
                                                    </h5>
                                                    <div class="grid-3">
                                                        <% if (staff !=null && !staff.isEmpty()) { for (Map<String,
                                                            Object> s : staff) {
                                                            String firstName = (String) s.get("first_name");
                                                            String lastName = (String) s.get("last_name");
                                                            String position = (String) s.get("position");
                                                            String status = (String) s.get("status");
                                                            %>
                                                            <div class="card-compact">
                                                                <div class="mb-3">
                                                                    <h6 class="mb-1">
                                                                        <%= firstName %>
                                                                            <%= lastName %>
                                                                    </h6>
                                                                    <p class="text-muted mb-0" style="font-size: 12px;">
                                                                        <i class="bi bi-briefcase"></i>
                                                                        <%= position %>
                                                                    </p>
                                                                </div>
                                                                <div class="mb-3 pb-3 border-bottom">
                                                                    <p class="mb-1"><small
                                                                            class="text-muted">Status:</small></p>
                                                                    <p class="mb-0"><small>
                                                                            <%= status %>
                                                                        </small></p>
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
                                                                    <p class="text-muted mt-3">No staff members</p>
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