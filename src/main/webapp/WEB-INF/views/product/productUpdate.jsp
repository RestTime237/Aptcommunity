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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product/productUpdate.css"/>
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
                <a href="${pageContext.request.contextPath}/product/detail?id=${updateProduct.id}" class="btn btn-outline-primary">
                    <i class="bi bi-arrow-left me-1"></i> 상품 상세로
                </a>
                <div>
                    <a href="${pageContext.request.contextPath}/product/list" class="btn btn-secondary me-2">
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
    // Define contextPath for the external JS file
    var contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/resources/js/product/productUpdate.js"></script>
</body>
</html>
