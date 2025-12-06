<%-- Invoices Management Page --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.util.Map" %>
                <jsp:include page="/includes/header.jsp" />

                <div class="px-2 main-container">
                    <div class="row">
                        <div class="col-lg-3 col-md-4 mb-4">
                            <jsp:include page="/includes/sidebar.jsp" />
                        </div>

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
                                                        <i class="bi bi-receipt"></i> Invoice Management
                                                    </div>
                                                    <div class="page-subtitle">Generate and manage guest invoices</div>
                                                </div>

                                                <!-- Statistics -->
                                                <div class="grid-4 mb-4">
                                                    <div class="stat-card">
                                                        <div class="stat-number text-info">
                                                            <% List<Map<String, Object>> invoices = (List<Map<String,
                                                                    Object>>) request.getAttribute("invoices");
                                                                    int totalInvoices = invoices != null ?
                                                                    invoices.size() : 0;
                                                                    %>
                                                                    <%= totalInvoices %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-receipt"></i> Total Invoices
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-success">
                                                            <% int paidInvoices=0; if (invoices !=null) { for
                                                                (Map<String, Object> invoice : invoices) {
                                                                if ("paid".equals(invoice.get("status"))) {
                                                                paidInvoices++;
                                                                }
                                                                }
                                                                }
                                                                %>
                                                                <%= paidInvoices %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-check-circle"></i> Paid
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-warning">
                                                            <% int pendingInvoices=totalInvoices - paidInvoices; %>
                                                                <%= pendingInvoices %>
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
                                                            <i class="bi bi-currency-dollar"></i> Total Revenue
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Generate Invoice Form -->
                                                <div class="card-modern mb-4">
                                                    <h5 class="mb-3">
                                                        <i class="bi bi-plus-circle"></i> Generate Invoice
                                                    </h5>
                                                    <form action="<%= request.getContextPath() %>/invoices"
                                                        method="post" class="row g-3">
                                                        <input type="hidden" name="action" value="generate">
                                                        <div class="col-md-3">
                                                            <label class="form-label">Booking ID</label>
                                                            <input type="number" name="bookingId" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Guest Name</label>
                                                            <input type="text" name="guestName" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">Total Amount</label>
                                                            <input type="number" name="totalAmount" class="form-control"
                                                                step="0.01" required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label">&nbsp;</label>
                                                            <button class="btn-modern btn-primary w-100" type="submit">
                                                                <i class="bi bi-plus"></i> Generate
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>

                                                <!-- Invoices List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> Recent Invoices
                                                    </h5>
                                                    <div class="grid-3">
                                                        <% if (invoices !=null && !invoices.isEmpty()) { for
                                                            (Map<String, Object> invoice : invoices) {
                                                            String guestName = (String) invoice.get("guest_name");
                                                            String status = (String) invoice.get("status");
                                                            Object amount = invoice.get("amount");
                                                            %>
                                                            <div class="card-compact">
                                                                <div class="mb-3">
                                                                    <h6 class="mb-1">
                                                                        <%= guestName %>
                                                                    </h6>
                                                                    <p class="text-muted mb-0" style="font-size: 12px;">
                                                                        <i class="bi bi-receipt"></i> Invoice #<%=
                                                                            invoice.get("invoice_id") %>
                                                                    </p>
                                                                </div>
                                                                <div class="mb-3 pb-3 border-bottom">
                                                                    <p class="mb-1"><small
                                                                            class="text-muted">Amount:</small></p>
                                                                    <p class="mb-2"><small><strong>
                                                                                <%= amount %> VNĐ
                                                                            </strong></small></p>
                                                                    <p class="mb-0"><small class="text-muted">Status:
                                                                            <%= status %></small></p>
                                                                </div>
                                                                <div class="d-flex gap-2">
                                                                    <button
                                                                        class="btn-modern btn-ghost btn-sm flex-grow-1"
                                                                        type="button">
                                                                        <i class="bi bi-download"></i> Download
                                                                    </button>
                                                                    <button class="btn-modern btn-danger btn-sm"
                                                                        type="button">
                                                                        <i class="bi bi-trash"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                            <% } } else { %>
                                                                <div class="col-12 text-center py-5">
                                                                    <i class="bi bi-inbox"
                                                                        style="font-size: 3rem; color: var(--text-secondary);"></i>
                                                                    <p class="text-muted mt-3">No invoices available</p>
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