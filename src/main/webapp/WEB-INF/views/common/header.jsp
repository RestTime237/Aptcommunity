<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
	<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>


<style>
	/* 헤더 스타일 */
        .navbar-brand {
            font-weight: 700;
            color: #0d6efd !important;
        }

        .nav-link {
            color: #495057;
            font-weight: 500;
        }

        .nav-link:hover {
            color: #0d6efd;
        }
</style>

<!-- 헤더 -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="/AptCommunity/">
                <i class="bi bi-house-door me-2"></i>
                아파트 커뮤니티
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/AptCommunity/post/list">
                            <i class="bi bi-file-text me-1"></i> 커뮤니티
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/AptCommunity/product/list">
                            <i class="bi bi-bag me-1"></i> 중고마켓
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/AptCommunity/schedule/calendar">
                            <i class="bi bi-calendar-event me-1"></i> 아파트 일정
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/AptCommunity/map">
                            <i class="ri-map-pin-2-line"></i> 내 주변
                        </a>
                    </li>
                    <c:if test="${not empty sessionScope.mb and sessionScope.mb.role >= 3}">
	                    <li class="nav-item">
	                        <a class="nav-link" href="/AptCommunity/admin/dashboard">
	                            <i class="bi bi-bell me-1"></i> 관리자
	                        </a>
	                    </li>
                    </c:if>
                    <li class="nav-item">
                        <a class="nav-link" href="/AptCommunity/member/mypage">
                            <i class="bi bi-person me-1"></i> 마이페이지
                        </a>         	
                    </li>

                </ul>
            </div>
        </div>
    </nav>
