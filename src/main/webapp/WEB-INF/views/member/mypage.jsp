<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 아파트 커뮤니티</title>

    <!-- Bootstrap & jQuery -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css//member/mypage.css"/>

    <script src="${pageContext.request.contextPath}/resources/js/member/mypage.js"></script>

</head>

<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <!-- 페이지 타이틀 -->
    <div class="page-title">
        <h2 class="d-flex align-items-center">
            <i class="bi bi-person-circle me-2 text-primary"></i>
            마이페이지
        </h2>
        <p class="text-muted">내 활동 내역과 정보를 확인하세요.</p>
    </div>

    <!-- 프로필 및 통계 영역 -->
    <div class="row mb-4">
        <!-- 프로필 카드 -->
        <div class="col-lg-4 mb-4">
            <div class="profile-card text-center">
                <div id="profileImageArea" class="position-relative d-inline-block profile-img-wrapper"
                     style="cursor: pointer;">
                    <img src="${pageContext.request.contextPath}/uploads/${empty mb.profileImage ? 'default-profile.png' : mb.profileImage}"
                         id="profileImagePreview" class="profile-image rounded-circle border border-3"
                         style="width: 120px; height: 120px; object-fit: cover; cursor: pointer;"
                         data-bs-toggle="modal" data-bs-target="#profileImageModal">
                    <div class="overlay">
                        <i class="bi bi-plus-lg plus-icon"></i>
                    </div>
                </div>

                <h3 class="profile-name mt-3">${mb.userId}</h3>
                <div class="profile-info">
                    <p class="mb-0">가입일:
                        <fmt:formatDate value="${mb.createdAt}" pattern="yyyy년 MM월 dd일"/>
                    </p>
                </div>

                <a href="${pageContext.request.contextPath}/chat/rooms" class="btn btn-sm btn-primary">
                    <i class="ri-chat-1-line"></i> 내 채팅
                </a>

                <a href="update" class="btn btn-outline-primary profile-edit-btn mt-3">
                    <i class="bi bi-pencil-square me-1"></i> 정보 수정
                </a>
            </div>
        </div>

        <!-- 프로필 이미지 모달 -->
        <div class="modal fade" id="profileImageModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form id="profileImageForm" enctype="multipart/form-data">
                        <div class="modal-header">
                            <h5 class="modal-title">프로필 사진 변경</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body text-center">
                            <input type="file" name="profileImage" accept="image/*" class="form-control mb-3"
                                   required/>
                            <img id="previewProfile"
                                 src="${pageContext.request.contextPath}/uploads/${empty mb.profileImage ? 'default-profile.png' : mb.profileImage}"
                                 class="img-fluid rounded-circle border" style="width: 100px; height: 100px;"/>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">저장</button>
                            <button type="button" class="btn btn-danger" id="deleteProfileImage">삭제</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>


        <!-- 통계 카드 -->
        <div class="col-lg-8">
            <div class="row h-100">
                <div class="col-md-4 mb-4 mb-md-0">
                    <div class="stats-card stats-posts text-center">
                        <div class="stats-icon">
                            <i class="bi bi-file-text"></i>
                        </div>
                        <h4 class="stats-title">작성한 게시글</h4>
                        <div class="stats-count">${postCount}</div>
                        <a href="#posts" id="watchPost" class="btn btn-sm btn-outline-primary mt-3">
                            <i class="bi bi-list-ul me-1"></i> 게시글 보기
                        </a>
                    </div>
                </div>
                <div class="col-md-4 mb-4 mb-md-0">
                    <div class="stats-card stats-products text-center">
                        <div class="stats-icon">
                            <i class="bi bi-box-seam"></i>
                        </div>
                        <h4 class="stats-title">등록한 상품</h4>
                        <div class="stats-count">${productCount}</div>
                        <a href="#products" id="watchProduct" class="btn btn-sm btn-outline-primary mt-3">
                            <i class="bi bi-list-ul me-1"></i> 상품 보기
                        </a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card stats-wishlist text-center">
                        <div class="stats-icon">
                            <i class="bi bi-heart"></i>
                        </div>
                        <h4 class="stats-title">찜한 상품</h4>
                        <div class="stats-count">${wishCount}</div>
                        <a href="#wishlist" id="watchWishlist" class="btn btn-sm btn-outline-primary mt-3">
                            <i class="bi bi-list-ul me-1"></i> 찜 목록 보기
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 탭 메뉴 -->
    <ul class="nav nav-tabs" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="posts-tab" data-bs-toggle="tab" data-bs-target="#posts"
                    type="button" role="tab" aria-controls="posts" aria-selected="true">
                <i class="bi bi-file-text me-1"></i> 내 게시글
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="products-tab" data-bs-toggle="tab" data-bs-target="#products" type="button"
                    role="tab" aria-controls="products" aria-selected="false">
                <i class="bi bi-box-seam me-1"></i> 내 상품
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="wishlist-tab" data-bs-toggle="tab" data-bs-target="#wishlist" type="button"
                    role="tab" aria-controls="wishlist" aria-selected="false">
                <i class="bi bi-heart me-1"></i> 찜 목록
            </button>
        </li>
    </ul>

    <!-- 탭 내용 -->
    <div class="tab-content" id="myTabContent">
        <!-- 내가 쓴 게시글 탭 -->
        <div class="tab-pane fade show active" id="posts" role="tabpanel" aria-labelledby="posts-tab">
            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="section-title mb-0">
                        <i class="bi bi-file-text"></i> 내가 작성한 게시글
                    </h3>
                    <a href="${pageContext.request.contextPath}/post/add" class="btn btn-sm btn-primary">
                        <i class="bi bi-plus-lg me-1"></i> 새 글 작성
                    </a>
                </div>

                <c:if test="${empty myPosts}">
                    <div class="empty-state">
                        <i class="bi bi-file-earmark-text empty-state-icon"></i>
                        <p class="empty-state-text">작성한 게시글이 없습니다.</p>
                        <a href="${pageContext.request.contextPath}/post/add" class="btn btn-primary">
                            <i class="bi bi-pencil-square me-1"></i> 첫 게시글 작성하기
                        </a>
                    </div>
                </c:if>

                <c:if test="${not empty myPosts}">
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                            <tr>
                                <th style="width: 50%">제목</th>
                                <th style="width: 20%">카테고리</th>
                                <th style="width: 20%">작성일</th>
                                <th style="width: 10%">보기</th>
                            </tr>
                            </thead>
                            <tbody id="myPostsContainer">
                            <c:forEach var="post" items="${myPosts}">
                                <tr>
                                    <td>
                                        <div class="fw-medium text-truncate" style="max-width: 300px;">
                                                ${post.title}
                                        </div>
                                    </td>
                                    <td>
                                        <c:if test="${post.category == '공지'}">
                                            <span class="badge bg-warning text-dark">공지</span>
                                        </c:if>
                                        <c:if test="${post.category != '공지'}">
                                            ${post.category}
                                        </c:if>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd"/>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/post/detail?id=${post.id}"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <div id="postPagination" class="mt-3"></div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- 내가 등록한 상품 탭 -->
        <div class="tab-pane fade" id="products" role="tabpanel" aria-labelledby="products-tab">
            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="section-title mb-0">
                        <i class="bi bi-box-seam"></i> 내가 등록한 상품
                    </h3>
                    <a href="${pageContext.request.contextPath}/product/add" class="btn btn-sm btn-primary">
                        <i class="bi bi-plus-lg me-1"></i> 상품 등록
                    </a>
                </div>

                <c:if test="${empty myProducts}">
                    <div class="empty-state">
                        <i class="bi bi-box2 empty-state-icon"></i>
                        <p class="empty-state-text">등록한 상품이 없습니다.</p>
                        <a href="${pageContext.request.contextPath}/product/add" class="btn btn-primary">
                            <i class="bi bi-plus-lg me-1"></i> 상품 등록하기
                        </a>
                    </div>
                </c:if>

                <c:if test="${not empty myProducts}">
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                            <tr>
                                <th style="width: 40%">상품명</th>
                                <th style="width: 20%">가격</th>
                                <th style="width: 20%">상태</th>
                                <th style="width: 20%">관리</th>
                            </tr>
                            </thead>
                            <tbody id="myProductsContainer">
                            <c:forEach var="product" items="${myProducts}">
                                <tr>
                                    <td>
                                        <div class="fw-medium text-truncate" style="max-width: 250px;">
                                                ${product.name}
                                        </div>
                                    </td>
                                    <td>
                                                <span class="fw-medium">
                                                    <fmt:formatNumber value="${product.price}" type="number"
                                                                      pattern="#,###"/>원
                                                </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.status == '판매중'}">
                                                <span class="status-badge status-available">판매중</span>
                                            </c:when>
                                            <c:when test="${product.status == '예약중'}">
                                                <span class="status-badge status-reserved">예약중</span>
                                            </c:when>
                                            <c:when test="${product.status == '판매완료'}">
                                                <span class="status-badge status-sold">판매완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${product.status}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}"
                                               class="btn btn-outline-primary">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/product/update?id=${product.id}"
                                               class="btn btn-outline-primary">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <div id="productPagination" class="mt-3"></div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- 찜한 상품 탭 -->
        <div class="tab-pane fade" id="wishlist" role="tabpanel" aria-labelledby="wishlist-tab">
            <div class="content-card">
                <h3 class="section-title">
                    <i class="bi bi-heart"></i> 찜한 상품
                </h3>

                <!-- 빈 상태 -->
                <div id="wishlistEmpty" class="empty-state d-none">
                    <i class="bi bi-heart empty-state-icon"></i>
                    <p class="empty-state-text">찜한 상품이 없습니다.</p>
                    <a href="${pageContext.request.contextPath}/product/list" class="btn btn-primary">
                        <i class="bi bi-shop me-1"></i> 상품 둘러보기
                    </a>
                </div>

                <!-- 상품 리스트 -->
                <div class="row" id="myWishlistContainer"></div>

                <!-- 페이지네이션 -->
                <div id="wishlistPagination" class="mt-3"></div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/resources/js/mypage.js" defer></script>
</body>

</html>
