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
            display: flex;
            align-items: center;
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
        .content-card {
            background-color: white;
            border-radius: 0.5rem;
            padding: 2rem;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.125);
        }

        /* 테이블 스타일 */
        .vote-table {
            margin-bottom: 0;
        }

        .vote-table th {
            background-color: #e7f1ff;
            color: #0d6efd;
            border-bottom: 2px solid #0d6efd;
            font-weight: 600;
            padding: 0.75rem 1rem;
        }

        .vote-table td {
            padding: 1rem;
            vertical-align: middle;
        }

        .vote-table tr:hover {
            background-color: #f8f9fa;
        }

        .vote-link {
            text-decoration: none;
            color: #0d6efd;
            font-weight: 500;
            display: flex;
            align-items: center;
            transition: color 0.2s ease;
        }

        .vote-link:hover {
            color: #0a58ca;
            text-decoration: underline;
        }

        /* 상태 배지 */
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 500;
            margin-left: 0.75rem;
        }

        .status-active {
            background-color: #d1e7dd;
            color: #0f5132;
        }

        .status-closed {
            background-color: #f8d7da;
            color: #842029;
        }

        /* 버튼 스타일 */
        .btn-create {
            background-color: #0d6efd;
            color: white;
            border: none;
            padding: 0.5rem 1.25rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn-create:hover {
            background-color: #0a58ca;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* 빈 상태 스타일 */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
        }

        .empty-icon {
            font-size: 3rem;
            color: #dee2e6;
            margin-bottom: 1rem;
        }

        /* 페이지네이션 스타일 */
        .pagination {
            margin-top: 1.5rem;
            justify-content: center;
        }

        .page-link {
            color: #0d6efd;
            border-radius: 0.25rem;
            margin: 0 0.25rem;
        }

        .page-item.active .page-link {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }

        /* 필터 스타일 */
        .filter-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .filter-dropdown {
            min-width: 150px;
        }

        /* 반응형 스타일 */
        @media (max-width: 768px) {
            .filter-section {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-dropdown {
                width: 100%;
            }

            .vote-table th:nth-child(3),
            .vote-table td:nth-child(3) {
                display: none;
            }
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
                <a class="btn btn-create" href="/AptCommunity/vote/add">
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
                                    <a class="vote-link" href="/AptCommunity/vote/detail?voteId=${vote.voteId}">
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
                    <a href="/AptCommunity/vote/add" class="btn btn-primary">
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

<style>
    /* 서비스 아이콘 스타일 (home.jsp에서 가져옴) */
    .service-icon {
        width: 48px;
        height: 48px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #e7f1ff;
        color: #0d6efd;
        border-radius: 0.5rem;
        margin: 0 auto 0.5rem;
        font-size: 1.5rem;
    }
</style>
</body>
</html>
