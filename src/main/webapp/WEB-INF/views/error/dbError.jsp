<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>DB 오류</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container py-5 text-center">
    <h2 class="text-warning"><i class="bi bi-database-exclamation me-2"></i> 데이터베이스 오류</h2>
    <p class="mt-3 text-muted">요청 처리 중 데이터베이스 오류가 발생했습니다.</p>
    <a href="${pageContext.request.contextPath}" class="btn btn-warning mt-4">홈으로 돌아가기</a>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

