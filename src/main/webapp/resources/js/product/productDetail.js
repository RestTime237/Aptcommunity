const userId = "<c:out value='${mb.userId}' default='' />";
const role = "<c:out value='${mb.role}' default='0' />";

$("#chat").click(function () {
    const opponentId = $(this).data('opponent');
    console.log('상대방 ID : ', opponentId);

    $.ajax({
        url: '/chat/start',
        method: 'post',
        data: {opponentId: opponentId},
        success: function (res) {
            window.location.href = '/chat/room/' + res;
        },
        error: function (err) {
            alert('채팅방 생성에 실패했습니다.');
        }
    });
});

//게시글 삭제
document.addEventListener("DOMContentLoaded", function () {
    const productId = document.querySelector("#productId").value;

    const deleteBtn = document.querySelector("#deleteProduct");
    if (deleteBtn) {
        deleteBtn.addEventListener("click", function () {
            if (confirm("상품을 삭제하시겠습니까?")) {
                $.ajax({
                    url: "/product/delete",
                    method: "GET",
                    data: {id: productId},
                    success: function (res) {
                        alert("삭제되었습니다.");
                        window.location.href = "/product/list";
                    },
                    error: function (err) {
                        alert("삭제에 실패했습니다.");
                    }
                });
            }
        });
    }

    // 신고하기 제출
    $("#submitReport").click(function () {
        const form = $("#reportForm");
        const reason = $("#reportReason").val();
        const detail = $("#reportDetail").val();

        if (!reason) {
            alert("신고 사유를 선택해주세요.");
            return;
        }

        if (!detail) {
            alert("상세 내용을 입력해주세요.");
            return;
        }

        // 여기에 신고 처리 AJAX 추가
        $.ajax({
            url: "/report/add",
            method: "POST",
            data: form.serialize(),
            success: function (res) {
                alert("신고가 접수되었습니다.");
                $("#reportModal").modal("hide");
            },
            error: function (err) {
                alert("신고 접수에 실패했습니다. 다시 시도해주세요.");
            }
        });
    });
});

$("#wishlistBtn").click(function () {
    const productId = this.dataset.productId;
    const heartIcon = this.querySelector("i");
    const textSpan = this.querySelector("span");
    const self = this;

    $.ajax({
        url: "/wishlist/toggle-ajax",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({productId: productId}),
        success: function (res) {
            if (res == 'added') {
                self.classList.add("active");
                heartIcon.classList.remove("bi-heart");
                heartIcon.classList.add("bi-heart-fill");
                textSpan.innerText = "찜 취소";
            } else if (res == 'removed') {
                self.classList.remove("active");
                heartIcon.classList.remove("bi-heart-fill");
                heartIcon.classList.add("bi-heart");
                textSpan.innerText = "찜하기";
            } else {
                alert('로그인이 필요합니다.')
            }
        },
        error: function (err) {
            alert('찜하기 실패');
        }
    });
});

// 댓글 삭제
document.querySelectorAll(".deleteComment").forEach(btn => {
    btn.addEventListener("click", function () {
        const commentId = this.dataset.id;
        const refType = document.querySelector("input[name='refType']").value;
        const refId = document.querySelector("input[name='refId']").value;

        if (confirm("댓글을 삭제하시겠습니까?")) {
            $.ajax({
                url: "/comment/delete",
                method: "POST",
                data: {
                    id: commentId,
                    refType: refType,
                    refId: refId
                },
                success: function (res) {
                    alert("댓글이 삭제되었습니다.");
                    window.location.reload();
                },
                error: function (err) {
                    alert("삭제에 실패했습니다.");
                }
            });
        }
    });
});

// 댓글 수정
$(document).on('click', '.edit-comment-btn', function () {
    const id = $(this).data('id');
    const content = $(this).data('content');
    const commentDiv = $(this).closest('.comment-item');
    const refType = document.querySelector("input[name='refType']").value;
    const refId = document.querySelector("input[name='refId']").value;

    // 원래 댓글 내용 숨기기
    const original = commentDiv.find('.comment-content p');
    original.hide();

    // 이미 편집중이면 return
    if (commentDiv.find('textarea.edit-area').length > 0) return;

    // textarea 생성
    const textarea = $(`<textarea class="form-control mb-2 edit-area" rows="2">${content}</textarea>`);
    const saveBtn = $(`<button class="btn btn-sm btn-primary me-1 save-edit-btn">저장</button>`);
    const cancelBtn = $(`<button class="btn btn-sm btn-secondary cancel-edit-btn">취소</button>`);
    const btnGroup = $('<div class="d-flex gap-2 mt-2"></div>').append(saveBtn).append(cancelBtn);

    commentDiv.find('.comment-content').append(textarea).append(btnGroup);

    // 저장 처리
    saveBtn.click(function () {
        const newContent = textarea.val().trim();
        if (!newContent) {
            alert("내용을 입력하세요.");
            return;
        }

        $.post("/comment/update", {
            id: id,
            content: newContent,
            refType: refType,
            refId: refId
        }, function (res) {
            if (res === 'success') {
                original.text(newContent).show();
                textarea.remove();
                btnGroup.remove();
            } else {
                alert("수정에 실패했습니다.");
            }
        });
    });

    // 취소 처리
    cancelBtn.click(function () {
        textarea.remove();
        btnGroup.remove();
        original.show();
    });
});

// 대댓글 작성
document.querySelectorAll(".reply-toggle").forEach(button => {
    button.addEventListener("click", () => {
        const commentId = button.dataset.commentId;
        const replyForm = document.getElementById("replyForm-" + commentId);
        replyForm.style.display = replyForm.style.display === "none" ? "block" : "none";
    });
});

// 대댓글 등록
document.querySelectorAll(".submit-reply").forEach(button => {
    button.addEventListener("click", () => {
        const parentId = button.dataset.parentId;
        const refId = button.closest('.reply-form').querySelector('input[name="refId"]').value;
        const refType = button.closest('.reply-form').querySelector('input[name="refType"]').value;
        const userId = button.closest('.reply-form').querySelector('input[name="userId"]').value;
        const content = button.closest('.reply-form').querySelector('textarea').value;

        $.ajax({
            url: '/comment/add-ajax',
            method: 'post',
            contentType: 'application/json',
            data: JSON.stringify({
                refType: refType,
                refId: refId,
                content: content,
                parentId: parentId
            }),
            success: function () {
                window.location.reload();
            },
            error: function () {
                alert('답글 등록에 실패했습니다.');
            }
        });
    });
});

$("#replyDeleteBtn").click(function () {
    const id = $(this).data("id");
    const refType = $(this).data("ref-type");
    const refId = $(this).data("ref-id");

    if (confirm('이 답글을 삭제하시겠습니까?')) {
        $.ajax({
            url: '/comment/delete',
            method: 'post',
            data: {
                id: id,
                refType: refType,
                refId: refId
            },
            success: function () {
                alert('삭제되었습니다.');
                window.location.reload();
            },
            error: function () {
                alert('삭제 실패');
            }
        });
    }
});

$("#replyEditBtn").click(function () {
    const id = $(this).data('id');
    const content = $(this).data('content');
    const commentDiv = $(this).closest('.comment-item, .reply-item'); // 대댓글도 포함

    const original = commentDiv.find('.comment-content p');
    original.hide();

    // 중복 방지
    if (commentDiv.find('textarea.edit-area').length > 0) return;

    const textarea = $(`<textarea class="form-control mb-2 edit-area" rows="2">${content}</textarea>`);
    const saveBtn = $(`<button class="btn btn-sm btn-primary me-1 save-edit-btn">저장</button>`);
    const cancelBtn = $(`<button class="btn btn-sm btn-secondary cancel-edit-btn">취소</button>`);
    const btnGroup = $('<div class="d-flex gap-2 mt-2"></div>').append(saveBtn).append(cancelBtn);

    commentDiv.find('.comment-content').append(textarea).append(btnGroup);

    // 저장
    saveBtn.click(function () {
        const newContent = textarea.val().trim();
        if (!newContent) {
            alert("내용을 입력하세요.");
            return;
        }

        const refType = $('input[name="refType"]').val();
        const refId = $('input[name="refId"]').val();

        $.post("/comment/update", {
            id: id,
            content: newContent,
            refType: refType,
            refId: refId
        }, function (res) {
            if (res === 'success') {
                original.text(newContent).show();
                textarea.remove();
                btnGroup.remove();
            } else {
                alert("수정에 실패했습니다.");
            }
        });
    });

    // 취소
    cancelBtn.click(function () {
        textarea.remove();
        btnGroup.remove();
        original.show();
    });
});

// 대댓글 접기/펼치기
document.querySelectorAll(".toggle-replies-btn").forEach(button => {
    button.addEventListener("click", () => {
        const commentId = button.dataset.commentId;
        const replyBox = document.getElementById("replies-" + commentId);
        const icon = button.querySelector("i");

        if (replyBox.style.display === "none") {
            replyBox.style.display = "block";
            button.innerHTML = '<i class="bi bi-chevron-up me-1"></i> 답글 숨기기';
        } else {
            replyBox.style.display = "none";
            button.innerHTML = '<i class="bi bi-chevron-down me-1"></i> 답글 보기';
        }
    });
});