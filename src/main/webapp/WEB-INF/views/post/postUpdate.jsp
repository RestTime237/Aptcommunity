<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 수정 - 아파트 커뮤니티</title>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Summernote -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/lang/summernote-ko-KR.min.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post/postUpdate.css">

    <script src="${pageContext.request.contextPath}/resources/js/post/postUpdate.js" defer></script>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <!-- 페이지 타이틀 -->
    <div class="page-title">
        <h2 class="d-flex align-items-center">
            <i class="bi bi-pencil-square me-2 text-primary"></i>
            게시글 수정
        </h2>
        <p class="text-muted">작성한 게시글의 내용을 수정합니다.</p>
    </div>

    <!-- 게시글 수정 폼 -->
    <div class="content-card">
        <form:form modelAttribute="updatePost" method="POST" action="${pageContext.request.contextPath}/post/update" class="row g-4">
            <form:hidden path="id"/>
            <form:hidden path="userId"/>

            <!-- 카테고리 -->
            <div class="col-md-4">
                <label class="form-label">카테고리</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-tag"></i></span>
                    <form:select path="category" class="form-select">
                        <form:option value="자유">자유</form:option>
                        <form:option value="질문">질문</form:option>
                        <form:option value="정보">정보</form:option>
                        <form:option value="행사">행사</form:option>
                        <c:if test="${mb.role >= 3}">
                            <form:option value="공지">공지</form:option>
                        </c:if>
                    </form:select>
                </div>
            </div>

            <!-- 제목 -->
            <div class="col-md-12">
                <label class="form-label">제목</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-type"></i></span>
                    <form:input path="title" class="form-control" placeholder="제목을 입력하세요" required="required"/>
                </div>
            </div>

            <!-- 내용 -->
            <div class="col-md-12">
                <label class="form-label">내용</label>
                <form:textarea path="content" id="summernote" class="form-control" required="required"/>
            </div>

            <!-- 버튼 영역 -->
            <div class="col-md-12 d-flex justify-content-between mt-4">
                <div>
                    <a href="${pageContext.request.contextPath}/post/detail?id=${post.id}" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> 취소
                    </a>
                    <button type="button" id="deleteButton" class="btn btn-danger ms-2">
                        <i class="bi bi-trash me-1"></i> 삭제
                    </button>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-lg me-1"></i> 수정 완료
                </button>
            </div>

        </form:form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

</body>
</html>
