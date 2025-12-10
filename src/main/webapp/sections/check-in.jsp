<%-- Check-in Management Page --%>
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
                                                        <i class="bi bi-door-open"></i> Check-in Management
                                                    </div>
                                                    <div class="page-subtitle">Process guest check-ins and room
                                                        assignments</div>
                                                </div>

                                                <!-- Statistics -->
                                                <div class="grid-4 mb-4">
                                                    <div class="stat-card">
                                                        <div class="stat-number text-info">
                                                            <% List<Map<String, Object>> checkIns = (List<Map<String,
                                                                    Object>>) request.getAttribute("checkIns");
                                                                    int totalCheckIns = checkIns != null ?
                                                                    checkIns.size() : 0;
                                                                    %>
                                                                    <%= totalCheckIns %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-door-open"></i> Today's Check-ins
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-success">
                                                            <% int completedCheckIns=0; if (checkIns !=null) { for
                                                                (Map<String, Object> checkIn : checkIns) {
                                                                if ("completed".equals(checkIn.get("status"))) {
                                                                completedCheckIns++;
                                                                }
                                                                }
                                                                }
                                                                %>
                                                                <%= completedCheckIns %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-check-circle"></i> Completed
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-warning">
                                                            <% int pendingCheckIns=totalCheckIns - completedCheckIns; %>
                                                                <%= pendingCheckIns %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-hourglass-split"></i> Pending
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-primary">
                                                            0
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-exclamation-circle"></i> Issues
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Check-in Form -->
                                                <div class="card-modern mb-4">
                                                    <h5 class="mb-3">
                                                        <i class="bi bi-plus-circle"></i> Process Check-in
                                                    </h5>
                                                    <form action="<%= request.getContextPath() %>/check-in"
                                                        method="post" class="row g-3">
                                                        <input type="hidden" name="action" value="checkin">
                                                        <div class="col-md-4">
                                                            <label class="form-label">Select Booking</label>
                                                            <select name="bookingId" id="bookingSelect" class="form-control" required onchange="updateGuestInfo()">
                                                                <option value="">-- Select a booking --</option>
                                                                <% List<Map<String, Object>> bookings = (List<Map<String, Object>>) request.getAttribute("bookings");
                                                                        if (bookings != null && !bookings.isEmpty()) {
                                                                        for (Map<String, Object> booking : bookings) {
                                                                            String bookingId = String.valueOf(booking.get("booking_id"));
                                                                            String guestName = booking.get("first_name") + " " + booking.get("last_name");
                                                                            String roomNumber = (String) booking.get("room_number");
                                                                            %>
                                                                            <option value="<%= bookingId %>" data-guest="<%= guestName %>" data-room="<%= roomNumber %>">
                                                                                Booking #<%= bookingId %> - <%= guestName %> - Room <%= roomNumber %>
                                                                            </option>
                                                                            <% } } %>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <label class="form-label">Guest Name</label>
                                                            <input type="text" name="guestName" id="guestName" class="form-control" placeholder="Auto-populated" readonly>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <label class="form-label">Room Number</label>
                                                            <input type="text" name="roomNumber" id="roomNumber" class="form-control" placeholder="Auto-populated" readonly>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Check-in Time</label>
                                                            <input type="time" name="checkInTime" id="checkInTime" class="form-control" required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Number of Guests</label>
                                                            <input type="number" name="numGuests" class="form-control"
                                                                min="1" value="1">
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Special Requests</label>
                                                            <textarea name="specialRequests" class="form-control" rows="1" placeholder="Any special requests"></textarea>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <label class="form-label">&nbsp;</label>
                                                                <button class="btn-modern btn-primary w-100" type="submit">
                                                                    <i class="bi bi-check"></i> Check-in
                                                                </button>
                                                        </div>
                                                    </form>
                                                </div>

                                                <!-- Check-in List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> Recent Check-ins
                                                    </h5>
                                                    <div class="grid-3">
                                                        <% if (checkIns !=null && !checkIns.isEmpty()) { for
                                                            (Map<String, Object> checkIn : checkIns) {
                                                            String guestName = (String) checkIn.get("guest_name");
                                                            String roomNumber = (String) checkIn.get("room_number");
                                                            String status = (String) checkIn.get("status");
                                                            String checkInTime = (String) checkIn.get("check_in_time");
                                                            %>
                                                            <div class="card-compact">
                                                                <div class="mb-3">
                                                                    <h6 class="mb-1">
                                                                        <%= guestName %>
                                                                    </h6>
                                                                    <p class="text-muted mb-0" style="font-size: 12px;">
                                                                        <i class="bi bi-door-open"></i> Room <%=
                                                                            roomNumber %>
                                                                    </p>
                                                                </div>
                                                                <div class="mb-3 pb-3 border-bottom">
                                                                    <p class="mb-1"><small class="text-muted">Check-in
                                                                            Time:</small></p>
                                                                    <p class="mb-0"><small>
                                                                            <%= checkInTime !=null ? checkInTime : "N/A"
                                                                                %>
                                                                        </small></p>
                                                                    <p class="mb-0"><small class="text-muted">Status:
                                                                            <%= status %></small></p>
                                                                </div>
                                                                <div class="d-flex gap-2">
                                                                    <button
                                                                        class="btn-modern btn-ghost btn-sm flex-grow-1"
                                                                        type="button">
                                                                        <i class="bi bi-pencil"></i> Edit
                                                                    </button>
                                                                    <button class="btn-modern btn-danger btn-sm"
                                                                        type="button"
                                                                        onclick="return confirm('Cancel check-in?')">
                                                                        <i class="bi bi-x"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                            <% } } else { %>
                                                                <div class="col-12 text-center py-5">
                                                                    <i class="bi bi-inbox"
                                                                        style="font-size: 3rem; color: var(--text-secondary);"></i>
                                                                    <p class="text-muted mt-3">No check-ins today</p>
                                                                </div>
                                                                <% } %>
                                                    </div>
                                                </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Set current time on page load
                    function setCurrentTime() {
                        const now = new Date();
                        const hours = String(now.getHours()).padStart(2, '0');
                        const minutes = String(now.getMinutes()).padStart(2, '0');
                        document.getElementById('checkInTime').value = hours + ':' + minutes;
                    }

                    // Auto-populate guest name and room number from selected booking
                    function updateGuestInfo() {
                        const select = document.getElementById('bookingSelect');
                        const selectedOption = select.options[select.selectedIndex];

                        if (selectedOption.value) {
                            const guestName = selectedOption.getAttribute('data-guest');
                            const roomNumber = selectedOption.getAttribute('data-room');

                            document.getElementById('guestName').value = guestName || '';
                            document.getElementById('roomNumber').value = roomNumber || '';
                        } else {
                            document.getElementById('guestName').value = '';
                            document.getElementById('roomNumber').value = '';
                        }
                    }

                    // Initialize on page load
                    document.addEventListener('DOMContentLoaded', function () {
                        setCurrentTime();
                    });
                </script>

                </body>

                </html>