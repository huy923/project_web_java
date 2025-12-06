<%-- Header Component --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Management System - Dashboard</title>
    <link href="/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/theme.css">
    <link rel="stylesheet" href="../css/modern-ui.css">
    <link rel="stylesheet" href="../css/page-template.css">
    <link rel="stylesheet" href="style.css">
    <script src="../js/theme-manager.js"></script>
    <script src="../js/crud-helper.js"></script>
    <style>
        .main-container {
            padding: 2rem 0;
        }
    
        .dashboard-card {
            background: var(--bg-primary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
        }
    
        .dashboard-card:hover {
            box-shadow: var(--shadow-md);
            border-color: var(--primary-200);
        }
    
        .room-card {
            background: var(--bg-primary);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border-color);
        }
    
        .room-status {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }
    
        .status-available {
            background: var(--success-50);
            color: var(--success-700);
        }
    
        .status-occupied {
            background: var(--danger-50);
            color: var(--danger-700);
        }
    
        .status-maintenance {
            background: var(--warning-50);
            color: var(--warning-700);
        }
    
        .recent-activity {
            max-height: 300px;
            overflow-y: auto;
        }
    
        .activity-item {
            padding: 0.75rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 1rem;
        }
    
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }
    
        .icon-checkin {
            background: var(--success-50);
            color: var(--success-700);
        }
    
        .icon-checkout {
            background: var(--danger-50);
            color: var(--danger-700);
        }
    
        .icon-booking {
            background: var(--info-50);
            color: var(--info-700);
        }
    
        .icon-maintenance {
            background: var(--warning-50);
            color: var(--warning-700);
        }
    
        /* Loading animation */
        .spin {
            animation: spin 1s linear infinite;
        }
    
        @keyframes spin {
            from {
                transform: rotate(0deg);
            }
            to {
                transform: rotate(360deg);
            }
        }
    
        /* Room card hover effect */
        .room-card {
            transition: all 0.3s ease;
        }
    
        .room-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
    
        .priority-urgent {
            background: var(--danger-50);
            color: var(--danger-700);
        }
    
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }
    
        .status-reported {
            background: var(--info-50);
            color: var(--info-700);
        }
    
        .status-in-progress {
            background: var(--warning-50);
            color: var(--warning-700);
        }
    
        .status-completed {
            background: var(--success-50);
            color: var(--success-700);
        }
    
        .status-cancelled {
            background: var(--text-tertiary);
            color: var(--text-light);
        }
    
        .priority-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }
    
        .priority-low {
            background: var(--success-50);
            color: var(--success-700);
        }
    
        .priority-medium {
            background: var(--warning-50);
            color: var(--warning-700);
        }
    
        .priority-high {
            background: var(--danger-50);
            color: var(--danger-700);
        }
    
        .btn-hotel-outline {
            background: transparent;
            border: 2px solid var(--border-color);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
    
        .btn-hotel-outline:hover {
            background: var(--bg-secondary);
            border-color: var(--primary-300);
            color: var(--primary-600);
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
    
        .table-dark {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            overflow: hidden;
        }
        
        .table-dark th {
            background: rgba(255, 255, 255, 0.1);
            border: none;
            font-weight: 600;
        }
        .table-light {
            border-radius: 10px;
            overflow: hidden;
            border: none;
            background: rgba(255, 255, 255, 0.1);
        }
        .table-light th {
            background: rgba(255, 255, 255, 0.1);
            border: none;
            font-weight: 600;
        }
        .table-light td {
            border: none;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .form-control, .form-select {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }
        
        .form-control:focus, .form-select:focus {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.4);
            /* color: white; */
            box-shadow: 0 0 0 0.2rem rgba(255, 255, 255, 0.1);
        }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
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
        
        .room-status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        
        .status-available {
            background: rgba(46, 204, 113, 0.2);
            color: #2ecc71;
        }
        
        .status-occupied {
            background: rgba(231, 76, 60, 0.2);
            color: #e74c3c;
        }
        
        .status-maintenance {
            background: rgba(241, 196, 15, 0.2);
            color: #f1c40f;
        }
        
        .status-cleaning {
            background: rgba(149, 165, 166, 0.2);
            color: #95a5a6;
        }
         .settings-section {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .settings-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
        }
        
        .alert {
            border: none;
            border-radius: 10px;
        }
        
        .modal-content {
            background: rgba(30, 60, 114, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }
        
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(255, 255, 255, 0.2);
            transition: .4s;
            border-radius: 34px;
        }
        
        .slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .slider {
            background-color: #ff6b6b;
        }
        
        input:checked + .slider:before {
            transform: translateX(26px);
        }
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .review-card {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }
        
        .review-stars {
            color: #ffd93d;
            font-size: 1.2rem;
        }
        
        .review-body {
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
            <a class="navbar-brand" href="/dashboard">
                <i class="bi bi-building"></i> Hotel Management System
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text">
                    <i class="bi bi-person-circle"></i> Admin Dashboard
                </span>
                </div>
            </div>
            </nav>
