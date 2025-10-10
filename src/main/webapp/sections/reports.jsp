<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.util.Map" %>
            <%@ page import="java.text.NumberFormat" %>
                <%@ page import="java.util.Locale" %>
                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Hotel Management System - Báo cáo</title>
                        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                        <link href="/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
                        <link href="/webjars/bootstrap-icons/1.11.1/font/bootstrap-icons.css" rel="stylesheet">
                        <style>
                            body {
                                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
                                color: white;
                                min-height: 100vh;
                            }

                            .navbar {
                                background: rgba(255, 255, 255, 0.1);
                                backdrop-filter: blur(10px);
                                border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                            }

                            .navbar-brand {
                                font-weight: bold;
                                font-size: 1.5rem;
                            }

                            .main-container {
                                padding: 2rem 0;
                            }

                            .dashboard-card {
                                background: rgba(255, 255, 255, 0.1);
                                backdrop-filter: blur(10px);
                                border: 1px solid rgba(255, 255, 255, 0.2);
                                border-radius: 15px;
                                transition: transform 0.3s ease;
                            }

                            .dashboard-card:hover {
                                transform: translateY(-5px);
                            }

                            .btn-hotel {
                                background: linear-gradient(135deg, #ff6b6b, #ee5a24);
                                border: none;
                                color: white;
                                padding: 0.75rem 1.5rem;
                                border-radius: 25px;
                                transition: all 0.3s ease;
                                text-decoration: none;
                                display: inline-block;
                            }

                            .btn-hotel:hover {
                                transform: translateY(-2px);
                                box-shadow: 0 5px 15px rgba(238, 90, 36, 0.4);
                                color: white;
                            }

                            .btn-hotel-outline {
                                background: transparent;
                                border: 2px solid rgba(255, 255, 255, 0.3);
                                color: white;
                                padding: 0.75rem 1.5rem;
                                border-radius: 25px;
                                transition: all 0.3s ease;
                                text-decoration: none;
                                display: inline-block;
                            }

                            .btn-hotel-outline:hover {
                                background: rgba(255, 255, 255, 0.1);
                                border-color: rgba(255, 255, 255, 0.5);
                                color: white;
                            }

                            .sidebar {
                                background: rgba(255, 255, 255, 0.1);
                                backdrop-filter: blur(10px);
                                border-radius: 15px;
                                padding: 1.5rem;
                                height: fit-content;
                            }

                            .sidebar-menu {
                                list-style: none;
                                padding: 0;
                                margin: 0;
                            }

                            .sidebar-menu li {
                                margin-bottom: 0.5rem;
                            }

                            .sidebar-menu a {
                                color: white;
                                text-decoration: none;
                                padding: 0.75rem 1rem;
                                display: block;
                                border-radius: 8px;
                                transition: all 0.3s ease;
                            }

                            .sidebar-menu a:hover {
                                background: rgba(255, 255, 255, 0.1);
                                color: white;
                            }

                            .sidebar-menu a.active {
                                background: rgba(255, 255, 255, 0.2);
                            }

                            .stats-card {
                                background: rgba(255, 255, 255, 0.1);
                                border-radius: 10px;
                                padding: 1.5rem;
                                text-align: center;
                                border: 1px solid rgba(255, 255, 255, 0.2);
                            }

                            .stat-number {
                                font-size: 2rem;
                                font-weight: bold;
                                margin-bottom: 0.5rem;
                            }

                            .report-card {
                                background: rgba(255, 255, 255, 0.1);
                                border-radius: 15px;
                                padding: 2rem;
                                border: 1px solid rgba(255, 255, 255, 0.2);
                                transition: all 0.3s ease;
                                cursor: pointer;
                            }

                            .report-card:hover {
                                transform: translateY(-5px);
                                background: rgba(255, 255, 255, 0.15);
                            }

                            .report-icon {
                                font-size: 3rem;
                                margin-bottom: 1rem;
                            }

                            .chart-container {
                                background: rgba(255, 255, 255, 0.1);
                                border-radius: 15px;
                                padding: 1.5rem;
                                margin-bottom: 2rem;
                            }

                            .form-control,
                            .form-select {
                                background: rgba(255, 255, 255, 0.1);
                                border: 1px solid rgba(255, 255, 255, 0.2);
                                color: white;
                            }

                            .form-control:focus,
                            .form-select:focus {
                                background: rgba(255, 255, 255, 0.15);
                                border-color: rgba(255, 255, 255, 0.4);
                                color: white;
                                box-shadow: 0 0 0 0.2rem rgba(255, 255, 255, 0.1);
                            }

                            .form-control::placeholder {
                                color: rgba(255, 255, 255, 0.6);
                            }
                        </style>
                    </head>

                    <body>
                        <!-- Navigation Bar -->
                        <nav class="navbar navbar-expand-lg navbar-dark">
                            <div class="container">
                                <a class="navbar-brand" href="<%= request.getContextPath() %>/dashboard">
                                    <i class="bi bi-building"></i> Hotel Management System
                                </a>
                                <div class="navbar-nav ms-auto">
                                    <span class="navbar-text">
                                        <i class="bi bi-person-circle"></i> Admin Dashboard
                                    </span>
                                </div>
                            </div>
                        </nav>

                        <div class="container main-container">
                            <div class="row">
                                <!-- Sidebar -->
                                <div class="col-lg-3 col-md-4 mb-4">
                                    <div class="sidebar">
                                        <h5 class="mb-3">
                                            <i class="bi bi-list-ul"></i> Menu
                                        </h5>
                                        <ul class="sidebar-menu">
                                            <li><a href="<%= request.getContextPath() %>/dashboard"><i
                                                        class="bi bi-speedometer2"></i> Dashboard</a></li>
                                            <li><a href="<%= request.getContextPath() %>/rooms"><i
                                                        class="bi bi-door-open"></i> Room Management</a></li>
                                            <li><a href="<%= request.getContextPath() %>/bookings"><i
                                                        class="bi bi-calendar-check"></i> Bookings</a></li>
                                            <li><a href="<%= request.getContextPath() %>/guests"><i
                                                        class="bi bi-people"></i> Guests</a></li>
                                            <li><a href="<%= request.getContextPath() %>/payments"><i
                                                        class="bi bi-credit-card"></i> Payments</a></li>
                                            <li><a href="<%= request.getContextPath() %>/reports" class="active"><i
                                                        class="bi bi-graph-up"></i> Reports</a></li>
                                            <li><a href="<%= request.getContextPath() %>/settings"><i
                                                        class="bi bi-gear"></i> Settings</a></li>
                                        </ul>
                                    </div>
                                </div>

                                <!-- Main Content -->
                                <div class="col-lg-9 col-md-8">
                                    <!-- Header -->
                                    <div class="row mb-4">
                                        <div class="col-12">
                                            <h1 class="display-6 mb-3">
                                                <i class="bi bi-graph-up"></i> Báo cáo và Thống kê
                                            </h1>
                                            <p class="lead">Phân tích dữ liệu và tạo báo cáo chi tiết về hoạt động khách
                                                sạn</p>
                                        </div>
                                    </div>

                                    <!-- Quick Stats -->
                                    <div class="row mb-4">
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="stats-card">
                                                <div class="stat-number text-info">
                                                    <% List<Map<String, Object>> bookings = (List<Map<String, Object>>)
                                                            request.getAttribute("bookings");
                                                            int totalBookings = bookings != null ? bookings.size() : 0;
                                                            %>
                                                            <%= totalBookings %>
                                                </div>
                                                <div class="stats-label">
                                                    <i class="bi bi-calendar-plus"></i> Tổng đặt phòng
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="stats-card">
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
                                                    <i class="bi bi-currency-dollar"></i> Doanh thu (VNĐ)
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="stats-card">
                                                <div class="stat-number text-warning">
                                                    <% List<Map<String, Object>> rooms = (List<Map<String, Object>>)
                                                            request.getAttribute("rooms");
                                                            int totalRooms = rooms != null ? rooms.size() : 0;
                                                            %>
                                                            <%= totalRooms %>
                                                </div>
                                                <div class="stats-label">
                                                    <i class="bi bi-door-open"></i> Tổng phòng
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="stats-card">
                                                <div class="stat-number text-primary">
                                                    <% List<Map<String, Object>> guests = (List<Map<String, Object>>)
                                                            request.getAttribute("guests");
                                                            int totalGuests = guests != null ? guests.size() : 0;
                                                            %>
                                                            <%= totalGuests %>
                                                </div>
                                                <div class="stats-label">
                                                    <i class="bi bi-people"></i> Tổng khách hàng
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
                                                <h5>Công suất phòng</h5>
                                                <p class="text-muted">Phân tích tỷ lệ lấp đầy phòng theo thời gian</p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <div class="report-card text-center" onclick="showReport('revenue')">
                                                <div class="report-icon text-success">
                                                    <i class="bi bi-graph-up-arrow"></i>
                                                </div>
                                                <h5>Báo cáo doanh thu</h5>
                                                <p class="text-muted">Thống kê doanh thu theo ngày, tháng, năm</p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <div class="report-card text-center" onclick="showReport('guests')">
                                                <div class="report-icon text-warning">
                                                    <i class="bi bi-people"></i>
                                                </div>
                                                <h5>Phân tích khách hàng</h5>
                                                <p class="text-muted">Thống kê và phân tích hành vi khách hàng</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Date Range Filter -->
                                    <div class="dashboard-card p-4 mb-4">
                                        <h5 class="mb-3">
                                            <i class="bi bi-calendar-range"></i> Chọn khoảng thời gian
                                        </h5>
                                        <div class="row g-3">
                                            <div class="col-md-3">
                                                <label class="form-label">Từ ngày</label>
                                                <input type="date" class="form-control" id="fromDate">
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">Đến ngày</label>
                                                <input type="date" class="form-control" id="toDate">
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">Loại báo cáo</label>
                                                <select class="form-select" id="reportType">
                                                    <option value="daily">Hàng ngày</option>
                                                    <option value="weekly">Hàng tuần</option>
                                                    <option value="monthly">Hàng tháng</option>
                                                    <option value="yearly">Hàng năm</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">&nbsp;</label>
                                                <button class="btn-hotel w-100" onclick="generateReport()">
                                                    <i class="bi bi-file-earmark-text"></i> Tạo báo cáo
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Charts Section -->
                                    <div id="chartsSection" style="display: none;">
                                        <!-- Occupancy Chart -->
                                        <div class="chart-container" id="occupancyChart">
                                            <h5 class="mb-3">
                                                <i class="bi bi-house-door"></i> Công suất phòng
                                            </h5>
                                            <canvas id="occupancyCanvas" width="400" height="200"></canvas>
                                        </div>

                                        <!-- Revenue Chart -->
                                        <div class="chart-container" id="revenueChart">
                                            <h5 class="mb-3">
                                                <i class="bi bi-graph-up-arrow"></i> Doanh thu
                                            </h5>
                                            <canvas id="revenueCanvas" width="400" height="200"></canvas>
                                        </div>

                                        <!-- Guest Analysis Chart -->
                                        <div class="chart-container" id="guestChart">
                                            <h5 class="mb-3">
                                                <i class="bi bi-people"></i> Phân tích khách hàng
                                            </h5>
                                            <canvas id="guestCanvas" width="400" height="200"></canvas>
                                        </div>
                                    </div>

                                    <!-- Report Actions -->
                                    <div class="dashboard-card p-4" id="reportActions" style="display: none;">
                                        <h5 class="mb-3">
                                            <i class="bi bi-download"></i> Xuất báo cáo
                                        </h5>
                                        <div class="row g-3">
                                            <div class="col-md-3">
                                                <button class="btn-hotel-outline w-100" onclick="exportReport('pdf')">
                                                    <i class="bi bi-file-pdf"></i> Xuất PDF
                                                </button>
                                            </div>
                                            <div class="col-md-3">
                                                <button class="btn-hotel-outline w-100" onclick="exportReport('excel')">
                                                    <i class="bi bi-file-excel"></i> Xuất Excel
                                                </button>
                                            </div>
                                            <div class="col-md-3">
                                                <button class="btn-hotel-outline w-100" onclick="exportReport('csv')">
                                                    <i class="bi bi-file-text"></i> Xuất CSV
                                                </button>
                                            </div>
                                            <div class="col-md-3">
                                                <button class="btn-hotel-outline w-100" onclick="printReport()">
                                                    <i class="bi bi-printer"></i> In báo cáo
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
                                        labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                                        datasets: [{
                                            label: 'Công suất (%)',
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
                                        labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6'],
                                        datasets: [{
                                            label: 'Doanh thu (VNĐ)',
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
                                        labels: ['Khách mới', 'Khách quay lại', 'Khách VIP'],
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
                                    alert('Vui lòng chọn khoảng thời gian!');
                                    return;
                                }

                                // Show loading
                                document.getElementById('chartsSection').innerHTML = `
                <div class="text-center py-5">
                    <i class="bi bi-hourglass-split" style="font-size: 3rem;"></i>
                    <p class="mt-3">Đang tạo báo cáo...</p>
                </div>
            `;
                                document.getElementById('chartsSection').style.display = 'block';

                                // Simulate report generation
                                setTimeout(() => {
                                    document.getElementById('chartsSection').innerHTML = `
                    <div class="chart-container" id="occupancyChart">
                        <h5 class="mb-3"><i class="bi bi-house-door"></i> Công suất phòng</h5>
                        <canvas id="occupancyCanvas" width="400" height="200"></canvas>
                    </div>
                    <div class="chart-container" id="revenueChart">
                        <h5 class="mb-3"><i class="bi bi-graph-up-arrow"></i> Doanh thu</h5>
                        <canvas id="revenueCanvas" width="400" height="200"></canvas>
                    </div>
                    <div class="chart-container" id="guestChart">
                        <h5 class="mb-3"><i class="bi bi-people"></i> Phân tích khách hàng</h5>
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
                                alert(`Tính năng xuất báo cáo ${format.toUpperCase()} đang được phát triển!`);
                            }

                            function printReport() {
                                window.print();
                            }
                        </script>
                    </body>

                    </html>