package filter;

import dao.PermissionDao;
import model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebFilter(filterName = "PermissionFilter", urlPatterns = {"/api/*", "/servlet/*"})
public class PermissionFilter implements Filter {

    private PermissionDao permissionDao;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        permissionDao = new PermissionDao();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String requestURI = httpRequest.getRequestURI();
        String permission = getRequiredPermission(requestURI, httpRequest.getMethod());

        // If permission is required, check it
        if (permission != null) {
            try {
                if (!permissionDao.hasPermission(user.getUserId(), permission)) {
                    httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    httpResponse.setContentType("application/json");
                    httpResponse.getWriter().write("{\"success\": false, \"message\": \"Access Denied\"}");
                    return;
                }
            } catch (SQLException e) {
                httpResponse.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                httpResponse.getWriter().write("{\"success\": false, \"message\": \"Database error\"}");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }

    // Map URL patterns to required permissions
    private String getRequiredPermission(String uri, String method) {
        if (uri.contains("/api/rooms")) {
            if ("GET".equals(method)) return "rooms.view";
            if ("POST".equals(method)) return "rooms.create";
            if ("PUT".equals(method)) return "rooms.edit";
            if ("DELETE".equals(method)) return "rooms.delete";
        }
        if (uri.contains("/api/bookings")) {
            if ("GET".equals(method)) return "bookings.view";
            if ("POST".equals(method)) return "bookings.create";
            if ("PUT".equals(method)) return "bookings.edit";
            if ("DELETE".equals(method)) return "bookings.delete";
        }
        if (uri.contains("/api/guests")) {
            if ("GET".equals(method)) return "guests.view";
            if ("POST".equals(method)) return "guests.create";
            if ("PUT".equals(method)) return "guests.edit";
            if ("DELETE".equals(method)) return "guests.delete";
        }
        if (uri.contains("/api/payments")) {
            if ("GET".equals(method)) return "payments.view";
            if ("POST".equals(method)) return "payments.create";
            if ("PUT".equals(method)) return "payments.edit";
            if ("DELETE".equals(method)) return "payments.delete";
        }
        if (uri.contains("/api/services")) {
            if ("GET".equals(method)) return "services.view";
            if ("POST".equals(method)) return "services.create";
            if ("PUT".equals(method)) return "services.edit";
            if ("DELETE".equals(method)) return "services.delete";
        }
        if (uri.contains("/api/maintenance")) {
            if ("GET".equals(method)) return "maintenance.view";
            if ("POST".equals(method)) return "maintenance.create";
            if ("PUT".equals(method)) return "maintenance.edit";
            if ("DELETE".equals(method)) return "maintenance.delete";
        }
        if (uri.contains("/api/inventory")) {
            if ("GET".equals(method)) return "inventory.view";
            if ("POST".equals(method)) return "inventory.create";
            if ("PUT".equals(method)) return "inventory.edit";
            if ("DELETE".equals(method)) return "inventory.delete";
        }
        if (uri.contains("/api/reports")) {
            if ("GET".equals(method)) return "reports.view";
            if ("POST".equals(method)) return "reports.create";
        }
        if (uri.contains("/api/reviews")) {
            if ("GET".equals(method)) return "reviews.view";
            if ("POST".equals(method)) return "reviews.create";
            if ("PUT".equals(method)) return "reviews.edit";
            if ("DELETE".equals(method)) return "reviews.delete";
        }
        if (uri.contains("/api/users")) {
            if ("GET".equals(method)) return "users.view";
            if ("POST".equals(method)) return "users.create";
            if ("PUT".equals(method)) return "users.edit";
            if ("DELETE".equals(method)) return "users.delete";
        }
        return null;
    }
}
