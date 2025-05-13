<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 상세보기 - 아파트 커뮤니티</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="/AptCommunity/resources/css/post/postDetail.css"/>

    <script src="/AptCommunity/resources/js/post/postDetail.js" defer></script>

</head>

<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <!-- 페이지 타이틀 -->
    <div class="page-title">
        <h2 class="d-flex align-items-center">
            <i class="bi bi-file-text me-2 text-primary"></i>
            게시글 상세보기
        </h2>
        <p class="text-muted">커뮤니티 게시판의 게시글 내용입니다.</p>
    </div>

    <!-- 게시글 내용 -->
    <div class="content-card">
        <!-- 게시글 헤더 -->
        <div class="post-header">
            <div class="d-flex align-items-center mb-2">
                <c:if test="${post.category == '공지'}">
                    <span class="notice-badge"><i class="bi bi-megaphone-fill"></i> 공지</span>
                </c:if>
                <h1 class="post-title mb-0">${post.title}</h1>
            </div>
            <div class="post-info">
                <div class="post-info-item">
                    <i class="bi bi-person-circle post-info-icon"></i>
                    <span>${nickname}</span>
                </div>
                <div class="post-info-item">
                    <i class="bi bi-calendar3 post-info-icon"></i>
                    <span>
                            <fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                        </span>
                </div>
                <div class="post-info-item">
                    <i class="bi bi-tag post-info-icon"></i>
                    <span>${post.category}</span>
                </div>
                <div class="post-info-item">
                    <i class="bi bi-eye post-info-icon"></i>
                    <span>${post.views}</span>
                </div>
            </div>
        </div>

        <!-- 게시글 내용 -->
        <div class="post-content">
            <!-- 첨부 이미지 -->
            <c:if test="${not empty images}">
                <div class="image-gallery mb-4">
                    <c:forEach var="image" items="${images}" varStatus="status">
                        <div class="image-item" data-bs-toggle="modal" data-bs-target="#imageModal"
                             data-img-src="/AptCommunity/resources/images/${image.fileName}">
                            <img src="/AptCommunity/resources/images/${image.fileName}" class="img-fluid"
                                 style="width: 200px; height: 150px; object-fit: cover;"
                                 alt="첨부 이미지 ${status.index + 1}"/>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- 본문 내용 -->
            <div class="mb-4">
                ${post.content}
            </div>

            <!-- 버튼 영역 -->
            <div class="d-flex justify-content-between align-items-center mt-5">

                <input type="hidden" id="postId" value="${post.id}"/>

                <!-- 왼쪽 여백: 목록 버튼 -->
                <div style="min-width: 150px;">
                    <a href="/AptCommunity/post/list" class="btn btn-primary-soft">
                        <i class="bi bi-arrow-left me-1"></i> 목록으로
                    </a>
                </div>

                <!-- 가운데: 추천 버튼 -->
                <div class="text-center flex-grow-1">
                    <button class="btn btn-primary-soft me-2" onclick="toggleRecommend('post', ${post.id})"> 추천
                        ${post.likeCount}</button>
                </div>

                <!-- 오른쪽 여백: 수정/삭제 버튼 or 공백 -->
                <div style="min-width: 150px;" class="text-end">
                    <c:if test="${post.userId == mb.userId || mb.role >= 3}">
                        <div class="btn-group-sm">
                            <a href="/AptCommunity/post/update?id=${post.id}" class="btn btn-primary-soft me-2">
                                <i class="bi bi-pencil-square me-1"></i> 수정
                            </a>
                            <button type="button" id="deleteButton" class="btn btn-danger-soft">
                                <i class="bi bi-trash me-1"></i> 삭제
                            </button>
                        </div>
                    </c:if>
                </div>
            </div>

        </div>
    </div>

    <!-- 댓글 섹션 -->
    <div class="comments-section">
        <div class="comments-header">
            <i class="bi bi-chat-dots-fill"></i> 댓글 (${comments.size()})
        </div>
        <div class="comments-body">
            <!-- 댓글 작성 폼 -->
            <div class="comment-form">
                <form action="${pageContext.request.contextPath}/comment/add" method="post">
                    <input type="hidden" name="refId" value="${post.id}"/>
                    <input type="hidden" name="refType" value="post"/>
                    <input type="hidden" name="userId" value="${mb.userId}"/>
                    <div class="mb-3">
                        <label for="commentContent" class="form-label fw-medium">댓글 작성</label>
                        <textarea name="content" id="commentContent" class="form-control" rows="3"
                                  placeholder="댓글을 입력하세요"></textarea>
                    </div>
                    <div class="text-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-send me-1"></i> 등록
                        </button>
                    </div>
                </form>
            </div>

            <!-- 댓글 목록 -->
            <c:forEach var="comment" items="${comments}">
                <c:if test="${empty comment.parentId}">
                    <!-- 부모 댓글 -->
                    <div class="comment-item">
                        <div class="comment-header">
                            <div class="comment-author">
                                <i class="bi bi-person-circle me-1"></i> ${comment.userId}
                            </div>
                            <div class="comment-date">
                                <fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                            </div>
                        </div>
                        <div class="comment-content">
                            <p>${comment.content}</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="comment-actions">
                                <button class="btn btn-sm btn-primary-soft reply-toggle"
                                        data-comment-id="${comment.id}">
                                    <i class="bi bi-reply me-1"></i> 답글
                                </button>
                                <button class="btn btn-sm btn-primary-soft toggle-replies-btn"
                                        data-comment-id="${comment.id}" data-reply-count="${comment.replyCount}">
                                    <i class="bi bi-chevron-down me-1"></i> 답글(${comment.replyCount})
                                </button>
                            </div>

                            <c:if test="${comment.userId == mb.userId || mb.role >= 3}">
                                <div class="btn-group-sm">
                                    <button type="button" class="btn btn-sm btn-primary-soft edit-comment-btn me-1"
                                            data-id="${comment.id}" data-content="${comment.content}">
                                        <i class="bi bi-pencil me-1"></i> 수정
                                    </button>
                                    <button type="button" data-id="${comment.id}"
                                            class="btn btn-sm btn-danger-soft deleteComment">
                                        <i class="bi bi-trash me-1"></i> 삭제
                                    </button>
                                </div>
                            </c:if>
                        </div>

                        <!-- 대댓글 입력창 -->
                        <div class="reply-form mt-3" id="replyForm-${comment.id}" style="display: none;">
                            <input type="hidden" name="refId" value="${post.id}"/>
                            <input type="hidden" name="refType" value="post"/>
                            <input type="hidden" name="userId" value="${mb.userId}"/>
                            <textarea class="form-control mb-2 reply-content" name="content" rows="2"
                                      placeholder="답글을 입력하세요"></textarea>
                            <div class="text-end">
                                <button class="btn btn-sm btn-primary submit-reply" data-parent-id="${comment.id}">
                                    <i class="bi bi-send me-1"></i> 등록
                                </button>
                            </div>
                        </div>

                        <!-- 대댓글 목록 -->
                        <div class="reply-container" id="replies-${comment.id}" style="display: none;">
                            <c:forEach var="reply" items="${comments}">
                                <c:if test="${reply.parentId eq comment.id}">
                                    <div class="reply-item">
                                        <div class="comment-header">
                                            <div class="comment-author">
                                                <i class="bi bi-person-circle me-1"></i> ${reply.userId}
                                            </div>
                                            <div class="comment-date">
                                                <fmt:formatDate value="${reply.createdAt}"
                                                                pattern="yyyy-MM-dd HH:mm"/>
                                            </div>
                                        </div>
                                        <div class="comment-content">
                                            <p>${reply.content}</p>
                                        </div>

                                        <c:if test="${reply.userId == mb.userId || mb.role >= 3}">
                                            <div class="text-end">
                                                <button type="button"
                                                        class="btn btn-sm btn-primary-soft edit-reply-btn me-1"
                                                        data-id="${reply.id}" data-content="${reply.content}">
                                                    <i class="bi bi-pencil me-1"></i> 수정
                                                </button>
                                                <button type="button" data-id="${reply.id}"
                                                        class="btn btn-sm btn-danger-soft deleteReply">
                                                    <i class="bi bi-trash me-1"></i> 삭제
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
                <div class="text-center py-5">
                    <i class="bi bi-chat-dots fs-1 text-muted mb-3"></i>
                    <p class="text-muted">아직 댓글이 없습니다. 첫 댓글을 작성해보세요!</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- 이미지 모달 -->
<div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">이미지 보기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <img id="modalImage" src="/placeholder.svg" class="modal-img" alt="확대된 이미지">
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

</body>

</html>
