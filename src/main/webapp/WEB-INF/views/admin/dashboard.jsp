<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드 | 아파트 커뮤니티</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
          rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="/AptCommunity/resources/css/admin/dashboard.css"/>

    <script src="/AptCommunity/resources/js/admin/dashboard.js" defer></script>


</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="admin-container">
    <!-- 대시보드 헤더 -->
    <div class="dashboard-header">
        <div class="dashboard-header-content">
            <h1 class="dashboard-title">관리자 대시보드</h1>
            <p class="dashboard-subtitle">아파트 커뮤니티 관리 시스템에 오신 것을 환영합니다.</p>
            <div class="mt-3">
                    <span class="badge bg-light text-dark">
                        <i class="bi bi-clock me-1"></i> 마지막 업데이트: <fmt:formatDate value="<%= new java.util.Date() %>"
                                                                                   pattern="yyyy-MM-dd HH:mm:ss"/>
                    </span>
            </div>
        </div>
    </div>

    <!-- 통계 카드 -->
    <div class="row g-4 mb-4">
        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="card-body">
                    <div class="stat-icon posts">
                        <i class="bi bi-file-text"></i>
                    </div>
                    <div class="stat-value">${postCount}</div>
                    <div class="stat-label">게시글</div>
                    <div class="stat-change positive">
                        <i class="bi bi-arrow-up-short me-1"></i> 5% 증가
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="card-body">
                    <div class="stat-icon products">
                        <i class="bi bi-bag"></i>
                    </div>
                    <div class="stat-value">${productCount}</div>
                    <div class="stat-label">상품</div>
                    <div class="stat-change positive">
                        <i class="bi bi-arrow-up-short me-1"></i> 8% 증가
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="card-body">
                    <div class="stat-icon members">
                        <i class="bi bi-people"></i>
                    </div>
                    <div class="stat-value">${memberCount}</div>
                    <div class="stat-label">회원</div>
                    <div class="stat-change positive">
                        <i class="bi bi-arrow-up-short me-1"></i> 3% 증가
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="card-body">
                    <div class="stat-icon reports">
                        <i class="bi bi-exclamation-triangle"></i>
                    </div>
                    <div class="stat-value">12</div>
                    <div class="stat-label">신고</div>
                    <div class="stat-change negative">
                        <i class="bi bi-arrow-up-short me-1"></i> 2건 증가
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 빠른 작업 -->
    <div class="quick-actions mb-4">
        <h5 class="mb-3">빠른 작업</h5>
        <div class="row g-3">
            <div class="col-6 col-md-3">
                <a href="/AptCommunity/post/add" class="action-btn">
                    <i class="bi bi-file-earmark-plus"></i>
                    <span>공지사항 작성</span>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="/AptCommunity/admin/members" class="action-btn">
                    <i class="bi bi-person-plus"></i>
                    <span>회원 관리</span>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="/AptCommunity/admin/reports" class="action-btn">
                    <i class="bi bi-flag"></i>
                    <span>신고 처리</span>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="/AptCommunity/admin/settings" class="action-btn">
                    <i class="bi bi-gear"></i>
                    <span>시스템 설정</span>
                </a>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <!-- 활동 차트 -->
        <div class="col-lg-8">
            <div class="chart-container">
                <h5 class="chart-title">최근 30일 활동 통계</h5>
                <canvas id="activityChart" height="300"></canvas>
            </div>
        </div>

        <!-- 최근 활동 -->
        <div class="col-lg-4">
            <div class="recent-activity">
                <h5 class="mb-3">최근 활동</h5>

                <div class="activity-item">
                    <div class="activity-icon post">
                        <i class="bi bi-file-text"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">새 게시글 등록</div>
                        <div class="activity-meta">김주민님이 '주차장 이용 규칙' 게시글을 작성했습니다.</div>
                    </div>
                    <div class="activity-time">10분 전</div>
                </div>

                <div class="activity-item">
                    <div class="activity-icon product">
                        <i class="bi bi-bag"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">새 상품 등록</div>
                        <div class="activity-meta">이판매님이 '아이폰 14 Pro' 상품을 등록했습니다.</div>
                    </div>
                    <div class="activity-time">35분 전</div>
                </div>

                <div class="activity-item">
                    <div class="activity-icon member">
                        <i class="bi bi-person"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">새 회원 가입</div>
                        <div class="activity-meta">박신규님이 회원으로 가입했습니다.</div>
                    </div>
                    <div class="activity-time">1시간 전</div>
                </div>

                <div class="activity-item">
                    <div class="activity-icon report">
                        <i class="bi bi-exclamation-triangle"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">게시글 신고</div>
                        <div class="activity-meta">'부적절한 내용' 사유로 게시글이 신고되었습니다.</div>
                    </div>
                    <div class="activity-time">2시간 전</div>
                </div>

                <div class="text-center mt-3">
                    <a href="/AptCommunity/admin/activities" class="btn btn-sm btn-outline-primary">모든 활동 보기</a>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- 최근 게시글 -->
        <div class="col-lg-6">
            <div class="table-container">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">최근 게시글</h5>
                    <a href="/AptCommunity/post/list" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-list me-1"></i> 전체보기
                    </a>
                </div>

                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>날짜</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>주차장 이용 규칙 안내</td>
                        <td>김주민</td>
                        <td>2025-04-14</td>
                        <td><span class="status-badge active">활성</span></td>
                        <td>
                            <div class="dropdown action-dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown">
                                    관리
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-eye"></i> 보기</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-pencil"></i> 수정</a></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="bi bi-trash"></i> 삭제</a>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>단지 내 벼룩시장 개최 안내</td>
                        <td>박행사</td>
                        <td>2025-04-13</td>
                        <td><span class="status-badge active">활성</span></td>
                        <td>
                            <div class="dropdown action-dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown">
                                    관리
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-eye"></i> 보기</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-pencil"></i> 수정</a></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="bi bi-trash"></i> 삭제</a>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>층간 소음 문제 해결 방안</td>
                        <td>최주민</td>
                        <td>2025-04-12</td>
                        <td><span class="status-badge reported">신고됨</span></td>
                        <td>
                            <div class="dropdown action-dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown">
                                    관리
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-eye"></i> 보기</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-pencil"></i> 수정</a></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="bi bi-trash"></i> 삭제</a>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>아파트 헬스장 이용 시간 변경</td>
                        <td>이관리</td>
                        <td>2025-04-11</td>
                        <td><span class="status-badge active">활성</span></td>
                        <td>
                            <div class="dropdown action-dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown">
                                    관리
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-eye"></i> 보기</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-pencil"></i> 수정</a></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="bi bi-trash"></i> 삭제</a>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 최근 상품 -->
        <div class="col-lg-6">
            <div class="table-container">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">최근 상품</h5>
                    <a href="/AptCommunity/product/list" class="btn btn-sm btn-outline-success">
                        <i class="bi bi-list me-1"></i> 전체보기
                    </a>
                </div>

                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>상품명</th>
                        <th>판매자</th>
                        <th>가격</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>아이폰 14 Pro</td>
                        <td>이판매</td>
                        <td>850,000원</td>
                        <td><span class="status-badge active">판매중</span></td>
                        <td>
                            <div class="dropdown action-dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown">
                                    관리
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-eye"></i> 보기</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-pencil"></i> 수정</a></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="bi bi-trash"></i> 삭제</a>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>LG 냉장고</td>
                        <td>주부9</td>
                        <td>350,000원</td>
                        <td><span class="status-badge active">판매중</span></td>
                        <td>
                            <div class="dropdown action-dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown">
                                    관리
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-eye"></i> 보기</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-pencil"></i> 수정</a></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="bi bi-trash"></i> 삭제</a>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>유아용 자전거</td>
                        <td>아이맘</td>
                        <td>50,000원</td>
                        <td><span class="status-badge pending">예약중</span></td>
                        <td>
                            <div class="dropdown action-dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown">
                                    관리
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-eye"></i> 보기</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-pencil"></i> 수정</a></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="bi bi-trash"></i> 삭제</a>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>게이밍 컴퓨터 풀셋</td>
                        <td>게이머킹</td>
                        <td>1,200,000원</td>
                        <td><span class="status-badge inactive">판매완료</span></td>
                        <td>
                            <div class="dropdown action-dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown">
                                    관리
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-eye"></i> 보기</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="bi bi-pencil"></i> 수정</a></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="bi bi-trash"></i> 삭제</a>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

</body>
</html>
