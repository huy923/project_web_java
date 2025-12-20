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
                        <i class="bi bi-box-seam"></i> Quản lý kho
                    </div>
                    <div class="page-subtitle">Theo dõi và quản lý hàng tồn kho và vật tư khách sạn</div>
                </div>

                <!-- Statistics -->
                <% List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("items");
                        Integer lowStockCount = (Integer) request.getAttribute("lowStockCount");
                        if (lowStockCount == null) lowStockCount = 0;
                
                        int totalItems = items != null ? items.size() : 0;
                        int inStock = 0, outOfStock = 0;
                        if (items != null) {
                        for (Map<String, Object> item : items) {
                            int stock = Integer.parseInt(item.get("current_stock").toString());
                            if (stock > 0) inStock++;
                            else outOfStock++;
                            }
                            }
                            %>
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-info">
                                <%= totalItems %>
                            </div>
                            <div class="stats-label"><i class="bi bi-box-seam"></i> Tổng mặt hàng</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-warning">
                                <%= lowStockCount %>
                            </div>
                            <div class="stats-label"><i class="bi bi-exclamation-circle"></i> Sắp hết hàng</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-success">
                                <%= inStock %>
                            </div>
                            <div class="stats-label"><i class="bi bi-check-circle"></i> Còn hàng</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-danger">
                                <%= outOfStock %>
                            </div>
                            <div class="stats-label"><i class="bi bi-x-circle"></i> Hết hàng</div>
                        </div>
                    </div>
                </div>

                <!-- Add Inventory Item Form -->
                <% if (PermissionUtil.canCreate(session, "inventory" )) { %>
                    <div class="card-modern mb-4">
                        <h5 class="mb-3">
                            <i class="bi bi-plus-circle"></i> Thêm mặt hàng mới
                            </h5>
                            <form method="post" action="<%= request.getContextPath() %>/inventory">
                                <input type="hidden" name="action" value="add">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                    <label class="form-label">Tên mặt hàng</label>
                                    <input type="text" name="itemName" class="form-control" placeholder="VD: Khăn tắm" required>
                                    </div>
                                    <div class="col-md-3">
                                    <label class="form-label">Danh mục</label>
                                    <select name="category" class="form-select" required>
                                        <option value="">Chọn danh mục</option>
                                        <option value="linen">Đồ vải</option>
                                        <option value="amenities">Tiện nghi</option>
                                        <option value="food">Thực phẩm</option>
                                        <option value="cleaning">Vệ sinh</option>
                                        <option value="other">Khác</option>
                                        </select>
                                        </div>
                                        <div class="col-md-3">
                                    <label class="form-label">Tồn hiện tại</label>
                                    <input type="number" name="currentStock" class="form-control" placeholder="0" min="0" required>
                                    </div>
                                    <div class="col-md-3">
                                    <label class="form-label">Tồn tối thiểu</label>
                                    <input type="number" name="minimumStock" class="form-control" placeholder="10" min="0" required>
                                    </div>
                                    <div class="col-md-4">
                                    <label class="form-label">Đơn giá</label>
                                    <input type="number" name="unitPrice" class="form-control" placeholder="0.00" step="0.01" required>
                                    </div>
                                    <div class="col-md-4">
                                    <label class="form-label">Nhà cung cấp</label>
                                    <input type="text" name="supplier" class="form-control" placeholder="Tên nhà cung cấp">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">&nbsp;</label>
                                    <button type="submit" class="w-100 btn-modern btn-success">
                                        <i class="bi bi-plus"></i> Thêm mặt hàng
                                    </button>
                                    </div>
                                    </div>
                                    </form>
                                    </div>
                <% } %>

                <!-- Low Stock Alert -->
                <% if (lowStockCount> 0) { %>
                <div class="stock-warning mb-4">
                    <i class="bi bi-exclamation-triangle"></i> <strong>Cảnh báo:</strong> Có <%= lowStockCount %> mặt hàng dưới mức tồn tối
                        thiểu
                </div>
                <% } %>

                <!-- Inventory Table -->
                <div class="card-modern">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Danh sách mặt hàng
                    </h5>
                    <div class="table-responsive">
                            <table class="table table-striped " style="border-radius: 20px;">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> ID</th>
                                    <th><i class="bi bi-box-seam"></i> Tên mặt hàng</th>
                                    <th><i class="bi bi-tag"></i> Danh mục</th>
                                    <th><i class="bi bi-bar-chart"></i> Tồn kho</th>
                                    <th><i class="bi bi-currency-dollar"></i> Đơn giá</th>
                                    <th><i class="bi bi-gear"></i> Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (items !=null && !items.isEmpty()) { for (Map<String, Object> item : items) {
                                    %>
                                    <tr>
                                        <td>
                                            <%= item.get("item_id") %>
                                        </td>
                                        <td>
                                            <%= item.get("item_name") %>
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary">
                                                <%= item.get("category") %>
                                            </span>
                                        </td>
                                        <td>
                                            <% int stock=Integer.parseInt(item.get("current_stock").toString()); int
                                                minStock=Integer.parseInt(item.get("minimum_stock").toString()); String stockClass=stock> minStock ?
                                                "text-success" : stock > 0 ? "text-warning" : "text-danger";
                                                %>
                                                <span class="<%= stockClass %>"><strong>
                                                        <%= stock %>
                                                    </strong></span>
                                        </td>
                                        <td>$<%= String.format("%.2f", item.get("unit_price")) %>
                                        </td>
                                        <td>
                                            <% if (PermissionUtil.canDelete(session, "inventory" )) { %>
                                                <form method="post" action="<%= request.getContextPath() %>/inventory" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="inventoryId" value="<%= item.get(" item_id") %>">
                                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn không?')">
                                                        <i class="bi bi-trash"></i> Xóa
                                                    </button>
                                                    </form>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">Không có mặt hàng nào</p>
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
