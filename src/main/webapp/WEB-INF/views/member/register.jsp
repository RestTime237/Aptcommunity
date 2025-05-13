<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 아파트 커뮤니티</title>

    <!-- Bootstrap & jQuery -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="/AptCommunity/resources/css/member/register.css">

    <script src="/AptCommunity/resources/js/member/register.js" defer></script>

</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="register-card">
                <!-- 회원가입 헤더 -->
                <div class="register-header">
                    <div class="register-logo">
                        <i class="bi bi-buildings"></i>
                    </div>
                    <h1>아파트 커뮤니티</h1>
                    <p>이웃과 함께하는 따뜻한 공간</p>
                </div>

                <!-- 회원가입 본문 -->
                <div class="register-body">
                    <div class="register-welcome">
                        <h2>회원가입</h2>
                        <p>아파트 커뮤니티의 회원이 되어 다양한 서비스를 이용해보세요.</p>
                    </div>

                    <!-- 회원가입 폼 -->
                    <form:form modelAttribute="NewMember" method="post">
                        <!-- 기본 정보 섹션 -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="bi bi-person-badge"></i> 기본 정보
                            </div>

                            <!-- 이름 -->
                            <div class="mb-3">
                                <label for="username" class="form-label">이름</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-person"></i>
                                        </span>
                                    <form:input path="username" id="username" class="form-control" required="required"
                                                placeholder="실명을 입력하세요"/>
                                </div>
                                <div class="form-text">실명을 입력해주세요. 이웃 주민들에게 표시됩니다.</div>
                            </div>

                            <!-- 별명 -->
                            <div class="mb-3">
                                <label for="nickname" class="form-label">별명</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-person-badge"></i>
                                        </span>
                                    <form:input path="nickname" id="nickname" class="form-control" required="required"
                                                placeholder="커뮤니티에서 사용할 별명을 입력하세요"/>
                                </div>
                                <div class="form-text">커뮤니티 활동시 사용할 별명을 입력해주세요.</div>
                            </div>
                        </div>

                        <!-- 계정 정보 섹션 -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="bi bi-shield-lock"></i> 계정 정보
                            </div>

                            <!-- 아이디 -->
                            <div class="mb-3">
                                <label for="userId" class="form-label">아이디</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-at"></i>
                                        </span>
                                    <form:input path="userId" id="userId" class="form-control" required="required"
                                                placeholder="로그인에 사용할 아이디를 입력하세요"/>
                                </div>
                                <div class="form-text">영문, 숫자를 조합하여 6~20자로 입력해주세요.</div>
                            </div>

                            <!-- 비밀번호 -->
                            <div class="mb-3">
                                <label for="password" class="form-label">비밀번호</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-lock"></i>
                                        </span>
                                    <form:input path="password" type="password" id="password" class="form-control"
                                                required="required" placeholder="비밀번호를 입력하세요"/>
                                </div>
                                <div class="form-text">영문, 숫자, 특수문자를 조합하여 8자 이상 입력해주세요.</div>
                            </div>
                        </div>

                        <!-- 주소 정보 섹션 -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="bi bi-geo-alt"></i> 주소 정보
                            </div>

                            <!-- 주소 -->
                            <div class="mb-3">
                                <label for="roadAddress" class="form-label">주소</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-house-door"></i>
                                        </span>
                                    <input type="text" id="roadAddress" class="form-control" placeholder="도로명 주소"
                                           readonly/>
                                    <button type="button" class="btn btn-address" onclick="openDaumPopup()">
                                        <i class="bi bi-search me-1"></i> 주소 찾기
                                    </button>
                                </div>
                                <div class="form-text">거주하시는 아파트 주소를 입력해주세요.</div>
                            </div>

                            <!-- 숨겨진 주소 관련 정보 -->
                            <input type="hidden" name="buildingName" id="buildingName"/>
                            <input type="hidden" name="sigunguCode" id="sigunguCode"/>
                            <input type="hidden" name="roadnameCode" id="roadnameCode"/>
                            <input type="hidden" name="roadAddress" value="${roadAddress}"/>
                            <input type="hidden" name="dong" id="dong"/>
                        </div>

                        <!-- 회원가입 버튼 -->
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-primary btn-register">
                                <i class="bi bi-person-plus me-2"></i> 회원가입 완료
                            </button>
                        </div>
                    </form:form>

                    <!-- 로그인 링크 -->
                    <div class="login-link">
                        <p>이미 계정이 있으신가요?</p>
                        <a href="/AptCommunity/member/login" class="d-inline-block">
                            <i class="bi bi-box-arrow-in-right me-1"></i> 로그인하기
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