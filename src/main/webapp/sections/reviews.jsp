<%-- Reviews Management Page --%>
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
                <!-- Messages -->
                <% String successMessage=(String) request.getAttribute("successMessage"); String errorMessage=(String)
                    request.getAttribute("errorMessage"); %>
                    <% if (successMessage !=null) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Success!</strong>
                            <%= successMessage %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>
                            <% if (errorMessage !=null) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <strong>Error!</strong>
                                    <%= errorMessage %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>

                <!-- Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h1 class="display-6 mb-3">
                            <i class="bi bi-star"></i> Guest Reviews
                        </h1>
                        <p class="lead">Manage and view guest reviews and ratings</p>
                    </div>
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
                            <div class="stats-label"><i class="bi bi-star-fill"></i> Average Rating</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-success">
                                <%= totalReviews %>
                            </div>
                            <div class="stats-label"><i class="bi bi-chat-square"></i> Total Reviews</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-info">
                                <%= publicReviews %>
                            </div>
                            <div class="stats-label"><i class="bi bi-check-circle"></i> Public Reviews</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-danger">
                                <%= hiddenReviews %>
                            </div>
                            <div class="stats-label"><i class="bi bi-eye-slash"></i> Hidden Reviews</div>
                        </div>
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="dashboard-card p-4 mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-funnel"></i> Filter Reviews
                    </h5>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Rating</label>
                            <select class="form-select" id="ratingFilter">
                                <option value="">All Ratings</option>
                                <option value="5">5 Stars</option>
                                <option value="4">4 Stars</option>
                                <option value="3">3 Stars</option>
                                <option value="2">2 Stars</option>
                                <option value="1">1 Star</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" id="statusFilter">
                                <option value="">All</option>
                                <option value="public">Public</option>
                                <option value="private">Private</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Sort By</label>
                            <select class="form-select" id="sortFilter">
                                <option value="recent">Most Recent</option>
                                <option value="oldest">Oldest</option>
                                <option value="highest">Highest Rated</option>
                                <option value="lowest">Lowest Rated</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <button class="btn-hotel w-100">
                                <i class="bi bi-search"></i> Filter
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Reviews List -->
                <div class="dashboard-card p-4">
                    <h5 class="mb-4">
                        <i class="bi bi-list-check"></i> All Reviews
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
                                </strong> - Booking ID: #<%= review.get("booking_id") %>
                                    <br><small class="text-muted">Posted on <%= review.get("review_date") %></small>
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
                            <%= review.get("review_text") %>
                        </p>
                        <div class="mt-3">
                            <small class="text-muted">Status:
                                <span class="badge <%= (Boolean) review.get(" is_public") ? "bg-success" : "bg-secondary" %>">
                                    <%= (Boolean) review.get("is_public") ? "Public" : "Private" %>
                                </span>
                            </small>
                            <div class="mt-2">
                                <form method="post" action="<%= request.getContextPath() %>/reviews" style="display:inline;">
                                    <input type="hidden" name="action" value="toggleVisibility">
                                    <input type="hidden" name="reviewId" value="<%= review.get(" review_id") %>">
                                    <button type="submit" class="btn btn-sm btn-hotel-outline" title="Toggle Visibility">
                                        <i class="bi <%= (Boolean) review.get(" is_public") ? "bi-eye-slash" : "bi-eye" %>"></i>
                                        <%= (Boolean) review.get("is_public") ? "Hide" : "Show" %>
                                    </button>
                                </form>
                                <form method="post" action="<%= request.getContextPath() %>/reviews" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="reviewId" value="<%= review.get(" review_id") %>">
                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">
                                        <i class="bi bi-trash"></i> Delete
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% } } else { %>
                    <!-- Empty State -->
                    <div class="text-center py-4">
                        <i class="bi bi-inbox display-4 text-muted"></i>
                        <p class="text-muted mt-2">No reviews available</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />
</body>
</html>
