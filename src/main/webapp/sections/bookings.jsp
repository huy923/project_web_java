<%-- Bookings Management Page --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<link rel="stylesheet" href="../css/modern-ui.css">

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
                        <i class="bi bi-calendar-check"></i> Booking Management
                    </div>
                    <div class="page-subtitle">Manage and track all hotel bookings</div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3 ">
                        <div class="stat-card">
                            <div class="stat-number text-info">
                                <% 
                                List<Map<String, Object>> bookings = (List<Map<String, Object>>) request.getAttribute("bookings");
                                int totalBookings = bookings != null ? bookings.size() : 0;
                                %>
                                <%= totalBookings %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-calendar-plus"></i> Total Bookings
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-warning">
                                <% 
                                int confirmedCount = 0;
                                if (bookings != null) {
                                    for (Map<String, Object> booking : bookings) {
                                        if ("confirmed".equals(booking.get("status"))) {
                                            confirmedCount++;
                                        }
                                    }
                                }
                                %>
                                <%= confirmedCount %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-clock"></i> Pending Check-in
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-success">
                                <% 
                                int checkedInCount = 0;
                                if (bookings != null) {
                                    for (Map<String, Object> booking : bookings) {
                                        if ("checked_in".equals(booking.get("status"))) {
                                            checkedInCount++;
                                        }
                                    }
                                }
                                %>
                                <%= checkedInCount %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-person-check"></i> Checked In
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-number text-secondary">
                                <% 
                                int checkedOutCount = 0;
                                if (bookings != null) {
                                    for (Map<String, Object> booking : bookings) {
                                        if ("checked_out".equals(booking.get("status"))) {
                                            checkedOutCount++;
                                        }
                                    }
                                }
                                %>
                                <%= checkedOutCount %>
                            </div>
                            <div class="stats-label">
                                <i class="bi bi-person-dash"></i> Checked Out
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Filter and Search Section -->
                <div class="filter-section">
                    <div class="row align-items-end">
                        <div class="col-md-3 mb-3">
                            <label class="form-label">Search Guest</label>
                            <input type="text" class="form-control text-white border-secondary" 
                                   placeholder="Enter guest name" id="guestSearch">
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label">Status</label>
                            <select class="form-select border-secondary" id="statusFilter">
                                <option value="">All</option>
                                <option value="confirmed">Pending Check-in</option>
                                <option value="checked_in">Checked In</option>
                                <option value="checked_out">Checked Out</option>
                                <option value="cancelled">Cancelled</option>
                            </select>
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label">From Date</label>
                            <input type="date" class="form-control border-secondary" id="fromDate">
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label">To Date</label>
                            <input type="date" class="form-control border-secondary" id="toDate">
                        </div>
                        <div class="col-md-3 mb-3">
                            <button class="btn-modern btn-success me-2" onclick="filterBookings()">
                                <i class="bi bi-search"></i> Filter
                            </button>
                            <button class="btn-modern btn-primary" data-bs-toggle="modal" data-bs-target="#newBookingModal">
                                <i class="bi bi-plus"></i>New Booking
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Bookings Table -->
                <div class="card-modern">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">
                            <i class="bi bi-table"></i> Booking List
                        </h5>
                        <div class="d-flex gap-2">
                            <button class="btn btn-sm btn-outline-light" onclick="exportBookings()">
                                <i class="bi bi-download"></i> Export Excel
                            </button>
                            <button class="btn btn-sm btn-outline-light" onclick="refreshBookings()">
                                <i class="bi bi-arrow-clockwise"></i> Refresh
                            </button>
                        </div>
                    </div>
                    
                    <div class="table-responsive overflow-x-auto" style="max-height: 500px;">
                        <table class="table table-dark table-striped table-hover" id="bookingsTable">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Guest</th>
                                    <th>Phone</th>
                                    <th>Room</th>
                                    <th>Check-in</th>
                                    <th>Check-out</th>
                                    <th>Nights</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                if (bookings != null && !bookings.isEmpty()) {
                                    for (Map<String, Object> booking : bookings) {
                                        String bookingId = String.valueOf(booking.get("booking_id"));
                                        String guestName = booking.get("first_name") + " " + booking.get("last_name");
                                        String phone = (String) booking.get("phone");
                                        String roomNumber = (String) booking.get("room_number");
                                        String checkInDate = booking.get("check_in_date") != null ? booking.get("check_in_date").toString() : "";
                                        String checkOutDate = booking.get("check_out_date") != null ? booking.get("check_out_date").toString() : "";
                                        String totalAmount = booking.get("total_amount") != null ? booking.get("total_amount").toString() : "0";
                                        String status = (String) booking.get("status");
                                        
                                        // Calculate nights
                                        int nights = 1;
                                        if (!checkInDate.isEmpty() && !checkOutDate.isEmpty()) {
                                            try {
                                                java.sql.Date checkIn = java.sql.Date.valueOf(checkInDate);
                                                java.sql.Date checkOut = java.sql.Date.valueOf(checkOutDate);
                                                long diffInMillies = checkOut.getTime() - checkIn.getTime();
                                                nights = (int) (diffInMillies / (1000 * 60 * 60 * 24));
                                                if (nights <= 0) nights = 1;
                                            } catch (Exception e) {
                                                nights = 1;
                                            }
                                        }
                                        
                                        String statusClass = "status-" + status;
                                        String statusText = "";
                                        String statusIcon = "";
                                        
                                        if ("confirmed".equals(status)) {
                                            statusText = "Pending Check-in";
                                            statusIcon = "bi-clock";
                                        } else if ("checked_in".equals(status)) {
                                            statusText = "Checked In";
                                            statusIcon = "bi-person-check";
                                        } else if ("checked_out".equals(status)) {
                                            statusText = "Checked Out";
                                            statusIcon = "bi-person-dash";
                                        } else if ("cancelled".equals(status)) {
                                            statusText = "Cancelled";
                                            statusIcon = "bi-x-circle";
                                        } else {
                                            statusText = status;
                                            statusIcon = "bi-question-circle";
                                        }
                                %>
                                <tr>
                                    <td><strong>BK<%= String.format("%03d", Integer.parseInt(bookingId)) %></strong></td>
                                    <td><%= guestName %></td>
                                    <td><%= phone != null ? phone : "N/A" %></td>
                                    <td><span class="badge bg-info">Room <%= roomNumber %></span></td>
                                    <td><%= checkInDate %></td>
                                    <td><%= checkOutDate %></td>
                                    <td><%= nights %> night(s)</td>
                                    <td><strong><%= String.format("%,.0f", Double.parseDouble(totalAmount)) %> VNĐ</strong></td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>">
                                            <i class="bi <%= statusIcon %>"></i> <%= statusText %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-primary" onclick="viewBookingDetails('<%= bookingId %>')" title="View Details">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <% if ("confirmed".equals(status)) { %>
                                            <button class="btn btn-sm btn-outline-success" onclick="checkInBooking('<%= bookingId %>')" title="Check-in">
                                                <i class="bi bi-person-plus"></i>
                                            </button>
                                            <% } else if ("checked_in".equals(status)) { %>
                                            <button class="btn btn-sm btn-outline-warning" onclick="checkOutBooking('<%= bookingId %>')" title="Check-out">
                                                <i class="bi bi-person-dash"></i>
                                            </button>
                                            <% } %>
                                            <button class="btn btn-sm btn-outline-danger" onclick="cancelBooking('<%= bookingId %>')" title="Cancel Booking">
                                                <i class="bi bi-x-circle"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% 
                                    }
                                } else { 
                                %>
                                <tr>
                                    <td colspan="10" class="text-center text-muted py-4">
                                        <i class="bi bi-calendar-x" style="font-size: 2rem;"></i>
                                        <br>No bookings found
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

    <!-- New Booking Modal -->
    <div class="modal fade" id="newBookingModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-calendar-plus"></i> New Booking
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%= request.getContextPath() %>/bookings" method="post" id="newBookingForm">
                        <input type="hidden" name="action" value="create">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Guest Name</label>
                                <input type="text" name="firstName" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Last Name</label>
                                <input type="text" name="lastName" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" name="phone" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control text-white border-secondary">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">ID/Passport Number</label>
                                <input type="text" name="idNumber" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Room</label>
                                <select name="roomId" class="form-select text-white border-secondary" required>
                                    <option value="">Select Room</option>
                                    <% 
                                    List<Map<String, Object>> availableRooms = (List<Map<String, Object>>) request.getAttribute("availableRooms");
                                    if (availableRooms != null) {
                                        for (Map<String, Object> room : availableRooms) {
                                    %>
                                    <option value="<%= room.get("room_id") %>">
                                        Room <%= room.get("room_number") %> - <%= room.get("type_name") %> 
                                        (<%= String.format("%,d", ((java.math.BigDecimal) room.get("base_price")).longValue()) %> VND/night)
                                    </option>
                                    <% 
                                        }
                                    } 
                                    %>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Check-in Date</label>
                                <input type="date" name="checkInDate" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Check-out Date</label>
                                <input type="date" name="checkOutDate" class="form-control text-white border-secondary" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Adults</label>
                                <input type="number" name="adults" class="form-control text-white border-secondary" value="1" min="1" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Children</label>
                                <input type="number" name="children" class="form-control text-white border-secondary" value="0" min="0">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="newBookingForm" class="btn-hotel">Create Booking</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Booking Details Modal -->
    <div class="modal fade" id="bookingDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-calendar-check"></i> Booking Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="bookingDetailsContent">
                    <!-- Content will be loaded dynamically -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Filter bookings function
        function filterBookings() {
            const guestSearch = document.getElementById('guestSearch').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            const fromDate = document.getElementById('fromDate').value;
            const toDate = document.getElementById('toDate').value;
            
            const table = document.getElementById('bookingsTable');
            const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const guestName = row.cells[1].textContent.toLowerCase();
                const status = row.cells[8].textContent.toLowerCase();
                const checkInDate = row.cells[4].textContent;
                
                let showRow = true;
                
                // Guest name filter
                if (guestSearch && !guestName.includes(guestSearch)) {
                    showRow = false;
                }
                
                // Status filter
                if (statusFilter) {
                    const statusText = row.cells[8].textContent.toLowerCase();
                    if (!statusText.includes(statusFilter)) {
                        showRow = false;
                    }
                }
                
                // Date range filter
                if (fromDate && checkInDate < fromDate) {
                    showRow = false;
                }
                if (toDate && checkInDate > toDate) {
                    showRow = false;
                }
                
                row.style.display = showRow ? '' : 'none';
            }
        }
        
        // View booking details
        function viewBookingDetails(bookingId) {
            // This would typically make an AJAX call to get booking details
            const modal = new bootstrap.Modal(document.getElementById('bookingDetailsModal'));
            document.getElementById('bookingDetailsContent').innerHTML = `
                <div class="text-center">
                    <i class="bi bi-hourglass-split" style="font-size: 3rem;"></i>
                    <p class="mt-3">Loading booking information...</p>
                </div>
            `;
            modal.show();
            
            // Simulate loading
            setTimeout(() => {
                document.getElementById('bookingDetailsContent').innerHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Guest Information</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Booking ID:</strong></td><td>BK${bookingId.padStart(3, '0')}</td></tr>
                                <tr><td><strong>Guest Name:</strong></td><td>John Doe</td></tr>
                                <tr><td><strong>Phone:</strong></td><td>0123456789</td></tr>
                                <tr><td><strong>Email:</strong></td><td>guest@example.com</td></tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>Room Information</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Room:</strong></td><td>102</td></tr>
                                <tr><td><strong>Type:</strong></td><td>Standard</td></tr>
                                <tr><td><strong>Check-in:</strong></td><td>2024-01-15</td></tr>
                                <tr><td><strong>Check-out:</strong></td><td>2024-01-18</td></tr>
                                <tr><td><strong>Total Amount:</strong></td><td>3,600,000 VND</td></tr>
                            </table>
                        </div>
                    </div>
                `;
            }, 1000);
        }
        
        // Check-in booking
        function checkInBooking(bookingId) {
            if (confirm('Confirm check-in for this booking?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/bookings';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'checkin';
                form.appendChild(actionInput);
                
                const bookingIdInput = document.createElement('input');
                bookingIdInput.type = 'hidden';
                bookingIdInput.name = 'bookingId';
                bookingIdInput.value = bookingId;
                form.appendChild(bookingIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Check-out booking
        function checkOutBooking(bookingId) {
            if (confirm('Confirm check-out for this booking?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/bookings';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'checkout';
                form.appendChild(actionInput);
                
                const bookingIdInput = document.createElement('input');
                bookingIdInput.type = 'hidden';
                bookingIdInput.name = 'bookingId';
                bookingIdInput.value = bookingId;
                form.appendChild(bookingIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Cancel booking
        function cancelBooking(bookingId) {
            if (confirm('Are you sure you want to cancel this booking?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/bookings';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'cancel';
                form.appendChild(actionInput);
                
                const bookingIdInput = document.createElement('input');
                bookingIdInput.type = 'hidden';
                bookingIdInput.name = 'bookingId';
                bookingIdInput.value = bookingId;
                form.appendChild(bookingIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Export bookings
        function exportBookings() {
            alert('Excel export feature is under development!');
        }
        
        // Refresh bookings
        function refreshBookings() {
            location.reload();
        }
        
        // Auto-refresh every 30 seconds
        setInterval(function() {
            console.log('Auto-refreshing bookings...');
        }, 30000);
        
        // Initialize date inputs with today's date
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('fromDate').value = today;
            document.getElementById('toDate').value = today;
        });
    </script>
    
</body>
</html>
