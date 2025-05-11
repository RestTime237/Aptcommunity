<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>페이지를 찾을 수 없습니다</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<div class="container py-5 text-center">
	    <h2 class="text-danger"><i class="bi bi-x-octagon-fill me-2"></i> 404 - 페이지를 찾을 수 없습니다</h2>
	    <p class="mt-3 text-muted">요청하신 페이지가 존재하지 않거나 삭제되었습니다.</p>
	    <a href="/AptCommunity" class="btn btn-outline-secondary mt-4">홈으로 돌아가기</a>
    </div>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>