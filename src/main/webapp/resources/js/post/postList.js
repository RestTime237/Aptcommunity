let currentCategory = "";
let currentChoice = "";
let currentKeyword = "";
let currentSort = "latest"; // 기본 정렬: 최신순

// 날짜 포맷 함수 - JavaScript 내에서만 사용
function formatDate(dateString) {
    const date = new Date(dateString);
    const now = new Date();
    const diffTime = Math.abs(now - date);
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

    if (diffDays === 0) {
        // 오늘
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        return `오늘 ${hours}:${minutes}`;
    } else if (diffDays === 1) {
        // 어제
        return "어제";
    } else if (diffDays < 7) {
        // 일주일 이내
        return `${diffDays}일 전`;
    } else {
        // 일주일 이상
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }
}

function fetchPosts(page = 1) {
    // 로딩 표시
    $("#post-table-body").html(`
            <tr>
                <td colspan="7" class="text-center py-5 loading-state">
                    <div class="spinner-border text-primary loading-spinner" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-3 text-muted">게시글을 불러오는 중입니다...</p>
                </td>
            </tr>
        `);

    $.ajax({
        url: "/post/search",
        method: "GET",
        data: {
            category: currentCategory,
            choice: currentChoice,
            keyword: currentKeyword,
            sort: currentSort,
            page: page
        },
        success: function (res) {
            console.log(res);
            const posts = res.posts;
            const currentPage = res.currentPage;
            const totalPages = res.totalPages;
            const imageMap = res.imageMap;

            const tbody = $("#post-table-body");
            tbody.empty();

            if (posts.length === 0) {
                tbody.append(`
                        <tr>
                            <td colspan="7" class="text-center py-5 empty-state">
                                <i class="bi bi-search empty-state-icon"></i>
                                <h5 class="mb-2">검색 결과가 없습니다</h5>
                                <p class="text-muted mb-3">다른 검색어로 다시 시도해보세요.</p>
                                <button class="btn btn-outline-primary" onclick="resetSearch()">
                                    <i class="bi bi-arrow-counterclockwise me-1"></i> 검색 초기화
                                </button>
                            </td>
                        </tr>
                    `);
            } else {
                // 공지사항을 먼저 표시하기 위해 정렬
                const sortedPosts = [...posts].sort((a, b) => {
                    if (a.category === '공지' && b.category !== '공지') return -1;
                    if (a.category !== '공지' && b.category === '공지') return 1;
                    return 0;
                });

                sortedPosts.forEach((post, index) => {
                    const isNotice = post.category === '공지';
                    const rowClass = isNotice ? 'notice-row animate-fade-in' : 'animate-fade-in';
                    const animationDelay = index * 50; // 각 행마다 애니메이션 지연 시간 추가

                    // 카테고리 배지 스타일 결정
                    let categoryClass = '';
                    let categoryIcon = '';

                    if (isNotice) {
                        categoryDisplay = '<span class="notice-badge"><i class="bi bi-megaphone-fill"></i> 공지</span>';
                    } else {
                        switch (post.category) {
                            case '자유':
                                categoryClass = 'free';
                                categoryIcon = 'bi-chat';
                                break;
                            case '질문':
                                categoryClass = 'question';
                                categoryIcon = 'bi-question-circle';
                                break;
                            case '정보':
                                categoryClass = 'discussion';
                                categoryIcon = 'bi-info-circle';
                                break;
                            case '행사':
                                categoryClass = 'event';
                                categoryIcon = 'bi-calendar-event';
                                break;
                            default:
                                categoryClass = 'free';
                                categoryIcon = 'bi-chat';
                        }

                        categoryDisplay = `<span class="category-badge ${categoryClass}"><i class="bi ${categoryIcon} me-1"></i> ${post.category}</span>`;
                    }

                    const hasImage = imageMap[post.id];
                    const imageIcon = hasImage
                        ? '<i class="bi bi-image post-icon"></i>'
                        : '';

                    // 댓글 수 표시
                    const commentCount = post.commentCount || 0;
                    const commentBadge = commentCount > 0
                        ? `<span class="badge bg-primary ms-2">${commentCount}</span>`
                        : '';

                    // 공지사항 제목 스타일 변경
                    const titleClass = isNotice ? 'notice-link' : 'post-link';

                    // JavaScript에서 날짜 포맷팅
                    const formattedDate = formatDate(post.createdAt);

                    const nicknameMap = res.nicknameMap;
                    const nickname = nicknameMap[post.userId];

                    tbody.append(`
                            <tr class="${rowClass}" style="animation-delay: ${animationDelay}ms">
                                <td class="text-center">${post.id}</td>
                                <td class="text-center">${categoryDisplay}</td>
                                <td class="ps-4">
                                    <a href="/post/detail?id=${post.id}" class="${titleClass}">
                                        ${imageIcon}${post.title} ${commentBadge}
                                    </a>
                                </td>
                                <td class="text-center">
                                    <span class="d-flex align-items-center justify-content-center">
                                        <i class="bi bi-person-circle me-1 text-muted"></i>
                                        ${nickname}
                                    </span>
                                </td>
                                <td class="text-center">${formattedDate}</td>
                                <td class="text-center">${post.views}</td>
                                <td class="text-center">${post.likeCount}</td>
                            </tr>
                        `);
                });
            }

            // 페이지네이션 생성
            const pagination = $("#pagination");
            pagination.empty();

            if (totalPages > 0) {
                // 이전 페이지 버튼
                pagination.append(`
                        <button type="button" class="btn page-btn ${currentPage == 1 ? 'disabled' : ''}" 
                                ${currentPage == 1 ? 'disabled' : 'data-page="' + (currentPage - 1) + '"'}>
                            <i class="bi bi-chevron-left"></i>
                        </button>
                    `);

                // 페이지 번호 버튼
                const maxPageButtons = 5; // 최대 표시할 페이지 버튼 수
                let startPage = Math.max(1, currentPage - Math.floor(maxPageButtons / 2));
                let endPage = Math.min(totalPages, startPage + maxPageButtons - 1);

                if (endPage - startPage + 1 < maxPageButtons) {
                    startPage = Math.max(1, endPage - maxPageButtons + 1);
                }

                for (let i = startPage; i <= endPage; i++) {
                    const isActive = i == Number(currentPage);
                    const btnClass = isActive ? "active" : "";

                    pagination.append(`
                            <button type="button" class="btn page-btn ${btnClass}" data-page="${i}">
                                ${i}
                            </button>
                        `);
                }

                // 다음 페이지 버튼
                pagination.append(`
                        <button type="button" class="btn page-btn ${currentPage == totalPages ? 'disabled' : ''}" 
                                ${currentPage == totalPages ? 'disabled' : 'data-page="' + (Number(currentPage) + 1) + '"'}>
                            <i class="bi bi-chevron-right"></i>
                        </button>
                    `);

                // 페이지 버튼 이벤트 연결
                $(".page-btn:not(.disabled)").click(function () {
                    const page = $(this).data("page");
                    fetchPosts(page);

                    // 페이지 상단으로 부드럽게 스크롤
                    $('html, body').animate({
                        scrollTop: $(".content-card").offset().top - 20
                    }, 300);
                });
            }
        },
        error: function () {
            $("#post-table-body").html(`
                    <tr>
                        <td colspan="7" class="text-center py-5">
                            <i class="bi bi-exclamation-triangle fs-1 text-danger mb-3 d-block"></i>
                            <p class="text-danger">게시글을 불러오는데 실패했습니다.</p>
                            <button class="btn btn-outline-primary mt-2" onclick="fetchPosts(1)">
                                <i class="bi bi-arrow-clockwise me-1"></i> 다시 시도
                            </button>
                        </td>
                    </tr>
                `);
        }
    });
}

// 검색 초기화
function resetSearch() {
    currentCategory = "";
    currentChoice = "";
    currentKeyword = "";
    currentSort = "latest";

    // 폼 초기화
    $("[name='category']").val("");
    $("[name='choice']").val("all");
    $("[name='keyword']").val("");

    // 카테고리 버튼 초기화
    $(".category-btn").removeClass("active");
    $(".category-btn[data-category='']").addClass("active");

    // 정렬 버튼 초기화
    $(".btn-group .btn").removeClass("active");
    $("#sort-latest").addClass("active");

    // 게시글 다시 로드
    fetchPosts(1);
}

// 검색 버튼 이벤트
$("#search").click(function (e) {
    e.preventDefault();
    currentCategory = $("[name='category']").val();
    currentChoice = $("[name='choice']").val();
    currentKeyword = $("[name='keyword']").val();
    fetchPosts(1);
});

// 엔터키 검색 이벤트
$("[name='keyword']").keypress(function (e) {
    if (e.which === 13) {
        e.preventDefault();
        $("#search").click();
    }
});

// 카테고리 필터 이벤트
$(".category-btn").click(function () {
    $(".category-btn").removeClass("active");
    $(this).addClass("active");

    currentCategory = $(this).data("category");
    $("[name='category']").val(currentCategory);
    fetchPosts(1);
});

// 정렬 버튼 이벤트
$("#sort-latest, #sort-views, #sort-likeCount").click(function () {
    $(".btn-group .btn").removeClass("active");
    $(this).addClass("active");

    if (this.id === "sort-latest") {
        currentSort = "latest";
    } else if (this.id === "sort-views") {
        currentSort = "views";
    } else if (this.id === "sort-likeCount") {
        currentSort = "likeCount";
    }

    fetchPosts(1);
});

// 페이지 로드 시 게시글 목록 불러오기
$(document).ready(function () {
    loadBoardStats();
    fetchPosts(1);
});
