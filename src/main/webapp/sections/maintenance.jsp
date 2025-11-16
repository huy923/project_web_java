<jsp:include page="/includes/header.jsp" />
    <div class="px-2 main-container">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-3 col-md-4 mb-4">
                <jsp:include page="/includes/sidebar.jsp" />
            </div>
            
            <!-- Main Content -->
            <div class="col-lg-9 col-md-8">
                <!-- Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h1 class="display-6 mb-3">
                            <i class="bi bi-tools"></i> Maintenance Management
                        </h1>
                        <p class="lead">Manage and track maintenance records</p>
                    </div>
                </div>

                <!-- Statistics -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-warning">0</div>
                            <div class="stats-label"><i class="bi bi-exclamation-circle"></i> Reported</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-info">0</div>
                            <div class="stats-label"><i class="bi bi-hourglass-split"></i> In Progress</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-success">0</div>
                            <div class="stats-label"><i class="bi bi-check-circle"></i> Completed</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-danger">0</div>
                            <div class="stats-label"><i class="bi bi-x-circle"></i> Cancelled</div>
                        </div>
                    </div>
                </div>

                <!-- Add Maintenance Form -->
                <div class="dashboard-card p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-plus-circle"></i> Report New Maintenance Issue
                    </h5>
                    <form method="post" action="<%= request.getContextPath() %>/maintenance">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Room Number</label>
                                <select name="roomId" class="form-select" required>
                                    <option value="">Select Room</option>
                                    <!-- Populate from database -->
                                </select>
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
                <div class="dashboard-card p-4">
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
                                <tr>
                                    <td colspan="6" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">No maintenance records</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />
</body>
</html>
