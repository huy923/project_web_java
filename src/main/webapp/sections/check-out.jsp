<%-- Check-out Management Page --%>
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
                                                        <i class="bi bi-door-closed"></i> Check-out Management
                                                    </div>
                                                    <div class="page-subtitle">Process guest check-outs and billing
                                                    </div>
                                                </div>

                                                <!-- Statistics -->
                                                <div class="grid-4 mb-4">
                                                    <div class="stat-card">
                                                        <div class="stat-number text-info">
                                                            <% List<Map<String, Object>> checkOuts = (List<Map<String,
                                                                    Object>>) request.getAttribute("checkOuts");
                                                                    int totalCheckOuts = checkOuts != null ?
                                                                    checkOuts.size() : 0;
                                                                    %>
                                                                    <%= totalCheckOuts %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-door-closed"></i> Today's Check-outs
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-success">
                                                            <% int completedCheckOuts=0; if (checkOuts !=null) { for
                                                                (Map<String, Object> checkOut : checkOuts) {
                                                                if ("completed".equals(checkOut.get("status"))) {
                                                                completedCheckOuts++;
                                                                }
                                                                }
                                                                }
                                                                %>
                                                                <%= completedCheckOuts %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-check-circle"></i> Completed
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-warning">
                                                            <% int pendingCheckOuts=totalCheckOuts - completedCheckOuts;
                                                                %>
                                                                <%= pendingCheckOuts %>
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

                                                <!-- Check-out Form -->
                                                <div class="card-modern mb-4">
                                                    <h5 class="mb-3">
                                                        <i class="bi bi-plus-circle"></i> Process Check-out
                                                    </h5>
                                                    <form action="<%= request.getContextPath() %>/check-out"
                                                        method="post" class="row g-3">
                                                        <input type="hidden" name="action" value="checkout">
                                                        <div class="col-md-4">
                                                            <label class="form-label">Select Booking</label>
                                                            <select name="bookingId" id="bookingSelect" class="form-control" required onchange="updateCheckoutInfo()">
                                                                <option value="">-- Select a booking --</option>
                                                                <% List<Map<String, Object>> bookings = (List<Map<String, Object>>) request.getAttribute("bookings");
                                                                        if (bookings != null && !bookings.isEmpty()) {
                                                                        for (Map<String, Object> booking : bookings) {
                                                                            String bookingId = String.valueOf(booking.get("booking_id"));
                                                                            String guestName = booking.get("first_name") + " " + booking.get("last_name");
                                                                            String roomNumber = (String) booking.get("room_number");
                                                                            String totalAmount = booking.get("total_amount") != null ? booking.get("total_amount").toString() :
                                                                            "0";
                                                                            %>
                                                                            <option value="<%= bookingId %>" data-guest="<%= guestName %>" data-room="<%= roomNumber %>"
                                                                                data-amount="<%= totalAmount %>">
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
                                                            <label class="form-label">Check-out Time</label>
                                                            <input type="time" name="checkOutTime" id="checkOutTime" class="form-control" required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Total Amount</label>
                                                            <input type="number" name="totalAmount" id="totalAmount" class="form-control" step="0.01" placeholder="0.00" readonly>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Payment Method</label>
                                                            <select name="paymentMethod" class="form-select" required>
                                                                <option value="">Select method</option>
                                                                <option value="cash">Cash</option>
                                                                <option value="card">Card</option>
                                                                <option value="bank_transfer">Bank Transfer</option>
                                                                <option value="online">Online</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">&nbsp;</label>
                                                            <button class="btn-modern btn-primary w-100" type="submit">
                                                                <i class="bi bi-check"></i> Check-out
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>

                                                <!-- Check-out List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> Recent Check-outs
                                                    </h5>
                                                    <div class="grid-3">
                                                        <% if (checkOuts !=null && !checkOuts.isEmpty()) { for
                                                            (Map<String, Object> checkOut : checkOuts) {
                                                            String guestName = (String) checkOut.get("guest_name");
                                                            String roomNumber = (String) checkOut.get("room_number");
                                                            String status = (String) checkOut.get("status");
                                                            String checkOutTime = (String)
                                                            checkOut.get("check_out_time");
                                                            %>
                                                            <div class="card-compact">
                                                                <div class="mb-3">
                                                                    <h6 class="mb-1">
                                                                        <%= guestName %>
                                                                    </h6>
                                                                    <p class="text-muted mb-0" style="font-size: 12px;">
                                                                        <i class="bi bi-door-closed"></i> Room <%=
                                                                            roomNumber %>
                                                                    </p>
                                                                </div>
                                                                <div class="mb-3 pb-3 border-bottom">
                                                                    <p class="mb-1"><small class="text-muted">Check-out
                                                                            Time:</small></p>
                                                                    <p class="mb-0"><small>
                                                                            <%= checkOutTime !=null ? checkOutTime
                                                                                : "N/A" %>
                                                                        </small></p>
                                                                    <p class="mb-0"><small class="text-muted">Status:
                                                                            <%= status %></small></p>
                                                                </div>
                                                                <div class="d-flex gap-2">
                                                                    <button
                                                                        class="btn-modern btn-ghost btn-sm flex-grow-1"
                                                                        type="button">
                                                                        <i class="bi bi-receipt"></i> Invoice
                                                                    </button>
                                                                    <button class="btn-modern btn-danger btn-sm"
                                                                        type="button"
                                                                        onclick="return confirm('Cancel check-out?')">
                                                                        <i class="bi bi-x"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                            <% } } else { %>
                                                                <div class="col-12 text-center py-5">
                                                                    <i class="bi bi-inbox"
                                                                        style="font-size: 3rem; color: var(--text-secondary);"></i>
                                                                    <p class="text-muted mt-3">No check-outs today</p>
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
                        document.getElementById('checkOutTime').value = hours + ':' + minutes;
                    }

                    // Auto-populate guest name, room number, and total amount from selected booking
                    function updateCheckoutInfo() {
                        const select = document.getElementById('bookingSelect');
                        const selectedOption = select.options[select.selectedIndex];

                        if (selectedOption.value) {
                            const guestName = selectedOption.getAttribute('data-guest');
                            const roomNumber = selectedOption.getAttribute('data-room');
                            const totalAmount = selectedOption.getAttribute('data-amount');

                            document.getElementById('guestName').value = guestName || '';
                            document.getElementById('roomNumber').value = roomNumber || '';
                            document.getElementById('totalAmount').value = totalAmount || '0';
                        } else {
                            document.getElementById('guestName').value = '';
                            document.getElementById('roomNumber').value = '';
                            document.getElementById('totalAmount').value = '';
                        }
                    }

                    // Initialize on page load
                    document.addEventListener('DOMContentLoaded', function () {
                        setCurrentTime();
                    });
                </script>

                </body>

                </html>