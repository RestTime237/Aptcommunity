<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>오류 발생</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container py-5 text-center">
    <h2 class="text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i> 오류가 발생했습니다</h2>
    <p class="mt-3 text-muted">${errorMessage}</p>
    <a href="${pageContext.request.contextPath}" class="btn btn-outline-primary mt-4">홈으로 돌아가기</a>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
