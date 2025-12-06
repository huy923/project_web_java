<%-- Feedback Management Page --%>
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
                                                        <i class="bi bi-chat-dots"></i> Guest Feedback
                                                    </div>
                                                    <div class="page-subtitle">Manage and respond to guest feedback
                                                    </div>
                                                </div>

                                                <!-- Statistics -->
                                                <div class="grid-4 mb-4">
                                                    <div class="stat-card">
                                                        <div class="stat-number text-info">
                                                            <% List<Map<String, Object>> feedbacks = (List<Map<String,
                                                                    Object>>) request.getAttribute("feedbacks");
                                                                    int totalFeedbacks = feedbacks != null ?
                                                                    feedbacks.size() : 0;
                                                                    %>
                                                                    <%= totalFeedbacks %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-chat-dots"></i> Total Feedback
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-success">
                                                            <% int positiveFeedbacks=0; if (feedbacks !=null) { for
                                                                (Map<String, Object> f : feedbacks) {
                                                                if ("positive".equals(f.get("type"))) {
                                                                positiveFeedbacks++;
                                                                }
                                                                }
                                                                }
                                                                %>
                                                                <%= positiveFeedbacks %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-hand-thumbs-up"></i> Positive
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-warning">
                                                            <% int neutralFeedbacks=0; if (feedbacks !=null) { for
                                                                (Map<String, Object> f : feedbacks) {
                                                                if ("neutral".equals(f.get("type"))) {
                                                                neutralFeedbacks++;
                                                                }
                                                                }
                                                                }
                                                                %>
                                                                <%= neutralFeedbacks %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-dash-circle"></i> Neutral
                                                        </div>
                                                    </div>
                                                    <div class="stat-card">
                                                        <div class="stat-number text-danger">
                                                            <% int negativeFeedbacks=totalFeedbacks - positiveFeedbacks
                                                                - neutralFeedbacks; %>
                                                                <%= negativeFeedbacks %>
                                                        </div>
                                                        <div class="stat-label">
                                                            <i class="bi bi-hand-thumbs-down"></i> Negative
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Feedback List -->
                                                <div class="card-modern">
                                                    <h5 class="mb-4">
                                                        <i class="bi bi-list-check"></i> Guest Feedback
                                                    </h5>
                                                    <div class="grid-2">
                                                        <% if (feedbacks !=null && !feedbacks.isEmpty()) { for
                                                            (Map<String, Object> f : feedbacks) {
                                                            String guestName = (String) f.get("guest_name");
                                                            String type = (String) f.get("type");
                                                            String message = (String) f.get("message");
                                                            String date = (String) f.get("date");
                                                            %>
                                                            <div class="card-compact">
                                                                <div class="mb-3">
                                                                    <div
                                                                        class="d-flex justify-content-between align-items-start">
                                                                        <div>
                                                                            <h6 class="mb-1">
                                                                                <%= guestName %>
                                                                            </h6>
                                                                            <p class="text-muted mb-0"
                                                                                style="font-size: 12px;">
                                                                                <%= date %>
                                                                            </p>
                                                                        </div>
                                                                        <% String badgeClass="positive" .equals(type)
                                                                            ? "badge-success" : "neutral" .equals(type)
                                                                            ? "badge-warning" : "badge-danger" ; %>
                                                                            <span class="badge <%= badgeClass %>">
                                                                                <%= type %>
                                                                            </span>
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3 pb-3 border-bottom">
                                                                    <p class="mb-0"><small>
                                                                            <%= message %>
                                                                        </small></p>
                                                                </div>
                                                                <div class="d-flex gap-2">
                                                                    <button
                                                                        class="btn-modern btn-ghost btn-sm flex-grow-1"
                                                                        type="button">
                                                                        <i class="bi bi-reply"></i> Reply
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
                                                                    <p class="text-muted mt-3">No feedback available</p>
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