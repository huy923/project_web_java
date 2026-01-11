/**
 * CRUD Helper Functions
 * Provides common CRUD operations for all pages
 */

// Show success notification
function showSuccess(message) {
    const alert = document.createElement('div');
    alert.className = 'alert-modern alert-success';
    alert.innerHTML = `
        <i class="bi bi-check-circle"></i>
        <span><strong>Success!</strong> ${message}</span>
    `;
    insertAlertAtTop(alert);
}

// Show error notification
function showError(message) {
    const alert = document.createElement('div');
    alert.className = 'alert-modern alert-danger';
    alert.innerHTML = `
        <i class="bi bi-exclamation-circle"></i>
        <span><strong>Error!</strong> ${message}</span>
    `;
    insertAlertAtTop(alert);
}

// Show warning notification
function showWarning(message) {
    const alert = document.createElement('div');
    alert.className = 'alert-modern alert-warning';
    alert.innerHTML = `
        <i class="bi bi-exclamation-triangle"></i>
        <span><strong>Warning!</strong> ${message}</span>
    `;
    insertAlertAtTop(alert);
}

// Insert alert at top of main content
function insertAlertAtTop(alert) {
    const mainContent = document.querySelector('.col-lg-9, .col-md-8');
    if (mainContent) {
        mainContent.insertBefore(alert, mainContent.firstChild);
        setTimeout(() => {
            alert.remove();
        }, 5000);
    }
}

// Confirm delete action
function confirmDelete(itemName) {
    return confirm(`Are you sure you want to delete this ${itemName}? This action cannot be undone.`);
}

// Format currency
function formatCurrency(value) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(value);
}

// Format date
function formatDate(dateString) {
    const options = { year: 'numeric', month: 'short', day: '2-digit' };
    return new Date(dateString).toLocaleDateString('en-US', options);
}

// Format datetime
function formatDateTime(dateString) {
    const options = { year: 'numeric', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit' };
    return new Date(dateString).toLocaleDateString('en-US', options);
}

// Get status badge HTML
function getStatusBadge(status) {
    const statusMap = {
        'available': { class: 'badge-available', text: 'Available', icon: 'bi-check-circle' },
        'occupied': { class: 'badge-occupied', text: 'Occupied', icon: 'bi-person-fill' },
        'maintenance': { class: 'badge-maintenance', text: 'Maintenance', icon: 'bi-tools' },
        'cleaning': { class: 'badge-cleaning', text: 'Cleaning', icon: 'bi-brush' },
        'pending': { class: 'badge-pending', text: 'Pending', icon: 'bi-hourglass-split' },
        'confirmed': { class: 'badge-confirmed', text: 'Confirmed', icon: 'bi-check-lg' },
        'checked_in': { class: 'badge-checked-in', text: 'Checked In', icon: 'bi-door-open' },
        'checked_out': { class: 'badge-checked-out', text: 'Checked Out', icon: 'bi-door-closed' },
        'cancelled': { class: 'badge-cancelled', text: 'Cancelled', icon: 'bi-x-circle' },
        'completed': { class: 'badge-completed', text: 'Completed', icon: 'bi-check-circle' },
        'failed': { class: 'badge-failed', text: 'Failed', icon: 'bi-x-circle' },
        'refunded': { class: 'badge-refunded', text: 'Refunded', icon: 'bi-arrow-counterclockwise' }
    };

    const statusInfo = statusMap[status] || { class: 'badge-default', text: status, icon: 'bi-info-circle' };
    return `<span class="badge-status ${statusInfo.class}"><i class="bi ${statusInfo.icon}"></i> ${statusInfo.text}</span>`;
}

// Debounce function for search
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Search/filter functionality
function setupSearch(inputSelector, itemSelector, searchFields) {
    const searchInput = document.querySelector(inputSelector);
    if (!searchInput) return;

    searchInput.addEventListener('input', debounce((e) => {
        const searchTerm = e.target.value.toLowerCase();
        const items = document.querySelectorAll(itemSelector);

        items.forEach(item => {
            let found = false;
            searchFields.forEach(field => {
                const fieldValue = item.getAttribute(`data-${field}`)?.toLowerCase() || '';
                if (fieldValue.includes(searchTerm)) {
                    found = true;
                }
            });
            item.style.display = found ? '' : 'none';
        });
    }, 300));
}

// Pagination helper
function setupPagination(itemsPerPage) {
    const items = document.querySelectorAll('[data-item]');
    const totalPages = Math.ceil(items.length / itemsPerPage);
    let currentPage = 1;

    function showPage(page) {
        const start = (page - 1) * itemsPerPage;
        const end = start + itemsPerPage;

        items.forEach((item, index) => {
            item.style.display = (index >= start && index < end) ? '' : 'none';
        });

        // Update pagination buttons
        updatePaginationButtons(page, totalPages);
    }

    function updatePaginationButtons(current, total) {
        const paginationContainer = document.querySelector('[data-pagination]');
        if (!paginationContainer) return;

        paginationContainer.innerHTML = '';
        for (let i = 1; i <= total; i++) {
            const btn = document.createElement('button');
            btn.className = `btn-modern btn-sm ${i === current ? 'btn-primary' : 'btn-ghost'}`;
            btn.textContent = i;
            btn.onclick = () => {
                currentPage = i;
                showPage(i);
            };
            paginationContainer.appendChild(btn);
        }
    }

    showPage(1);
    return { showPage, totalPages };
}

// Export data to CSV
function exportToCSV(filename, data) {
    const csv = convertToCSV(data);
    downloadCSV(csv, filename);
}

function convertToCSV(data) {
    if (!Array.isArray(data) || data.length === 0) return '';

    const headers = Object.keys(data[0]);
    const csvHeaders = headers.join(',');
    const csvRows = data.map(row => {
        return headers.map(header => {
            const value = row[header];
            return typeof value === 'string' && value.includes(',') ? `"${value}"` : value;
        }).join(',');
    });

    return [csvHeaders, ...csvRows].join('\n');
}

function downloadCSV(csv, filename) {
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.click();
    window.URL.revokeObjectURL(url);
}

// Print functionality
function printElement(elementId) {
    const element = document.getElementById(elementId);
    if (!element) return;

    const printWindow = window.open('', '', 'height=600,width=800');
    printWindow.document.write('<html><head><title>Print</title>');
    printWindow.document.write('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">');
    printWindow.document.write('<link rel="stylesheet" href="../css/modern-ui.css">');
    printWindow.document.write('</head><body>');
    printWindow.document.write(element.innerHTML);
    printWindow.document.write('</body></html>');
    printWindow.document.close();
    printWindow.print();
}

// Initialize tooltips (Bootstrap)
function initTooltips() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

// Initialize popovers (Bootstrap)
function initPopovers() {
    const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
}

// Document ready
document.addEventListener('DOMContentLoaded', function () {
    initTooltips();
    initPopovers();
});
