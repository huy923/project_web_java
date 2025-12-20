<%-- Rooms Management Page --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<jsp:include page="/includes/header.jsp"/>
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
                        <i class="bi bi-door-open"></i> Quản lý phòng
                    </div>
                    <div class="page-subtitle">Quản lý thông tin phòng và theo dõi trạng thái sử dụng</div>
                </div>

                <!-- Statistics Cards -->
                <div class="grid-4 mb-4">
                    <div class="stat-card">
                        <div class="stat-number text-success">
                            <% List<Map<String, Object>> rooms = (List<Map<String, Object>>) request.getAttribute("rooms");
                                    int availableRooms = 0;
                                    if (rooms != null) {
                                    for (Map<String, Object> room : rooms) {
                                        if ("available".equals(room.get("status"))) {
                                            availableRooms++;
                                            }
                                        }
                                    }
                            %>
                            <%= availableRooms %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-check-circle"></i> Trống
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number text-warning">
                            <% int occupiedRooms=0; if (rooms !=null) { for (Map<String, Object> room : rooms) {
                                if ("occupied".equals(room.get("status"))) {
                                    occupiedRooms++;
                                    }
                                }
                            }
                            %>
                            <%= occupiedRooms %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-person-fill"></i> Có khách
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number text-danger">
                            <% int maintenanceRooms=0; if (rooms !=null) { for (Map<String, Object> room : rooms) {
                                if ("maintenance".equals(room.get("status"))) {
                                    maintenanceRooms++;
                                    }
                                }
                            }
                            %>
                            <%= maintenanceRooms %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-tools"></i> Bảo trì
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <% int totalRooms=rooms !=null ? rooms.size() : 0; %>
                            <%= totalRooms %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-door-open"></i> Tổng
                        </div>
                    </div>
                </div>

                <!-- Add Room Form -->
                <div class="card-modern mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-plus-circle"></i> Thêm phòng mới
                    </h5>
                    <form action="<%= request.getContextPath() %>/rooms" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Số phòng</label>
                                <input type="text" name="roomNumber" class="form-control" placeholder="VD: 101" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Loại phòng</label>
                                <select name="roomTypeId" class="form-select" required>
                                    <option value="">Chọn loại</option>
                                    <% 
                                    List<Map<String, Object>> roomTypes = (List<Map<String, Object>>) request.getAttribute("roomTypes");
                                    if (roomTypes != null) {
                                        for (Map<String, Object> type : roomTypes) {
                                    %>
                                    <option value="<%= type.get("room_type_id") %>">
                                        <%= type.get("type_name") %>
                                    </option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Tầng</label>
                                <input type="number" name="floorNumber" class="form-control" placeholder="VD: 1" min="1" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">&nbsp;</label>
                                <button class="btn-modern btn-primary w-100" type="submit">
                                    <i class="bi bi-plus"></i> Thêm phòng
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Rooms Grid -->
                <div class="card-modern">
                    <h5 class="mb-4">
                        <i class="bi bi-grid-3x3-gap"></i> Danh sách phòng
                    </h5>
                    <div class="grid-3">
                        <% if (rooms !=null && !rooms.isEmpty()) { for (Map<String, Object> room : rooms) {
                            String status = (String) room.get("status");
                            String statusClass = "";
                            String statusText = "";
                            String statusIcon = "";
                    
                            if ("available".equals(status)) {
                                    statusClass = "badge-available";
                                    statusText = "Trống";
                                    statusIcon = "bi-check-circle";
                            } else if ("occupied".equals(status)) {
                                    statusClass = "badge-occupied";
                                    statusText = "Có khách";
                                    statusIcon = "bi-person-fill";
                            } else if ("maintenance".equals(status)) {
                                    statusClass = "badge-maintenance";
                                    statusText = "Bảo trì";
                                    statusIcon = "bi-tools";
                            } else if ("cleaning".equals(status)) {
                                    statusClass = "badge-cleaning";
                                    statusText = "Dọn phòng";
                                    statusIcon = "bi-brush";
                            }
                        %>
                        <div class="card-compact">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h6 class="mb-1">Phòng <%= room.get("room_number") %>
                                    </h6>
                                    <p class="text-muted mb-0" style="font-size: 12px;">Tầng <%= room.get("floor_number") %>
                                    </p>
                                </div>
                                <span class="badge-status <%= statusClass %>">
                                    <i class="bi <%= statusIcon %>"></i>
                                    <%= statusText %>
                                </span>
                            </div>
                            <div class="mb-3 pb-3 border-bottom">
                                <p class="mb-1"><small class="text-muted">Loại:</small></p>
                                <p class="mb-0"><strong>
                                        <%= room.get("type_name") %>
                                    </strong></p>
                                    <p class="mb-0"><small class="text-success">
                                            <%= String.format("%,d", ((java.math.BigDecimal) room.get("base_price")).longValue()) %> VNĐ/đêm
                                        </small></p>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <form action="<%= request.getContextPath() %>/rooms" method="post" class="flex-grow-1">
                                            <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="roomId" value="<%= room.get("room_id") %>">
                                    <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                                        <option value="available" <%=status.equals("available") ? "selected" : "" %>>Trống</option>
                                        <option value="occupied" <%=status.equals("occupied") ? "selected" : "" %>>Có khách</option>
                                        <option value="maintenance" <%=status.equals("maintenance") ? "selected" : "" %>>Bảo trì</option>
                                        <option value="cleaning" <%=status.equals("cleaning") ? "selected" : "" %>>Dọn phòng</option>
                                    </select>
                                    </form>
                                <form action="<%= request.getContextPath() %>/rooms" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="roomId" value="<%= room.get("room_id") %>">
                                    <button type="submit" class="btn-modern btn-danger btn-sm" onclick="return confirm('Xóa phòng này?')" title="Xóa">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                    </form>
                                    </div>
                        </div>
                        <% } } else { %>
                            <div class="col-12 text-center py-5">
                                <i class="bi bi-inbox" style="font-size: 3rem; color: var(--text-secondary);"></i>
                                <p class="text-muted mt-3">Không có phòng nào</p>
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
