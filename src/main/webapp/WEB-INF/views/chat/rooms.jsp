<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>채팅방 목록 - 아파트 커뮤니티</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/chat/rooms.css"/>

    <script src="${pageContext.request.contextPath}/resources/js/chat/rooms.js" defer></script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            initChatCreate("${sessionScope.userId}");
        });
    </script>

</head>

<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <!-- 페이지 타이틀 -->
    <div class="page-title">
        <h2>
            <div class="chat-icon">
                <i class="bi bi-chat-dots-fill"></i>
            </div>
            채팅방 목록
        </h2>
        <p>이웃과 실시간으로 대화를 나눌 수 있는 공간입니다.</p>
    </div>

    <!-- 새 채팅방 생성 카드 -->
    <div class="new-chat-card">
        <h3 class="new-chat-title">
            <i class="bi bi-plus-circle-fill"></i>
            새로운 채팅 시작
        </h3>

        <form id="createRoomForm" class="new-chat-form">
            <div class="form-floating">
                <input type="text" id="targetUserId" class="form-control" placeholder="상대방 ID 입력" required/>
                <label for="targetUserId">상대방 ID 입력</label>
            </div>
            <button type="submit" class="btn btn-create">
                <i class="bi bi-chat-text-fill"></i>
                채팅방 생성
            </button>
        </form>
    </div>

    <!-- 채팅방 목록 -->
    <div class="chat-rooms-container">
        <c:choose>
            <c:when test="${empty chatRooms}">
                <!-- 빈 상태 표시 -->
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="bi bi-chat-square-text"></i>
                    </div>
                    <h4 class="empty-state-title">참여 중인 채팅방이 없습니다</h4>
                    <p class="empty-state-text">새로운 채팅을 시작하여 이웃과 대화를 나눠보세요.</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 채팅방 카드 목록 -->
                <c:forEach var="room" items="${chatRooms}">
                    <c:if test="${room.user1 eq sessionScope.userId || room.user2 eq sessionScope.userId}">
                        <div class="chat-room-card">
                            <div class="chat-room-body">
                                <c:choose>
                                    <c:when test="${room.user1 eq sessionScope.userId}">
                                        <c:set var="opponent" value="${members[room.id]}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="opponent" value="${members[room.id]}"/>
                                    </c:otherwise>
                                </c:choose>

                                <!-- 프로필 이미지가 존재하면 출력, 없으면 첫 글자 표시 -->
                                <div class="user-avatar">
                                    <c:choose>
                                        <c:when test="${not empty opponent.profileImage}">
                                            <img src="${pageContext.request.contextPath}/uploads/${opponent.profileImage}"
                                                 alt="Profile">
                                        </c:when>
                                        <c:otherwise>
                                            ${fn:substring(opponent.userId, 0, 1)}
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="user-info">
                                    <div class="user-name">
                                            ${opponent.userId}
                                    </div>
                                    <div class="last-activity">
                                        <i class="bi bi-clock me-1"></i> 마지막 활동:
                                        <fmt:formatDate value="${room.updatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </div>
                                </div>

                                <a href="${pageContext.request.contextPath}/chat/room/${room.id}" class="btn btn-enter">
                                    <i class="bi bi-box-arrow-in-right"></i>
                                    입장하기
                                </a>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

</body>

</html>
