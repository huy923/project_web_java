<%-- Payments Management Page --%>
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
            </div>
            
            <!-- Main Content -->
            <div class="col-lg-9 col-md-8">
                <!-- Header -->
                <div class="page-header">
                    <div class="page-title">
                        <i class="bi bi-credit-card"></i> Payment Management
                    </div>
                    <div class="page-subtitle">Manage and track all hotel payment transactions</div>
                </div>

                <!-- Alert Messages -->
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

                <!-- Filter Section -->
                <div class="card-modern mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-funnel"></i> Payment Filter
                    </h5>
                    <form method="GET" class="row g-3">
                        <div class="col-md-4">
                            <select name="status" class="form-select">
                                <option value="">All Status</option>
                                <option value="completed" <%= "completed".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Completed</option>
                                <option value="pending" <%= "pending".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Pending</option>
                                <option value="failed" <%= "failed".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Failed</option>
                                <option value="refunded" <%= "refunded".equals(request.getAttribute("statusFilter")) ? "selected" : "" %>>Refunded</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <button type="submit" class="btn-modern btn-primary">
                                <i class="bi bi-search"></i> Filter
                            </button>
                            <a href="<%= request.getContextPath() %>/payments" class="btn-modern btn-ghost">
                                <i class="bi bi-x-circle"></i> Clear Filters
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Add Payment Form -->
                <div class="card-modern mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-plus-circle"></i> Add New Payment
                    </h5>
                    <form method="POST" action="<%= request.getContextPath() %>/payments" class="row g-3">
                        <input type="hidden" name="action" value="add_payment">
                        <div class="col-md-2">
                            <label class="form-label">Booking ID</label>
                            <input type="number" name="booking_id" class="form-control" placeholder="Enter booking ID" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Amount</label>
                            <input type="number" name="amount" class="form-control" placeholder="Enter amount" step="0.01" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Payment Type</label>
                            <select name="payment_type" class="form-select" required>
                                <option value="">Select Type</option>
                                <option value="cash">Cash</option>
                                <option value="credit_card">Credit Card</option>
                                <option value="debit_card">Debit Card</option>
                                <option value="bank_transfer">Bank Transfer</option>
                                <option value="online">Online</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Transaction ID</label>
                            <input type="text" name="transaction_id" class="form-control" placeholder="Enter transaction ID">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Notes</label>
                            <input type="text" name="notes" class="form-control" placeholder="Enter notes">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn-hotel w-100" type="submit">
                                <i class="bi bi-plus"></i> Add Payment
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Payments Table -->
                <div class="card-modern">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Payment List
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> Payment ID</th>
                                    <th><i class="bi bi-calendar-check"></i> Booking ID</th>
                                    <th><i class="bi bi-person"></i> Guest</th>
                                    <th><i class="bi bi-door-open"></i> Room</th>
                                    <th><i class="bi bi-credit-card"></i> Payment Type</th>
                                    <th><i class="bi bi-flag"></i> Status</th>
                                    <th><i class="bi bi-currency-dollar"></i> Amount</th>
                                    <th><i class="bi bi-clock"></i> Payment Date</th>
                                    <th><i class="bi bi-person-gear"></i> Processed By</th>
                                    <th><i class="bi bi-gear"></i> Actions</th>
                                </tr>
                            </thead>
                <tbody>
                    <% List<Map<String, Object>> payments = (List<Map<String, Object>>) request.getAttribute("payments");
                        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        
                        if (payments != null && !payments.isEmpty()) {
                            for (Map<String, Object> payment : payments) {
                    %>
                    <tr>
                        <td><%= payment.get("payment_id") %></td>
                        <td><%= payment.get("booking_id") %></td>
                        <td>
                            <%= payment.get("first_name") %> <%= payment.get("last_name") %><br>
                            <small class="text-muted"><%= payment.get("phone") %></small>
                        </td>
                        <td>
                            <%= payment.get("room_number") %><br>
                            <small class="text-muted"><%= payment.get("type_name") %></small>
                        </td>
                        <td>
                            <%
                                String paymentType = (String) payment.get("payment_type");
                                String typeDisplay = "";
                                if ("cash".equals(paymentType)) {
                                    typeDisplay = "Cash";
                                } else if ("credit_card".equals(paymentType)) {
                                    typeDisplay = "Credit Card";
                                } else if ("debit_card".equals(paymentType)) {
                                    typeDisplay = "Debit Card";
                                } else if ("bank_transfer".equals(paymentType)) {
                                    typeDisplay = "Bank Transfer";
                                } else if ("online".equals(paymentType)) {
                                    typeDisplay = "Online";
                                } else {
                                    typeDisplay = paymentType;
                                }
                            %>
                            <%= typeDisplay %>
                        </td>
                        <td>
                            <%
                                String status = (String) payment.get("payment_status");
                                String statusClass = "";
                                String statusDisplay = "";
                                if ("completed".equals(status)) {
                                    statusClass = "status-completed";
                                    statusDisplay = "Completed";
                                } else if ("pending".equals(status)) {
                                    statusClass = "status-pending";
                                    statusDisplay = "Pending";
                                } else if ("failed".equals(status)) {
                                    statusClass = "status-failed";
                                    statusDisplay = "Failed";
                                } else if ("refunded".equals(status)) {
                                    statusClass = "status-refunded";
                                    statusDisplay = "Refunded";
                                } else {
                                    statusClass = "status-pending";
                                    statusDisplay = status;
                                }
                            %>
                            <span class="badge status-badge <%= statusClass %>"><%= statusDisplay %></span>
                        </td>
                        <td><%= currencyFormat.format(payment.get("amount")) %></td>
                        <td>
                            <%
                                java.sql.Timestamp paymentDate = (java.sql.Timestamp) payment.get("payment_date");
                                if (paymentDate != null) {
                            %>
                                <%= dateFormat.format(paymentDate) %>
                            <% } else { %>
                                -
                            <% } %>
                        </td>
                        <td>
                            <%
                                String processedByName = (String) payment.get("processed_by_name");
                                if (processedByName != null) {
                            %>
                                <%= processedByName %>
                            <% } else { %>
                                -
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group" role="group">
                                <button class="btn btn-sm btn-hotel-outline" onclick="showPaymentDetails(<%= payment.get("payment_id") %>)">
                                    <i class="bi bi-eye"></i> Details
                                </button>
                                <% if (!"completed".equals(status) && !"refunded".equals(status)) { %>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-hotel-outline dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                            <i class="bi bi-pencil"></i> Update
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#" onclick="updateStatus(<%= payment.get("payment_id") %>, 'completed')">
                                                <i class="bi bi-check-circle text-success"></i> Completed
                                            </a></li>
                                            <li><a class="dropdown-item" href="#" onclick="updateStatus(<%= payment.get("payment_id") %>, 'failed')">
                                                <i class="bi bi-x-circle text-danger"></i> Failed
                                            </a></li>
                                            <li><a class="dropdown-item" href="#" onclick="updateStatus(<%= payment.get("payment_id") %>, 'refunded')">
                                                <i class="bi bi-arrow-clockwise text-warning"></i> Refunded
                                            </a></li>
                                        </ul>
                                    </div>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                            <tr>
                                <td colspan="10" class="text-center py-4">
                                    <i class="bi bi-inbox display-4 text-muted"></i>
                                    <p class="text-muted mt-2">No payment data available</p>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

    <!-- Payment Details Modal -->
    <div class="modal fade" id="paymentDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-credit-card"></i> Payment Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="paymentDetailsContent">
                    <!-- Content will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hotel-outline" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden form for status updates -->
    <form id="statusUpdateForm" method="POST" action="<%= request.getContextPath() %>/payments" style="display: none;">
        <input type="hidden" name="action" value="update_status">
        <input type="hidden" name="payment_id" id="updatePaymentId">
        <input type="hidden" name="new_status" id="updateNewStatus">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showPaymentDetails(paymentId) {
            // This would typically make an AJAX call to get payment details
            // For now, we'll show a simple message
            document.getElementById('paymentDetailsContent').innerHTML = 
                '<p>Payment Details #' + paymentId + '</p><p>This feature will be developed further.</p>';
            
            var modal = new bootstrap.Modal(document.getElementById('paymentDetailsModal'));
            modal.show();
        }

        function updateStatus(paymentId, newStatus) {
            if (confirm('Are you sure you want to update this payment status?')) {
                document.getElementById('updatePaymentId').value = paymentId;
                document.getElementById('updateNewStatus').value = newStatus;
                document.getElementById('statusUpdateForm').submit();
            }
        }
    </script>
</body>

</html>