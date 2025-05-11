<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:forEach var="comment" items="${comments}">
  <c:if test="${empty comment.parentId}">
    <div class="comment-item border-top pt-2 mt-1">
      <div class="comment-author fw-bold">${comment.userId}</div>
      <div class="comment-date text-muted small">
        <fmt:formatDate value="${comment.createdAt}" pattern="yyyy. M. d. a h:mm" />
      </div>
      <div class="comment-content mt-2">
        <p>${comment.content}</p>
      </div>

      <div class="d-flex gap-2 mt-2 align-items-center">
        <button class="btn btn-sm btn-outline-primary reply-toggle d-flex align-items-center" data-comment-id="${comment.id}">
          <i class="bi bi-reply me-1"></i> 답글
        </button>
        <button class="btn btn-sm btn-outline-secondary toggle-replies-btn d-flex align-items-center" data-comment-id="${comment.id}">
          <i class="bi bi-chevron-down me-1"></i> 답글 보기
        </button>
      </div>

      <c:if test="${comment.userId == mb.userId || mb.role >= 3}">
        <div class="comment-actions mt-2 d-flex gap-2">
          <button type="button" class="btn btn-sm btn-outline-primary edit-comment-btn" data-id="${comment.id}" data-content="${comment.content}">
            <i class="bi bi-pencil"></i>
          </button>
          <button data-id="${comment.id}" class="btn btn-sm btn-outline-danger deleteComment">
            <i class="bi bi-trash"></i>
          </button>
        </div>
      </c:if>

      <div class="reply-form mt-3" id="replyForm-${comment.id}" style="display: none;">
        <input type="hidden" name="refType" value="${refType}" />
        <input type="hidden" name="refId" value="${refId}" />
        <textarea class="form-control mb-2 reply-content" name="content" rows="2" placeholder="답글을 입력하세요"></textarea>
        <div class="text-end">
          <button class="btn btn-sm btn-primary submit-reply" data-parent-id="${comment.id}">
            <i class="bi bi-send me-1"></i> 등록
          </button>
        </div>
      </div>

      <div class="reply-container" id="replies-${comment.id}" style="display: none;">
        <c:forEach var="reply" items="${comments}">
          <c:if test="${reply.parentId eq comment.id}">
            <div class="reply-item ps-3 pt-2">
              <div class="comment-author fw-bold">${reply.userId}</div>
              <div class="comment-date text-muted small">
                <fmt:formatDate value="${reply.createdAt}" pattern="yyyy. M. d. a h:mm" />
              </div>
              <div class="comment-content mt-2">
                <p>${reply.content}</p>
              </div>

              <c:if test="${reply.userId == mb.userId || mb.role >= 3}">
                <div class="comment-actions mt-2 d-flex gap-2">
                  <button type="button" class="btn btn-sm btn-outline-primary edit-comment-btn" data-id="${reply.id}" data-content="${reply.content}">
                    <i class="bi bi-pencil"></i>
                  </button>
                  <button data-id="${reply.id}" class="btn btn-sm btn-outline-danger deleteComment">
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