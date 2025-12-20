<%-- Reviews Management Page --%>
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
            </div>
            
            <!-- Main Content -->
            <div class="col-lg-9 col-md-8">
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

                <!-- Header -->
                <div class="page-header">
                    <div class="page-title">
                        <i class="bi bi-star"></i> Đánh giá của khách
                    </div>
                    <div class="page-subtitle">Quản lý và xem đánh giá/xếp hạng của khách</div>
                </div>

                <!-- Statistics -->
                <% List<Map<String, Object>> reviews = (List<Map<String, Object>>) request.getAttribute("reviews");
                        Double avgRating = (Double) request.getAttribute("avgRating");
                        if (avgRating == null) avgRating = 0.0;
                
                        int totalReviews = reviews != null ? reviews.size() : 0;
                        int publicReviews = 0, hiddenReviews = 0;
                        if (reviews != null) {
                        for (Map<String, Object> review : reviews) {
                            Boolean isPublic = (Boolean) review.get("is_public");
                            if (isPublic != null && isPublic) publicReviews++;
                            else hiddenReviews++;
                            }
                            }
                            %>
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-warning">
                                <%= String.format("%.1f", avgRating) %>
                            </div>
                            <div class="stats-label"><i class="bi bi-star-fill"></i> Điểm trung bình</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-success">
                                <%= totalReviews %>
                            </div>
                            <div class="stats-label"><i class="bi bi-chat-square"></i> Tổng đánh giá</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-info">
                                <%= publicReviews %>
                            </div>
                            <div class="stats-label"><i class="bi bi-check-circle"></i> Đánh giá công khai</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-danger">
                                <%= hiddenReviews %>
                            </div>
                            <div class="stats-label"><i class="bi bi-eye-slash"></i> Đánh giá ẩn</div>
                        </div>
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="card-modern mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-funnel"></i> Lọc đánh giá
                    </h5>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Xếp hạng</label>
                            <select class="form-select" id="ratingFilter">
                                <option value="">Tất cả</option>
                                <option value="5">5 sao</option>
                                <option value="4">4 sao</option>
                                <option value="3">3 sao</option>
                                <option value="2">2 sao</option>
                                <option value="1">1 sao</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select" id="statusFilter">
                                <option value="">Tất cả</option>
                                <option value="public">Công khai</option>
                                <option value="private">Riêng tư</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Sắp xếp theo</label>
                            <select class="form-select" id="sortFilter">
                                <option value="recent">Mới nhất</option>
                                <option value="oldest">Cũ nhất</option>
                                <option value="highest">Điểm cao nhất</option>
                                <option value="lowest">Điểm thấp nhất</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn-hotel w-100">
                                <i class="bi bi-search"></i> Lọc
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Reviews List -->
                <div class="card-modern">
                    <h5 class="mb-4">
                        <i class="bi bi-list-check"></i> Tất cả đánh giá
                    </h5>
                    
                    <% if (reviews !=null && !reviews.isEmpty()) { for (Map<String, Object> review : reviews) {
                        Integer rating = Integer.parseInt(review.get("rating").toString());
                        %>
                        <!-- Review Card -->
                    <div class="review-card">
                        <div class="review-header">
                            <div>
                                <strong>
                                    <%= review.get("guest_name") %>
                                </strong> - Mã đặt phòng: #<%= review.get("booking_id") %>
                                    <br><small class="text-muted">Đăng lúc <%= review.get("created_at") %></small>
                            </div>
                            <div>
                                <span class="review-stars">
                                    <% for (int i=0; i < 5; i++) { if (i < rating) { %>
                                        <i class="bi bi-star-fill" style="color: gold;"></i>
                                        <% } else { %>
                                            <i class="bi bi-star"></i>
                                            <% } } %>
                                </span>
                            </div>
                        </div>
                        <h6>
                            <%= review.get("title") %>
                        </h6>
                        <p class="review-body">
                            <%= review.get("comment") %>
                        </p>
                        <div class="mt-3">
                            <small class="text-muted">Trạng thái:
                                <span class="badge <%= (Boolean) review.get(" is_public") ? "bg-success" : "bg-secondary" %>">
                                    <%= (Boolean) review.get("is_public") ? "Công khai" : "Riêng tư" %>
                                </span>
                            </small>
                            <div class="mt-2">
                                <% if (PermissionUtil.canEdit(session, "reviews" )) { %>
                                    <form method="post" action="<%= request.getContextPath() %>/reviews" style="display:inline;">
                                        <input type="hidden" name="action" value="toggleVisibility">
                                        <input type="hidden" name="reviewId" value="<%= review.get(" review_id") %>">
                                        <button type="submit" class="btn btn-sm btn-hotel-outline" title="Chuyển hiển thị">
                                            <i class="bi <%= (Boolean) review.get(" is_public") ? "bi-eye-slash" : "bi-eye" %>"></i>
                                            <%= (Boolean) review.get("is_public") ? "Ẩn" : "Hiện" %>
                                        </button>
                                        </form>
                                <% } %>
                                    <% if (PermissionUtil.canDelete(session, "reviews" )) { %>
                                    <form method="post" action="<%= request.getContextPath() %>/reviews" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="reviewId" value="<%= review.get(" review_id") %>">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn không?')">
                                            <i class="bi bi-trash"></i> Xóa
                                        </button>
                                        </form>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% } } else { %>
                    <!-- Empty State -->
                    <div class="text-center py-4">
                        <i class="bi bi-inbox display-4 text-muted"></i>
                        <p class="text-muted mt-2">Chưa có đánh giá nào</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    
</body>
</html>
