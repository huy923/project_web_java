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
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-warning">0.0</div>
                            <div class="stats-label"><i class="bi bi-star-fill"></i> Average Rating</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-success">0</div>
                            <div class="stats-label"><i class="bi bi-chat-square"></i> Total Reviews</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-info">0</div>
                            <div class="stats-label"><i class="bi bi-check-circle"></i> Public Reviews</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="stat-number text-danger">0</div>
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
                    
                    <!-- Sample Review Card -->
                    <div class="review-card">
                        <div class="review-header">
                            <div>
                                <strong>Guest Name</strong> - Booking ID: #12345
                                <br><small class="text-muted">Posted on 2024-01-15</small>
                            </div>
                            <div>
                                <span class="review-stars">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                </span>
                            </div>
                        </div>
                        <h6>Great stay!</h6>
                        <p class="review-body">
                            The room was clean and comfortable. The staff was very helpful and friendly. I would definitely recommend this hotel to my friends and family.
                        </p>
                        <div class="mt-3">
                            <small class="text-muted">Status: <span class="badge bg-success">Public</span></small>
                            <div class="mt-2">
                                <button class="btn btn-sm btn-hotel-outline" title="Edit">
                                    <i class="bi bi-pencil"></i> Edit
                                </button>
                                <button class="btn btn-sm btn-hotel-outline" title="Delete">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                                <button class="btn btn-sm btn-hotel-outline" title="Toggle Visibility">
                                    <i class="bi bi-eye-slash"></i> Hide
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Empty State -->
                    <div class="text-center py-4">
                        <i class="bi bi-inbox display-4 text-muted"></i>
                        <p class="text-muted mt-2">No reviews available</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />
</body>
</html>
