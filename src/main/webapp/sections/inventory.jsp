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
                            <i class="bi bi-box-seam"></i> Inventory Management
                        </h1>
                        <p class="lead">Track and manage hotel inventory and supplies</p>
                    </div>
                </div>

                <!-- Statistics -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-info">0</div>
                            <div class="stats-label"><i class="bi bi-box-seam"></i> Total Items</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-warning">0</div>
                            <div class="stats-label"><i class="bi bi-exclamation-circle"></i> Low Stock</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-success">0</div>
                            <div class="stats-label"><i class="bi bi-check-circle"></i> In Stock</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-danger">0</div>
                            <div class="stats-label"><i class="bi bi-x-circle"></i> Out of Stock</div>
                        </div>
                    </div>
                </div>

                <!-- Add Inventory Item Form -->
                <div class="dashboard-card p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-plus-circle"></i> Add New Inventory Item
                    </h5>
                    <form method="post" action="<%= request.getContextPath() %>/inventory">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Item Name</label>
                                <input type="text" name="itemName" class="form-control" placeholder="e.g. Towels" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Category</label>
                                <select name="category" class="form-select" required>
                                    <option value="">Select Category</option>
                                    <option value="linen">Linen</option>
                                    <option value="amenities">Amenities</option>
                                    <option value="food">Food</option>
                                    <option value="cleaning">Cleaning</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Current Stock</label>
                                <input type="number" name="currentStock" class="form-control" placeholder="0" min="0" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Minimum Stock</label>
                                <input type="number" name="minimumStock" class="form-control" placeholder="10" min="0" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Unit Price</label>
                                <input type="number" name="unitPrice" class="form-control" placeholder="0.00" step="0.01" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Supplier</label>
                                <input type="text" name="supplier" class="form-control" placeholder="Supplier name">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn-hotel w-100">
                                    <i class="bi bi-plus"></i> Add Item
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Low Stock Alert -->
                <div class="stock-warning mb-4">
                    <i class="bi bi-exclamation-triangle"></i> <strong>Alert:</strong> You have 0 items below minimum stock level
                </div>

                <!-- Inventory Table -->
                <div class="dashboard-card p-4">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Inventory Items
                    </h5>
                    <div class="table-responsive">
                            <table class="table table-striped " style="border-radius: 20px;">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> ID</th>
                                    <th><i class="bi bi-box-seam"></i> Item Name</th>
                                    <th><i class="bi bi-tag"></i> Category</th>
                                    <th><i class="bi bi-bar-chart"></i> Stock</th>
                                    <th><i class="bi bi-currency-dollar"></i> Unit Price</th>
                                    <th><i class="bi bi-gear"></i> Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="6" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">No inventory items</p>
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
