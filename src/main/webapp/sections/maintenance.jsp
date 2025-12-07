<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.util.Map" %>

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
                        <i class="bi bi-tools"></i> Maintenance Management
                    </div>
                    <div class="page-subtitle">Manage and track maintenance records</div>
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
                            <div class="stats-label"><i class="bi bi-exclamation-circle"></i> Reported</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-info">
                                <%= inProgress %>
                            </div>
                            <div class="stats-label"><i class="bi bi-hourglass-split"></i> In Progress</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-success">
                                <%= completed %>
                            </div>
                            <div class="stats-label"><i class="bi bi-check-circle"></i> Completed</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-danger">
                                <%= cancelled %>
                            </div>
                            <div class="stats-label"><i class="bi bi-x-circle"></i> Cancelled</div>
                        </div>
                    </div>
                </div>

                <!-- Add Maintenance Form -->
                <div class="card-modern mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-plus-circle"></i> Report New Maintenance Issue
                    </h5>
                    <form method="post" action="<%= request.getContextPath() %>/maintenance">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Room Number</label>
                                <input type="number" name="roomId" class="form-control" placeholder="Enter Room ID" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Priority</label>
                                <select name="priority" class="form-select" required>
                                    <option value="">Select Priority</option>
                                    <option value="low">Low</option>
                                    <option value="medium">Medium</option>
                                    <option value="high">High</option>
                                    <option value="urgent">Urgent</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn-hotel w-100">
                                    <i class="bi bi-plus"></i> Report Issue
                                </button>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Issue Description</label>
                                <textarea name="issueDescription" class="form-control" rows="3" placeholder="Describe the maintenance issue" required></textarea>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Maintenance Records Table -->
                <div class="card-modern">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Maintenance Records
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-dark table-striped">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> ID</th>
                                    <th><i class="bi bi-door-open"></i> Room</th>
                                    <th><i class="bi bi-chat-square-text"></i> Issue</th>
                                    <th><i class="bi bi-flag"></i> Priority</th>
                                    <th><i class="bi bi-hourglass"></i> Status</th>
                                    <th><i class="bi bi-gear"></i> Actions</th>
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
                                            <span class="badge <%= " urgent".equals(record.get("priority")) ? "bg-danger" : "high"
                                                .equals(record.get("priority")) ? "bg-warning" : "medium" .equals(record.get("priority")) ? "bg-info"
                                                : "bg-secondary" %>">
                                                <%= record.get("priority") %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge <%= " completed".equals(record.get("status")) ? "bg-success" : "in-progress"
                                                .equals(record.get("status")) ? "bg-primary" : "reported" .equals(record.get("status")) ? "bg-warning"
                                                : "bg-secondary" %>">
                                                <%= record.get("status") %>
                                            </span>
                                        </td>
                                        <td>
                                            <form method="post" action="<%= request.getContextPath() %>/maintenance" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="maintenanceId" value="<%= record.get(" maintenance_id") %>">
                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">
                                                    <i class="bi bi-trash"></i> Delete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">No maintenance records</p>
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
