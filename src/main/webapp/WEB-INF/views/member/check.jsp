<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 완료 - 아파트 커뮤니티</title>

    <!-- Bootstrap & jQuery -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="/AptCommunity/resources/css/member/check.css">

</head>

<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="success-card">
                <!-- 완료 헤더 -->
                <div class="success-header">
                    <div class="success-logo">
                        <i class="bi bi-buildings"></i>
                    </div>
                    <h1>아파트 커뮤니티</h1>
                    <p>회원가입이 완료되었습니다!</p>
                </div>

                <!-- 완료 본문 -->
                <div class="success-body">
                    <div class="success-icon">
                        <i class="bi bi-check-lg"></i>
                    </div>

                    <div class="welcome-message">
                        <h2>${member.nickname}님, 환영합니다!</h2>
                        <p>아파트 커뮤니티의 회원이 되신 것을 축하합니다.<br>이웃과 함께하는 따뜻한 공간에서 다양한 서비스를 이용해보세요.</p>
                    </div>

                    <!-- 사용자 정보 (민감 정보 제외) -->
                    <div class="user-info">
                        <div class="user-info-title">
                            <i class="bi bi-person-check"></i> 회원 정보
                        </div>
                        <div class="user-info-item">
                            <div class="user-info-label">닉네임</div>
                            <div class="user-info-value">${member.nickname}</div>
                        </div>
                        <div class="user-info-item">
                            <div class="user-info-label">아이디</div>
                            <div class="user-info-value">${member.userId}</div>
                        </div>
                    </div>

                    <!-- 홈으로 버튼 -->
                    <a href="/AptCommunity/" class="btn-home">
                        <i class="bi bi-house-door me-2"></i> 홈으로 이동하기
                    </a>
                </div>
            </div>

            <!-- 추가 정보 -->
            <div class="text-center mt-4 text-muted">
                <small>&copy; 2025 아파트 커뮤니티. All rights reserved.</small>
            </div>
        </div>
    </div>
</div>
</body>

</html>