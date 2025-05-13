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

    <style>
        /* 공통 스타일 */
        body {
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            color: #333;
            background-color: #f8f9fa;
        }

        /* 페이지 타이틀 */
        .page-title {
            position: relative;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e9ecef;
        }

        .page-title::after {
            content: "";
            position: absolute;
            bottom: -1px;
            left: 0;
            width: 80px;
            height: 3px;
            background-color: #0d6efd;
        }

        /* 카드 스타일 */
        .content-card {
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            background-color: #fff;
            overflow: hidden;
            margin-bottom: 2rem;
            padding: 1.5rem;
        }

        /* 필터 영역 */
        .filter-area {
            background-color: #f8f9fa;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 1px solid #e9ecef;
        }

        .filter-title {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .filter-title i {
            margin-right: 0.5rem;
            color: #0d6efd;
        }

        /* 상품 카드 */
        .product-card {
            border-radius: 0.5rem;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            height: 100%;
            position: relative;
            border: 1px solid #e9ecef;
            background-color: #fff;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .product-img-container {
            position: relative;
            padding-top: 75%; /* 4:3 비율 */
            overflow: hidden;
            background-color: #f8f9fa;
        }

        .product-img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-img {
            transform: scale(1.05);
        }

        .product-status {
            position: absolute;
            top: 0.75rem;
            left: 0.75rem;
            padding: 0.35rem 0.65rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            z-index: 1;
        }

        .status-new {
            background-color: #d1e7dd;
            color: #0f5132;
        }

        .status-used {
            background-color: #fff3cd;
            color: #664d03;
        }

        .status-free {
            background-color: #cfe2ff;
            color: #084298;
        }

        .product-wishlist {
            position: absolute;
            top: 0.75rem;
            right: 0.75rem;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 1;
            transition: all 0.2s;
        }

        .product-wishlist:hover {
            background-color: #fff;
            transform: scale(1.1);
        }

        .product-wishlist i {
            color: #dc3545;
            font-size: 1rem;
        }

        .product-info {
            padding: 1rem;
        }

        .product-category {
            font-size: 0.75rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
            display: inline-block;
            background-color: #f8f9fa;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
        }

        .product-title {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #212529;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            height: 2.5rem;
        }

        .product-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: #0d6efd;
            margin-bottom: 0.5rem;
        }

        .product-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.75rem;
            color: #6c757d;
            padding-top: 0.5rem;
            border-top: 1px solid #e9ecef;
        }

        /* 빈 상태 메시지 */
        .empty-state {
            padding: 3rem;
            text-align: center;
            background-color: #f8f9fa;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .empty-state-icon {
            font-size: 3rem;
            color: #adb5bd;
            margin-bottom: 1rem;
        }

        .empty-state-text {
            color: #6c757d;
            margin-bottom: 1rem;
        }

        /* 버튼 스타일 */
        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-primary:hover {
            background-color: #0b5ed7;
            border-color: #0b5ed7;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-outline-primary {
            color: #0d6efd;
            border-color: #0d6efd;
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-outline-primary:hover {
            background-color: #0d6efd;
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* 페이지네이션 */
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 2rem;
        }

        .page-btn {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 0.25rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .page-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .page-btn.disabled,
        .page-btn[disabled] {
            opacity: 0.65;
            pointer-events: none;
            background-color: #f8f9fa;
            border-color: #dee2e6;
            color: #6c757d;
            box-shadow: none;
            transform: none;
        }

        /* 뷰 전환 버튼 */
        .view-toggle {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .view-toggle-btn {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 0.5rem;
            margin-right: 0.5rem;
            background-color: #fff;
            border: 1px solid #dee2e6;
            transition: all 0.2s;
        }

        .view-toggle-btn:hover {
            background-color: #f8f9fa;
        }

        .view-toggle-btn.active {
            background-color: #0d6efd;
            color: #fff;
            border-color: #0d6efd;
        }

        /* 테이블 뷰 */
        .table-view {
            display: none;
        }

        .custom-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 0.5rem;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .custom-table thead th {
            background-color: #e7f1ff;
            color: #0d6efd;
            font-weight: 600;
            padding: 1rem;
            border-bottom: 2px solid #dee2e6;
        }

        .custom-table tbody tr {
            transition: all 0.2s;
        }

        .custom-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .custom-table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #dee2e6;
        }

        .custom-table tbody tr:last-child td {
            border-bottom: none;
        }

        .full-link {
            display: block;
            width: 100%;
            height: 100%;
            padding: 8px 0;
        }

        /* 반응형 조정 */
        @media (max-width: 768px) {
            .product-card {
                margin-bottom: 1rem;
            }

            .filter-area {
                padding: 1rem;
            }

            .view-toggle {
                display: none;
            }

            .table-view {
                display: none !important;
            }
        }
    </style>
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
        <form action="/AptCommunity/product/search" method="get" id="searchForm">
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
        <a href="add" class="btn btn-primary">
            <i class="bi bi-plus-lg me-1"></i> 상품 등록하기
        </a>
    </div>

    <!-- 페이지네이션 -->
    <div class="pagination-container" id="pagination">
        <!-- 페이지 버튼이 여기에 동적으로 추가됩니다 -->
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
    let currentCategory = "";
    let currentStatus = "";
    let currentMinPrice = "";
    let currentMaxPrice = "";
    let currentChoice = "";
    let currentKeyword = "";
    let currentSort = "latest";
    let currentView = "grid"; // 기본 뷰 타입

    // 상품 데이터 가져오기
    function fetchProducts(page = 1) {
        $.ajax({
            url: "/AptCommunity/product/search",
            method: "GET",
            data: {
                category: currentCategory,
                status: currentStatus,
                minPrice: currentMinPrice,
                maxPrice: currentMaxPrice,
                choice: currentChoice,
                keyword: currentKeyword,
                sort: currentSort,
                page: page
            },
            success: function (res) {
                const products = res.products;
                const wishlistedIds = res.wishlistedIds || [];

                renderGridView(products, wishlistedIds);

                const currentPage = res.currentPage;
                const totalPages = res.totalPages;

                // 빈 상태 처리
                if (products.length === 0) {
                    $("#empty-state").show();
                    $(".grid-view").hide();
                    $(".table-view").hide();
                } else {
                    $("#empty-state").hide();

                    if (currentView === "grid") {
                        $(".grid-view").show();
                        $(".table-view").hide();
                        renderGridView(products, wishlistedIds);
                    } else {
                        $(".grid-view").hide();
                        $(".table-view").show();
                        renderTableView(products);
                    }
                }

                // 페이지네이션 렌더링
                renderPagination(currentPage, totalPages);
            },
            error: function () {
                alert("상품 목록을 불러오는데 실패했습니다.");
            }
        });
    }

    // 그리드 뷰 렌더링
    function renderGridView(products, wishlistedIds) {

        const grid = $("#product-grid");
        grid.empty();

        products.forEach(product => {


            // 상태에 따른 배지 클래스
            let statusClass = "";
            if (product.status === "새상품") {
                statusClass = "status-new";
            } else if (product.status === "중고") {
                statusClass = "status-used";
            } else if (product.status === "나눔") {
                statusClass = "status-free";
            }

            // 가격 포맷팅
            const formattedPrice = product.price.toLocaleString() + "원";

            // 날짜 포맷팅
            const date = new Date(product.createdAt);
            const formattedDate = `\${date.getFullYear()}-\${String(date.getMonth() + 1).padStart(2, '0')}-\${String(date.getDate()).padStart(2, '0')}`;

            // 찜 상태에 따른 하트 아이콘 클래스
            const isWishlisted = wishlistedIds && wishlistedIds.includes(product.id);
            const wishClass = isWishlisted ? "bi-heart-fill text-danger" : "bi-heart";

            // 상품 카드 생성
            const card = `
                  <div class="col-lg-3 col-md-4 col-sm-6 mb-4 position-relative">
                  	<a href="/AptCommunity/product/detail?id=\${product.id}" class="text-decoration-none text-dark">
	                	<div class="product-card">
	                      <div class="product-img-container">
	                      <img 
		                      src="\${product.image ? product.image + '?height=200&width=300' : '/AptCommunity/resources/images/default-image.png'}" 
		                      class="product-img" 
		                      alt="\${product.name}">
	                        <span class="product-status \${statusClass}">\${product.status}</span>

	                      </div>
	                      <div class="product-info">
	                        <span class="product-category">${product.category}</span>
	                        <h3 class="product-title">
	                            \${product.name}
	                        </h3>
	                        <div class="product-price">\${formattedPrice}</div>
	                        <div class="product-meta">
	                          <span><i class="bi bi-person me-1"></i>\${product.userId}</span>
	                          <span><i class="bi bi-calendar3 me-1"></i>\${formattedDate}</span>
	                        </div>
	                      </div>
	                    </div>
                    </a>
                    <div class="product-wishlist position-absolute top-5 end-30 me-3" onclick="toggleWishlist(\${product.id}, this)">
                   		 <i class="bi \${wishClass}"></i>
                  	</div>
                  </div>

                `;

            grid.append(card);
        });
    }


    // 테이블 뷰 렌더링
    function renderTableView(products) {

        const tbody = $("#product-table-body");
        tbody.empty();

        products.forEach(product => {
            // 날짜 포맷팅
            const date = new Date(product.createdAt);
            const formattedDate = `\${date.getFullYear()}-\${String(date.getMonth() + 1).padStart(2, '0')}-\${String(date.getDate()).padStart(2, '0')}`;

            // 가격 포맷팅
            const formattedPrice = product.price.toLocaleString() + "원";

            // 테이블 행 생성
            const row = `
                    <tr>
                        <td>\${product.id}</td>
                        <td>\${product.status}</td>
                        <td>\${product.category}</td>
                        <td>
                        	<a href="/AptCommunity/product/detail?id=\${product.id}" class="text-decoration-none full-link">
                        		\${product.name}
                   			</a>
                        </td>
                        <td>\${formattedPrice}</td>
                        <td>\${product.quantity}</td>
                        <td>\${product.userId}</td>
                        <td>\${formattedDate}</td>
                    </tr>
                `;

            tbody.append(row);
        });
    }

    // 페이지네이션 렌더링
    function renderPagination(currentPage, totalPages) {
        const pagination = $("#pagination");
        pagination.empty();

        // 이전 페이지 버튼 (항상 표시)
        const prevDisabled = currentPage == 1 ? 'disabled' : '';
        const prevOnClick = currentPage == 1 ? '' : 'onclick="fetchProducts(' + (currentPage - 1) + ')"';

        pagination.append(`
                <button type="button" class="btn btn-outline-primary page-btn \${prevDisabled}" \${prevDisabled ? 'disabled' : ''} \${prevOnClick}>
                    <i class="bi bi-chevron-left"></i>
                </button>
            `);

        // 페이지 번호 버튼
        for (let i = 1; i <= totalPages; i++) {
            const isActive = i == Number(currentPage);
            const btnClass = isActive ? "btn-primary" : "btn-outline-primary";

            pagination.append(`
                    <button type="button" class="btn \${btnClass} page-btn" onclick="fetchProducts(\${i})">
                        \${i}
                    </button>
                `);
        }

        // 다음 페이지 버튼 (항상 표시)
        const nextDisabled = currentPage == totalPages ? 'disabled' : '';
        const nextOnClick = currentPage == totalPages ? '' : 'onclick="fetchProducts(' + (Number(currentPage) + 1) + ')"';

        pagination.append(`
                <button type="button" class="btn btn-outline-primary page-btn \${nextDisabled}" \${nextDisabled ? 'disabled' : ''} \${nextOnClick}>
                    <i class="bi bi-chevron-right"></i>
                </button>
            `);
    }

    // 찜하기 토글
    function toggleWishlist(productId, element) {
        const icon = element.querySelector("i");

        $.ajax({
            url: "/AptCommunity/wishlist/toggle-ajax",
            method: "POST",
            contentType: 'application/json',
            data: JSON.stringify({productId: productId}),
            success: function (res) {
                console.log("서버 응답 : ", res)
                if (res === "added") {
                    icon.classList.remove("bi-heart");
                    icon.classList.add("bi-heart-fill", "text-danger");
                } else if (res === "removed") {
                    icon.classList.remove("bi-heart-fill", "text-danger");
                    icon.classList.add("bi-heart");
                } else if (res === "unauthorized") {
                    alert("로그인이 필요합니다.");
                }
            },
            error: function () {
                alert("요청 실패");
            }
        });
    }


    // 검색 버튼 클릭 이벤트
    $("#search").click(function (e) {
        e.preventDefault();
        currentCategory = $("[name='category']").val();
        currentStatus = $("[name='status']").val();
        currentMinPrice = $("[name='minPrice']").val();
        currentMaxPrice = $("[name='maxPrice']").val();
        currentChoice = $("[name='choice']").val();
        currentKeyword = $("[name='keyword']").val();
        fetchProducts(1);
    });

    // 정렬 옵션 변경 이벤트
    $("#sortOption").change(function () {
        currentSort = $(this).val();
        fetchProducts(1);
    });

    // 뷰 전환 버튼 이벤트
    $("#gridViewBtn").click(function () {
        currentView = "grid";
        $(this).addClass("active");
        $("#tableViewBtn").removeClass("active");
        $(".grid-view").show();
        $(".table-view").hide();
        fetchProducts(page = 1)
    });

    $("#tableViewBtn").click(function () {
        currentView = "table";
        $(this).addClass("active");
        $("#gridViewBtn").removeClass("active");
        $(".grid-view").hide();
        $(".table-view").show();
        fetchProducts(page = 1)
    });

    // 페이지 로드 시 상품 목록 가져오기
    $(document).ready(function () {
        fetchProducts(1);

        // URL 파라미터에서 필터 값 가져오기
        const urlParams = new URLSearchParams(window.location.search);

        // 필터 값 설정
        if (urlParams.has('category')) {
            currentCategory = urlParams.get('category');
            $("[name='category']").val(currentCategory);
        }

        if (urlParams.has('status')) {
            currentStatus = urlParams.get('status');
            $("[name='status']").val(currentStatus);
        }

        if (urlParams.has('minPrice')) {
            currentMinPrice = urlParams.get('minPrice');
            $("[name='minPrice']").val(currentMinPrice);
        }

        if (urlParams.has('maxPrice')) {
            currentMaxPrice = urlParams.get('maxPrice');
            $("[name='maxPrice']").val(currentMaxPrice);
        }

        if (urlParams.has('choice')) {
            currentChoice = urlParams.get('choice');
            $("[name='choice']").val(currentChoice);
        }

        if (urlParams.has('keyword')) {
            currentKeyword = urlParams.get('keyword');
            $("[name='keyword']").val(currentKeyword);
        }
    });

</script>
</body>
</html>
