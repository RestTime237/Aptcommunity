// 전역 변수 선언
let currentCategory = ""
let currentStatus = ""
let currentMinPrice = ""
let currentMaxPrice = ""
let currentChoice = ""
let currentKeyword = ""
let currentSort = "latest"
let currentView = "grid" // 기본 뷰 타입

// URL 파라미터 파싱 함수
function getUrlParams() {
    const params = {}
    const queryString = window.location.search.substring(1)
    const pairs = queryString.split("&")

    for (let i = 0; i < pairs.length; i++) {
        if (!pairs[i]) continue

        const pair = pairs[i].split("=")
        const key = decodeURIComponent(pair[0])
        const value = pair.length > 1 ? decodeURIComponent(pair[1]) : ""

        params[key] = value
    }

    return params
}

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
            page: page,
        },
        success: (res) => {
            const products = res.products
            const wishlistedIds = res.wishlistedIds || []

            // 빈 상태 처리
            if (products.length === 0) {
                $("#empty-state").show()
                $(".grid-view").hide()
                $(".table-view").hide()
            } else {
                $("#empty-state").hide()

                if (currentView === "grid") {
                    $(".grid-view").show()
                    $(".table-view").hide()
                    renderGridView(products, wishlistedIds)
                } else {
                    $(".grid-view").hide()
                    $(".table-view").show()
                    renderTableView(products)
                }
            }

            // 페이지네이션 렌더링
            renderPagination(res.currentPage, res.totalPages)
        },
        error: () => {
            alert("상품 목록을 불러오는데 실패했습니다.")
        },
    })
}

// 그리드 뷰 렌더링
function renderGridView(products, wishlistedIds) {
    const grid = $("#product-grid")
    grid.empty()

    products.forEach((product) => {
        // 상태에 따른 배지 클래스
        let statusClass = ""
        if (product.status === "새상품") {
            statusClass = "status-new"
        } else if (product.status === "중고") {
            statusClass = "status-used"
        } else if (product.status === "나눔") {
            statusClass = "status-free"
        }

        // 가격 포맷팅
        const formattedPrice = product.price.toLocaleString() + "원"

        // 날짜 포맷팅
        const date = new Date(product.createdAt)
        const formattedDate = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`

        // 찜 상태에 따른 하트 아이콘 클래스
        const isWishlisted = wishlistedIds && wishlistedIds.includes(product.id)
        const wishClass = isWishlisted ? "bi-heart-fill text-danger" : "bi-heart"

        // 상품 카드 생성
        const card = `
      <div class="col-lg-3 col-md-4 col-sm-6 mb-4 position-relative">
        <a href="/AptCommunity/product/detail?id=${product.id}" class="text-decoration-none text-dark">
          <div class="product-card">
            <div class="product-img-container">
              <img
                src="${product.image ? product.image + "?height=200&width=300" : "/AptCommunity/resources/images/default-image.png"}"
                class="product-img"
                alt="${product.name}">
              <span class="product-status ${statusClass}">${product.status}</span>
            </div>
            <div class="product-info">
              <span class="product-category">${product.category}</span>
              <h3 class="product-title">
                ${product.name}
              </h3>
              <div class="product-price">${formattedPrice}</div>
              <div class="product-meta">
                <span><i class="bi bi-person me-1"></i>${product.userId}</span>
                <span><i class="bi bi-calendar3 me-1"></i>${formattedDate}</span>
              </div>
            </div>
          </div>
        </a>
        <div class="product-wishlist position-absolute top-5 end-30 me-3" onclick="toggleWishlist(${product.id}, this)">
          <i class="bi ${wishClass}"></i>
        </div>
      </div>
    `

        grid.append(card)
    })
}

// 테이블 뷰 렌더링
function renderTableView(products) {
    const tbody = $("#product-table-body")
    tbody.empty()

    products.forEach((product) => {
        // 날짜 포맷팅
        const date = new Date(product.createdAt)
        const formattedDate = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`

        // 가격 포맷팅
        const formattedPrice = product.price.toLocaleString() + "원"

        // 테이블 행 생성
        const row = `
      <tr>
        <td>${product.id}</td>
        <td>${product.status}</td>
        <td>${product.category}</td>
        <td>
          <a href="/AptCommunity/product/detail?id=${product.id}" class="text-decoration-none full-link">
            ${product.name}
          </a>
        </td>
        <td>${formattedPrice}</td>
        <td>${product.quantity}</td>
        <td>${product.userId}</td>
        <td>${formattedDate}</td>
      </tr>
    `

        tbody.append(row)
    })
}

// 페이지네이션 렌더링
function renderPagination(currentPage, totalPages) {
    const pagination = $("#pagination")
    pagination.empty()

    // 이전 페이지 버튼

    pagination.append(`
      <button type="button" class="btn btn-outline-primary page-btn ${currentPage == 1 ? 'disabled' : ''}" 
                                ${currentPage == 1 ? 'disabled' : 'data-page="' + (currentPage - 1) + '"'}" onclick="fetchProducts(${currentPage - 1})">
        <i class="bi bi-chevron-left"></i>
      </button>
    `)


    // 페이지 번호 버튼
    for (let i = 1; i <= totalPages; i++) {
        const isActive = i == Number(currentPage)
        const btnClass = isActive ? "btn-primary" : "btn-outline-primary"

        pagination.append(`
      <button type="button" class="btn ${btnClass} page-btn" onclick="fetchProducts(${i})">
        ${i}
      </button>
    `)
    }

    // 다음 페이지 버튼
    pagination.append(`
      <button type="button" class="btn btn-outline-primary page-btn ${currentPage == totalPages ? 'disabled' : ''}" 
                                ${currentPage == totalPages ? 'disabled' : 'data-page="' + (Number(currentPage) + 1) + '"'}" onclick="fetchProducts(${currentPage + 1})">
        <i class="bi bi-chevron-right"></i>
      </button>
    `)
}

// 찜하기 토글
function toggleWishlist(productId, element) {
    const icon = element.querySelector("i")

    $.ajax({
        url: "/AptCommunity/wishlist/toggle-ajax",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({ productId: productId }),
        success: (res) => {
            console.log("서버 응답 : ", res)
            if (res === "added") {
                icon.classList.remove("bi-heart")
                icon.classList.add("bi-heart-fill", "text-danger")
            } else if (res === "removed") {
                icon.classList.remove("bi-heart-fill", "text-danger")
                icon.classList.add("bi-heart")
            } else if (res === "unauthorized") {
                alert("로그인이 필요합니다.")
            }
        },
        error: () => {
            alert("요청 실패")
        },
    })
}

// 이벤트 핸들러 등록 및 초기화
$(document).ready(() => {
    // URL 파라미터에서 초기 필터 값 가져오기
    const urlParams = getUrlParams()

    // 필터 값 설정
    if (urlParams.category) {
        currentCategory = urlParams.category
        $("[name='category']").val(currentCategory)
    }

    if (urlParams.status) {
        currentStatus = urlParams.status
        $("[name='status']").val(currentStatus)
    }

    if (urlParams.minPrice) {
        currentMinPrice = urlParams.minPrice
        $("[name='minPrice']").val(currentMinPrice)
    }

    if (urlParams.maxPrice) {
        currentMaxPrice = urlParams.maxPrice
        $("[name='maxPrice']").val(currentMaxPrice)
    }

    if (urlParams.choice) {
        currentChoice = urlParams.choice
        $("[name='choice']").val(currentChoice)
    }

    if (urlParams.keyword) {
        currentKeyword = urlParams.keyword
        $("[name='keyword']").val(currentKeyword)
    }

    // 검색 버튼 클릭 이벤트
    $("#search").click((e) => {
        e.preventDefault()
        currentCategory = $("[name='category']").val()
        currentStatus = $("[name='status']").val()
        currentMinPrice = $("[name='minPrice']").val()
        currentMaxPrice = $("[name='maxPrice']").val()
        currentChoice = $("[name='choice']").val()
        currentKeyword = $("[name='keyword']").val()
        fetchProducts(1)
    })

    // 정렬 옵션 변경 이벤트
    $("#sortOption").change(function () {
        currentSort = $(this).val()
        fetchProducts(1)
    })

    // 뷰 전환 버튼 이벤트
    $("#gridViewBtn").click(function () {
        currentView = "grid"
        $(this).addClass("active")
        $("#tableViewBtn").removeClass("active")
        $(".grid-view").show()
        $(".table-view").hide()
        fetchProducts(1)
    })

    $("#tableViewBtn").click(function () {
        currentView = "table"
        $(this).addClass("active")
        $("#gridViewBtn").removeClass("active")
        $(".grid-view").hide()
        $(".table-view").show()
        fetchProducts(1)
    })

    // 페이지 로드 시 상품 목록 가져오기
    fetchProducts(1)
})
