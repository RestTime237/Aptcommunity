<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - 아파트 커뮤니티</title>

    <!-- Bootstrap & jQuery -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 1. 아임포트 스크립트 불러오기 -->
    <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product/productDetail.css"/>

    <script src="${pageContext.request.contextPath}/resources/js/product/productDetail.js" defer></script>


</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <!-- 페이지 타이틀 -->
    <div class="page-title">
        <i class="bi bi-shop me-2 text-primary"></i>
        <div>
            <h2 class="mb-0">상품 상세</h2>
            <p class="text-muted mb-0">이웃 주민이 판매하는 상품 정보를 확인하세요.</p>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <!-- 상품 정보 카드 -->
            <div class="content-card">
                <div class="product-info">
                    <!-- 상품 상태 배지 -->
                    <c:choose>
                        <c:when test="${product.status == '새상품'}">
                                <span class="product-status status-new">
                                    <i class="bi bi-box-seam me-1"></i> 새상품
                                </span>
                        </c:when>
                        <c:when test="${product.status == '중고'}">
                                <span class="product-status status-used">
                                    <i class="bi bi-recycle me-1"></i> 중고
                                </span>
                        </c:when>
                        <c:when test="${product.status == '나눔'}">
                                <span class="product-status status-free">
                                    <i class="bi bi-gift me-1"></i> 나눔
                                </span>
                        </c:when>
                        <c:otherwise>
                                <span class="product-status status-used">
                                        ${product.status}
                                </span>
                        </c:otherwise>
                    </c:choose>

                    <!-- 상품명 -->
                    <h1 class="product-title">${product.name}</h1>

                    <!-- 가격 -->
                    <div class="product-price">
                        <fmt:formatNumber value="${product.price}" type="number" pattern="#,###"/>원
                    </div>

                    <!-- 판매자 정보 -->
                    <div class="seller-info">
                        <div class="seller-avatar">
                            <i class="bi bi-person"></i>
                        </div>
                        <div>
                            <div class="seller-name">${product.userId}</div>
                            <div class="seller-rating">
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-half"></i>
                            </div>
                        </div>
                    </div>

                    <!-- 상품 메타 정보 -->
                    <div class="product-meta">
                        <div class="product-meta-item">
                            <i class="bi bi-calendar3"></i>
                            등록일: <fmt:formatDate value="${product.createdAt}" pattern="yyyy년 MM월 dd일"/>
                        </div>
                        <div class="product-meta-item">
                            <i class="bi bi-box"></i>
                            수량: ${product.quantity}개
                        </div>
                        <div class="product-meta-item">
                            <i class="bi bi-eye"></i>
                            조회수: ${product.views}회
                        </div>
                    </div>

                    <!-- 버튼 영역 -->
                    <div class="d-flex flex-wrap gap-2 mb-4">

                        <input type="hidden" id="productId" value="${product.id}"/>

                        <!-- 찜 버튼 -->
                        <button id="wishlistBtn" class="btn btn-wishlist ${isWishlisted ? 'active' : ''}"
                                data-product-id="${product.id}">
                            <i class="bi ${isWishlisted ? 'bi-heart-fill' : 'bi-heart'}"></i>
                            <span>${isWishlisted ? '찜 취소' : '찜하기'}</span>
                        </button>

                        <!-- 채팅 버튼 -->
                        <button class="btn btn-primary" id="chat" data-opponent="${product.userId}">
                            <i class="bi bi-chat-dots me-1"></i> 채팅하기
                        </button>

                        <!-- 관리 버튼 (작성자 또는 관리자만 표시) -->
                        <c:if test="${product.userId == mb.userId || mb.role >= 3}">
                            <a href="${pageContext.request.contextPath}/product/update?id=${product.id}" class="btn btn-outline-primary">
                                <i class="bi bi-pencil me-1"></i> 수정
                            </a>
                            <button id="deleteProduct" class="btn btn-outline-danger">
                                <i class="bi bi-trash me-1"></i> 삭제
                            </button>
                        </c:if>
                    </div>

                    <!-- 상품 설명 (Summernote 내용) -->
                    <div class="product-description">
                        ${product.description}
                    </div>

                    <!-- 목록으로 버튼 -->
                    <div class="mt-4 text-center">
                        <a href="${pageContext.request.contextPath}/product/list" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i> 목록으로
                        </a>
                    </div>
                </div>
            </div>

            <!-- 댓글 섹션 -->
            <div class="comment-section">
                <div class="content-card">
                    <!-- 댓글 헤더 -->
                    <div class="product-info">
                        <div class="comment-header">
                            <i class="bi bi-chat-square-text"></i>
                            <h3>댓글</h3>
                        </div>

                        <!-- 댓글 작성 폼 -->
                        <div class="comment-form">
                            <form id="commentForm" method="post" action="${pageContext.request.contextPath}/comment/add">
                                <input type="hidden" name="refType" value="product">
                                <input type="hidden" name="refId" value="${product.id}"/>
                                <div class="form-group mb-3">
                                    <textarea name="content" id="commentContent" class="form-control" rows="3"
                                              placeholder="댓글을 입력하세요"></textarea>
                                </div>
                                <div class="text-end">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-send me-1"></i> 댓글 등록
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- 댓글 목록 -->
                        <div class="comment-list" id="commentList">
                            <c:forEach var="comment" items="${comments}">
                                <c:if test="${empty comment.parentId}">
                                    <div class="comment-item animate-fade-in">
                                        <!-- 댓글 작성자 및 날짜 -->
                                        <div class="comment-author">
                                            <i class="bi bi-person-circle"></i>
                                                ${comment.userId}
                                        </div>
                                        <div class="comment-date">
                                            <fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                        </div>

                                        <!-- 댓글 내용 -->
                                        <div class="comment-content">
                                            <p>${comment.content}</p>
                                        </div>

                                        <!-- 댓글 액션 버튼 -->
                                        <div class="d-flex gap-2 btn-group-sm">
                                            <button class="btn btn-sm btn-outline-primary reply-toggle"
                                                    data-comment-id="${comment.id}">
                                                <i class="bi bi-reply me-1"></i> 답글
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary toggle-replies-btn"
                                                    data-comment-id="${comment.id}">
                                                <i class="bi bi-chevron-down me-1"></i> 답글 보기
                                            </button>
                                        </div>

                                        <!-- 댓글 수정/삭제 버튼 (작성자 또는 관리자만 표시) -->
                                        <c:if test="${comment.userId == mb.userId || mb.role >= 3}">
                                            <div class="comment-actions btn-group-sm">
                                                <button type="button"
                                                        class="btn btn-sm btn-outline-primary edit-comment-btn"
                                                        data-id="${comment.id}" data-content="${comment.content}">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button data-id="${comment.id}"
                                                        class="btn btn-sm btn-outline-danger deleteComment">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </c:if>

                                        <!-- 답글 작성 폼 -->
                                        <div class="reply-form mt-3" id="replyForm-${comment.id}"
                                             style="display: none;">
                                            <input type="hidden" name="refId" value="${product.id}"/>
                                            <input type="hidden" name="refType" value="product"/>
                                            <input type="hidden" name="userId" value="${mb.userId}"/>
                                            <textarea class="form-control mb-2 reply-content" name="content" rows="2"
                                                      placeholder="답글을 입력하세요"></textarea>
                                            <div class="text-end">
                                                <button class="btn btn-sm btn-primary submit-reply"
                                                        data-parent-id="${comment.id}">
                                                    <i class="bi bi-send me-1"></i> 등록
                                                </button>
                                            </div>
                                        </div>

                                        <!-- 답글 목록 -->
                                        <div class="reply-container" id="replies-${comment.id}" style="display: none;">
                                            <c:forEach var="reply" items="${comments}">
                                                <c:if test="${reply.parentId eq comment.id}">
                                                    <div class="reply-item animate-fade-in">
                                                        <!-- 답글 작성자 및 날짜 -->
                                                        <div class="comment-author">
                                                            <i class="bi bi-person-circle"></i>
                                                                ${reply.userId}
                                                        </div>
                                                        <div class="comment-date">
                                                            <fmt:formatDate value="${reply.createdAt}"
                                                                            pattern="yyyy-MM-dd HH:mm"/>
                                                        </div>

                                                        <!-- 답글 내용 -->
                                                        <div class="comment-content">
                                                            <p>${reply.content}</p>
                                                        </div>

                                                        <!-- 답글 수정/삭제 버튼 (작성자 또는 관리자만 표시) -->
                                                        <c:if test="${reply.userId == mb.userId || mb.role >= 3}">
                                                            <div class="comment-actions btn-group-sm">
                                                                <button type="button" id="replyEditBtn"
                                                                        class="btn btn-sm btn-outline-primary"
                                                                        data-id="${reply.id}" data-ref-type="product"
                                                                        data-ref-id="${product.id}">
                                                                    <i class="bi bi-pencil"></i>
                                                                </button>
                                                                <button type="button" id="replyDeleteBtn"
                                                                        class="btn btn-sm btn-outline-danger"
                                                                        data-id="${reply.id}" data-ref-type="product"
                                                                        data-ref-id="${product.id}">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>

                            <!-- 댓글이 없을 경우 -->
                            <c:if test="${empty comments}">
                                <div class="text-center py-5 text-muted">
                                    <i class="bi bi-chat-square-text fs-1 mb-3"></i>
                                    <p>첫 번째 댓글을 남겨보세요!</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- 판매자 다른 상품 -->
            <div class="content-card mb-4">
                <div class="product-info">
                    <h5 class="mb-3"><i class="bi bi-person-square me-2 text-primary"></i>판매자의 다른 상품</h5>

                    <div class="list-group">
                        <c:forEach var="p" items="${otherProducts}">
                            <a href="${pageContext.request.contextPath}/product/detail?id=${p.id}"
                               class="list-group-item list-group-item-action d-flex align-items-center gap-3 py-3">

                                <div class="flex-shrink-0"
                                     style="width: 60px; height: 60px; overflow: hidden; border-radius: 0.25rem;">
                                    <c:choose>
                                        <c:when test="${not empty p.image}">
                                            <img src="${p.image}?height=60&width=60" alt="${p.name}"
                                                 class="w-100 h-100 object-fit-cover"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/uploads/default-image.png" alt="${p.name}"
                                                 class="w-100 h-100 object-fit-cover"/>
                                        </c:otherwise>
                                    </c:choose>

                                </div>

                                <div class="flex-grow-1">
                                    <h6 class="mb-1">${p.name}</h6>
                                    <p class="mb-0 text-primary fw-medium">
                                        <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>원
                                    </p>
                                </div>

                            </a>
                        </c:forEach>
                    </div>

                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/product/list?userId=${product.userId}"
                           class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-grid me-1"></i> 판매자의 모든 상품 보기
                        </a>
                    </div>
                </div>
            </div>

            <!-- 안전거래 안내 -->
            <div class="content-card mb-4">
                <div class="product-info">
                    <h5 class="mb-3"><i class="bi bi-shield-check me-2 text-primary"></i>안전거래 안내</h5>

                    <div class="alert alert-warning mb-3">
                        <div class="d-flex">
                            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                            <div>
                                <p class="mb-1 fw-medium">직거래 시 주의사항</p>
                                <p class="mb-0 small">아파트 내 공용장소에서 거래하시고, 가급적 밝은 시간대에 거래하세요.</p>
                            </div>
                        </div>
                    </div>

                    <ul class="list-group list-group-flush mb-0">
                        <li class="list-group-item px-0 d-flex">
                            <i class="bi bi-check-circle-fill text-primary me-2 mt-1"></i>
                            <span>상품을 직접 확인한 후 현금 거래하세요.</span>
                        </li>
                        <li class="list-group-item px-0 d-flex">
                            <i class="bi bi-check-circle-fill text-primary me-2 mt-1"></i>
                            <span>고가의 상품은 공인된 감정서나 보증서를 확인하세요.</span>
                        </li>
                        <li class="list-group-item px-0 d-flex">
                            <i class="bi bi-check-circle-fill text-primary me-2 mt-1"></i>
                            <span>개인정보 및 계좌번호 공유에 주의하세요.</span>
                        </li>
                        <li class="list-group-item px-0 d-flex">
                            <i class="bi bi-check-circle-fill text-primary me-2 mt-1"></i>
                            <span>불법 상품 거래는 법적 처벌을 받을 수 있습니다.</span>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- 신고하기 -->
            <div class="content-card">
                <div class="product-info">
                    <h5 class="mb-3"><i class="bi bi-flag me-2 text-primary"></i>신고하기</h5>

                    <p class="text-muted small mb-3">아래와 같은 경우 신고해 주세요:</p>
                    <ul class="text-muted small mb-3">
                        <li>불법 또는 허위 상품</li>
                        <li>광고성 콘텐츠</li>
                        <li>욕설 및 비방</li>
                        <li>개인정보 노출</li>
                    </ul>

                    <button class="btn btn-outline-danger w-100" data-bs-toggle="modal" data-bs-target="#reportModal">
                        <i class="bi bi-exclamation-octagon me-1"></i> 신고하기
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 관련 상품 -->
    <div class="related-products mt-5">
        <h4 class="mb-4"><i class="bi bi-grid me-2 text-primary"></i>관련 상품</h4>

        <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-4">
            <c:forEach var="p" items="${relatedProducts}">
                <div class="col">
                    <a href="${pageContext.request.contextPath}/product/detail?id=${p.id}" class="text-decoration-none text-dark">
                        <div class="card related-product-card h-100">
                            <div class="related-product-img">
                                <c:choose>
                                    <c:when test="${not empty p.image}">
                                        <img src="${p.image}?height=160&width=240" alt="${p.name}"
                                             class="w-100 object-fit-cover"/>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/uploads/default-image.png" alt="${p.name}"
                                             class="w-100 object-fit-cover"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="related-product-info">
                                <h6 class="related-product-title text-truncate">${p.name}</h6>
                                <p class="related-product-price mb-0 text-primary fw-medium">
                                    <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>원
                                </p>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

</div>

<!-- 신고 모달 -->
<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="reportModalLabel">상품 신고하기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="reportForm">
                    <input type="hidden" name="productId" value="${product.id}">

                    <div class="mb-3">
                        <label for="reportReason" class="form-label">신고 사유</label>
                        <select class="form-select" id="reportReason" name="reason" required>
                            <option value="" selected disabled>신고 사유를 선택하세요</option>
                            <option value="불법상품">불법 또는 허위 상품</option>
                            <option value="광고성콘텐츠">광고성 콘텐츠</option>
                            <option value="욕설비방">욕설 및 비방</option>
                            <option value="개인정보노출">개인정보 노출</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="reportDetail" class="form-label">상세 내용</label>
                        <textarea class="form-control" id="reportDetail" name="detail" rows="4"
                                  placeholder="신고 내용을 자세히 적어주세요" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger" id="submitReport">신고하기</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

</body>
</html>
