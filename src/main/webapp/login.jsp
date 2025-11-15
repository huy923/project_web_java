<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
        <link href="/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="/webjars/bootstrap-icons/1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    </head>

    <body class=" text-white" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
        <div class="container min-vh-100 d-flex align-items-center justify-content-center">
            <div class="card bg-secondary bg-opacity-25 p-4" style="min-width: 360px;">
                <h4 class="mb-3 text-center text-white">Login</h4>
                <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                    <div class="alert alert-danger">
                        <%= error %>
                    </div>
                    <% } %>
                        <form action="<%= request.getContextPath() %>/login" method="post">
                            <div class="mb-3">
                                <label class="form-label text-white">Username</label>
                                <input class="form-control" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-white">Password</label>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                            <button class="btn btn-primary w-100" type="submit">Login</button>
                        </form>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>