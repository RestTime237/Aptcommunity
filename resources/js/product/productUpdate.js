// Summernote 에디터 초기화
$(document).ready(function () {
    console.log("✅ Summernote 초기화 시작");

    $('#summernote').summernote({
        height: 500,
        lang: 'ko-KR',
        placeholder: '상품에 대한 자세한 설명을 입력하세요. (상태, 사용감, 구매 시기, 사용 기간 등)\n\n이미지는 에디터의 이미지 업로드 기능이나 드래그&드롭을 사용하여 첨부해주세요.',
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
                console.log("🔥 onImageUpload 실행");
                for (let i = 0; i < files.length; i++) {
                    uploadImage(files[i]);
                }
            }
        }
    });

    // 상태 버튼 클릭 이벤트
    $('.status-btn').click(function () {
        $('.status-btn').removeClass('active');
        $(this).addClass('active');
        $('#statusInput').val($(this).data('value'));

        // 나눔 선택 시 가격 0원으로 설정 및 비활성화
        if ($(this).data('value') === '나눔') {
            $('[name="price"]').val(0).prop('readonly', true);
        } else {
            $('[name="price"]').prop('readonly', false);
        }
    });

    // 초기 상태에 따른 가격 필드 설정
    if ($('#statusInput').val() === '나눔') {
        $('[name="price"]').val(0).prop('readonly', true);
    }

    // 이미지 업로드 함수
    function uploadImage(file) {
        let data = new FormData();
        data.append("uploadImage", file);
        data.append("refType", "product");

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

    // 폼 제출 전 유효성 검사
    $('form').submit(function (e) {
        // 상품명 검사
        if ($('[name="name"]').val().trim() === '') {
            alert('상품명을 입력해주세요.');
            $('[name="name"]').focus();
            e.preventDefault();
            return false;
        }

        // 가격 검사
        const price = $('[name="price"]').val();
        if (price === '' || isNaN(price) || parseInt(price) < 0) {
            alert('유효한 가격을 입력해주세요.');
            $('[name="price"]').focus();
            e.preventDefault();
            return false;
        }

        // 수량 검사
        const quantity = $('[name="quantity"]').val();
        if (quantity === '' || isNaN(quantity) || parseInt(quantity) < 1) {
            alert('유효한 수량을 입력해주세요.');
            $('[name="quantity"]').focus();
            e.preventDefault();
            return false;
        }

        // 설명 검사
        const description = $('#summernote').summernote('code');
        if (description === '<p><br></p>' || description.trim() === '') {
            alert('상품 설명을 입력해주세요.');
            $('#summernote').summernote('focus');
            e.preventDefault();
            return false;
        }

        return true;
    });
});