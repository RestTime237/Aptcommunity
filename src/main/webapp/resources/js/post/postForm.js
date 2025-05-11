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
        let data = new FormData();
        data.append("uploadImage", file);
        data.append("refType", "post");

        $.ajax({
            url: '/AptCommunity/uploadImage',
            type: 'POST',
            data: data,
            contentType: false,
            processData: false,
            success: function (url) {
                $('#summernote').summernote('insertImage', url);
            },
            error: function () {
                alert('이미지 업로드에 실패했습니다.');
            }
        });
    }
});