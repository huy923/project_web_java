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
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Success!</strong>
                            <%= successMessage %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>
                            <% if (errorMessage !=null) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <strong>Error!</strong>
                                    <%= errorMessage %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>

                <!-- Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h1 class="display-6 mb-3">
                            <i class="bi bi-bag-check"></i> Services Management
                        </h1>
                        <p class="lead">Manage hotel services and add-ons</p>
                    </div>
                </div>

                <!-- Statistics -->
                <% List<Map<String, Object>> services = (List<Map<String, Object>>) request.getAttribute("services");
                        int totalServices = services != null ? services.size() : 0;
                        double totalRevenue = 0;
                        java.util.Set<String> categories = new java.util.HashSet<>();
                                if (services != null) {
                                for (Map<String, Object> service : services) {
                                    Double price = Double.parseDouble(service.get("price").toString());
                                    totalRevenue += price;
                                    categories.add((String) service.get("category"));
                                    }
                                    }
                                    %>
                <div class="row mb-4">
                    <div class="col-lg-4 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-success">
                                <%= totalServices %>
                            </div>
                            <div class="stats-label"><i class="bi bi-check-circle"></i> Active Services</div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-info">
                                <%= categories.size() %>
                            </div>
                            <div class="stats-label"><i class="bi bi-bar-chart"></i> Total Categories</div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-warning">$<%= String.format("%.2f", totalRevenue) %>
                            </div>
                            <div class="stats-label"><i class="bi bi-coin"></i> Total Revenue</div>
                        </div>
                    </div>
                </div>

                <!-- Add Service Form -->
                <div class="dashboard-card p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-plus-circle"></i> Add New Service
                    </h5>
                    <form method="post" action="<%= request.getContextPath() %>/services">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Service Name</label>
                                <input type="text" name="serviceName" class="form-control" placeholder="e.g. Spa Treatment" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Category</label>
                                <select name="category" class="form-select" required>
                                    <option value="">Select Category</option>
                                    <option value="food">Food & Beverage</option>
                                    <option value="spa">Spa & Wellness</option>
                                    <option value="laundry">Laundry</option>
                                    <option value="transportation">Transportation</option>
                                    <option value="entertainment">Entertainment</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Price</label>
                                <input type="number" name="price" class="form-control" placeholder="Enter price" step="0.01" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" rows="3" placeholder="Describe the service"></textarea>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn-hotel">
                                    <i class="bi bi-plus"></i> Add Service
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Services Table -->
                <div class="dashboard-card p-4">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> All Services
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-dark table-striped">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> ID</th>
                                    <th><i class="bi bi-bag-check"></i> Service Name</th>
                                    <th><i class="bi bi-tag"></i> Category</th>
                                    <th><i class="bi bi-currency-dollar"></i> Price</th>
                                    <th><i class="bi bi-gear"></i> Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (services !=null && !services.isEmpty()) { for (Map<String, Object> service : services) {
                                    %>
                                    <tr>
                                        <td>
                                            <%= service.get("service_id") %>
                                        </td>
                                        <td>
                                            <%= service.get("service_name") %>
                                        </td>
                                        <td>
                                            <span class="badge bg-info">
                                                <%= service.get("category") %>
                                            </span>
                                        </td>
                                        <td>$<%= String.format("%.2f", service.get("price")) %>
                                        </td>
                                        <td>
                                            <form method="post" action="<%= request.getContextPath() %>/services" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="serviceId" value="<%= service.get(" service_id") %>">
                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">
                                                    <i class="bi bi-trash"></i> Delete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">No services added</p>
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

    <jsp:include page="/includes/footer.jsp" />
