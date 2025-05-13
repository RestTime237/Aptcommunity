<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>투표 목록 - 아파트 커뮤니티</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/vote/voteList.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <div class="page-title">
        <i class="ri-checkbox-circle-line me-2 text-primary"></i>투표 목록
    </div>

    <div class="content-card">
        <div class="filter-section">
            <div class="d-flex align-items-center gap-3">
                <select class="form-select filter-dropdown">
                    <option selected>모든 투표</option>
                    <option>진행 중인 투표</option>
                    <option>마감된 투표</option>
                    <option>내가 참여한 투표</option>
                </select>

                <div class="input-group" style="width: 450px;">
                    <input type="text" class="form-control" placeholder="투표 검색...">
                    <button class="btn btn-outline-primary" type="button">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </div>
            <c:if test="${mb.role >= 3}">
                <a class="btn btn-create" href="${pageContext.request.contextPath}/vote/add">
                    <i class="bi bi-plus-circle me-1"></i> 새 투표 만들기
                </a>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${not empty voteList}">
                <div class="table-responsive">
                    <table class="table vote-table">
                        <thead>
                        <tr>
                            <th style="width: 60%;">제목</th>
                            <th style="width: 20%;">마감일</th>
                            <th style="width: 20%;">작성자</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="vote" items="${voteList}">
                            <tr>
                                <td>
                                    <a class="vote-link" href="${pageContext.request.contextPath}/vote/detail?voteId=${vote.voteId}">
                                        <i class="bi bi-check2-square me-2"></i>
                                            ${vote.title}

                                        <c:choose>
                                            <c:when test="${vote.active}">
                                                <span class="status-badge status-active">진행 중</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-closed">마감됨</span>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:if test="${vote.newVote}">
                                            <span class="badge bg-danger ms-2">NEW</span>
                                        </c:if>
                                    </a>
                                </td>
                                <td>
                                    <i class="bi bi-calendar-event me-1 text-muted"></i>
                                        ${vote.formattedDeadline}
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-person-circle me-2 text-muted"></i>
                                            ${vote.creatorId}
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- 페이지네이션 -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </c:when>
            <c:otherwise>
                <!-- 투표가 없을 때 표시할 내용 -->
                <div class="empty-state">
                    <i class="bi bi-clipboard-check empty-icon"></i>
                    <h4>등록된 투표가 없습니다</h4>
                    <p class="text-muted mb-4">아파트 주민들과 함께 결정할 사항이 있으신가요?<br>새로운 투표를 만들어 의견을 모아보세요!</p>
                    <a href="${pageContext.request.contextPath}/vote/add" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-1"></i> 첫 투표 만들기
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 투표 안내 카드 -->
    <div class="row mt-4">
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <div class="text-center mb-3">
                        <div class="service-icon mx-auto">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                    </div>
                    <h5 class="card-title text-center">투표 만들기</h5>
                    <p class="card-text text-muted">아파트 주민들과 함께 결정할 사항이 있으신가요? 새로운 투표를 만들어 의견을 모아보세요.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <div class="text-center mb-3">
                        <div class="service-icon mx-auto">
                            <i class="bi bi-check2"></i>
                        </div>
                    </div>
                    <h5 class="card-title text-center">투표 참여하기</h5>
                    <p class="card-text text-muted">진행 중인 투표에 참여하여 여러분의 의견을 표현해보세요. 모든 의견이 소중합니다.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <div class="text-center mb-3">
                        <div class="service-icon mx-auto">
                            <i class="bi bi-bar-chart"></i>
                        </div>
                    </div>
                    <h5 class="card-title text-center">결과 확인하기</h5>
                    <p class="card-text text-muted">투표 결과를 실시간으로 확인하고 주민들의 의견 동향을 파악해보세요.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
