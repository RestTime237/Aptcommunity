document.addEventListener("DOMContentLoaded", function () {
    const postId = document.querySelector("#postId").value;

    const deleteBtn = document.querySelector("#deleteButton");
    if (deleteBtn) {
        deleteBtn.addEventListener("click", function () {
            if (confirm("게시글을 삭제하시겠습니까?")) {
                $.ajax({
                    url: "/post/delete",
                    method: "DELETE",
                    data: {id: postId},
                    success: function (res) {
                        alert("삭제되었습니다.");
                        window.location.href = "/post/list";
                    },
                    error: function (err) {
                        alert("삭제에 실패했습니다.");
                    }
                });
            }
        });
    }

    // 이미지 모달
    const imageModal = document.getElementById('imageModal');
    if (imageModal) {
        imageModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const imgSrc = button.getAttribute('data-img-src');
            const modalImage = document.getElementById('modalImage');
            modalImage.src = imgSrc;
        });
    }
});

// 대댓글 작성
document.querySelectorAll(".reply-toggle").forEach(button => {
    button.addEventListener("click", () => {
        const commentId = button.dataset.commentId;
        const replyForm = document.getElementById("replyForm-" + commentId);
        replyForm.style.display = replyForm.style.display === "none" ? "block" : "none";
    });
});

// 대댓글 삭제
document.querySelectorAll(".deleteReply").forEach(btn => {
    btn.addEventListener("click", function () {
        const replyId = this.dataset.id;
        const refType = document.querySelector("input[name='refType']").value;
        const refId = document.querySelector("input[name='refId']").value;

        if (confirm("답글을 삭제하시겠습니까?")) {
            $.ajax({
                url: "/comment/delete",
                method: "POST",
                data: {
                    id: replyId,
                    refId: refId,
                    refType: refType
                },
                success: function (res) {
                    alert("삭제되었습니다.");
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

    // 원래 댓글 내용 숨기기
    const original = commentDiv.find('.comment-content p');
    original.hide();

    // 이미 편집중이면 return
    if (commentDiv.find('textarea.edit-area').length > 0) return;

    // textarea 생성
    const textarea = $(`<textarea class="form-control mb-2 edit-area" rows="2">${content}</textarea>`);
    const saveBtn = $(`<button class="btn btn-sm btn-primary me-1 save-edit-btn">저장</button>`);
    const cancelBtn = $(`<button class="btn btn-sm btn-secondary cancel-edit-btn">취소</button>`);
    const btnGroup = $('<div class="edit-btn-group mt-2 text-end"></div>').append(saveBtn).append(cancelBtn);

    commentDiv.find('.comment-content').append(textarea).append(btnGroup);

    // 저장 처리
    saveBtn.click(function () {
        const newContent = textarea.val().trim();
        if (!newContent) {
            alert("내용을 입력하세요.");
            return;
        }

        const refType = "post";
        const refId = $("input[name='refId']").val();

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

// 대댓글 수정
$(document).on('click', '.edit-reply-btn', function () {
    const id = $(this).data('id');
    const content = $(this).data('content');
    const replyDiv = $(this).closest('.reply-item');
    const refId = document.querySelector('input[name="refId"]').value;
    const refType = document.querySelector('input[name="refType"]').value;

    // 원래 댓글 내용 숨기기
    const original = replyDiv.find('.comment-content p');
    original.hide();

    // 이미 편집중이면 return
    if (replyDiv.find('textarea.edit-area').length > 0) return;

    // textarea 생성
    const textarea = $(`<textarea class="form-control mb-2 edit-area" rows="2">${content}</textarea>`);
    const saveBtn = $(`<button class="btn btn-sm btn-primary me-1 save-edit-btn">저장</button>`);
    const cancelBtn = $(`<button class="btn btn-sm btn-secondary cancel-edit-btn">취소</button>`);
    const btnGroup = $('<div class="edit-btn-group mt-2 text-end"></div>').append(saveBtn).append(cancelBtn);

    replyDiv.find('.comment-content').append(textarea).append(btnGroup);

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

// 대댓글 등록
document.querySelectorAll(".submit-reply").forEach(button => {
    button.addEventListener("click", () => {
        const parentId = button.dataset.parentId;
        const refId = document.querySelector('input[name="refId"]').value;
        const refType = document.querySelector('input[name="refType"]').value;
        const userId = document.querySelector('input[name="userId"]').value;
        const content = button.closest('.reply-form').querySelector('textarea').value;

        if (!content.trim()) {
            alert("내용을 입력하세요.");
            return;
        }

        // JSON 데이터 생성
        const commentData = {
            refId: refId,
            refType: refType,
            userId: userId,
            content: content,
            parentId: parentId
        };

        fetch("/comment/add-ajax", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(commentData)
        })
            .then(response => response.text())
            .then(data => {
                console.log("등록 성공:", data);
                location.reload(); // 성공 후 새로고침
            })
            .catch(err => {
                console.error("에러:", err);
                alert("댓글 등록 중 문제가 발생했습니다.");
            });
    });
});

// 대댓글 접기/펼치기
document.querySelectorAll(".toggle-replies-btn").forEach(button => {
    button.addEventListener("click", () => {
        const commentId = button.dataset.commentId;
        const replyCount = button.dataset.replyCount; // data-reply-count 속성에서 값을 가져옴
        const replyBox = document.getElementById("replies-" + commentId);

        if (replyBox.style.display === "none") {
            replyBox.style.display = "block";
            button.innerHTML = '<i class="bi bi-chevron-up me-1"></i> 답글(' + replyCount + ')';
        } else {
            replyBox.style.display = "none";
            button.innerHTML = '<i class="bi bi-chevron-down me-1"></i> 답글(' + replyCount + ')';
        }
    });
});

function toggleRecommend(refType, refId) {
    $.post("/recommend", {refType, refId}, function (response) {
        if (response == "liked") {
            // 좋아요 표시
        } else if (response == "unliked") {
            // 취소 표시
        } else {
            alert("로그인이 필요합니다.");
        }
        location.reload(); // 또는 좋아요 수만 업데이트
    });
}