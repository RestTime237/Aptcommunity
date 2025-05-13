<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 등록 - 아파트 커뮤니티</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Bootstrap-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <!-- Summernote -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product/productForm.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <!-- 페이지 타이틀 -->
    <div class="page-title">
        <h2 class="d-flex align-items-center">
            <i class="bi bi-bag-plus me-2 text-primary"></i>
            상품 등록
        </h2>
        <p class="text-muted">이웃 주민들에게 판매할 상품을 등록하세요.</p>
    </div>

    <!-- 상품 등록 폼 -->
    <div class="content-card">
        <form:form modelAttribute="NewProduct" method="post" enctype="multipart/form-data" class="row g-4">
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
                    <label class="status-btn active" data-value="새상품">
                        <i class="bi bi-box-seam"></i>
                        새상품
                    </label>
                    <label class="status-btn" data-value="중고">
                        <i class="bi bi-recycle"></i>
                        중고
                    </label>
                    <label class="status-btn" data-value="나눔">
                        <i class="bi bi-gift"></i>
                        나눔
                    </label>
                </div>
                <form:hidden path="status" value="새상품" id="statusInput"/>
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
                        <i class="bi bi-lightbulb"></i> 상품 등록 팁
                    </div>
                    <ul>
                        <li><strong>상세한 설명</strong>을 작성하면 판매 확률이 높아집니다.</li>
                        <li><strong>여러 각도의 사진</strong>을 첨부하면 구매자의 신뢰를 얻을 수 있습니다.</li>
                        <li>중고 상품의 경우 <strong>사용 기간과 상태</strong>를 자세히 설명해주세요.</li>
                        <li>에디터의 <strong>이미지 업로드 기능이나 드래그&드롭</strong>을 사용하여 상품 사진을 첨부할 수 있습니다.</li>
                    </ul>
                </div>
            </div>

            <!-- 상품 상세 정보 섹션 -->
            <div class="col-12">
                <h3 class="section-title">
                    <i class="bi bi-card-text"></i> 상세 정보
                </h3>
                <p class="text-muted mb-3">상품에 대한 자세한 설명과 이미지를 함께 등록해주세요.</p>
            </div>

            <!-- 상품 설명 (써머노트) -->
            <div class="col-12">
                <form:textarea path="description" id="summernote" cssClass="form-control"/>
            </div>

            <!-- 버튼 영역 -->
            <div class="col-12 mt-5 d-flex justify-content-between">
                <a href="${pageContext.request.contextPath}/product/list" class="btn btn-outline-primary">
                    <i class="bi bi-arrow-left me-1"></i> 목록으로
                </a>
                <div>
                    <button type="reset" class="btn btn-outline-primary me-2">
                        <i class="bi bi-arrow-counterclockwise me-1"></i> 초기화
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i> 등록하기
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
<script src="${pageContext.request.contextPath}/resources/js/product/productForm.js"></script>
</body>
</html>
