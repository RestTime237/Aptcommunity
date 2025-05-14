// Summernote 에디터 초기화
$(document).ready(function () {
    $('#summernote').summernote({
        height: 500,
        lang: 'ko-KR',
        placeholder: '내용을 입력하세요...',
        toolbar: [
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['font', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['insert', ['picture', 'link']],
            ['view', ['fullscreen', 'codeview']]
        ],
        callbacks: {
            onImageUpload: function (files) {
                for (let i = 0; i < files.length; i++) {
                    uploadImage(files[i]);
                }
            }
        }
    });

    // 이미지 업로드 함수
    function uploadImage(file) {
        console.log("uploadImage 호출됨", file);
        let data = new FormData();
        data.append("uploadImage", file);
        data.append("refType", "post")

        $.ajax({
            url: '/AptCommunity/uploadImage',
            type: 'POST',
            data: data,
            contentType: false,
            processData: false,
            success: function (url) {
                console.log("서버 응답 URL:", url);
                $('#summernote').summernote('insertImage', url);
            },
            error: function () {
                alert('이미지 업로드에 실패했습니다.');
            }
        });
    }

    // 게시글 삭제 버튼 이벤트
    $("#deleteButton").click(function () {
        if (confirm("게시글을 삭제하시겠습니까?")) {
            const postId = "${post.id}";

            $.ajax({
                url: "/AptCommunity/post/delete",
                method: "GET",
                data: {id: postId},
                success: function (res) {
                    alert("게시글이 삭제되었습니다.");
                    window.location.href = "/AptCommunity/post/list";
                },
                error: function (err) {
                    alert("삭제에 실패했습니다.");
                }
            });
        }
    });
});