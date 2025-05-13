<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 수정 - 아파트 커뮤니티</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Bootstrap-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <!-- Summernote -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

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

        /* 폼 스타일 */
        .form-label {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #495057;
        }

        .form-control, .form-select {
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            border: 1px solid #dee2e6;
            transition: all 0.2s;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        /* 섹션 타이틀 */
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.5rem;
            color: #0d6efd;
        }

        /* 가격 입력 그룹 */
        .price-input-group {
            position: relative;
        }

        .price-input-group .form-control {
            padding-left: 2.5rem;
        }

        .price-input-group .currency-symbol {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            display: flex;
            align-items: center;
            padding: 0 1rem;
            font-weight: 600;
            color: #495057;
            z-index: 5;
        }

        /* 상태 선택 버튼 */
        .status-btn-group {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .status-btn {
            flex: 1;
            border-radius: 0.5rem;
            padding: 1rem;
            text-align: center;
            cursor: pointer;
            border: 2px solid #dee2e6;
            transition: all 0.2s;
            font-weight: 600;
        }

        .status-btn:hover {
            border-color: #0d6efd;
            background-color: #e7f1ff;
        }

        .status-btn.active {
            border-color: #0d6efd;
            background-color: #e7f1ff;
            color: #0d6efd;
        }

        .status-btn i {
            display: block;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        /* 버튼 스타일 */
        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
            border-radius: 0.5rem;
            padding: 0.75rem 1.5rem;
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
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-outline-primary:hover {
            background-color: #0d6efd;
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
            border-radius: 0.5rem;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* 써머노트 에디터 스타일 조정 */
        .note-editor {
            border-radius: 0.5rem;
            border: 1px solid #dee2e6 !important;
            box-shadow: none !important;
        }

        .note-editor.note-frame .note-statusbar {
            border-top: 1px solid #dee2e6;
            background-color: #f8f9fa;
        }

        .note-editor .note-toolbar {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            padding: 0.5rem;
        }

        .note-btn {
            border-radius: 0.25rem !important;
            padding: 0.25rem 0.5rem !important;
        }

        /* 도움말 박스 */
        .help-box {
            background-color: #e7f1ff;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid #0d6efd;
        }

        .help-box-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .help-box-title i {
            margin-right: 0.5rem;
            color: #0d6efd;
        }

        .help-box ul {
            margin-bottom: 0;
            padding-left: 1.5rem;
        }

        .help-box li {
            margin-bottom: 0.5rem;
        }

        .help-box li:last-child {
            margin-bottom: 0;
        }

        /* 반응형 조정 */
        @media (max-width: 768px) {
            .content-card {
                padding: 1rem;
            }

            .status-btn i {
                font-size: 1.25rem;
            }

            .status-btn {
                padding: 0.75rem 0.5rem;
                font-size: 0.875rem;
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
            <i class="bi bi-pencil-square me-2 text-primary"></i>
            상품 수정
        </h2>
        <p class="text-muted">등록한 상품 정보를 수정하세요.</p>
    </div>

    <!-- 상품 수정 폼 -->
    <div class="content-card">
        <form:form modelAttribute="updateProduct" method="post" enctype="multipart/form-data" class="row g-4">
            <!-- 상품 기본 정보 섹션 -->
            <div class="col-12">
                <h3 class="section-title">
                    <i class="bi bi-info-circle"></i> 기본 정보
                </h3>
            </div>

            <!-- 상품 상태 선택 (말머리) -->
            <div class="col-12">
                <label class="form-label">상품 상태</label>
                <div class="status-btn-group">
                    <label class="status-btn ${updateProduct.status == '새상품' ? 'active' : ''}" data-value="새상품">
                        <i class="bi bi-box-seam"></i>
                        새상품
                    </label>
                    <label class="status-btn ${updateProduct.status == '중고' ? 'active' : ''}" data-value="중고">
                        <i class="bi bi-recycle"></i>
                        중고
                    </label>
                    <label class="status-btn ${updateProduct.status == '나눔' ? 'active' : ''}" data-value="나눔">
                        <i class="bi bi-gift"></i>
                        나눔
                    </label>
                </div>
                <form:hidden path="status" id="statusInput"/>
            </div>

            <!-- 상품명 -->
            <div class="col-md-8">
                <label class="form-label">상품명</label>
                <form:input path="name" cssClass="form-control" required="required" placeholder="판매할 상품의 이름을 입력하세요"/>
            </div>

            <!-- 카테고리 -->
            <div class="col-md-4">
                <label class="form-label">카테고리</label>
                <form:select path="category" cssClass="form-select">
                    <form:option value="전자제품">전자제품</form:option>
                    <form:option value="생활용품">생활용품</form:option>
                    <form:option value="의류">의류</form:option>
                    <form:option value="식품">식품</form:option>
                    <form:option value="기타">기타</form:option>
                </form:select>
            </div>

            <!-- 가격 -->
            <div class="col-md-6">
                <label class="form-label">가격</label>
                <div class="price-input-group">
                    <span class="currency-symbol">₩</span>
                    <form:input path="price" type="number" cssClass="form-control" required="required" placeholder="0"
                                min="0"/>
                </div>
                <small class="form-text text-muted">나눔의 경우 0원으로 입력하세요.</small>
            </div>

            <!-- 수량 -->
            <div class="col-md-6">
                <label class="form-label">수량</label>
                <form:input path="quantity" type="number" cssClass="form-control" required="required" placeholder="1"
                            min="1"/>
            </div>

            <!-- 도움말 박스 -->
            <div class="col-12">
                <div class="help-box">
                    <div class="help-box-title">
                        <i class="bi bi-lightbulb"></i> 상품 수정 안내
                    </div>
                    <ul>
                        <li>상품 설명에 <strong>이미지를 추가</strong>하려면 에디터의 이미지 업로드 기능을 사용하세요.</li>
                        <li>기존 이미지를 유지하려면 설명 내용을 그대로 두세요.</li>
                        <li>이미지를 변경하려면 기존 이미지를 삭제하고 새 이미지를 업로드하세요.</li>
                        <li>상품 상태가 변경된 경우 (예: 판매중 → 예약중) 상태 변경을 반영해주세요.</li>
                    </ul>
                </div>
            </div>

            <!-- 상품 상세 정보 섹션 -->
            <div class="col-12">
                <h3 class="section-title">
                    <i class="bi bi-card-text"></i> 상세 정보
                </h3>
                <p class="text-muted mb-3">상품에 대한 자세한 설명과 이미지를 수정하세요.</p>
            </div>

            <!-- 상품 설명 (써머노트) -->
            <div class="col-12">
                <form:textarea path="description" id="summernote" cssClass="form-control"/>
            </div>

            <!-- 히든 필드 -->
            <form:hidden path="id"/>
            <form:hidden path="userId"/>

            <!-- 버튼 영역 -->
            <div class="col-12 mt-5 d-flex justify-content-between">
                <a href="/AptCommunity/product/detail?id=${updateProduct.id}" class="btn btn-outline-primary">
                    <i class="bi bi-arrow-left me-1"></i> 상품 상세로
                </a>
                <div>
                    <a href="/AptCommunity/product/list" class="btn btn-secondary me-2">
                        <i class="bi bi-x-lg me-1"></i> 취소
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i> 수정 완료
                    </button>
                </div>
            </div>
        </form:form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<script>
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
</script>
</body>
</html>
