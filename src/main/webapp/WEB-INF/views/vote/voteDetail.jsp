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

    <style>
        /* 전체 스타일 */
        body {
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            color: #333;
            background-color: #f8f9fa;
        }

        /* 페이지 타이틀 */
        .page-title {
            font-size: 1.75rem;
            font-weight: bold;
            position: relative;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid #e9ecef;
        }

        .page-title::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background-color: #0d6efd;
        }

        /* 카드 스타일 */
        .vote-card {
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.125);
            border-radius: 0.5rem;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }

        .vote-header {
            background-color: #e7f1ff;
            color: #0d6efd;
            border-bottom: 1px solid #dee2e6;
            border-radius: 0.5rem 0.5rem 0 0;
            padding: 1.25rem;
        }

        .vote-info {
            display: flex;
            justify-content: space-between;
            margin-top: 0.5rem;
            font-size: 0.9rem;
            color: #6c757d;
        }

        .vote-status {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-active {
            background-color: #d1e7dd;
            color: #0f5132;
        }

        .status-closed {
            background-color: #f8d7da;
            color: #842029;
        }

        .vote-description {
            padding: 1.5rem;
            border-bottom: 1px solid #dee2e6;
            line-height: 1.6;
        }

        /* 투표 옵션 스타일 */
        .vote-options {
            padding: 1.5rem;
        }

        .option-item {
            margin-bottom: 1rem;
            padding: 1rem;
            border: 1px solid #dee2e6;
            border-radius: 0.5rem;
            transition: all 0.2s ease;
        }

        .option-item:hover {
            background-color: #f8f9fa;
            border-color: #0d6efd;
        }

        .option-item.selected {
            background-color: #e7f1ff;
            border-color: #0d6efd;
        }

        .option-radio {
            margin-right: 0.75rem;
        }

        /* 결과 그래프 스타일 */
        .result-bar-container {
            height: 25px;
            background-color: #e9ecef;
            border-radius: 0.25rem;
            margin-top: 0.5rem;
            overflow: hidden;
        }

        .result-bar {
            height: 100%;
            background-color: #0d6efd;
            border-radius: 0.25rem;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding-right: 0.5rem;
            color: white;
            font-size: 0.8rem;
            font-weight: 500;
            transition: width 0.5s ease;
        }

        /* 버튼 스타일 */
        .vote-actions {
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            border-top: 1px solid #dee2e6;
        }

        /* 참여자 목록 */
        .participants {
            padding: 1.5rem;
            border-top: 1px solid #dee2e6;
        }

        .participant-badge {
            background-color: #e7f1ff;
            color: #0d6efd;
            border-radius: 1rem;
            padding: 0.25rem 0.75rem;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
            display: inline-block;
            font-size: 0.85rem;
        }

        /* 댓글 스타일 */
        .comments-section {
            margin-top: 2rem;
        }

        .comment-item {
            padding: 1rem;
            border-bottom: 1px solid #dee2e6;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }

        .comment-author {
            font-weight: 500;
        }

        .comment-date {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .comment-content {
            line-height: 1.5;
        }

        .comment-form {
            margin-top: 1.5rem;
        }

        footer a {
            color: #333;
            transition: color 0.3s ease;
        }

        footer a:hover {
            color: #0D6EFD !important;
            transition: color 0.3s ease;
        }
    </style>
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
                <form action="/AptCommunity/vote/submit" method="post" class="vote-options">
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
                <a href="/AptCommunity/vote/list" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i>목록으로
                </a>
            </div>

            <c:if test="${userId == vote.creatorId}">
                <div>
                    <a href="/AptCommunity/vote/edit?voteId=${vote.voteId}" class="btn btn-outline-primary me-2">
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
                <form action="/AptCommunity/vote/delete" method="post">
                    <input type="hidden" name="voteId" value="${vote.voteId}"/>
                    <button type="submit" class="btn btn-danger">삭제</button>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 옵션 선택 시 시각적 피드백
        const optionItems = document.querySelectorAll('.option-item');
        const optionRadios = document.querySelectorAll('.option-radio');

        optionRadios.forEach((radio, index) => {
            radio.addEventListener('change', function () {
                optionItems.forEach(item => item.classList.remove('selected'));
                if (this.checked) {
                    optionItems[index].classList.add('selected');
                }
            });
        });
    });
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
