// 컨텍스트 경로를 동적으로 가져오는 함수
const getContextPath = () => {
    // meta 태그에서 컨텍스트 경로를 가져오거나, 기본값 사용
    const metaContextPath = $('meta[name="contextPath"]').attr('content');
    return metaContextPath || '/AptCommunity';
};

$(document).ready(function () {
    // 기존 해시로 탭 전환
    let hash = window.location.hash;
    if (hash) {
        $('.nav-tabs button[data-bs-target="' + hash + '"]').tab('show');
    }

    // 탭 이동 시 스크롤 위치 조정
    $('.nav-tabs button').on('click', function (e) {
        const target = $(this).data('bsTarget'); // "#posts", "#products", ...

        // 탭 콘텐츠가 로딩된 후 스크롤 보정 (짧은 지연)
        setTimeout(() => {
            const offset = $(target).offset()?.top || 0;
            window.scrollTo({
                top: offset - 150,
                behavior: 'smooth'
            });

            // URL 해시 갱신
            history.replaceState(null, null, target);
        }, 50); // 50ms 정도의 짧은 delay가 탭 전환 후 위치 정확도에 도움됨
    });



    // 🧩 게시글 보기 버튼 클릭 시 탭 이동 + 스크롤
    $("#watchPost").on("click", function (e) {
        e.preventDefault();

        const targetTab = $('#posts-tab');
        const targetContent = document.querySelector('#posts');

        targetTab.tab('show');

        setTimeout(() => {
            const offsetTop = targetContent.getBoundingClientRect().top + window.pageYOffset;
            window.scrollTo({
                top: offsetTop - 150,
                behavior: 'smooth'
            });
        }, 100);
    });

    $("#watchProduct").on("click", function (e) {
        e.preventDefault();

        const targetTab = $('#products-tab');
        const targetContent = document.querySelector('#products');

        targetTab.tab('show');

        setTimeout(() => {
            const offsetTop = targetContent.getBoundingClientRect().top + window.pageYOffset;
            window.scrollTo({
                top: offsetTop - 150,
                behavior: 'smooth'
            });
        }, 100);
    });

    $("#watchWishlist").on("click", function (e) {
        e.preventDefault();

        const targetTab = $('#wishlist-tab');
        const targetContent = document.querySelector('#wishlist');

        targetTab.tab('show');

        setTimeout(() => {
            const offsetTop = targetContent.getBoundingClientRect().top + window.pageYOffset;
            window.scrollTo({
                top: offsetTop - 150,
                behavior: 'smooth'
            });
        }, 100);
    });

});

$(document).ready(function () {
    fetchMyPosts(1);
    fetchMyProducts(1);
    fetchMyWishlist(1);

    // 이미지 클릭 시 모달 열기
    $("#profileImageArea").click(function () {
        $("#profileImageModal").modal("show");
    });

    // 미리보기
    $("input[name='profileImage']").change(function (e) {
        const file = e.target.files[0];
        if (file) {
            $("#previewProfile").attr("src", URL.createObjectURL(file));
        }
    });

    // 업로드
    $("#profileImageForm").submit(function (e) {
        e.preventDefault();
        const formData = new FormData(this);
        $.ajax({
            url: getContextPath() + "/member/uploadProfileImage",
            method: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function (filename) {
                const timestamp = new Date().getTime();
                const imageUrl = getContextPath() + '/resources/images/' + filename + "?t=" + timestamp;
                console.log('이미지 url : ', imageUrl);
                $(".profile-image").attr("src", imageUrl);
                $("#previewProfile").attr("src", imageUrl);
                $("#profileImageModal").modal("hide");
            },
            error: function () {
                alert("업로드 실패");
            }
        });
    });

});

// 삭제
$("#deleteProfileImage").click(function () {
    if (!confirm("정말 프로필 사진을 삭제하시겠습니까?")) return;

    $.ajax({
        url: getContextPath() + "/member/deleteProfileImage",
        type: "POST",
        success: function () {
            // 프리뷰 이미지 변경
            $("#previewProfile").attr("src", getContextPath() + "/resources/images/default-profile.png");

            // 메인 프로필 이미지도 변경
            $(".profile-image").attr("src", getContextPath() + "/resources/images/default-profile.png");

            // 모달 닫기
            bootstrap.Modal.getInstance(document.getElementById("profileImageModal")).hide();
        },
        error: function () {
            alert("프로필 이미지 삭제 실패");
        }
    });
});


// 찜 목록에서 상품 제거 함수
function removeWishlist(productId) {
    if (confirm('찜 목록에서 삭제하시겠습니까?')) {
        $.ajax({
            url: getContextPath() + '/product/removeWishlist',
            type: 'POST',
            data: { productId: productId },
            success: function (response) {
                alert('찜 목록에서 삭제되었습니다.');
                location.reload();
            },
            error: function (error) {
                alert('오류가 발생했습니다. 다시 시도해주세요.');
            }
        });
    }
}

// 페이지 이동
$("#posts-tab").click(function () {
    fetchMyPosts(1);
});

$("#products-tab").click(function () {
    fetchMyProducts(1);
});

$("#wishlist-tab").click(function () {
    fetchMyWishlist(1);
});



// 게시글
function fetchMyPosts(page) {
    $.ajax({
        url: getContextPath() + '/member/mypage/posts',
        method: 'GET',
        data: { page: page },
        success: function (res) {
            renderMyPosts(res.posts);
            renderPagination(res.currentPage, res.totalPages, fetchMyPosts, "postPagination");
        },
        error: function (err) {
            alert('내가 쓴 글을 불러오는데 실패했습니다.')
        }
    })
}

function renderMyPosts(posts) {
    const container = $("#myPostsContainer");
    container.empty();

    posts.forEach(post => {
        const row = `
      	      <tr>
      	        <td>${post.title}</td>
      	        <td>${post.category}</td>
      	        <td>${formatDate(post.createdAt)}</td>
      	        <td>
      	          <a href="${getContextPath()}/post/detail?id=${post.id}" class="btn btn-sm btn-outline-primary">
      	            <i class="bi bi-eye"></i>
      	          </a>
      	        </td>
      	      </tr>
      	    `;
        container.append(row);
    });
}

// 판매글
function fetchMyProducts(page) {
    $.ajax({
        url: getContextPath() + '/member/mypage/products',
        method: 'GET',
        data: { page: page },
        success: function (res) {
            renderMyProducts(res.products);
            renderPagination(res.currentPage, res.totalPages, fetchMyProducts, "productPagination");
        },
        error: function (err) {
            alert('내가 쓴 판매글을 불러오는데 실패했습니다.')
        }
    })
}

function renderMyProducts(products) {
    const container = $("#myProductsContainer");
    container.empty();

    products.forEach(product => {
        const row = `
      	      <tr>
      	        <td>${product.name}</td>
      	        <td>${product.price}</td>
      	        <td>${product.status}</td>
      	        <td>
      	          <a href="${getContextPath()}/product/detail?id=${product.id}" class="btn btn-sm btn-outline-primary">
      	            <i class="bi bi-eye"></i>
      	          </a>
      	        </td>
      	      </tr>
      	    `;
        container.append(row);
    });
}

// 위시리스트
function fetchMyWishlist(page) {
    $.ajax({
        url: getContextPath() + '/member/mypage/wishlist',
        method: 'GET',
        data: { page: page },
        success: function (res) {
            console.log('응답 결과: ', res);
            renderMyWishlist(res.wishlist);
            renderPagination(res.currentPage, res.totalPages, fetchMyWishlist, "wishlistPagination");
        },
        error: function (err) {
            alert('내가 찜한 목록을 불러오는데 실패했습니다.')
        }
    })
}

function renderMyWishlist(products) {
    const container = $("#myWishlistContainer");
    const emptyState = $("#wishlistEmpty");
    container.empty();

    if (products.length === 0) {
        emptyState.removeClass("d-none");
        return;
    } else {
        emptyState.addClass("d-none");
    }

    products.forEach(product => {
        const formattedPrice = product.price.toLocaleString();
        const date = formatDate(product.createdAt);

        const card = `
	        	  <div class="col-md-6 col-lg-4 mb-4">
	        	  <a href="${getContextPath()}/product/detail?id=${product.id}" class="text-decoration-none text-dark">
	        	    <div class="card h-100 border-0 shadow-sm">
	        	      <div class="position-relative">
	        	        <img src="${product.image ? product.image + '?height=180&width=300' : getContextPath() + '/resources/images/default-image.png'}" class="card-img-top  card-img" alt="${product.name}" style="height: 180px; object-fit: cover;">

	        	        <!-- 하트 토글버튼 -->
		        	    <div class="wishlist-heart position-absolute top-5 end-30" onclick="toggleWishlist(event, ${product.id}, this)">
                          <i class="bi bi-heart-fill text-danger fs-5"></i>
                        </div>



	        	      </div>
	        	      <div class="card-body">
	        	        <h5 class="card-title text-truncate">${product.name}</h5>
	        	        <p class="card-text fw-bold text-primary">${formattedPrice}원</p>
	        	        <div class="d-flex justify-content-between align-items-center">
	        	          <span class="badge bg-light text-dark">${product.category}</span>
	        	          ${renderStatusBadge(product.status)}
	        	        </div>
		        	    <div class="product-meta">
	                      <span><i class="bi bi-person me-1"></i>${product.userId}</span>
	                      <span><i class="bi bi-calendar3 me-1"></i>${date}</span>
	                    </div>
	        	      </div>

	        	    </div>
	        	    </a>
	        	  </div>
	        	`;


        container.append(card);
    });
}


// 공용 페이징처리 함수
function renderPagination(currentPage, totalPages, callbackFn, containerId) {
    const container = $("#" + containerId);
    container.empty();

    if (totalPages <= 1) return;

    let html = `<ul class="pagination justify-content-center">`;

    for (let i = 1; i <= totalPages; i++) {
        html += `
        	      <li class="page-item ${i === currentPage ? 'active' : ''}">
        	        <button class="page-link" onclick="${callbackFn.name}(${i})">${i}</button>
        	      </li>
        	    `;
    }

    html += `</ul>`;
    container.html(html);
}

// 날짜 처리 함수
function formatDate(dateStr) {
    const date = new Date(dateStr);
    return `${date.getFullYear()}-${String(date.getMonth()+1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

// 상태 뱃지 렌더링 함수
function renderStatusBadge(status) {
    if (status === "판매중") {
        return `<span class="status-badge status-available">판매중</span>`;
    } else if (status === "예약중") {
        return `<span class="status-badge status-reserved">예약중</span>`;
    } else if (status === "판매완료") {
        return `<span class="status-badge status-sold">판매완료</span>`;
    } else {
        return `<span class="badge bg-secondary">${status}</span>`;
    }
}

$("#profileImageForm").submit(function (e) {
    e.preventDefault();

    const formData = new FormData(this);

    $.ajax({
        url: getContextPath() + '/member/uploadProfileImage',
        type: 'post',
        data: formData,
        processData: false,
        contentType: false,
        success: function (res) {
            $("#profileImagePreview").attr("src", `${getContextPath()}/resources/images/${res}?t=${new Date().getTime()}`);
            bootstrap.Modal.getInstance(document.getElementById('profileImageModal')).hide();
        },
        error: function (err) {
            alert('이미지 업로드 실패');
        }
    })
})

function toggleWishlist(event, productId, buttonEl) {
    event.stopPropagation();
    event.preventDefault();

    $.ajax({
        url: getContextPath() + "/wishlist/toggle-ajax",
        type: "POST",
        contentType: 'application/json',
        data: JSON.stringify({ productId }),
        success: function (res) {
            const icon = buttonEl.querySelector("i");

            if (res === "removed") {
                if (icon) {
                    icon.classList.remove("bi-heart-fill", "text-danger");
                    icon.classList.add("bi-heart");
                }
            } else if (res === "added") {
                if (icon) {
                    icon.classList.remove("bi-heart");
                    icon.classList.add("bi-heart-fill", "text-danger");
                }
            }
        },
        error: function () {
            alert("요청 처리 중 오류가 발생했습니다.");
        }
    });
}
