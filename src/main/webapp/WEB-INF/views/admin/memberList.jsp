<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 | 아파트 커뮤니티</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
          rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- css -->
    <link rel="stylesheet" href="/AptCommunity/resources/css/admin/memberList.css">

    <!-- js -->
    <script src="/AptCommunity/resources/js/admin/memberList.js" defer></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="admin-container">
    <!-- 대시보드 헤더 -->
    <div class="dashboard-header">
        <div class="dashboard-header-content">
            <h1 class="dashboard-title">회원 관리</h1>
            <p class="dashboard-subtitle">전체 회원 목록을 관리하고 조회할 수 있습니다.</p>
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
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon members">
                    <i class="bi bi-people"></i>
                </div>
                <div class="stat-value">${totalCount}</div>
                <div class="stat-label">전체 회원</div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon admins">
                    <i class="bi bi-shield-lock"></i>
                </div>
                <div class="stat-value">${adminCount}</div>
                <div class="stat-label">관리자</div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon members">
                    <i class="bi bi-person-plus"></i>
                </div>
                <div class="stat-value">${recentCount}</div>
                <div class="stat-label">이번 달 신규 가입</div>
            </div>
        </div>
    </div>

    <!-- 검색 및 필터 -->
    <div class="table-container">
        <div class="search-container">
            <div class="search-input">
                <i class="bi bi-search"></i>
                <input type="text" id="searchInput" placeholder="이름, 아이디, 닉네임으로 검색..." class="form-control">
            </div>
            <select class="filter-select form-select" id="roleFilter">
                <option value="all">전체 회원</option>
                <option value="admin">관리자</option>
                <option value="regular">일반 회원</option>
            </select>
            <select class="filter-select form-select" id="sortFilter">
                <option value="newest">최신순</option>
                <option value="oldest">오래된순</option>
                <option value="name">이름순</option>
            </select>
        </div>

        <!-- 회원 테이블 -->
        <table class="admin-table">
            <thead>
            <tr>
                <th>회원 정보</th>
                <th>아이디</th>
                <th>주소</th>
                <th>동</th>
                <th>권한</th>
                <th>가입일</th>
                <th>관리</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="member" items="${members}">
                <tr>
                    <td>
                        <div class="member-info">
                            <div class="member-avatar">
                                    ${fn:substring(member.username, 0, 1)}
                            </div>
                            <div>
                                <div class="member-name">${member.username}</div>
                                <div class="member-id">${member.nickname}</div>
                            </div>
                        </div>
                    </td>
                    <td>${member.userId}</td>
                    <td>${member.roadAddress}</td>
                    <td>${member.dong}</td>
                    <td>
                        <c:choose>
                            <c:when test="${member.role == 3}">
                                <span class="badge-role badge-admin">관리자</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-role badge-regular">일반</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><fmt:formatDate value="${member.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn btn-icon btn-outline-primary" onclick="viewMember('${member.userId}')">
                                <i class="bi bi-eye"></i>
                            </button>
                            <button class="btn btn-icon btn-outline-secondary"
                                    onclick="loadEditModal('${member.userId}')">
                                <i class="bi bi-pencil"></i>
                            </button>
                            <button class="btn btn-icon btn-outline-danger" onclick="deleteMember('${member.userId}')">
                                <i class="bi bi-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- 페이지네이션만 깔끔하게 중앙 정렬 -->
        <div class="d-flex justify-content-center mt-4">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center mb-0">
                    <!-- 이전 -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="/AptCommunity/admin/members?page=${currentPage - 1}"
                           aria-label="Previous">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>

                    <!-- 숫자 페이지 -->
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="/AptCommunity/admin/members?page=${i}">${i}</a>
                        </li>
                    </c:forEach>

                    <!-- 다음 -->
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="/AptCommunity/admin/members?page=${currentPage + 1}"
                           aria-label="Next">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>


    </div>
</div>
</div>

<!-- 회원 상세 정보 모달 -->
<div class="modal fade" id="memberDetailModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">회원 상세 정보</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="member-detail-info">
                    <dl>
                        <dt>이름</dt>
                        <dd id="detailUsername"></dd>
                        <dt>아이디</dt>
                        <dd id="detailUserId"></dd>
                        <dt>닉네임</dt>
                        <dd id="detailNickname"></dd>
                        <dt>주소</dt>
                        <dd id="detailAddress"></dd>
                        <dt>가입일</dt>
                        <dd id="detailCreatedAt"></dd>
                    </dl>
                </div>
                <div class="d-flex justify-content-end">
                    <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">닫기</button>
                    <button type="button" class="btn btn-primary" onclick="openEditModal()">수정</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 회원 정보 수정 모달 -->
<div class="modal fade" id="memberEditModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">회원 정보 수정</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="memberEditForm">
                    <input type="hidden" id="editUserId" name="userId">
                    <div class="mb-3">
                        <label for="editUsername" class="form-label">이름</label>
                        <input type="text" class="form-control" id="editUsername" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label for="editNickname" class="form-label">닉네임</label>
                        <input type="text" class="form-control" id="editNickname" name="nickname" required>
                    </div>
                    <div class="mb-3">
                        <label for="editAddress" class="form-label">주소</label>
                        <input type="text" class="form-control" id="editAddress" name="address">
                    </div>
                    <div class="mb-3">
                        <label for="editRole" class="form-label">권한</label>
                        <select class="form-select" id="editRole" name="role">
                            <option value="1">일반 회원</option>
                            <option value="3">관리자</option>
                        </select>
                    </div>
                    <div class="d-flex justify-content-between">
                        <button type="button" class="btn btn-delete" onclick="confirmDelete()">
                            회원 삭제
                        </button>
                        <div>
                            <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">취소</button>
                            <button type="submit" class="btn btn-primary">저장</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- 삭제 확인 모달 -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">회원 삭제 확인</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>정말로 이 회원을 삭제하시겠습니까?</p>
                <p class="text-danger">이 작업은 되돌릴 수 없습니다.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger" onclick="confirmDelete()">삭제</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

</body>
</html>
