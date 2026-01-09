<%-- Guests Management Page --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="util.PermissionUtil" %>
<style>
/* Gradient backgrounds */
.bg-gradient-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.bg-gradient-success {
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
}

.bg-gradient-info {
    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.bg-gradient-secondary {
    background: linear-gradient(135deg, #89898d 0%, #a8a8ab 100%);
}

/* Card styling */
.card-modern {
    border-radius: 15px;
    overflow: hidden;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card-modern:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 35px rgba(0,0,0,0.15) !important;
}

.card-header {
    border: none;
}

/* Table styling */
.table {
    font-size: 0.95rem;
}

.table thead th {
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.85rem;
    letter-spacing: 0.5px;
    border: none;
    padding: 1rem;
}

.table tbody td {
    padding: 1rem;
    vertical-align: middle;
    border-color: #f0f0f0;
}

.guest-row {
    transition: all 0.3s ease;
}

.guest-row:hover {
    background-color: #f8f9ff !important;
    transform: scale(1.01);
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

/* Avatar circle */
.avatar-circle {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
}

/* Badge enhancements */
.badge {
    font-weight: 500;
    letter-spacing: 0.3px;
    transition: all 0.3s ease;
}

.badge:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

/* Button group styling */
.btn-group .btn {
    transition: all 0.3s ease;
    border-width: 2px;
}

.btn-group .btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}

.btn-outline-success:hover {
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
    border-color: #11998e;
}

.btn-outline-primary:hover {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-color: #667eea;
}

.btn-outline-danger:hover {
    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
    border-color: #ff6b6b;
}

/* Empty state */
.empty-state {
    padding: 2rem;
}

.empty-state i {
    animation: float 3s ease-in-out infinite;
}

@keyframes float {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
}

/* Link styling */
a.text-decoration-none:hover {
    text-decoration: underline !important;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .table {
        font-size: 0.85rem;
    }
    
    .btn-group .btn {
        padding: 0.25rem 0.5rem;
        font-size: 0.85rem;
    }
    
    .badge {
        font-size: 0.75rem;
        padding: 0.35rem 0.6rem !important;
    }
}
</style>
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
                        <i class="bi bi-people"></i> Quản lý khách
                    </div>
                    <div class="page-subtitle">Quản lý thông tin khách và lịch sử đặt phòng</div>
                </div>
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
                            <i class="bi bi-people"></i> Tổng số khách
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
                            <i class="bi bi-person-check"></i> Đang lưu trú
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
                            <i class="bi bi-star"></i> Khách VIP
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
                            <i class="bi bi-person-plus"></i> Khách mới
                        </div>
                    </div>
                </div>

                <!-- Add Guest Form -->
                <div class="card-modern mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-person-plus"></i> Thêm khách mới
                    </h5>
                    <% if (PermissionUtil.hasPermission(session, "guests.create" )) { %>
                        <form action="<%= request.getContextPath() %>/guests" method="post" class="row g-3">
                        <input type="hidden" name="action" value="add">
                        <div class="col-md-3">
                            <label class="form-label">Tên</label>
                            <input type="text" name="firstName" class="form-control" placeholder="Nhập tên" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Họ</label>
                            <input type="text" name="lastName" class="form-control" placeholder="Nhập họ" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" name="phone" class="form-control" placeholder="Nhập số điện thoại" required>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn-modern btn-success" type="submit">
                                <i class="bi bi-plus"></i> Thêm khách
                            </button>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" placeholder="Nhập email">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Số CMND/CCCD/Hộ chiếu</label>
                            <input type="text" name="idNumber" class="form-control" placeholder="Nhập số CMND/CCCD/Hộ chiếu" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Quốc tịch</label>
                            <input type="text" name="nationality" class="form-control" placeholder="Nhập quốc tịch" value="Vietnam">
                        </div>
                    </form>
                    <% } else { %>
                        <div class="text-muted">Bạn không có quyền thêm khách.</div>
                        <% } %>
                </div>

                <!-- Search and Filter -->
                <div class="card-modern mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-search"></i> Tìm kiếm và lọc
                    </h5>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <input type="text" class="form-control" placeholder="Tìm theo tên hoặc số điện thoại" id="guestSearch">
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="statusFilter">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active">Đang lưu trú</option>
                                <option value="inactive">Chưa nhận phòng</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex justify-content-center align-items-center">
                            <button class="btn btn-primary d-flex mx-2" onclick="filterGuests()">
                                <i class="bi bi-funnel me-2"></i> Lọc
                            </button>
                            <button class="btn btn-outline-secondary d-flex ms-2" onclick="clearFilters()">
                                <i class="bi bi-x-circle ms-2"></i> Xóa bộ lọc
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Guests Table -->
                <div class="card-modern shadow-lg border-0">
    <div class="card-header bg-gradient-primary text-white py-4">
        <h5 class="mb-0 d-flex align-items-center ">
            <i class="bi bi-people-fill me-2 fs-4"></i> 
            <span class="fw-bold " >Danh sách khách hàng</span>
        </h5>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" id="guestsTable">
                <thead class="table-da">
                    <tr class="table-dak">
                        <th class="text-center"><i class="bi bi-hash me-1"></i> ID</th>
                        <th><i class="bi bi-person-circle me-1"></i> Họ tên</th>
                        <th><i class="bi bi-card-text me-1"></i> CMND/CCCD</th>
                        <th><i class="bi bi-telephone-fill me-1"></i> Điện thoại</th>
                        <th><i class="bi bi-envelope-fill me-1"></i> Email</th>
                        <th><i class="bi bi-globe-americas me-1"></i> Quốc tịch</th>
                        <th class="text-center"><i class="bi bi-door-open-fill me-1"></i> Phòng</th>
                        <th class="text-center"><i class="bi bi-flag-fill me-1"></i> Trạng thái</th>
                        <th class="text-center"><i class="bi bi-gear-fill me-1"></i> Thao tác</th>
                    </tr>
                </thead>
                <tbody >
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
                            
                            String statusClass = bookingStatus != null ? "bg-gradient-success" : "bg-gradient-secondary";
                            String statusText = bookingStatus != null ? "Đang lưu trú" : "Chưa nhận phòng";
                            String statusIcon = bookingStatus != null ? "bi-check-circle-fill" : "bi-clock-fill";
                    %>
                    <tr class="guest-row">
                        <td class="text-center">
                            <span class="badge bg-primary rounded-pill px-3 py-2">
                                <strong>#<%= guestId %></strong>
                            </span>
                        </td>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="avatar-circle bg-gradient-info me-2">
                                    <i class="bi bi-person-fill text-white"></i>
                                </div>
                                <strong class="text-dark"><%= fullName %></strong>
                            </div>
                        </td>
                        <td>
                            <span class="text-secondary">
                                <i class="bi bi-credit-card-2-front me-1 text-primary"></i>
                                <%= idNumber != null ? idNumber : "<span class='text-muted'>Không có</span>" %>
                            </span>
                        </td>
                        <td>
                            <% if (phone != null) { %>
                                <a href="tel:<%= phone %>" class="text-decoration-none text-success">
                                    <i class="bi bi-phone-vibrate me-1"></i><%= phone %>
                                </a>
                            <% } else { %>
                                <span class="text-muted">Không có</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (email != null) { %>
                                <a href="mailto:<%= email %>" class="text-decoration-none text-info">
                                    <i class="bi bi-envelope-at me-1"></i><%= email %>
                                </a>
                            <% } else { %>
                                <span class="text-muted">Không có</span>
                            <% } %>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark border">
                                <i class="bi bi-flag me-1 text-danger"></i>
                                <%= nationality != null ? nationality : "N/A" %>
                            </span>
                        </td>
                        <td class="text-center">
                            <% if (roomNumber != null) { %>
                                <span class="badge bg-gradient-info px-3 py-2 fs-6">
                                    <i class="bi bi-door-closed-fill me-1"></i>
                                    Phòng <%= roomNumber %>
                                </span>
                            <% } else { %>
                                <span class="text-muted">-</span>
                            <% } %>
                        </td>
                        <td class="text-center">
                            <span class="badge <%= statusClass %> px-3 py-2">
                                <i class="bi <%= statusIcon %> me-1"></i>
                                <%= statusText %>
                            </span>
                        </td>
                        <td class="text-center">
                            <div class="btn-group" role="group">
                                <button class="btn btn-sm btn-outline-success" 
                                        onclick="viewGuestDetails('<%= guestId %>')" 
                                        title="Xem chi tiết"
                                        data-bs-toggle="tooltip">
                                    <i class="bi bi-eye-fill"></i>
                                </button>
                                <% if (PermissionUtil.hasPermission(session, "guests.edit")) { %>
                                    <button class="btn btn-sm btn-outline-primary" 
                                            onclick="editGuest('<%= guestId %>')" 
                                            title="Chỉnh sửa"
                                            data-bs-toggle="tooltip">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                <% } %>
                                <% if (PermissionUtil.hasPermission(session, "guests.delete")) { %>
                                    <button class="btn btn-sm btn-outline-danger" 
                                            onclick="deleteGuest('<%= guestId %>')" 
                                            title="Xóa"
                                            data-bs-toggle="tooltip">
                                        <i class="bi bi-trash3-fill"></i>
                                    </button>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% 
                        }
                    } else { 
                    %>
                    <tr>
                        <td colspan="9" class="text-center py-5">
                            <div class="empty-state">
                                <i class="bi bi-inbox display-1 text-primary opacity-25"></i>
                                <h5 class="text-muted mt-3 mb-2">Không có dữ liệu khách</h5>
                                <p class="text-muted small">Danh sách khách hiện đang trống</p>
                            </div>
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
    </div>

    <!-- Guest Details Modal -->
    <div class="modal fade" id="guestDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-person"></i> Chi tiết khách
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="guestDetailsContent">
                    <!-- Content will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-bs-dismiss="modal" >Đóng</button>
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
                        <i class="bi bi-pencil"></i> Chỉnh sửa thông tin khách
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%= request.getContextPath() %>/guests" method="post" id="editGuestForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="guestId" id="editGuestId">
                        <div class="mb-3">
                            <label class="form-label">Tên</label>
                            <input type="text" name="firstName" id="editFirstName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Họ</label>
                            <input type="text" name="lastName" id="editLastName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" id="editEmail" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" name="phone" id="editPhone" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số CMND/CCCD/Hộ chiếu</label>
                            <input type="text" name="idNumber" id="editIdNumber" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Quốc tịch</label>
                            <input type="text" name="nationality" id="editNationality" class="form-control">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hotel-outline" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" form="editGuestForm" class="btn-hotel">Cập nhật</button>
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
                    if (statusFilter === 'active' && !status.includes('đang lưu trú')) {
                        showRow = false;
                    } else if (statusFilter === 'inactive' && !status.includes('chưa nhận phòng')) {
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
                    <p class="mt-3">Đang tải thông tin khách...</p>
                </div>
            `;
            modal.show();
            
            setTimeout(() => {
                document.getElementById('guestDetailsContent').innerHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Thông tin cá nhân</h6>
                            <table class="table table-sm">
                                <tr><td><strong>Mã:</strong></td><td>#${guestId}</td></tr>
                                <tr><td><strong>Họ tên:</strong></td><td>John Doe</td></tr>
                                <tr><td><strong>Số điện ng></td><td>0123456789</td></tr>
                                <tr><td><strong>Email:</strong></td><td>guest@example.com</td></tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>Lịch sử đặt phòng</h6>
                            <table class="table table-sm">
                                <tr><td><strong>Tổng đặt phòng:</strong></td><td>3 lần</td></tr>
                                <tr><td><strong>Lần đặt gần nhất:</strong></td><td>2024-01-15</td></tr>
                                <tr><td><strong>Phòng hiện tại:</strong></td><td>102</td></tr>
                                <tr><td><strong>Trạng thái:</strong></td><td>Đang lưu trú</td></tr>
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
            if (confirm('Bạn có chắc chắn muốn xóa khách này không?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/guests';
                
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