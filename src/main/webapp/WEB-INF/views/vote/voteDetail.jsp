<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>투표 상세 - 아파트 커뮤니티</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/vote/voteDetail.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <div class="page-title">
        <i class="ri-checkbox-circle-line me-2 text-primary"></i>투표 상세
    </div>

    <div class="vote-card mb-4">
        <div class="vote-header">
            <h2 class="mb-0">${vote.title}</h2>
            <div class="vote-info">
                <div>
                    <span class="me-3"><i class="bi bi-person me-1"></i>${vote.creatorId}</span>
                    <span><i class="bi bi-calendar3 me-1"></i><fmt:formatDate value="${vote.createdAt}"
                                                                              pattern="yyyy-MM-dd HH:mm"/></span>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${vote.active}">
                            <span class="vote-status status-active"><i class="bi bi-check-circle me-1"></i>진행 중</span>
                        </c:when>
                        <c:otherwise>
                            <span class="vote-status status-closed"><i class="bi bi-x-circle me-1"></i>마감됨</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="vote-description">
            <h5 class="mb-3">투표 설명</h5>
            <p>${vote.content}</p>
            <div class="d-flex justify-content-between text-muted mt-3">
                <div><i class="bi bi-people me-1"></i>참여자: <strong>${vote.voteCount}</strong>명</div>
                <div><i class="bi bi-calendar-x me-1"></i>마감일: <strong>${vote.formattedDeadline}</strong></div>
            </div>
        </div>

        <c:choose>
            <c:when test="${!vote.active}">
                <!-- 투표 결과 보기 -->
                <div class="vote-options">
                    <h5 class="mb-3">투표 결과</h5>
                    <c:forEach var="option" items="${vote.voteOptions}" varStatus="status">
                        <div class="option-item mb-3">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <span class="fw-medium">${option.optionText}</span>
                                    <c:if test="${userVotedOption == option.id}">
                                        <span class="ms-2 badge bg-primary">내 선택</span>
                                    </c:if>
                                </div>
                                <div class="text-muted">${option.voteCount}표 (${option.percentage}%)</div>
                            </div>
                            <div class="result-bar-container">
                                <div class="result-bar" style="width: ${option.percentage}%">
                                    <c:if test="${option.percentage > 10}">
                                        ${option.percentage}%
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>

            <c:when test="${alreadyVoted}">
                <div class="alert alert-info mt-3">
                    <i class="bi bi-hourglass-split me-1"></i> 투표에 참여하셨습니다. 결과는 투표 종료 후 공개됩니다.
                </div>
            </c:when>

            <c:otherwise>
                <!-- 투표 참여 폼 -->
                <form action="${pageContext.request.contextPath}/vote/submit" method="post" class="vote-options">
                    <h5 class="mb-3">투표 옵션</h5>
                    <input type="hidden" name="voteId" value="${vote.voteId}"/>

                    <c:forEach var="option" items="${vote.voteOptions}" varStatus="status">
                        <div class="option-item">
                            <div class="form-check">
                                <input class="form-check-input option-radio" type="radio" name="optionId"
                                       id="option${status.index}" value="${option.id}" required>
                                <label class="form-check-label" for="option${status.index}">
                                        ${option.optionText}
                                </label>
                            </div>
                        </div>
                    </c:forEach>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check2-circle me-1"></i>투표하기
                        </button>
                    </div>
                </form>
            </c:otherwise>


        </c:choose>

        <div class="vote-actions">
            <div>
                <a href="${pageContext.request.contextPath}/vote/list" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i>목록으로
                </a>
            </div>

            <c:if test="${userId == vote.creatorId}">
                <div>
                    <a href="${pageContext.request.contextPath}/vote/edit?voteId=${vote.voteId}" class="btn btn-outline-primary me-2">
                        <i class="bi bi-pencil me-1"></i>수정
                    </a>
                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal"
                            data-bs-target="#deleteModal">
                        <i class="bi bi-trash me-1"></i>삭제
                    </button>
                </div>
            </c:if>
        </div>
    </div>
</div>


<!-- 삭제 확인 모달 -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">투표 삭제 확인</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>정말로 이 투표를 삭제하시겠습니까?</p>
                <p class="text-danger"><small>이 작업은 되돌릴 수 없으며, 모든 투표 데이터가 삭제됩니다.</small></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <form action="${pageContext.request.contextPath}/vote/delete" method="post">
                    <input type="hidden" name="voteId" value="${vote.voteId}"/>
                    <button type="submit" class="btn btn-danger">삭제</button>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/vote/voteDetail.js"></script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
