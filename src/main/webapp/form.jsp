<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bootstrap Form Demo</title>
    
    <!-- Bootstrap CSS -->
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"> -->
    <link href="/webjars/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="/webjars/bootstrap-icons/1.11.1/font/bootstrap-icons.css" rel="stylesheet">    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        
        .form-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        
        .btn-gradient {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
        }
        
        .btn-gradient:hover {
            background: linear-gradient(45deg, #764ba2, #667eea);
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="form-container p-5">
                    <div class="text-center mb-4">
                        <h2 class="fw-bold">📝 Bootstrap Form Demo</h2>
                        <p class="text-muted">Ví dụ về form với Bootstrap styling</p>
                    </div>
                    
                    <form action="hello" method="post">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="firstName" class="form-label">Họ</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="lastName" class="form-label">Tên</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                            <div class="form-text">Chúng tôi sẽ không chia sẻ email của bạn.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone">
                        </div>
                        
                        <div class="mb-3">
                            <label for="country" class="form-label">Quốc gia</label>
                            <select class="form-select" id="country" name="country">
                                <option selected>Chọn quốc gia...</option>
                                <option value="VN">Việt Nam</option>
                                <option value="US">Hoa Kỳ</option>
                                <option value="JP">Nhật Bản</option>
                                <option value="KR">Hàn Quốc</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="message" class="form-label">Tin nhắn</label>
                            <textarea class="form-control" id="message" name="message" rows="4" placeholder="Nhập tin nhắn của bạn..."></textarea>
                        </div>
                        
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="newsletter" name="newsletter">
                            <label class="form-check-label" for="newsletter">
                                Đăng ký nhận newsletter
                            </label>
                        </div>
                        
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="gender" id="male" value="male">
                                <label class="form-check-label" for="male">Nam</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="gender" id="female" value="female">
                                <label class="form-check-label" for="female">Nữ</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="gender" id="other" value="other">
                                <label class="form-check-label" for="other">Khác</label>
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="index.jsp" class="btn btn-outline-secondary me-md-2">
                                ← Quay lại
                            </a>
                            <button type="submit" class="btn btn-gradient btn-lg px-4">
                                Gửi form →
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByTagName('form');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
    </script>
</body>
</html>