<%-- Reports Page --%>
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
                                                <i class="bi bi-graph-up"></i> Reports and Statistics
                                            </h1>
                                            <p class="lead">Analyze data and generate detailed reports about hotel operations</p>
                                        </div>
                                    </div>

                                    <!-- Quick Stats -->
                                    <div class="row mb-4">
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="stat-card">
                                                <div class="stat-number text-info">
                                                    <% List<Map<String, Object>> bookings = (List<Map<String, Object>>)
                                                            request.getAttribute("bookings");
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
                                                <div class="stat-number text-success">
                                                    <% double totalRevenue=0; if (bookings !=null) { for (Map<String,
                                                        Object> booking : bookings) {
                                                        if (booking.get("total_amount") != null) {
                                                        totalRevenue +=
                                                        Double.parseDouble(booking.get("total_amount").toString());
                                                        }
                                                        }
                                                        }
                                                        %>
                                                        <%= String.format("%.0f", totalRevenue / 1000000) %>M
                                                </div>
                                                <div class="stats-label">
                                                    <i class="bi bi-currency-dollar"></i> Revenue (VND)
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="stat-card">
                                                <div class="stat-number text-warning">
                                                    <% List<Map<String, Object>> rooms = (List<Map<String, Object>>)
                                                            request.getAttribute("rooms");
                                                            int totalRooms = rooms != null ? rooms.size() : 0;
                                                            %>
                                                            <%= totalRooms %>
                                                </div>
                                                <div class="stats-label">
                                                    <i class="bi bi-door-open"></i> Total Rooms
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="stat-card">
                                                <div class="stat-number text-primary">
                                                    <% List<Map<String, Object>> guests = (List<Map<String, Object>>)
                                                            request.getAttribute("guests");
                                                            int totalGuests = guests != null ? guests.size() : 0;
                                                            %>
                                                            <%= totalGuests %>
                                                </div>
                                                <div class="stats-label">
                                                    <i class="bi bi-people"></i> Total Guests
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Report Types -->
                                    <div class="row mb-4">
                                        <div class="col-md-4 mb-3">
                                            <div class="report-card text-center" onclick="showReport('occupancy')">
                                                <div class="report-icon text-info">
                                                    <i class="bi bi-house-door"></i>
                                                </div>
                                                <h5>Room Occupancy</h5>
                                                <p class="text-muted">Analyze room occupancy rate over time</p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <div class="report-card text-center" onclick="showReport('revenue')">
                                                <div class="report-icon text-success">
                                                    <i class="bi bi-graph-up-arrow"></i>
                                                </div>
                                                <h5>Revenue Report</h5>
                                                <p class="text-muted">Revenue statistics by day, month, and year</p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <div class="report-card text-center" onclick="showReport('guests')">
                                                <div class="report-icon text-warning">
                                                    <i class="bi bi-people"></i>
                                                </div>
                                                <h5>Guest Analysis</h5>
                                                <p class="text-muted">Guest statistics and behavior analysis</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Date Range Filter -->
                                    <div class="card-modern mb-4">
                                        <h5 class="mb-3">
                                            <i class="bi bi-calendar-range"></i> Select Date Range
                                        </h5>
                                        <div class="row g-3">
                                            <div class="col-md-3">
                                                <label class="form-label">From Date</label>
                                                <input type="date" class="form-control" id="fromDate">
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">To Date</label>
                                                <input type="date" class="form-control" id="toDate">
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">Report Type</label>
                                                <select class="form-select" id="reportType">
                                                    <option value="daily">Daily</option>
                                                    <option value="weekly">Weekly</option>
                                                    <option value="monthly">Monthly</option>
                                                    <option value="yearly">Yearly</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">&nbsp;</label>
                                                <button class="btn-modern btn-success w-100" onclick="generateReport()">
                                                    <i class="bi bi-file-earmark-text"></i> Generate Report
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Charts Section -->
                                    <div id="chartsSection" style="display: none;">
                                        <!-- Occupancy Chart -->
                                        <div class="chart-container" id="occupancyChart">
                                            <h5 class="mb-3">
                                                <i class="bi bi-house-door"></i> Room Occupancy
                                            </h5>
                                            <canvas id="occupancyCanvas" width="400" height="200"></canvas>
                                        </div>

                                        <!-- Revenue Chart -->
                                        <div class="chart-container" id="revenueChart">
                                            <h5 class="mb-3">
                                                <i class="bi bi-graph-up-arrow"></i> Revenue
                                            </h5>
                                            <canvas id="revenueCanvas" width="400" height="200"></canvas>
                                        </div>

                                        <!-- Guest Analysis Chart -->
                                        <div class="chart-container" id="guestChart">
                                            <h5 class="mb-3">
                                                <i class="bi bi-people"></i> Guest Analysis
                                            </h5>
                                            <canvas id="guestCanvas" width="400" height="200"></canvas>
                                        </div>
                                    </div>

                                    <!-- Report Actions -->
                                    <div class="card-modern" id="reportActions" style="display: none;">
                                        <h5 class="mb-3">
                                            <i class="bi bi-download"></i> Export Report
                                        </h5>
                                        <div class="row g-3">
                                            <div class="col-md-3">
                                                <button class="btn-hotel-outline w-100" onclick="exportReport('pdf')">
                                                    <i class="bi bi-file-pdf"></i> Export PDF
                                                </button>
                                            </div>
                                            <div class="col-md-3">
                                                <button class="btn-hotel-outline w-100" onclick="exportReport('excel')">
                                                    <i class="bi bi-file-excel"></i> Export Excel
                                                </button>
                                            </div>
                                            <div class="col-md-3">
                                                <button class="btn-hotel-outline w-100" onclick="exportReport('csv')">
                                                    <i class="bi bi-file-text"></i> Export CSV
                                                </button>
                                            </div>
                                            <div class="col-md-3">
                                                <button class="btn-hotel-outline w-100" onclick="printReport()">
                                                    <i class="bi bi-printer"></i> Print Report
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Initialize date inputs with current month
                            document.addEventListener('DOMContentLoaded', function () {
                                const today = new Date();
                                const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
                                const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);

                                document.getElementById('fromDate').value = firstDay.toISOString().split('T')[0];
                                document.getElementById('toDate').value = lastDay.toISOString().split('T')[0];
                            });

                            function showReport(type) {
                                // Hide all charts first
                                document.getElementById('chartsSection').style.display = 'none';
                                document.getElementById('reportActions').style.display = 'none';

                                // Show specific chart based on type
                                setTimeout(() => {
                                    document.getElementById('chartsSection').style.display = 'block';
                                    document.getElementById('reportActions').style.display = 'block';

                                    if (type === 'occupancy') {
                                        createOccupancyChart();
                                    } else if (type === 'revenue') {
                                        createRevenueChart();
                                    } else if (type === 'guests') {
                                        createGuestChart();
                                    }
                                }, 300);
                            }

                            function createOccupancyChart() {
                                const ctx = document.getElementById('occupancyCanvas').getContext('2d');
                                new Chart(ctx, {
                                    type: 'line',
                                    data: {
                                        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                                        datasets: [{
                                            label: 'Occupancy (%)',
                                            data: [85, 92, 78, 95, 88, 96, 82],
                                            borderColor: '#3498db',
                                            backgroundColor: 'rgba(52, 152, 219, 0.1)',
                                            tension: 0.4
                                        }]
                                    },
                                    options: {
                                        responsive: true,
                                        plugins: {
                                            legend: {
                                                labels: {
                                                    color: 'white'
                                                }
                                            }
                                        },
                                        scales: {
                                            y: {
                                                beginAtZero: true,
                                                ticks: {
                                                    color: 'white'
                                                },
                                                grid: {
                                                    color: 'rgba(255, 255, 255, 0.1)'
                                                }
                                            },
                                            x: {
                                                ticks: {
                                                    color: 'white'
                                                },
                                                grid: {
                                                    color: 'rgba(255, 255, 255, 0.1)'
                                                }
                                            }
                                        }
                                    }
                                });
                            }

                            function createRevenueChart() {
                                const ctx = document.getElementById('revenueCanvas').getContext('2d');
                                new Chart(ctx, {
                                    type: 'bar',
                                    data: {
                                        labels: ['M1', 'M2', 'M3', 'M4', 'M5', 'M6'],
                                        datasets: [{
                                            label: 'Revenue (VND)',
                                            data: [12000000, 15000000, 18000000, 16000000, 20000000, 22000000],
                                            backgroundColor: 'rgba(46, 204, 113, 0.8)',
                                            borderColor: '#2ecc71',
                                            borderWidth: 1
                                        }]
                                    },
                                    options: {
                                        responsive: true,
                                        plugins: {
                                            legend: {
                                                labels: {
                                                    color: 'white'
                                                }
                                            }
                                        },
                                        scales: {
                                            y: {
                                                beginAtZero: true,
                                                ticks: {
                                                    color: 'white',
                                                    callback: function (value) {
                                                        return (value / 1000000).toFixed(0) + 'M';
                                                    }
                                                },
                                                grid: {
                                                    color: 'rgba(255, 255, 255, 0.1)'
                                                }
                                            },
                                            x: {
                                                ticks: {
                                                    color: 'white'
                                                },
                                                grid: {
                                                    color: 'rgba(255, 255, 255, 0.1)'
                                                }
                                            }
                                        }
                                    }
                                });
                            }

                            function createGuestChart() {
                                const ctx = document.getElementById('guestCanvas').getContext('2d');
                                new Chart(ctx, {
                                    type: 'doughnut',
                                    data: {
                                        labels: ['New Guests', 'Returning Guests', 'VIP Guests'],
                                        datasets: [{
                                            data: [45, 35, 20],
                                            backgroundColor: [
                                                'rgba(52, 152, 219, 0.8)',
                                                'rgba(46, 204, 113, 0.8)',
                                                'rgba(241, 196, 15, 0.8)'
                                            ],
                                            borderColor: [
                                                '#3498db',
                                                '#2ecc71',
                                                '#f1c40f'
                                            ],
                                            borderWidth: 2
                                        }]
                                    },
                                    options: {
                                        responsive: true,
                                        plugins: {
                                            legend: {
                                                labels: {
                                                    color: 'white'
                                                }
                                            }
                                        }
                                    }
                                });
                            }

                            function generateReport() {
                                const fromDate = document.getElementById('fromDate').value;
                                const toDate = document.getElementById('toDate').value;
                                const reportType = document.getElementById('reportType').value;

                                if (!fromDate || !toDate) {
                                    alert('Please select a date range!');
                                    return;
                                }

                                // Show loading
                                document.getElementById('chartsSection').innerHTML = `
                <div class="text-center py-5">
                    <i class="bi bi-hourglass-split" style="font-size: 3rem;"></i>
                    <p class="mt-3">Generating report...</p>
                </div>
            `;
                                document.getElementById('chartsSection').style.display = 'block';

                                // Simulate report generation
                                setTimeout(() => {
                                    document.getElementById('chartsSection').innerHTML = `
                    <div class="chart-container" id="occupancyChart">
                        <h5 class="mb-3"><i class="bi bi-house-door"></i> Room Occupancy</h5>
                        <canvas id="occupancyCanvas" width="400" height="200"></canvas>
                    </div>
                    <div class="chart-container" id="revenueChart">
                        <h5 class="mb-3"><i class="bi bi-graph-up-arrow"></i> Revenue</h5>
                        <canvas id="revenueCanvas" width="400" height="200"></canvas>
                    </div>
                    <div class="chart-container" id="guestChart">
                        <h5 class="mb-3"><i class="bi bi-people"></i> Guest Analysis</h5>
                        <canvas id="guestCanvas" width="400" height="200"></canvas>
                    </div>
                `;

                                    // Recreate charts
                                    createOccupancyChart();
                                    createRevenueChart();
                                    createGuestChart();

                                    document.getElementById('reportActions').style.display = 'block';
                                }, 2000);
                            }

                            function exportReport(format) {
                                alert(`Report export feature for ${format.toUpperCase()} is under development!`);
                            }

                            function printReport() {
                                window.print();
                            }
                        </script>
                    </body>

                    </html>