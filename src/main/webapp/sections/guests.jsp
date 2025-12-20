<%-- Guests Management Page --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="util.PermissionUtil" %>
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
                <div class="card-modern">
                    <h5 class="mb-3">
                        <i class="bi bi-table"></i> Danh sách khách
                    </h5>
                    <div class="table-responsive overflow-x-auto">
                        <table class="table table-striped table-hover" id="guestsTable">
                            <thead>
                                <tr>
                                    <th><i class="bi bi-hash"></i> ID</th>
                                    <th><i class="bi bi-person"></i> Họ tên</th>
                                    <th><i class="bi bi-card-text"></i> CMND/CCCD/Hộ chiếu</th>
                                    <th><i class="bi bi-telephone"></i> Số điện thoại</th>
                                    <th><i class="bi bi-envelope"></i> Email</th>
                                    <th><i class="bi bi-globe"></i> Quốc tịch</th>
                                    <th><i class="bi bi-door-open"></i> Phòng hiện tại</th>
                                    <th><i class="bi bi-flag"></i> Trạng thái</th>
                                    <th><i class="bi bi-gear"></i> Thao tác</th>
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
                                        String statusText = bookingStatus != null ? "Đang lưu trú" : "Chưa nhận phòng";
                                %>
                                <tr>
                                    <td><strong>#<%= guestId %></strong></td>
                                    <td><%= fullName %></td>
                                    <td>
                                        <%= idNumber !=null ? idNumber : "Không có" %>
                                    </td>
                                    <td>
                                        <%= phone !=null ? phone : "Không có" %>
                                    </td>
                                    <td>
                                        <%= email !=null ? email : "Không có" %>
                                    </td>
                                    <td>
                                        <%= nationality !=null ? nationality : "Không có" %>
                                    </td>
                                    <td>
                                        <% if (roomNumber != null) { %>
                                            <span class="badge bg-info">Phòng <%= roomNumber %></span>
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
                                            <button class="btn btn-sm btn-success" onclick="viewGuestDetails('<%= guestId %>')" title="Xem chi tiết">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <% if (PermissionUtil.hasPermission(session, "guests.edit" )) { %>
                                                <button class="btn btn-sm btn-primary" onclick="editGuest('<%= guestId %>')" title="Chỉnh sửa thông tin">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <% } %>
                                                <% if (PermissionUtil.hasPermission(session, "guests.delete" )) { %>
                                                    <button class="btn btn-sm btn-danger" onclick="deleteGuest('<%= guestId %>')" title="Xóa khách">
                                                <i class="bi bi-trash"></i>
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
                                    <td colspan="9" class="text-center py-4">
                                        <i class="bi bi-inbox display-4 text-muted"></i>
                                        <p class="text-muted mt-2">Không có dữ liệu khách</p>
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
                        <i class="bi bi-person"></i> Chi tiết khách
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="guestDetailsContent">
                    <!-- Content will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-hotel-outline" data-bs-dismiss="modal">Đóng</button>
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
                            <table class="table table-dark table-sm">
                                <tr><td><strong>Mã:</strong></td><td>#${guestId}</td></tr>
                                <tr><td><strong>Họ tên:</strong></td><td>John Doe</td></tr>
                                <tr><td><strong>Số điện ng></td><td>0123456789</td></tr>
                                <tr><td><strong>Email:</strong></td><td>guest@example.com</td></tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>Lịch sử đặt phòng</h6>
                            <table class="table table-dark table-sm">
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