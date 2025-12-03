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
                            <i class="bi bi-door-open"></i> Room Management
                        </h1>
                        <p class="lead">Manage room information and track usage status</p>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-success">
                                <% 
                                List<Map<String, Object>> rooms = (List<Map<String, Object>>) request.getAttribute("rooms");
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
                            <div class="stats-label">
                                <i class="bi bi-check-circle"></i> Available Rooms
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-warning">
                                <% 
                                int occupiedRooms = 0;
                                if (rooms != null) {
                                    for (Map<String, Object> room : rooms) {
                                        if ("occupied".equals(room.get("status"))) {
                                            occupiedRooms++;
                                        }
                                    }
                                }
                                %>
                                <%= occupiedRooms %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-person-fill"></i> Occupied
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-danger">
                                <% 
                                int maintenanceRooms = 0;
                                if (rooms != null) {
                                    for (Map<String, Object> room : rooms) {
                                        if ("maintenance".equals(room.get("status"))) {
                                            maintenanceRooms++;
                                        }
                                    }
                                }
                                %>
                                <%= maintenanceRooms %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-tools"></i> Maintenance
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-info">
                                <% 
                                int totalRooms = rooms != null ? rooms.size() : 0;
                                %>
                                <%= totalRooms %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-door-open"></i> Total Rooms
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Add Room Form -->
                <div class="dashboard-card p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-plus-circle"></i> Add New Room
                    </h5>
                    <form action="<%= request.getContextPath() %>/rooms" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Room Number</label>
                                <input type="text" name="roomNumber" class="form-control" placeholder="Enter room number" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Room Type</label>
                                <select name="roomTypeId" class="form-select" required>
                                    <option value="">Select Room Type</option>
                                    <% 
                                    List<Map<String, Object>> roomTypes = (List<Map<String, Object>>) request.getAttribute("roomTypes");
                                    if (roomTypes != null) {
                                        for (Map<String, Object> type : roomTypes) {
                                    %>
                                    <option value="<%= type.get("room_type_id") %>">
                                        <%= type.get("type_name") %> - <%= String.format("%,d", ((java.math.BigDecimal) type.get("base_price")).longValue()) %> VNĐ/đêm
                                    </option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Floor</label>
                                <input type="number" name="floorNumber" class="form-control" placeholder="Enter floor number" min="1" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">&nbsp;</label>
                                <button class="btn-hotel w-100" type="submit">
                                    <i class="bi bi-plus"></i> Add Room
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Rooms Table -->
                <div class="dashboard-card p-4">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Room List
                    </h5>
                    <div class="row" id="roomStatusContainer">
                        <div class="col-12 text-center">
                            <div class="spinner-border text-light" role="status">
                                    <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-2">Loading room data...</p>
                        </div>
                    </div>
                     <div class="table-responsive border-radius-5">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> Số phòng</th>
                                    <th><i class="bi bi-house"></i> Loại phòng</th>
                                    <th><i class="bi bi-flag"></i> Trạng thái</th>
                                    <th><i class="bi bi-currency-dollar"></i> Giá/đêm</th>
                                    <th><i class="bi bi-building"></i> Tầng</th>
                                    <th><i class="bi bi-gear"></i> Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                if (rooms != null && !rooms.isEmpty()) {
                                    for (Map<String, Object> room : rooms) {
                                        String status = (String) room.get("status");
                                        String statusClass = "";
                                        String statusText = "";
                                        String statusIcon = "";
                                        
                                        if ("available".equals(status)) {
                                            statusClass = "status-available";
                                            statusText = "Trống";
                                            statusIcon = "bi-check-circle";
                                        } else if ("occupied".equals(status)) {
                                            statusClass = "status-occupied";
                                            statusText = "Có khách";
                                            statusIcon = "bi-person-fill";
                                        } else if ("maintenance".equals(status)) {
                                            statusClass = "status-maintenance";
                                            statusText = "Bảo trì";
                                            statusIcon = "bi-tools";
                                        } else if ("cleaning".equals(status)) {
                                            statusClass = "status-cleaning";
                                            statusText = "Dọn phòng";
                                            statusIcon = "bi-brush";
                                        }
                                %>
                                <tr>
                                    <td>
                                        <strong>Phòng <%= room.get("room_number") %></strong>
                                    </td>
                                    <td>
                                        <%= room.get("type_name") %>
                                    </td>
                                    <td>
                                        <span class="room-status-badge <%= statusClass %>">
                                            <i class="bi <%= statusIcon %>"></i> <%= statusText %>
                                        </span>
                                    </td>
                                    <td>
                                        <strong><%= String.format("%,d", ((java.math.BigDecimal) room.get("base_price")).longValue()) %> VNĐ</strong>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">Tầng <%= room.get("floor_number") %></span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <form action="<%= request.getContextPath() %>/rooms" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="roomId" value="<%= room.get("room_id") %>">
                                                <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                                                    <option value="available" <%=status.equals("available") ? "selected" : "" %>>Available</option>
                                    <option value="occupied" <%=status.equals("occupied") ? "selected" : "" %>>Occupied</option>
                                    <option value="maintenance" <%=status.equals("maintenance") ? "selected" : "" %>>Maintenance</option>
                                    <option value="cleaning" <%=status.equals("cleaning") ? "selected" : "" %>>Cleaning</option>
                                                </select>
                                            </form>
                                            <button class="btn btn-sm btn-hotel-outline ms-2" onclick="viewRoomDetails('<%= room.get("room_id") %>')" title="View Details">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <form action="<%= request.getContextPath() %>/rooms" method="post" class="d-inline ms-1">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="roomId" value="<%= room.get("room_id") %>">
                                                <button type="submit" class="btn btn-sm btn-hotel-outline" onclick="return confirm('Delete this room?')" title="Delete Room">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <% 
                                    }
                                } else { 
                                %>
                                <tr>
                                    <td colspan="6" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">No room data available</p>
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

    <!-- Room Details Modal -->
    <div class="modal fade" id="roomDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-door-open"></i> Room Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="roomDetailsContent">
                    <!-- Content will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hotel-outline" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        refreshRoomStatus();
        function refreshRoomStatus() {
            const container = document.getElementById('roomStatusContainer');
            const apiUrl = '<%= request.getContextPath() %>/api/room-status';
            fetch(apiUrl)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    console.log(data);
                    console.log('Room status reloaded successfully');
                    container.innerHTML = '';
                    data.forEach((room,index) => {
                        const status = room.status;
                        const statusClass = room.statusClass;
                        const statusIcon = room.statusIcon;
                        const statusText = room.statusText;
                        const roomId = room.roomId;
                        const roomNumber = room.roomNumber;
                        const roomCard = document.createElement('div');
                        roomCard.className = 'col-lg-3 col-md-4 col-sm-6 mb-3 d-flex';
                        roomCard.innerHTML = `
                            <div class="room-card text-center" style="cursor: pointer;" onclick="viewRoomDetails('${roomId}')">
                                <h6 class="mb-2">Room ${roomNumber}</h6>
                                <span class="status-${statusClass}">
                                    <i class="bi ${statusIcon}"></i> ${statusText}
                                </span>
                            </div>
                        `;
                        container.appendChild(roomCard);
                    });
                })
                .catch(error => {
                    console.error('Error loading room status:', error);
                });
        }
        function viewRoomDetails(roomId) {
            const modal = new bootstrap.Modal(document.getElementById('roomDetailsModal'));
            document.getElementById('roomDetailsContent').innerHTML = `
                <div class="text-center">
                    <i class="bi bi-hourglass-split" style="font-size: 3rem;"></i>
                    <p class="mt-3">Loading room information...</p>
                </div>
            `;
            modal.show();
            
            setTimeout(() => {
                document.getElementById('roomDetailsContent').innerHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Room Information</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Room Number:</strong></td><td>${roomId}</td></tr>
                                <tr><td><strong>Type:</strong></td><td>Standard</td></tr>
                                <tr><td><strong>Floor:</strong></td><td>1</td></tr>
                                <tr><td><strong>Price/Night:</strong></td><td>1,200,000 VND</td></tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>Current Status</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Status:</strong></td><td><span class="badge bg-success">Available</span></td></tr>
                                <tr><td><strong>Last Cleaned:</strong></td><td>2024-01-15 10:30</td></tr>
                                <tr><td><strong>Notes:</strong></td><td>Room is clean and ready for guests</td></tr>
                            </table>
                        </div>
                    </div>
                `;
            }, 1000);
        }
    </script>
</body>
</html>


