<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 목록 - 아파트 커뮤니티</title>

    <!-- Bootstrap & jQuery -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product/productList.css"/>

    <script src="${pageContext.request.contextPath}/resources/js/product/productList.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <!-- 페이지 타이틀 -->
    <div class="page-title">
        <h2 class="d-flex align-items-center">
            <i class="bi bi-shop me-2 text-primary"></i>
            상품 목록
        </h2>
        <p class="text-muted">이웃 주민들이 판매하는 다양한 상품을 확인하세요.</p>
    </div>

    <!-- 필터 영역 -->
    <div class="filter-area">
        <form action="${pageContext.request.contextPath}/product/search" method="get" id="searchForm">
            <div class="row g-3">
                <div class="col-lg-3 col-md-6">
                    <label class="filter-title">
                        <i class="bi bi-tag"></i> 카테고리
                    </label>
                    <select name="category" class="form-select">
                        <option value="">전체 카테고리</option>
                        <option value="전자제품">전자제품</option>
                        <option value="생활용품">생활용품</option>
                        <option value="의류">의류</option>
                        <option value="식품">식품</option>
                        <option value="기타">기타</option>
                    </select>
                </div>

                <div class="col-lg-3 col-md-6">
                    <label class="filter-title">
                        <i class="bi bi-info-circle"></i> 상태
                    </label>
                    <select name="status" class="form-select">
                        <option value="">전체 상태</option>
                        <option value="새상품">새상품</option>
                        <option value="중고">중고</option>
                        <option value="나눔">나눔</option>
                    </select>
                </div>

                <div class="col-lg-6 col-md-12">
                    <label class="filter-title">
                        <i class="bi bi-currency-dollar"></i> 가격 범위
                    </label>
                    <div class="row g-2">
                        <div class="col-6">
                            <div class="input-group">
                                <span class="input-group-text">₩</span>
                                <input type="number" name="minPrice" class="form-control" placeholder="최소가격"
                                       value="${param.minPrice}"/>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="input-group">
                                <span class="input-group-text">₩</span>
                                <input type="number" name="maxPrice" class="form-control" placeholder="최대가격"
                                       value="${param.maxPrice}"/>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-4">
                    <label class="filter-title">
                        <i class="bi bi-search"></i> 검색 조건
                    </label>
                    <select name="choice" class="form-select">
                        <option value="all">전체</option>
                        <option value="titleAndContent">제목+내용</option>
                        <option value="writer">작성자</option>
                    </select>
                </div>

                <div class="col-lg-6 col-md-8">
                    <label class="filter-title">
                        <i class="bi bi-search"></i> 검색어
                    </label>
                    <div class="input-group">
                        <input type="text" name="keyword" class="form-control" placeholder="검색어 입력"
                               value="${param.keyword}"/>
                        <button type="button" id="search" class="btn btn-primary">
                            <i class="bi bi-search me-1"></i> 검색
                        </button>
                    </div>
                </div>

                <div class="col-lg-3 col-md-12 d-flex align-items-end">
                    <a href="add" class="btn btn-primary w-100">
                        <i class="bi bi-plus-lg me-1"></i> 상품 등록하기
                    </a>
                </div>
            </div>
        </form>
    </div>

    <!-- 뷰 전환 및 정렬 옵션 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="view-toggle">
            <button type="button" class="view-toggle-btn active" id="gridViewBtn" title="그리드 보기">
                <i class="bi bi-grid-3x3-gap-fill"></i>
            </button>
            <button type="button" class="view-toggle-btn" id="tableViewBtn" title="테이블 보기">
                <i class="bi bi-list-ul"></i>
            </button>
        </div>

        <div class="d-flex align-items-center">
            <label class="me-2 text-nowrap">정렬:</label>
            <select class="form-select form-select-sm" id="sortOption" style="width: auto;">
                <option value="latest">최신순</option>
                <option value="priceAsc">가격 낮은순</option>
                <option value="priceDesc">가격 높은순</option>
                <option value="popular">인기순</option>
            </select>
        </div>
    </div>

    <!-- 그리드 뷰 (기본) -->
    <div class="grid-view">
        <div class="row" id="product-grid">
            <!-- 상품 카드가 여기에 동적으로 추가됩니다 -->
        </div>
    </div>

    <!-- 테이블 뷰 (토글) -->
    <div class="table-view">
        <div class="table-responsive">
            <table class="custom-table">
                <thead>
                <tr>
                    <th style="width: 5%;">번호</th>
                    <th style="width: 10%;">상태</th>
                    <th style="width: 10%;">카테고리</th>
                    <th style="width: 30%;">상품명</th>
                    <th style="width: 15%;">가격</th>
                    <th style="width: 10%;">수량</th>
                    <th style="width: 10%;">작성자</th>
                    <th style="width: 10%;">작성일</th>
                </tr>
                </thead>
                <tbody id="product-table-body">
                <!-- 상품 행이 여기에 동적으로 추가됩니다 -->
                </tbody>
            </table>
        </div>
    </div>

    <!-- 빈 상태 메시지 -->
    <div id="empty-state" class="empty-state" style="display: none;">
        <i class="bi bi-shop empty-state-icon"></i>
        <h4>상품이 없습니다</h4>
        <p class="empty-state-text">검색 조건을 변경하거나 새로운 상품을 등록해보세요.</p>
        <a href="${pageContext.request.contextPath}/product/add" class="btn btn-primary">
            <i class="bi bi-plus-lg me-1"></i> 상품 등록하기
        </a>
    </div>

    <!-- 페이지네이션 -->
    <div class="pagination-container" id="pagination">
        <!-- 페이지 버튼이 여기에 동적으로 추가됩니다 -->
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>


</body>
</html>
