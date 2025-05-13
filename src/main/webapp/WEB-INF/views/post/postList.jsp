<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 목록 - 아파트 커뮤니티</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post/postList.css"/>

    <script src="${pageContext.request.contextPath}/resources/js/post/postList.js" defer></script>

</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <!-- 페이지 타이틀 -->
    <div class="page-title">
        <i class="bi bi-file-text me-2 text-primary fs-3"></i>
        <div>
            <h2 class="mb-0">커뮤니티 게시판</h2>
            <p class="text-muted mb-0">이웃과 함께 소통하는 공간입니다.</p>
        </div>
    </div>

    <!-- 게시판 통계 -->
    <div class="stats-card mb-4">
        <div class="stats-card-body">
            <div class="row stats-row">
                <div class="col-lg-3 col-md-6 stats-col">
                    <div class="stats-item">
                        <div class="stats-icon">
                            <i class="bi bi-file-text"></i>
                        </div>
                        <div>
                            <div class="stats-value" id="total-posts">0</div>
                            <div class="stats-label">전체 게시글</div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 stats-col">
                    <div class="stats-item">
                        <div class="stats-icon">
                            <i class="bi bi-calendar-check"></i>
                        </div>
                        <div>
                            <div class="stats-value" id="today-posts">0</div>
                            <div class="stats-label">오늘 작성된 글</div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 stats-col">
                    <div class="stats-item">
                        <div class="stats-icon">
                            <i class="bi bi-chat-dots"></i>
                        </div>
                        <div>
                            <div class="stats-value" id="total-comments">0</div>
                            <div class="stats-label">전체 댓글</div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 stats-col">
                    <div class="stats-item">
                        <div class="stats-icon">
                            <i class="bi bi-people"></i>
                        </div>
                        <div>
                            <div class="stats-value" id="active-users">0</div>
                            <div class="stats-label">활동 중인 회원</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 인기 게시글 -->
    <div class="popular-posts">
        <h4 class="mb-3"><i class="bi bi-star me-2 text-warning"></i>인기 게시글</h4>
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
                                    <span><i class="bi bi-calendar3 me-1"></i>
                                            <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd"/>
                                        </span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- 카테고리 필터 -->
    <div class="category-filter">
        <button type="button" class="category-btn active" data-category="">
            <i class="bi bi-grid"></i> 전체
        </button>
        <button type="button" class="category-btn" data-category="공지">
            <i class="bi bi-megaphone"></i> 공지사항
        </button>
        <button type="button" class="category-btn" data-category="자유">
            <i class="bi bi-chat"></i> 자유게시판
        </button>
        <button type="button" class="category-btn" data-category="질문">
            <i class="bi bi-question-circle"></i> 질문게시판
        </button>
        <button type="button" class="category-btn" data-category="정보">
            <i class="bi bi-info-circle"></i> 정보공유
        </button>
        <button type="button" class="category-btn" data-category="행사">
            <i class="bi bi-calendar-event"></i> 행사/모임
        </button>
    </div>

    <!-- 검색 필터 -->
    <div class="search-filter shadow-sm">
        <form id="searchForm">
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label fw-medium">카테고리</label>
                    <select name="category" class="form-select">
                        <option value="">전체 카테고리</option>
                        <option value="자유">자유</option>
                        <option value="공지">공지</option>
                        <option value="질문">질문</option>
                        <option value="정보">정보</option>
                        <option value="행사">행사/모임</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-medium">검색 조건</label>
                    <select name="choice" class="form-select">
                        <option value="all">전체</option>
                        <option value="titleAndContent">제목+내용</option>
                        <option value="writer">작성자</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-medium">검색어</label>
                    <input type="text" name="keyword" value="${param.keyword}" class="form-control"
                           placeholder="검색어를 입력하세요"/>
                </div>
                <div class="col-md-2">
                    <button type="button" id="search" class="btn btn-search w-100">
                        <i class="bi bi-search me-1"></i> 검색
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- 게시글 목록 -->
    <div class="content-card mb-4">
        <div class="table-responsive">
            <table class="table post-table" style="table-layout: fixed; width: 100%;">
                <thead>
                <tr>
                    <th style="width: 5%;" class="text-center">번호</th>
                    <th style="width: 15%;" class="text-center">카테고리</th>
                    <th style="width: 25%;" class="ps-4">제목</th>
                    <th style="width: 15%;" class="text-center">작성자</th>
                    <th style="width: 20%;" class="text-center">작성일</th>
                    <th style="width: 10%;" class="text-center">조회수</th>
                    <th style="width: 10%;" class="text-center">추천수</th>
                </tr>
                </thead>
                <tbody id="post-table-body">
                <!-- 게시글 목록이 AJAX로 로드됩니다 -->
                <tr>
                    <td colspan="5" class="text-center py-5 loading-state">
                        <div class="spinner-border text-primary loading-spinner" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mt-3 text-muted">게시글을 불러오는 중입니다...</p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 버튼 영역 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="d-flex align-items-center">
            <span class="text-muted me-2">정렬:</span>
            <div class="btn-group">
                <button type="button" class="btn btn-outline-secondary btn-sm active" id="sort-latest">
                    <i class="bi bi-arrow-down me-1"></i> 최신순
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm" id="sort-views">
                    <i class="bi bi-eye me-1"></i> 조회순
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm" id="sort-likeCount">
                    <i class="bi bi-hand-thumbs-up"></i> 추천순
                </button>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/post/add" class="btn btn-write">
            <i class="bi bi-pencil-square me-1"></i> 글쓰기
        </a>
    </div>

    <!-- 페이지네이션 -->
    <div class="pagination-container" id="pagination">
        <!-- 페이지네이션이 AJAX로 로드됩니다 -->
    </div>

    <!-- 게시판 가이드 -->
    <div class="row mt-5">
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center">
                    <div class="service-icon mx-auto">
                        <i class="bi bi-pencil-square"></i>
                    </div>
                    <h5 class="card-title">게시글 작성</h5>
                    <p class="card-text text-muted">이웃 주민들과 소통하고 싶은 내용이 있으신가요? 자유롭게 글을 작성해 보세요.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center">
                    <div class="service-icon mx-auto">
                        <i class="bi bi-chat-dots"></i>
                    </div>
                    <h5 class="card-title">댓글 참여</h5>
                    <p class="card-text text-muted">다른 주민들의 게시글에 댓글을 남겨 활발한 소통에 참여해보세요.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center">
                    <div class="service-icon mx-auto">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <h5 class="card-title">커뮤니티 규칙</h5>
                    <p class="card-text text-muted">서로 존중하는 마음으로 건전한 커뮤니티 문화를 만들어가요.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

</body>

</html>
