<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.util.Map" %>
            <%@ page import="util.PermissionUtil" %>

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
                        <i class="bi bi-bag-check"></i> Quản lý dịch vụ
                    </div>
                    <div class="page-subtitle">Quản lý các dịch vụ và tiện ích bổ sung</div>
                </div>

                <!-- Statistics -->
                <% List<Map<String, Object>> services = (List<Map<String, Object>>) request.getAttribute("services");
                        int totalServices = services != null ? services.size() : 0;
                        double totalRevenue = 0;
                        java.util.Set<String> categories = new java.util.HashSet<String>();
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
                        <div class="stat-card">
                            <div class="stat-number text-success">
                                <%= totalServices %>
                            </div>
                            <div class="stat-label"><i class="bi bi-check-circle"></i> Dịch vụ đang hoạt động</div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-info">
                                <%= categories.size() %>
                            </div>
                            <div class="stat-label"><i class="bi bi-bar-chart"></i> Tổng danh mục</div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-warning">$<%= String.format("%.2f", totalRevenue) %>
                            </div>
                            <div class="stat-label"><i class="bi bi-coin"></i> Tổng doanh thu</div>
                        </div>
                    </div>
                </div>

                <!-- Add Service Form -->
                <% if (PermissionUtil.canCreate(session, "services" )) { %>
                    <div class="card-modern mb-4">
                        <h5 class="mb-3">
                            <i class="bi bi-plus-circle"></i> Thêm dịch vụ mới
                            </h5>
                            <form method="post" action="<%= request.getContextPath() %>/services">
                                <input type="hidden" name="action" value="add">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                    <label class="form-label">Tên dịch vụ</label>
                                    <input type="text" name="serviceName" class="form-control" placeholder="VD: Dịch vụ spa" required>
                                    </div>
                                    <div class="col-md-4">
                                    <label class="form-label">Danh mục</label>
                                    <select name="category" class="form-select" required>
                                        <option value="">Chọn danh mục</option>
                                        <option value="food">Ăn uống</option>
                                        <option value="spa">Spa & chăm sóc sức khỏe</option>
                                        <option value="laundry">Giặt ủi</option>
                                        <option value="transportation">Vận chuyển</option>
                                        <option value="entertainment">Giải trí</option>
                                        <option value="other">Khác</option>
                                        </select>
                                        </div>
                                        <div class="col-md-4">
                                    <label class="form-label">Giá</label>
                                    <input type="number" name="price" class="form-control" placeholder="Nhập giá" step="0.01" required>
                                    </div>
                                    <div class="col-12">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="description" class="form-control" rows="3" placeholder="Mô tả dịch vụ"></textarea>
                                    </div>
                                    <div class="col-12">
                                    <button type="submit" class="btn-modern btn-primary">
                                        <i class="bi bi-plus"></i> Thêm dịch vụ
                                    </button>
                                    </div>
                                    </div>
                                    </form>
                                    </div>
                <% } %>

                <!-- Services Table -->
                <div class="card-modern">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Tất cả dịch vụ
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-light table-striped">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> ID</th>
                                    <th><i class="bi bi-bag-check"></i> Tên dịch vụ</th>
                                    <th><i class="bi bi-tag"></i> Danh mục</th>
                                    <th><i class="bi bi-currency-dollar"></i> Giá</th>
                                    <th><i class="bi bi-gear"></i> Thao tác</th>
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
                                            <% if (PermissionUtil.canDelete(session, "services" )) { %>
                                                <form method="post" action="<%= request.getContextPath() %>/services" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="serviceId" value="<%= service.get(" service_id") %>">
                                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn không?')">
                                                        <i class="bi bi-trash"></i> Xóa
                                                    </button>
                                                    </form>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">Chưa có dịch vụ nào</p>
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

    
