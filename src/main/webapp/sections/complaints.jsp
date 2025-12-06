<%-- Complaints Management Page --%>
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
                                                        <i class="bi bi-exclamation-circle"></i> Complaints Management
                                                    </div>
                                                    <div class="page-subtitle">Handle and resolve guest complaints</div>
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
                                                            <i class="bi bi-exclamation-circle"></i> Total Complaints
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
                                                            <i class="bi bi-hourglass-split"></i> Open
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
                                                            <i class="bi bi-arrow-repeat"></i> In Progress
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
                                                            <i class="bi bi-check-circle"></i> Resolved
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Add Complaint Form -->
                                                <div class="card-modern mb-4">
                                                    <h5 class="mb-3">
                                                        <i class="bi bi-plus-circle"></i> Log New Complaint
                                                    </h5>
                                                    <form action="<%= request.getContextPath() %>/complaints"
                                                        method="post" class="row g-3">
                                                        <input type="hidden" name="action" value="add">
                                                        <div class="col-md-3">
                                                            <label class="form-label">Guest Name</label>
                                                            <input type="text" name="guestName" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Room Number</label>
                                                            <input type="text" name="roomNumber" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Category</label>
                                                            <select name="category" class="form-select" required>
                                                                <option value="">Select category</option>
                                                                <option value="cleanliness">Cleanliness</option>
                                                                <option value="noise">Noise</option>
                                                                <option value="service">Service</option>
                                                                <option value="amenities">Amenities</option>
                                                                <option value="other">Other</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">&nbsp;</label>
                                                            <button class="btn-modern btn-primary w-100" type="submit">
                                                                <i class="bi bi-plus"></i> Add
                                                            </button>
                                                        </div>
                                                        <div class="col-12">
                                                            <label class="form-label">Description</label>
                                                            <textarea name="description" class="form-control" rows="3"
                                                                placeholder="Describe the complaint..."
                                                                required></textarea>
                                                        </div>
                                                    </form>
                                                </div>

                                                <!-- Complaints List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> Complaints
                                                    </h5>
                                                    <div class="grid-2">
                                                        <% if (complaints !=null && !complaints.isEmpty()) { for
                                                            (Map<String, Object> c : complaints) {
                                                            String guestName = (String) c.get("guest_name");
                                                            String category = (String) c.get("category");
                                                            String status = (String) c.get("status");
                                                            String description = (String) c.get("description");
                                                            String date = (String) c.get("date");
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
                                                                                <%= category %> • <%= date %>
                                                                            </p>
                                                                        </div>
                                                                        <% String badgeClass="open" .equals(status)
                                                                            ? "badge-danger" : "in_progress"
                                                                            .equals(status) ? "badge-warning"
                                                                            : "badge-success" ; %>
                                                                            <span class="badge <%= badgeClass %>">
                                                                                <%= status %>
                                                                            </span>
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3 pb-3 border-bottom">
                                                                    <p class="mb-0"><small>
                                                                            <%= description %>
                                                                        </small></p>
                                                                </div>
                                                                <div class="d-flex gap-2">
                                                                    <button
                                                                        class="btn-modern btn-ghost btn-sm flex-grow-1"
                                                                        type="button">
                                                                        <i class="bi bi-pencil"></i> Update
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
                                                                    <p class="text-muted mt-3">No complaints</p>
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