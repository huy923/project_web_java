<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
                <div class="page-header">
                    <div class="page-title">
                        <i class="bi bi-house-door"></i> Hotel Dashboard
                    </div>
                    <div class="page-subtitle">Welcome to the Hotel Management System</div>
                </div>

                <!-- Statistics Cards -->
                <div class="grid-4 mb-4">
                    <% java.util.Map<String, Integer> roomStats = (java.util.Map<String, Integer>) request.getAttribute("roomStats");
                            Integer totalBookings = (Integer) request.getAttribute("totalBookings");
                            if (roomStats != null) {
                            %>
                    <div class="stat-card">
                        <div class="stat-number text-success">
                            <%= roomStats.get("available") %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-door-open"></i> Available Rooms
                        </div>
                        </div>
                    <div class="stat-card">
                        <div class="stat-number text-warning">
                            <%= roomStats.get("occupied") %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-person-fill"></i> Occupied
                        </div>
                        </div>
                    <div class="stat-card">
                        <div class="stat-number text-info">
                            <%= totalBookings !=null ? totalBookings : 0 %>
                        </div>
                        <div class="stat-label ">
                            <i class="bi bi-calendar-plus"></i> Total Bookings
                        </div>
                        </div>
                    <div class="stat-card">
                        <div class="stat-number text-danger">
                            <%= roomStats.get("maintenance") %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-tools"></i> Maintenance
                        </div>
                        </div>
                    <% } else { %>
                        <div class="col-12">
                            <div class="alert-modern alert-warning">
                                <i class="bi bi-exclamation-triangle"></i>
                                <span>Failed to load room statistics</span>
                            </div>
                        </div>
                        <% } %>
                </div>
                
                <!-- Quick Actions -->
                <div class="card-modern mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-lightning"></i> Quick Actions
                    </h5>
                    <div class="d-flex gap-3 flex-wrap">
                        <a href="<%= request.getContextPath() %>/check-in" class="btn-modern btn-primary">
                            <i class="bi bi-person-plus"></i> Check-in
                        </a>
                        <a href="<%= request.getContextPath() %>/check-out" class="btn-modern btn-success">
                            <i class="bi bi-person-dash"></i> Check-out
                        </a>
                        <a href="<%= request.getContextPath() %>/bookings" class="btn-modern btn-info">
                            <i class="bi bi-calendar-plus"></i> Bookings
                        </a>
                        <a href="<%= request.getContextPath() %>/rooms" class="btn-modern btn-warning">
                            <i class="bi bi-door-open"></i> Rooms
                        </a>
                        <a href="<%= request.getContextPath() %>/guests" class="btn-modern btn-ghost">
                            <i class="bi bi-people"></i> Guests
                        </a>
                        </div>
                        </div>
                                <div class="row">
                                   <!-- Room Status -->
                                    <div class="col-lg-8 mb-4">
                                        <div class="dashboard-card p-4">
                                            <h5 class="mb-3">
                                                <i class="bi bi-grid-3x3"></i> Room Status
                                                <button class="btn btn-sm btn-outline-light ms-2" onclick="refreshRoomStatus()" id="refreshBtn">
                                                    <i class="bi bi-arrow-clockwise"></i> Refresh
                                                </button>
                                            </h5>
                                            <div class="row" id="roomStatusContainer">
                                                <div class="col-12 text-center">
                                                    <div class="spinner-border text-light" role="status">
                                                        <span class="visually-hidden">Loading...</span>
                                                    </div>
                                                    <p class="mt-2">Loading room data...</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <!-- Recent Activity -->
                                <div class="col-lg-4 mb-4">
                                    <div class="dashboard-card p-4">
                                        <h5 class="mb-3">
                                            <i class="bi bi-clock-history"></i> Recent Activities
                                        </h5>
                                        <div class="recent-activity">
                                            <div class="activity-item">
                                                <div class="activity-icon icon-checkin">
                                                    <i class="bi bi-person-plus"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-bold">Check-in Room 205</div>
                                                    <small class="text-muted">Guest A - 10:30</small>
                                                </div>
                                            </div>
                                            <div class="activity-item">
                                                <div class="activity-icon icon-checkout">
                                                    <i class="bi bi-person-dash"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-bold">Check-out Room 103</div>
                                                    <small class="text-muted">Guest B - 09:15</small>
                                                </div>
                                            </div>
                                            <div class="activity-item">
                                                <div class="activity-icon icon-booking">
                                                    <i class="bi bi-calendar-plus"></i>
                                                </div>
                                    <div>
                                        <div class="fw-bold">Booked Room 201</div>
                                        <small class="text-muted">Lê Văn C - 08:45</small>
                                    </div>
                                    </div>
                                <div class="activity-item">
                                    <div class="activity-icon icon-maintenance">
                                        <i class="bi bi-tools"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold">Maintenance Room 105</div>
                                        <small class="text-muted">Staff - 07:20</small>
                                    </div>
                                    </div>
                                    </div>
                                    </div>
                                    </div>
                                    </div>
                                    </div>
                                    </div>
            </div>
        </div>
    </div>

    <!-- Check-in Modal -->
    <div class="modal fade" id="checkInModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-person-plus"></i> Guest Check-in
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%= request.getContextPath() %>/checkin" method="post" id="checkinForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Guest Name</label>
                                <input type="text" name="firstName" class="form-control bg-dark text-white border-secondary" placeholder="Enter full name"
                                    required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">ID/Passport Number</label>
                                <input type="text" name="idNumber" class="form-control bg-dark text-white border-secondary" placeholder="Enter ID/Passport number"
                                    required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Emhttps://img.shields.io/badge/Hotel-Management%20System-blue?style=for-the-badge&logo=hotelil</label>
                                    <input type="email" name="email" class="form-control bg-dark text-white border-secondary" placeholder="Enter email">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" name="phone" class="form-control bg-dark text-white border-secondary" placeholder="Enter phone number" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Room</label>
                                <select name="roomId" class="form-select bg-dark text-white border-secondary" required>
                                    <option value="">Select Room</option>
                                    <% java.util.List<java.util.Map<String, Object>> availableRooms =
                                        (java.util.List<java.util.Map<String, Object>>) request.getAttribute("availableRooms");
                                            if (availableRooms != null) {
                                            for (java.util.Map<String, Object> room : availableRooms) {
                                                %>
                                                <option value="<%= room.get(" room_id") %>">
                                                    <%= room.get("room_number") %> - <%= room.get("type_name") %>
                                                            (<%= room.get("base_price") %> VNĐ/đêm)
                                                </option>
                                                <% } } %>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Adults</label>
                                <input type="number" name="adults" class="form-control bg-dark text-white border-secondary" value="1" min="1" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Children</label>
                                    <input type="number" name="children" class="form-control bg-dark text-white border-secondary" value="0" min="0">
                                </div>
                                <div class="col-md-6 mb-3">
                                <label class="form-label">Ngày nhận phòng</label>
                                <input type="date" name="checkInDate" class="form-control bg-dark text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Check-out Date</label>
                                <input type="date" name="checkOutDate" class="form-control bg-dark text-white border-secondary" required>
                                </div>
                                <div class="col-md-12 mb-3">
                                    <label class="form-label">Total Amount (VND)</label>
                                    <input type="number" name="totalAmount" class="form-control bg-dark text-white border-secondary"
                                        placeholder="Auto-calculated" readonly>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" form="checkinForm" class="btn-hotel">Check-in</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Check-out Modal -->
    <div class="modal fade" id="checkOutModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-person-dash"></i> Guest Check-out
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%= request.getContextPath() %>/checkout" method="post" id="checkoutForm">
                    <div class="mb-3">
                        <label class="form-label">Select Room</label>
                            <select name="bookingId" class="form-select bg-dark text-white border-secondary" required>
                                <option value="">Select Room</option>
                                <% java.util.List<java.util.Map<String, Object>> occupiedRooms =
                                    (java.util.List<java.util.Map<String, Object>>) request.getAttribute("occupiedRooms");
                                        if (occupiedRooms != null) {
                                        for (java.util.Map<String, Object> booking : occupiedRooms) {
                                            %>
                                            <option value="<%= booking.get(" booking_id") %>">
                                                Phòng <%= booking.get("room_number") %> -
                                                    <%= booking.get("first_name") %>
                                                        <%= booking.get("last_name") %>
                                                            (<%= booking.get("phone") %>)
                                            </option>
                                            <% } } %>
                        </select>
                    </div>
                    <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> Tổng tiền: <strong id="checkoutAmount">Chọn phòng để xem</strong>
                    </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" form="checkoutForm" class="btn-hotel">Check-out</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Booking Modal -->
    <div class="modal fade" id="bookingModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-calendar-plus"></i> Đặt phòng mới
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Họ tên</label>
                                <input type="text" class="form-control bg-dark text-white border-secondary">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control bg-dark text-white border-secondary">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Loại phòng</label>
                                <select class="form-select bg-dark text-white border-secondary">
                                    <option>Standard - 1,200,000 VNĐ/đêm</option>
                                    <option>Deluxe - 1,800,000 VNĐ/đêm</option>
                                    <option>Suite - 2,500,000 VNĐ/đêm</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số đêm</label>
                                <input type="number" class="form-control bg-dark text-white border-secondary" value="1">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ngày nhận phòng</label>
                                <input type="date" class="form-control bg-dark text-white border-secondary">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số người</label>
                                <input type="number" class="form-control bg-dark text-white border-secondary" value="1">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn-hotel">Đặt phòng</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Room Management Modal -->
    <div class="modal fade" id="roomModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-door-open"></i> Room Management
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <h6>Add New Room</h6>
                            <form action="<%= request.getContextPath() %>/room-management" method="post">
                                <input type="hidden" name="action" value="add">
                                <div class="mb-3">
                                    <label class="form-label">Room Number</label>
                                    <input type="text" name="roomNumber" class="form-control bg-dark text-white border-secondary" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Room Type</label>
                                    <select name="roomTypeId" class="form-select bg-dark text-white border-secondary" required>
                                        <option value="">Select Room Type</option>
                                        <% java.util.List<java.util.Map<String, Object>> roomTypes =
                                            (java.util.List<java.util.Map<String, Object>>) request.getAttribute("roomTypes");
                                                if (roomTypes != null) {
                                                for (java.util.Map<String, Object> type : roomTypes) {
                                                    %>
                                                    <option value="<%= type.get(" room_type_id") %>">
                                                        <%= type.get("type_name") %> - <%= type.get("base_price") %> VNĐ/night
                                                    </option>
                                                    <% } } %>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Floor Number</label>
                                    <input type="number" name="floorNumber" class="form-control bg-dark text-white border-secondary" min="1" required>
                                </div>
                                <button type="submit" class="btn-hotel">Add Room</button>
                            </form>
                        </div>
                        <div class="col-md-8">
                            <h6>Room List</h6>
                            <div class="table-responsive">
                                <table class="table table-dark table-striped">
                                    <thead>
                                        <tr>
                                            <th>Room</th>
                                            <th>Type</th>
                                            <th>Status</th>
                                            <th>Price (VND/night)</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% java.util.List<java.util.Map<String, Object>> rooms =
                                            (java.util.List<java.util.Map<String, Object>>) request.getAttribute("rooms");
                                                if (rooms != null) {
                                                for (java.util.Map<String, Object> room : rooms) {
                                                    String status = (String) room.get("status");
                                                    String statusClass = status.equals("available") ? "bg-success" :
                                                    status.equals("occupied") ? "bg-warning" :
                                                    status.equals("maintenance") ? "bg-danger" : "bg-secondary";
                                                    String statusText = status.equals("available") ? "Trống" :
                                                    status.equals("occupied") ? "Có khách" :
                                                    status.equals("maintenance") ? "Bảo trì" : "Dọn phòng";
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <%= room.get("room_number") %>
                                                        </td>
                                                        <td>
                                                            <%= room.get("type_name") %>
                                                        </td>
                                                        <td>
                                                            <%= room.get("base_price") %> VNĐ
                                                        </td>
                                                        <td><span class="badge <%= statusClass %>">
                                                                <%= statusText %>
                                                            </span></td>
                                                        <td>
                                                            <form action="<%= request.getContextPath() %>/room-management" method="post"
                                                                class="d-inline">
                                                                <input type="hidden" name="action" value="updateStatus">
                                                                <input type="hidden" name="roomId" value="<%= room.get(" room_id") %>">
                                                                <select name="status"
                                                                    class="form-select form-select-sm bg-dark text-white border-secondary"
                                                                    onchange="this.form.submit()">
                                                                    <option value="available" <%=status.equals("available") ? "selected" : "" %>
                                                                        >Trống</option>
                                                                    <option value="occupied" <%=status.equals("occupied") ? "selected" : "" %>>Có
                                                                        khách</option>
                                                                    <option value="maintenance" <%=status.equals("maintenance") ? "selected" : "" %>
                                                                        >Bảo trì</option>
                                                                    <option value="cleaning" <%=status.equals("cleaning") ? "selected" : "" %>>Dọn
                                                                        phòng</option>
                                                                </select>
                                                            </form>
                                                            <form action="<%= request.getContextPath() %>/room-management" method="post"
                                                                class="d-inline ms-1">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="roomId" value="<%= room.get(" room_id") %>">
                                                                <button type="submit" class="btn btn-sm btn-outline-danger"
                                                                    onclick="return confirm('Xóa phòng này?')">Xóa</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                    <% } } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Guest Management Modal -->
    <div class="modal fade" id="guestModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-people"></i> Guest Management
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <h6>Add New Guest</h6>
                            <form action="<%= request.getContextPath() %>/guest-management" method="post">
                                <input type="hidden" name="action" value="add">
                                <div class="mb-3">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" name="firstName" class="form-control bg-dark text-white border-secondary" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Last Name</label>
                                    <input type="text" name="lastName" class="form-control bg-dark text-white border-secondary" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" name="email" class="form-control bg-dark text-white border-secondary">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Phone Number</label>
                                    <input type="tel" name="phone" class="form-control bg-dark text-white border-secondary" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">ID/Passport Number</label>
                                    <input type="text" name="idNumber" class="form-control bg-dark text-white border-secondary" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Nationality</label>
                                    <input type="text" name="nationality" class="form-control bg-dark text-white border-secondary"
                                        value="Vietnam">
                                </div>
                                <button type="submit" class="btn-hotel">Add Guest</button>
                            </form>
                        </div>
                        <div class="col-md-8">
                            <h6>Guest List</h6>
                    <div class="table-responsive" id="show">
                        <table class="table table-dark table-striped">
                            <thead>
                                <tr>
                                    <th>Full Name</th>
                                    <th>ID/Passport Number</th>
                                    <th>Phone Number</th>
                                    <th>Room Number</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                        <% java.util.List<java.util.Map<String, Object>> guests =
                                            (java.util.List<java.util.Map<String, Object>>) request.getAttribute("guests");
                                                if (guests != null) {
                                                for (java.util.Map<String, Object> guest : guests) {
                                                    String bookingStatus = (String) guest.get("booking_status");
                                                    String statusClass = bookingStatus != null ? "bg-warning" : "bg-secondary";
                                                    String statusText = bookingStatus != null ? "Checked-in" : "Not checked-in";
                                                    String roomNumber = (String) guest.get("room_number");
                                                    %>
                                        <tr>
                                            <td>
                                                <%= guest.get("first_name") %>
                                                    <%= guest.get("last_name") %>
                                    </td>
                                            <td>
                                                <%= guest.get("id_number") %>
                                            </td>
                                            <td>
                                                <%= guest.get("phone") %>
                                            </td>
                                            <td>
                                                <%= roomNumber !=null ? roomNumber : "-" %>
                                            </td>
                                            <td><span class="badge <%= statusClass %>">
                                                    <%= statusText %>
                                                </span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary" onclick="editGuest(<%= guest.get("guest_id") %>)">Edit</button>
                                                <form action="<%= request.getContextPath() %>/guest-management" method="post" class="d-inline">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="guestId" value="<%= guest.get("guest_id") %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger"
                                                        onclick="return confirm('Delete this guest?')">Delete</button>
                                                </form>
                                    </td>
                                </tr>
                                        <% } } %>
                            </tbody>
                        </table>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            </div>
                            
                            <!-- Room Details Modal -->
                            <div class="modal fade" id="roomDetailsModal" tabindex="-1">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">
                                                <i class="bi bi-door-open"></i> Thông tin phòng
                                            </h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form action="<%= request.getContextPath() %>/check-out" class="modal-body">
                                            <div  class="row">
                                                <div class="col-md-6">
                                                    <h6>Thông tin phòng</h6>
                                                    <table class="table table-sm">
                                                        <tr>
                                                            <td><strong>Số phòng:</strong></td>
                                                            <td id="roomNumber"></td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>Loại phòng:</strong></td>
                                                            <td id="roomType"></td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>Giá/đêm:</strong></td>
                                                            <td id="roomPrice"></td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>Trạng thái:</strong></td>
                                                            <td id="roomStatus"></td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div class="col-md-6">
                                                    <h6>Thông tin khách</h6>
                                                    <table class="table table-sm">
                                                        <tr>
                                                            <td><strong>Họ và tên:</strong></td>
                                                            <td id="guestName"></td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>Số điện thoại:</strong></td>
                                                            <td id="guestPhone"></td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>Check-in:</strong></td>
                                                            <td id="guestCheckin"></td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>Check-out:</strong></td>
                                                            <td id="guestCheckout"></td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </form>
                                        <div class="modal-footer">
                                            <button type="submit" class="btn btn-primary" > Thanh toán</button>
                                            <button type="button" class="btn btn-success" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Guest Modal -->
    <div class="modal fade" id="editGuestModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-person-gear"></i> Edit Guest Information
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%= request.getContextPath() %>/guest-management" method="post" id="editGuestForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="guestId" id="editGuestId">
                        <div class="mb-3">
                            <label class="form-label">First Name</label>
                            <input type="text" name="firstName" id="editFirstName" class="form-control bg-dark text-white border-secondary" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Last Name</label>
                            <input type="text" name="lastName" id="editLastName" class="form-control bg-dark text-white border-secondary" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" id="editEmail" class="form-control bg-dark text-white border-secondary">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" name="phone" id="editPhone" class="form-control bg-dark text-white border-secondary" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">ID/Passport Number</label>
                            <input type="text" name="idNumber" id="editIdNumber" class="form-control bg-dark text-white border-secondary" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Nationality</label>
                            <input type="text" name="nationality" id="editNationality" class="form-control bg-dark text-white border-secondary">
                        </div>
                    </form>
                </div>
                <div class="modal-footer" >
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="editGuestForm" class="btn-hotel">Update</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-refresh room status every 30 seconds
        setInterval(function () {
            refreshRoomStatus();
        }, 30000);

        // Room Status AJAX Functions
        function refreshRoomStatus() {
            const container = document.getElementById('roomStatusContainer');
            const refreshBtn = document.getElementById('refreshBtn');
            
            
            // Show loading state
            if (refreshBtn) {
                refreshBtn.innerHTML = '<i class="bi bi-arrow-clockwise spin"></i> Loading...';
                refreshBtn.disabled = true;
            }
            
            const apiUrl = '<%= request.getContextPath() %>/api/room-status';
            
            fetch(apiUrl)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.text(); 
                })
                .then(text => {
                    try {
                        const data = JSON.parse(text);
                        if (data.success) {
                            renderRoomStatus(data.data);
                        } else {
                            showError('Error: ' + data.message);
                        }
                    } catch (e) {
                        console.error('JSON parse error:', e);
                        showError('Error parsing data: ' + e.message);
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                    console.error('Error details:', error.message);
                    showError('Unable to load room data. Please try again. Details: ' + error.message);
                })
                .finally(() => {
                    // Reset button state
                    if (refreshBtn) {
                        refreshBtn.innerHTML = '<i class="bi bi-arrow-clockwise"></i> Refresh';
                        refreshBtn.disabled = false;
                    }
                });
        }
        
        function renderRoomStatus(roomData) {
            const container = document.getElementById('roomStatusContainer');
            if (!roomData || roomData.length === 0) {
                if (container) {
                    container.innerHTML = '<div class="col-12 text-center text-muted">No room data available</div>';
                } else {
                    console.error('Container not found for no data message');
                }
                return;
            }
            let html = '';
            // console.log(roomData[1]);

            roomData.forEach((room, index) => {

                const status = room.status || 'available';

                const showRoomDetail = `<div class="room-card text-center" style="cursor: pointer;" onclick="showRoomDetails(` + 
                    room.room_id + `,` + room.room_number + `,'` + (room.type_name?.value || '') + `',` + room.base_price + `,'` + room.status + `','` +
                    (room.firstName || '') + `','` + (room.lastName || '') + `','` + (room.phone || '') + `','` +
                    (room.check_in_date || '') + `','` + (room.check_out_date || '') + `')">`;

                // console.log(showRoomDetail);
                const roomHtml = `
                    <div class="col-lg-3 col-md-4 col-sm-6 mb-3 d-flex">`+showRoomDetail+`
                            <h6 class="mb-2">Room `+room.room_number+`</h6>
                            <span class="status-`+status+`">
                                `+getStatusText(status)+`
                            </span>
                        </div>
                    </div>
                `;
                
                html += roomHtml;
            });
            
            if (container) {
                container.innerHTML = html;
            } else {
                console.error('Container not found when setting HTML');
            }
        }
        function getStatusText(status) {
            switch(status) {
                case 'available': return 'Available';
                case 'occupied': return 'Occupied';
                case 'maintenance': return 'Maintenance';
                case 'cleaning': return 'Cleaning';
                default: return status;
            }
        }
        
        function showError(message) {
            const container = document.getElementById('roomStatusContainer');
            if (container) {
                container.innerHTML = `
                    <div class="col-12 text-center">
                        <div class="alert alert-warning" role="alert">
                            <i class="bi bi-exclamation-triangle"></i>`+ message +`
                        </div>
                    </div>
                `;
            } else {
                console.error('Container not found for error display');
            }
        }

        // Add some interactive functionality
        document.addEventListener('DOMContentLoaded', function () {
            // Load room status on page load
            
            // Check if elements exist
            const container = document.getElementById('roomStatusContainer');
            const refreshBtn = document.getElementById('refreshBtn');
            
            if (container) {
                refreshRoomStatus();
            } else {
                console.error('roomStatusContainer not found!');
            }
            
            // Room status click handlers (will be added dynamically)
            document.addEventListener('click', function(e) {
                if (e.target.closest('.room-card')) {
                    const roomNumber = e.target.closest('.room-card').querySelector('h6').textContent;
                }
            });
            
            // Stats card animations
            document.querySelectorAll('.stats-number').forEach(function (element) {
                const finalNumber = parseInt(element.textContent);
                let currentNumber = 0;
                const increment = finalNumber / 50;

                const timer = setInterval(function () {
                    currentNumber += increment;
                    if (currentNumber >= finalNumber) {
                        element.textContent = finalNumber;
                        clearInterval(timer);
                    } else {
                        element.textContent = Math.floor(currentNumber);
                    }
                }, 30);
            });

            // Quick action buttons functionality
            document.querySelectorAll('.btn-hotel, .btn-hotel-outline').forEach(function (btn) {
                btn.addEventListener('click', function (e) {
                    if (this.getAttribute('href') === '#') {
                        e.preventDefault();
                        // Add your functionality here
                    }
                });
            });

            // Sidebar menu functionality (only prevent default for '#')
            document.querySelectorAll('.sidebar-menu a').forEach(function (link) {
                link.addEventListener('click', function (e) {
                    const href = this.getAttribute('href');
                    if (!href || href === '#') {
                    e.preventDefault();
                        // Toggle active state for non-navigation links
                    document.querySelectorAll('.sidebar-menu a').forEach(function (l) {
                        l.classList.remove('active');
                    });
                    this.classList.add('active');
                    }
                    // Otherwise, allow navigation to proceed
                });
            });
        });

        // Hotel management functions
        function checkIn() {
            alert('Check-in functionality - Connect to backend!');
        }

        function checkOut(id, time, pay) {
            // Validate user inputs
            if (!id || !time || !pay) {
                alert('Please provide all required information');
                return;
            }

            // Sanitize user inputs
            id = sanitizeInput(id);
            time = sanitizeInput(time);
            pay = sanitizeInput(pay);

            // Connect to backend
            let con = "request.getContextPath() />check-out";

            try {
                // Make API request to backend
                let response = makeAPIRequest(con, id, time, pay);
                console.log(response);
            } catch (error) {
                console.error('Error occurred:', error);
            }
        }

// Room details functionality
        function makeBooking() {
            alert('Booking functionality - Connect to backend!');
        }

        function manageRooms() {
            alert('Room management - Connect to backend!');
        }

        function manageGuests() {
            alert('Guest management - Connect to backend!');
        }

        // Room details function
                    function showRoomDetails(roomId = null, roomNumber = null, roomType = null, roomPrice = null, status = null, firstName = null, lastName = null, phone = null, checkInDate = null, checkOutDate = null) {
            // Update room information
            document.getElementById('roomNumber').textContent = roomNumber;
            document.getElementById('roomType').textContent = roomType;
            document.getElementById('roomPrice').textContent = roomPrice + ' VNĐ';
                    console.log(roomId + ` ` + roomNumber + ` ` + roomType + ` ` + roomPrice + ` ` + status + ` ` + firstName + ` ` + lastName + ` ` + phone + ` ` + checkInDate + ` ` + checkOutDate);
            // Update status with badge
            const statusElement = document.getElementById('roomStatus');
            let statusClass = 'badge ';
            let statusText = '';
            
            switch(status) {
                case 'available':
                    statusClass += 'bg-success';
                    statusText = 'Trống';
                    break;
                case 'occupied':
                    statusClass += 'bg-warning';
                    statusText = 'Có khách';
                    break;
                case 'maintenance':
                    statusClass += 'bg-danger';
                    statusText = 'Bảo trì';
                    break;
                case 'cleaning':
                    statusClass += 'bg-secondary';
                    statusText = 'Dọn phòng';
                    break;
                default:
                    statusClass += 'bg-secondary';
                    statusText = status;
            }
            
                    // statusElement.innerHTML = '<span class="' + statusClass + '">' + statusText + '</span>';
                    document.getElementById('guestName').textContent = firstName + ' ' + lastName;
                    document.getElementById('guestPhone').textContent = phone;
                    document.getElementById('guestCheckin').textContent = checkInDate;
                    document.getElementById('guestCheckout').textContent = checkOutDate;
            
            // Show modal
            const modal = new bootstrap.Modal(document.getElementById('roomDetailsModal'));
            modal.show();
        }

        // Edit guest function
        function editGuest(guestId) {
            // Find the guest data from the table
            const guestRow = document.querySelector(`button[onclick="editGuest(` + guestId + `)"]`).closest('tr');
            const cells = guestRow.querySelectorAll('td');
            
            // Extract guest data from table cells
            const fullName = cells[0].textContent.trim();
            const nameParts = fullName.split(' ');
            const firstName = nameParts[0];
            const lastName = nameParts.slice(1).join(' ');
            const idNumber = cells[1].textContent.trim();
            const phone = cells[2].textContent.trim();
            
            // Fill the edit form
            document.getElementById('editGuestId').value = guestId;
            document.getElementById('editFirstName').value = firstName;
            document.getElementById('editLastName').value = lastName;
            document.getElementById('editIdNumber').value = idNumber;
            document.getElementById('editPhone').value = phone;
            document.getElementById('editEmail').value = ''; 
            document.getElementById('editNationality').value = 'Việt Nam'; 
            
            // Show the edit modal
            const modal = new bootstrap.Modal(document.getElementById('editGuestModal'));
            modal.show();
        }
        
    </script>
</body>
</html>