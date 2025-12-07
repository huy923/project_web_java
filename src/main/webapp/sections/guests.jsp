<%-- Guests Management Page --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<jsp:include page="/includes/header.jsp" />
    
    <div class="px-2 main-container">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-3 col-md-4 mb-4">
                <jsp:include page="/includes/sidebar.jsp" />
                <!-- Include sidebar component -->
            </div>
            
            <!-- Main Content -->
            <div class="col-lg-9 col-md-8">
                <!-- Header -->
                <div class="page-header">
                    <div class="page-title">
                        <i class="bi bi-people"></i> Guest Management
                    </div>
                    <div class="page-subtitle">Manage guest information and booking history</div>
                </div>
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

                <!-- Statistics Cards -->
                <div class="grid-4 mb-4">
                    <div class="stat-card">
                        <div class="stat-number">
                            <% List<Map<String, Object>> guests = (List<Map<String, Object>>) request.getAttribute("guests");
                                    int totalGuests = guests != null ? guests.size() : 0;
                            %>
                            <%= totalGuests %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-people"></i> Total Guests
                        </div>
                        </div>
                    <div class="stat-card">
                        <div class="stat-number text-success">
                            <% int activeGuests=0; if (guests !=null) { for (Map<String, Object> guest : guests) {
                                if (guest.get("booking_status") != null) {
                                   activeGuests++;
                                }
                            }
                            }
                            %>
                            <%= activeGuests %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-person-check"></i> Checked In
                        </div>
                        </div>
                    <div class="stat-card">
                        <div class="stat-number text-warning">
                            <% int vipGuests=0; if (guests !=null) { for (Map<String, Object> guest : guests) {
                                if (guest.get("booking_count") != null &&
                                Integer.parseInt(guest.get("booking_count").toString()) > 2) {
                                vipGuests++;
                                }
                            }
                            }
                            %>
                            <%= vipGuests %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-star"></i> VIP Guests
                        </div>
                        </div>
                    <div class="stat-card">
                        <div class="stat-number text-primary">
                            <% int newGuests=0; if (guests !=null) { for (Map<String, Object> guest : guests) {
                                if (guest.get("booking_count") != null &&
                                Integer.parseInt(guest.get("booking_count").toString()) == 1) {
                                    newGuests++;
                                }
                            }
                            }
                            %>
                            <%= newGuests %>
                        </div>
                        <div class="stat-label">
                            <i class="bi bi-person-plus"></i> New Guests
                        </div>
                    </div>
                </div>

                <!-- Add Guest Form -->
                <div class="card-modern mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-person-plus"></i> Add New Guest
                    </h5>
                    <form action="<%= request.getContextPath() %>/guest-management" method="post" class="row g-3">
                        <input type="hidden" name="action" value="add">
                        <div class="col-md-3">
                            <label class="form-label">First Name</label>
                            <input type="text" name="firstName" class="form-control" placeholder="Enter first name" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Last Name</label>
                            <input type="text" name="lastName" class="form-control" placeholder="Enter last name" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Phone Number</label>
                            <input type="tel" name="phone" class="form-control" placeholder="Enter phone number" required>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn-modern btn-success" type="submit">
                                <i class="bi bi-plus"></i> Add Guest
                            </button>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" placeholder="Enter email">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">ID/Passport Number</label>
                            <input type="text" name="idNumber" class="form-control" placeholder="Enter ID/Passport number" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Nationality</label>
                            <input type="text" name="nationality" class="form-control" placeholder="Enter nationality" value="Vietnam">
                        </div>
                    </form>
                </div>

                <!-- Search and Filter -->
                <div class="card-modern mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-search"></i> Search and Filter
                    </h5>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <input type="text" class="form-control" placeholder="Search by name or phone" id="guestSearch">
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="statusFilter">
                                <option value="">All Status</option>
                                <option value="active">Checked In</option>
                                <option value="inactive">Not Checked In</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex justify-content-center align-items-center">
                            <button class="btn btn-primary d-flex mx-2" onclick="filterGuests()">
                                <i class="bi bi-funnel me-2"></i> Filter
                            </button>
                            <button class="btn btn-outline-secondary d-flex ms-2" onclick="clearFilters()">
                                <i class="bi bi-x-circle ms-2"></i> Clear Filters
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Guests Table -->
                <div class="card-modern">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Guest List
                    </h5>
                    <div class="table-responsive overflow-x-auto">
                        <table class="table table-dark table-striped table-hover" id="guestsTable">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> ID</th>
                                    <th><i class="bi bi-person"></i> Full Name</th>
                                    <th><i class="bi bi-card-text"></i> ID/Passport</th>
                                    <th><i class="bi bi-telephone"></i> Phone</th>
                                    <th><i class="bi bi-envelope"></i> Email</th>
                                    <th><i class="bi bi-globe"></i> Nationality</th>
                                    <th><i class="bi bi-door-open"></i> Current Room</th>
                                    <th><i class="bi bi-flag"></i> Status</th>
                                    <th><i class="bi bi-gear"></i> Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                if (guests != null && !guests.isEmpty()) {
                                    for (Map<String, Object> guest : guests) {
                                        String guestId = String.valueOf(guest.get("guest_id"));
                                        String fullName = guest.get("first_name") + " " + guest.get("last_name");
                                        String idNumber = (String) guest.get("id_number");
                                        String phone = (String) guest.get("phone");
                                        String email = (String) guest.get("email");
                                        String nationality = (String) guest.get("nationality");
                                        String roomNumber = (String) guest.get("room_number");
                                        String bookingStatus = (String) guest.get("booking_status");
                                        
                                        String statusClass = bookingStatus != null ? "bg-success" : "bg-secondary";
                                        String statusText = bookingStatus != null ? "Checked In" : "Not Checked In";
                                %>
                                <tr>
                                    <td><strong>#<%= guestId %></strong></td>
                                    <td><%= fullName %></td>
                                    <td><%= idNumber != null ? idNumber : "N/A" %></td>
                                    <td><%= phone != null ? phone : "N/A" %></td>
                                    <td><%= email != null ? email : "N/A" %></td>
                                    <td><%= nationality != null ? nationality : "N/A" %></td>
                                    <td>
                                        <% if (roomNumber != null) { %>
                                            <span class="badge bg-info">Room <%= roomNumber %></span>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="badge <%= statusClass %>">
                                            <%= statusText %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-hotel-outline" onclick="viewGuestDetails('<%= guestId %>')" title="View Details">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-hotel-outline" onclick="editGuest('<%= guestId %>')" title="Edit Information">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-hotel-outline" onclick="deleteGuest('<%= guestId %>')" title="Delete Guest">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% 
                                    }
                                } else { 
                                %>
                                <tr>
                                    <td colspan="9" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">No guest data available</p>
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

    <!-- Guest Details Modal -->
    <div class="modal fade" id="guestDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-person"></i> Guest Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="guestDetailsContent">
                    <!-- Content will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hotel-outline" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Guest Modal -->
    <div class="modal fade" id="editGuestModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-pencil"></i> Edit Guest Information
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%= request.getContextPath() %>/guest-management" method="post" id="editGuestForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="guestId" id="editGuestId">
                        <div class="mb-3">
                            <label class="form-label">First Name</label>
                            <input type="text" name="firstName" id="editFirstName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Last Name</label>
                            <input type="text" name="lastName" id="editLastName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" id="editEmail" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone Number</label>
                            <input type="tel" name="phone" id="editPhone" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">ID/Passport Number</label>
                            <input type="text" name="idNumber" id="editIdNumber" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Nationality</label>
                            <input type="text" name="nationality" id="editNationality" class="form-control">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hotel-outline" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="editGuestForm" class="btn-hotel">Update</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterGuests() {
            const searchTerm = document.getElementById('guestSearch').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            const table = document.getElementById('guestsTable');
            const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const guestName = row.cells[1].textContent.toLowerCase();
                const phone = row.cells[3].textContent.toLowerCase();
                const status = row.cells[7].textContent.toLowerCase();
                
                let showRow = true;
                
                if (searchTerm && !guestName.includes(searchTerm) && !phone.includes(searchTerm)) {
                    showRow = false;
                }
                
                if (statusFilter) {
                    if (statusFilter === 'active' && !status.includes('checked in')) {
                        showRow = false;
                    } else if (statusFilter === 'inactive' && !status.includes('not checked in')) {
                        showRow = false;
                    }
                }
                
                row.style.display = showRow ? '' : 'none';
            }
        }
        
        function clearFilters() {
            document.getElementById('guestSearch').value = '';
            document.getElementById('statusFilter').value = '';
            filterGuests();
        }
        
        function viewGuestDetails(guestId) {
            const modal = new bootstrap.Modal(document.getElementById('guestDetailsModal'));
            document.getElementById('guestDetailsContent').innerHTML = `
                <div class="text-center">
                    <i class="bi bi-hourglass-split" style="font-size: 3rem;"></i>
                    <p class="mt-3">Loading guest information...</p>
                </div>
            `;
            modal.show();
            
            setTimeout(() => {
                document.getElementById('guestDetailsContent').innerHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Personal Information</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>ID:</strong></td><td>#${guestId}</td></tr>
                                <tr><td><strong>Name:</strong></td><td>John Doe</td></tr>
                                <tr><td><strong>Phone:</strong></td><td>0123456789</td></tr>
                                <tr><td><strong>Email:</strong></td><td>guest@example.com</td></tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>Booking History</h6>
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Total Bookings:</strong></td><td>3 times</td></tr>
                                <tr><td><strong>Last Booking:</strong></td><td>2024-01-15</td></tr>
                                <tr><td><strong>Current Room:</strong></td><td>102</td></tr>
                                <tr><td><strong>Status:</strong></td><td>Checked In</td></tr>
                            </table>
                        </div>
                    </div>
                `;
            }, 1000);
        }
        
        function editGuest(guestId) {
            const modal = new bootstrap.Modal(document.getElementById('editGuestModal'));
            document.getElementById('editGuestId').value = guestId;
            modal.show();
        }
        
        function deleteGuest(guestId) {
            if (confirm('Are you sure you want to delete this guest?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/guest-management';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                
                const guestIdInput = document.createElement('input');
                guestIdInput.type = 'hidden';
                guestIdInput.name = 'guestId';
                guestIdInput.value = guestId;
                form.appendChild(guestIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>

</html>