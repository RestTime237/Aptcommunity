<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아파트 커뮤니티 홈</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
          rel="stylesheet">
    <script src="${pageContext.request.contextPath}/resources/js/proj4.js"></script>
    <script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css"/>

</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <!-- 히어로 섹션 -->
    <div class="hero-section p-5 mb-5">
        <div class="row justify-content-center hero-content">
            <div class="col-lg-8 text-center">
                <h1 class="display-4 fw-bold mb-3 animate-fade-in">우리 아파트, 소통이 시작되는 곳</h1>
                <p class="lead mb-4 animate-fade-in" style="animation-delay: 0.2s;">이웃과 함께하는 편안한 아파트 생활</p>

                <!-- 로그인 상태 -->
                <c:if test="${not empty mb}">
                    <div class="login-box p-4 d-inline-block mb-3 animate-fade-in" style="animation-delay: 0.4s;">
                        <div class="d-flex align-items-center justify-content-center mb-3">
                            <div class="bg-white bg-opacity-25 rounded-circle p-2 me-3">
                                <c:if test="${mb.profileImage != null || !mb.profileImage == ''}">
                                    <img src="${pageContext.request.contextPath}/resources/images/${mb.profileImage}"
                                         class="chat-profile-img">
                                </c:if>
                                <c:if test="${mb.profileImage == null || mb.profileImage == ''}">
                                    <i class="bi bi-person-circle fs-2 text-white"></i>
                                </c:if>
                            </div>
                            <div class="text-start">
                                <div>
                                    <span class="fs-5 fw-semibold">${mb.username}님</span>
                                </div>
                                <p class="text-white-50 mb-0 small">환영합니다!</p>
                            </div>
                        </div>
                        <div class="d-flex justify-content-center gap-2">
                            <a href="${pageContext.request.contextPath}/member/mypage" class="btn btn-sm btn-outline-light">
                                <i class="bi bi-building me-1"></i> 마이페이지
                            </a>
                            <a href="${pageContext.request.contextPath}/chat/rooms" class="btn btn-sm btn-outline-light">
                                <i class="ri-chat-1-line me-1"></i> 내 채팅
                            </a>
                            <a href="${pageContext.request.contextPath}/member/logout" class="btn btn-sm btn-outline-light">
                                <i class="bi bi-box-arrow-right me-1"></i> 로그아웃
                            </a>
                        </div>
                    </div>
                </c:if>

                <!-- 비로그인 상태 -->
                <c:if test="${empty mb}">
                    <div class="animate-fade-in" style="animation-delay: 0.4s;">
                        <p class="text-white-50 mb-3">아파트 커뮤니티 서비스를 이용하시려면</p>
                        <a href="${pageContext.request.contextPath}/member/login"
                           class="btn btn-light text-primary fw-semibold px-4 py-2 me-2 shadow-sm">
                            <i class="bi bi-box-arrow-in-right me-1"></i> 로그인
                        </a>
                        <a href="${pageContext.request.contextPath}/member/register" class="btn btn-outline-light px-4 py-2">
                            <i class="bi bi-person-plus me-1"></i> 회원가입
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- 인기 게시글 -->
    <div class="popular-posts">
        <h4 class="mb-4 d-flex align-items-center">
            <i class="bi bi-star-fill me-2 text-warning"></i>
            인기 게시글
        </h4>
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mb-4">
            <c:forEach var="post" items="${popularPosts}">
                <div class="col">
                    <a href="${pageContext.request.contextPath}/post/detail?id=${post.id}" class="text-decoration-none text-dark">
                        <div class="popular-post-card">
                            <div class="popular-post-img">
                                <c:choose>
                                    <c:when test="${not empty thumbnailMap[post.id]}">
                                        <img src="${pageContext.request.contextPath}/resources/images/${thumbnailMap[post.id]}"
                                             alt="인기 게시글"/>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/resources/images/default-image.png" alt="인기 게시글"/>
                                    </c:otherwise>
                                </c:choose>

                                <span class="popular-post-badge"><i class="bi bi-eye me-1"></i> ${post.views}</span>
                            </div>
                            <div class="popular-post-info">
                                <h6 class="popular-post-title">${post.title}</h6>
                                <div class="popular-post-meta">
                                    <span><i class="bi bi-person me-1"></i> ${nicknameMap[post.userId]}</span>
                                    <span><i class="bi bi-calendar3 me-1"></i> <fmt:formatDate value="${post.createdAt}"
                                                                                               pattern="yyyy.MM.dd"/></span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- 날씨 + 미세먼지 위젯 -->
    <div class="row mb-5">
        <div class="col-md-6 mb-4 mb-md-0">
            <div class="weather-widget h-100 shadow position-relative">
                <div class="weather-content">
                    <h5 class="mb-4 d-flex align-items-center">
                        <i class="bi bi-cloud-sun me-2"></i>
                        오늘의 날씨
                    </h5>
                    <div class="d-flex align-items-center justify-content-center">
                        <lottie-player
                                id="weather-icon"
                                background="transparent"
                                speed="1"
                                style="width: 100px; height: 100px; margin-right: 10px;"
                                loop
                                autoplay>
                        </lottie-player>

                        <div>
                            <h5 id="weather-city" class="mb-1 fw-bold">도시명</h5>
                            <p id="weather-temp" class="fs-3 mb-0 fw-bold">-- °C</p>
                            <small id="weather-desc" class="opacity-75">날씨</small>
                        </div>

                    </div>
                </div>
                <small id="weather-updated" class="position-absolute translate-middle bottom-0 end-0 ">
                    마지막 업데이트 --:--:--
                </small>
            </div>
        </div>

        <div class="col-md-6">
            <div class="dust-widget h-100 shadow">
                <div class="dust-content">
                    <h5 class="mb-4 d-flex align-items-center">
                        <i class="bi bi-wind me-2"></i>
                        오늘의 미세먼지
                    </h5>
                    <div class="d-flex align-items-center mb-3">
                        <i class="bi bi-geo-alt fs-4 me-2"></i>
                        <span id="dust-station" class="fw-medium">측정소: --</span>
                    </div>

                    <div class="row">
                        <div class="col-6">
                            <div class="dust-card">
                                <div class="opacity-75 mb-1 small">미세먼지 (PM10)</div>
                                <div class="fs-3 fw-bold">
                                    <span id="pm10-value">--</span> <span class="fs-6 fw-normal">㎍/㎥</span>
                                </div>
                                <div id="pm10-grade" class="small">등급</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="dust-card">
                                <div class="opacity-75 mb-1 small">초미세먼지 (PM2.5)</div>
                                <div class="fs-3 fw-bold">
                                    <span id="pm25-value">--</span> <span class="fs-6 fw-normal">㎍/㎥</span>
                                </div>
                                <div id="pm25-grade" class="small">등급</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 아파트 서비스 바로가기 -->
    <div class="mb-5">
        <h4 class="mb-4 d-flex align-items-center">
            <i class="bi bi-building me-2 text-primary"></i>
            아파트 서비스
        </h4>
        <div class="row row-cols-2 row-cols-sm-3 row-cols-md-6 g-4">
            <div class="col">
                <a href="${pageContext.request.contextPath}/post/list" class="service-card card h-100 text-center">
                    <div class="card-body p-3">
                        <div class="service-icon">
                            <i class="bi bi-file-text"></i>
                        </div>
                        <h6 class="card-title mb-0">커뮤니티</h6>
                    </div>
                </a>
            </div>
            <div class="col">
                <a href="${pageContext.request.contextPath}/product/list" class="service-card card h-100 text-center">
                    <div class="card-body p-3">
                        <div class="service-icon">
                            <i class="bi bi-bag"></i>
                        </div>
                        <h6 class="card-title mb-0">중고마켓</h6>
                    </div>
                </a>
            </div>
            <div class="col">
                <a href="${pageContext.request.contextPath}/schedule/calendar" class="service-card card h-100 text-center">
                    <div class="card-body p-3">
                        <div class="service-icon">
                            <i class="bi bi-calendar-event"></i>
                        </div>
                        <h6 class="card-title mb-0">아파트 일정</h6>
                    </div>
                </a>
            </div>
            <div class="col">
                <a href="${pageContext.request.contextPath}/map" class="service-card card h-100 text-center">
                    <div class="card-body p-3">
                        <div class="service-icon">
                            <i class="ri-map-pin-2-line"></i>
                        </div>
                        <h6 class="card-title mb-0">내 주변</h6>
                    </div>
                </a>
            </div>
            <div class="col">
                <a href="${pageContext.request.contextPath}/vote/list" class="service-card card h-100 text-center">
                    <div class="card-body p-3">
                        <div class="service-icon">
                            <i class="ri-checkbox-circle-line"></i>
                        </div>
                        <h6 class="card-title mb-0">주민투표</h6>
                    </div>
                </a>
            </div>
            <div class="col">
                <a href="${pageContext.request.contextPath}/member/mypage" class="service-card card h-100 text-center">
                    <div class="card-body p-3">
                        <div class="service-icon">
                            <i class="bi bi-person"></i>
                        </div>
                        <h6 class="card-title mb-0">마이페이지</h6>
                    </div>
                </a>
            </div>
        </div>
    </div>

    <!-- 최신 게시글 및 판매글 -->
    <div class="row">
        <!-- 최신 게시글 -->
        <div class="col-lg-6 mb-4">
            <div class="card h-100 shadow-sm widget-card">
                <div class="card-header board-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 d-flex align-items-center">
                        <i class="bi bi-file-text me-2"></i> 최신 게시글
                    </h5>
                    <a href="${pageContext.request.contextPath}/post/list" class="btn btn-sm btn-outline-primary rounded-pill">
                        <i class="bi bi-arrow-right me-1"></i> 전체보기
                    </a>
                </div>
                <div class="list-group list-group-flush">
                    <c:forEach var="post" items="${recentPosts}">
                        <a href="${pageContext.request.contextPath}/post/detail?id=${post.id}"
                           class="list-group-item list-group-item-action post-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">
                                    <c:if test="${post.category == '공지'}">
                                        <span class="notice-badge">공지</span>
                                    </c:if>
                                        ${post.title}
                                </h6>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i
                                        class="bi bi-person-circle me-1"></i> ${nicknameMap[post.userId]}</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> <fmt:formatDate
                                        value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm"/></small>
                            </div>
                        </a>
                    </c:forEach>

                    <!-- 데이터가 없을 경우 샘플 데이터 표시 -->
                    <c:if test="${empty recentPosts}">
                        <a href="#" class="list-group-item list-group-item-action post-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">
                                    <span class="notice-badge">공지</span>
                                    단지 내 주차 문제에 관한 건의사항
                                </h6>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i class="bi bi-person-circle me-1"></i> 김주민</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> 2025-04-14 15:30</small>
                            </div>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action post-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">이번 주말 단지 내 벼룩시장 개최 안내</h6>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i class="bi bi-person-circle me-1"></i> 박행사</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> 2025-04-14 12:15</small>
                            </div>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action post-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">아파트 헬스장 이용 시간 변경 안내</h6>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i class="bi bi-person-circle me-1"></i> 이관리</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> 2025-04-13 18:45</small>
                            </div>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action post-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">단지 내 조경 공사 일정 안내</h6>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i class="bi bi-person-circle me-1"></i> 정원예</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> 2025-04-13 10:20</small>
                            </div>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action post-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">층간 소음 문제 해결을 위한 제안</h6>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i class="bi bi-person-circle me-1"></i> 최주민</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> 2025-04-12 21:05</small>
                            </div>
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 최신 판매글 -->
        <div class="col-lg-6 mb-4">
            <div class="card h-100 shadow-sm widget-card">
                <div class="card-header market-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 d-flex align-items-center">
                        <i class="bi bi-bag me-2"></i> 최신 판매글
                    </h5>
                    <a href="${pageContext.request.contextPath}/product/list" class="btn btn-sm btn-outline-success rounded-pill">
                        <i class="bi bi-arrow-right me-1"></i> 전체보기
                    </a>
                </div>
                <div class="list-group list-group-flush">
                    <c:forEach var="product" items="${recentProducts}">
                        <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}"
                           class="list-group-item list-group-item-action product-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">${product.name}</h6>
                                <p class="related-product-price mb-0 text-success fw-medium">
                                    <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>원
                                </p>

                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i
                                        class="bi bi-person-circle me-1"></i> ${nicknameMap[product.userId]}</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> <fmt:formatDate
                                        value="${product.createdAt}" pattern="yyyy-MM-dd HH:mm"/></small>
                            </div>
                        </a>
                    </c:forEach>

                    <!-- 데이터가 없을 경우 샘플 데이터 표시 -->
                    <c:if test="${empty recentProducts}">
                        <a href="#" class="list-group-item list-group-item-action product-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">거의 새것 아이폰 14 Pro 판매합니다</h6>
                                <span class="text-success fw-medium">850,000원</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i class="bi bi-person-circle me-1"></i> 애플맨</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> 2025-04-14 16:45</small>
                            </div>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action product-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">2년 사용한 LG 냉장고 팝니다</h6>
                                <span class="text-success fw-medium">350,000원</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i class="bi bi-person-circle me-1"></i> 주부9</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> 2025-04-14 11:30</small>
                            </div>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action product-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">유아용 자전거 판매합니다</h6>
                                <span class="text-success fw-medium">50,000원</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i class="bi bi-person-circle me-1"></i> 아이맘</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> 2025-04-13 19:20</small>
                            </div>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action product-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">게이밍 컴퓨터 풀셋 판매</h6>
                                <span class="text-success fw-medium">1,200,000원</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i class="bi bi-person-circle me-1"></i> 게이머킹</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> 2025-04-13 09:15</small>
                            </div>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action product-link">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-truncate">다이슨 청소기 거의 새것</h6>
                                <span class="text-success fw-medium">280,000원</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted"><i class="bi bi-person-circle me-1"></i> 청결맘</small>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i> 2025-04-12 14:50</small>
                            </div>
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- 공지사항 및 이벤트 -->
    <div class="row mb-5">
        <div class="col-12">
            <div class="card shadow-sm widget-card">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 d-flex align-items-center">
                        <i class="bi bi-megaphone me-2 text-primary"></i> 공지사항 및 이벤트
                    </h5>
                </div>
                <div class="card-body p-4">
                    <div class="alert alert-primary d-flex align-items-center" role="alert">
                        <i class="bi bi-info-circle-fill me-2 fs-4"></i>
                        <div>
                            <strong>아파트 관리비 납부 안내</strong> - 이번 달 관리비 납부 기한은 4월 25일까지입니다.
                        </div>
                    </div>
                    <div class="alert alert-warning d-flex align-items-center" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2 fs-4"></i>
                        <div>
                            <strong>단지 내 도로 보수공사 안내</strong> - 4월 20일부터 22일까지 단지 내 도로 보수공사가 진행됩니다.
                        </div>
                    </div>
                    <div class="alert alert-success d-flex align-items-center" role="alert">
                        <i class="bi bi-calendar-event-fill me-2 fs-4"></i>
                        <div>
                            <strong>주민 화합 행사 안내</strong> - 4월 30일 토요일 오후 2시, 단지 내 광장에서 주민 화합 행사가 개최됩니다.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 미세먼지 등급 계산 함수
    function getDustGrade(value, type = 'pm10') {
        value = Number(value);

        if (isNaN(value)) return {text: '알 수 없음', color: 'text-secondary'};

        if (type === 'pm10') {
            if (value <= 30) return {text: '좋음', color: 'text-success'};
            else if (value <= 80) return {text: '보통', color: 'text-primary'};
            else if (value <= 150) return {text: '나쁨', color: 'text-warning'};
            else return {text: '매우나쁨', color: 'text-danger'};
        } else if (type === 'pm25') {
            if (value <= 15) return {text: '좋음', color: 'text-success'};
            else if (value <= 35) return {text: '보통', color: 'text-primary'};
            else if (value <= 75) return {text: '나쁨', color: 'text-warning'};
            else return {text: '매우나쁨', color: 'text-danger'};
        } else {
            return {text: '알 수 없음', color: 'text-secondary'};
        }
    }

    // 날씨 및 미세먼지 데이터 로드
    document.addEventListener("DOMContentLoaded", function () {
        // 좌표계 정의
        proj4.defs('EPSG:4326', '+proj=longlat +datum=WGS84 +no_defs');
        proj4.defs('EPSG:5179', '+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +units=m +no_defs');

        // 회원 정보에 따라 다른 방식으로 데이터 로드
        <c:if test="${mb.dong == null || mb.roadAddress == null || mb.roadAddress == ''}">
        loadWeatherByLocation();
        </c:if>

        <c:if test="${not (mb.dong == null || mb.roadAddress == null || mb.roadAddress == '')}">
        loadWeatherByDong();
        </c:if>

        // 위치 기반 날씨 및 미세먼지 로드
        function loadWeatherByLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    const lat = position.coords.latitude;
                    const lon = position.coords.longitude;

                    const [tmX, tmY] = proj4('EPSG:4326', 'EPSG:5179', [lon, lat]);

                    const weatherURL = `${pageContext.request.contextPath}/weather?lat=\${lat}&lon=\${lon}`;
                    const dustURL = `${pageContext.request.contextPath}/dust?tmX=\${tmX}&tmY=\${tmY}`;

                    // 날씨 데이터 가져오기
                    fetch(weatherURL)
                        .then(res => res.json())
                        .then(data => {
                            updateWeatherUI(data);
                        })
                        .catch(err => {
                            console.error('날씨 데이터 로드 실패:', err);
                            // 날씨 데이터 로드 실패 시 샘플 데이터로 UI 업데이트
                            updateWeatherUI({
                                city: '서울시',
                                temp: 22,
                                feels_like: 24,
                                description: '맑음',
                                icon: '01d'
                            });
                        });

                    // 미세먼지 데이터 가져오기
                    fetch(dustURL)
                        .then(res => res.json())
                        .then(data => {
                            updateDustUI(data);
                        })
                        .catch(err => {
                            console.error('미세먼지 데이터 로드 실패:', err);
                            // 미세먼지 데이터 로드 실패 시 샘플 데이터로 UI 업데이트
                            updateDustUI({
                                stationName: '강남구',
                                pm10Value: '35',
                                pm25Value: '18'
                            });
                        });
                });
            } else {
                console.error('Geolocation이 지원되지 않습니다.');
                // 위치 정보를 가져올 수 없을 때 샘플 데이터로 UI 업데이트
                updateWeatherUI({
                    city: '서울시',
                    temp: 22,
                    feels_like: 24,
                    description: '맑음',
                    icon: '01d'
                });

                updateDustUI({
                    stationName: '강남구',
                    pm10Value: '35',
                    pm25Value: '18'
                });
            }
        }

        // 동 기반 날씨 및 미세먼지 로드
        function loadWeatherByDong() {
            // 날씨 데이터 가져오기
            fetch('${pageContext.request.contextPath}/weatherByDong')
                .then(res => res.json())
                .then(data => {
                    updateWeatherUI(data);
                })
                .catch(err => {
                    console.error('날씨 데이터 로드 실패:', err);
                    // 날씨 데이터 로드 실패 시 샘플 데이터로 UI 업데이트
                    updateWeatherUI({
                        city: '${mb.dong}',
                        temp: 22,
                        feels_like: 24,
                        description: '맑음',
                        icon: '01d'
                    });
                });

            // 미세먼지 데이터 가져오기
            fetch('${pageContext.request.contextPath}/dustByDong')
                .then(res => res.json())
                .then(data => {
                    updateDustUI(data);
                })
                .catch(err => {
                    console.error('미세먼지 데이터 로드 실패:', err);
                    // 미세먼지 데이터 로드 실패 시 샘플 데이터로 UI 업데이트
                    updateDustUI({
                        stationName: '${mb.dong}',
                        pm10Value: '35',
                        pm25Value: '18'
                    });
                });
        }

        // 날씨 UI 업데이트 함수
        function updateWeatherUI(data) {
            const temp = Math.round(data.temp);
            const feelsLike = Math.round(data.feels_like);
            const iconMap = {
                "01d": "clear-day",
                "01n": "clear-night",
                "02d": "few-clouds-day",
                "02n": "few-clouds-night",
                "03d": "cloudy",
                "03n": "cloudy",
                "04d": "cloudy",
                "04n": "cloudy",
                "09d": "rain-day",
                "09n": "rain-night",
                "10d": "rain-day",
                "10n": "rain-night",
                "11d": "thunderstorm",
                "11n": "thunderstorm",
                "13d": "snow",
                "13n": "snow",
                "50d": "mist",
                "50n": "mist"
            };

            const lottieUrls = {
                "clear-night": "https://lottie.host/d3f0cd8e-83df-4574-91f3-e29f949a8273/Qviq53lqPW.json",
                "few-clouds-night": "https://lottie.host/745166f6-1fbd-44d8-b0bb-4e3ee2fafa70/7uIwA2KNMY.json",
                "rain-night": "https://lottie.host/8a1e38e2-e09e-486b-999c-55dc95f241db/nbZCjtWy9X.json",
                "rain-day": "https://lottie.host/d976ce19-ae56-45a3-9cf8-f004b5d7dcb9/5vffDOi2LV.json",
                "snow": "https://lottie.host/2e25528f-b831-4e22-9c63-09a2a72609c2/X13MAKfjIg.json",
                "mist": "https://lottie.host/7930444a-22fd-4634-861a-e4c17e07db16/FyD3TrJc1G.json",
                "few-clouds-day": "https://lottie.host/e3e9beaf-2147-4cef-9345-a0c06a584755/aWBl0XdF3O.json",
                "thunderstorm": "https://lottie.host/04ac457f-5724-49f0-a7aa-ae99f01e87bb/XUOT8Qi9kb.json",
                "cloudy": "https://lottie.host/e6cdd98b-bc53-41ee-951b-8e858f418c4f/vcFhVMUGT4.json",
                "clear-day": "https://lottie.host/f50d7e91-edb9-4ce4-8d2f-e38416b84c56/woQEqCea3U.json"
            };


            const lottieKey = iconMap[data.icon];
            const lottieUrl = lottieUrls[lottieKey];

            const weatherIcon = document.getElementById("weather-icon");
            weatherIcon.load(lottieUrl);

            /*
            const iconUrl = `https://openweathermap.org/img/wn/\${data.icon}@2x.png`;

            document.getElementById("weather-icon").src = iconUrl;*/

            document.getElementById("weather-city").innerText = data.city;
            document.getElementById("weather-temp").innerText = `\${temp}°C (체감 \${feelsLike}°C)`;
            document.getElementById("weather-desc").innerText = data.description;
        }

        // 미세먼지 UI 업데이트 함수
        function updateDustUI(data) {
            document.getElementById("dust-station").innerText = `측정소: \${data.stationName}`;
            document.getElementById("pm10-value").innerText = data.pm10Value;
            document.getElementById("pm25-value").innerText = data.pm25Value;

            const pm10Grade = getDustGrade(data.pm10Value, 'pm10');
            const pm25Grade = getDustGrade(data.pm25Value, 'pm25');

            const pm10GradeElement = document.getElementById("pm10-grade");
            pm10GradeElement.innerText = `\${pm10Grade.text} 등급`;
            pm10GradeElement.className = `small ${pm10Grade.color}`;

            const pm25GradeElement = document.getElementById("pm25-grade");
            pm25GradeElement.innerText = `\${pm25Grade.text} 등급`;
            pm25GradeElement.className = `small ${pm25Grade.color}`;
        }
    });

    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    document.getElementById("weather-updated").textContent = `마지막 업데이트 \${hours}:\${minutes}`;
</script>
</body>
</html>
