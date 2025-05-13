<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 아파트 커뮤니티</title>

    <!-- Bootstrap & jQuery -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/login.css">

</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="login-card">
                <!-- 로그인 헤더 -->
                <div class="login-header">
                    <div class="login-logo">
                        <i class="bi bi-buildings"></i>
                    </div>
                    <h1>아파트 커뮤니티</h1>
                    <p>이웃과 함께하는 따뜻한 공간</p>
                </div>

                <!-- 로그인 본문 -->
                <div class="login-body">
                    <div class="login-welcome">
                        <h2>환영합니다!</h2>
                        <p>계정 정보를 입력하여 로그인해주세요.</p>
                    </div>

                    <!-- 로그인 폼 - 수정된 부분 -->
                    <form:form modelAttribute="loginForm" method="post">
                        <!-- 아이디 입력 -->
                        <div class="mb-3">
                            <label for="userId" class="form-label">아이디</label>
                            <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-person"></i>
                                    </span>
                                <form:input path="userId" cssClass="form-control" id="userId" placeholder="아이디를 입력하세요"/>
                            </div>
                        </div>

                        <!-- 비밀번호 입력 -->
                        <div class="mb-3">
                            <label for="password" class="form-label">비밀번호</label>
                            <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-lock"></i>
                                    </span>
                                <form:password path="password" cssClass="form-control" id="password"
                                               placeholder="비밀번호를 입력하세요"/>
                            </div>
                        </div>

                        <!-- 로그인 버튼 -->
                        <button type="submit" class="btn btn-primary btn-login w-100">
                            <i class="bi bi-box-arrow-in-right me-2"></i> 로그인
                        </button>

                        <!-- 로그인 에러 메시지 -->
                        <c:if test="${not empty loginError}">
                            <div class="login-error" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                    ${loginError}
                            </div>
                        </c:if>
                    </form:form>

                    <!-- 회원가입 링크 -->
                    <div class="register-link">
                        <p>아직 계정이 없으신가요?</p>
                        <a href="${pageContext.request.contextPath}/member/register" class="d-inline-block">
                            <i class="bi bi-person-plus me-1"></i> 회원가입
                        </a>
                    </div>
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
