<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>채팅방 - 아파트 커뮤니티</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- WebSocket 라이브러리 CDN -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

    <!-- 이모지 선택기 스타일 -->
    <link rel="stylesheet" href="/resources/css/emoji-picker.css">

    <!-- 이모지 선택기 스크립트 -->
    <script src="${pageContext.request.contextPath}/resources/js/emoji-picker.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/chat/room.css">

    <script src="${pageContext.request.contextPath}/resources/js/chat/room.js" defer></script>

    <script>
        // DOM이 완전히 로드된 후 실행
        document.addEventListener('DOMContentLoaded', function () {
            initChat("${chatRoom.id}", "${userId}", "${chatRoom.user1 eq userId ? chatRoom.user2 : chatRoom.user1}");
        });
    </script>

</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="main-content">
    <div class="chat-container">
        <!-- 채팅방 헤더 -->
        <div class="chat-header">
            <div class="chat-header-left">
                <a href="${pageContext.request.contextPath}/chat/rooms" class="back-button">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <div class="chat-partner">
                    <c:choose>
                        <c:when test="${chatRoom.user1 eq userId}">
                            <c:if test="${not empty opponent.profileImage}">
                                <img class="partner-avatar"
                                     src="${pageContext.request.contextPath}/uploads/${opponent.profileImage}">
                            </c:if>

                            <c:if test="${empty opponent.profileImage}">
                                <div class="partner-avatar">${fn:substring(chatRoom.user2, 0, 1)}</div>
                            </c:if>
                            <div class="partner-info">
                                <div class="partner-name">${chatRoom.user2}</div>
                                <div class="partner-status">
                                    <div class="status-indicator"></div>
                                    온라인
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="partner-avatar">${fn:substring(chatRoom.user1, 0, 1)}</div>
                            <div class="partner-info">
                                <div class="partner-name">${chatRoom.user1}</div>
                                <div class="partner-status">
                                    <div class="status-indicator"></div>
                                    온라인
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="chat-header-right">
                <i class="bi bi-search header-icon"></i>
                <i class="bi bi-three-dots-vertical header-icon"></i>
            </div>
        </div>

        <!-- 채팅 메시지 영역 -->
        <div class="chat-messages" id="chat-messages">
            <!-- 날짜 구분선 (첫 메시지의 날짜 기준) -->
            <c:if test="${not empty messages}">
                <div class="date-divider">
                    <span class="date-text">
                        <fmt:formatDate value="${messages[0].sentAt}" pattern="yyyy년 MM월 dd일"/>
                    </span>
                </div>
            </c:if>

            <!-- 메시지 그룹화 및 표시 -->
            <c:set var="currentSender" value=""/>
            <c:set var="messageGroup" value="false"/>
            <c:set var="currentDate" value=""/>

            <c:forEach var="msg" items="${messages}" varStatus="status">
            <!-- 현재 메시지 날짜 가져오기 -->
            <c:set var="msgDate">
                <fmt:formatDate value="${msg.sentAt}" pattern="yyyyMMdd"/>
            </c:set>

            <!-- 첫 메시지이거나 날짜가 바뀌었을 때만 날짜 구분선 추가 -->
            <c:if test="${status.index > 0 && currentDate ne msgDate}">
            <!-- 이전 메시지 그룹 닫기 -->
            <c:if test="${messageGroup}">
        </div>
        <c:set var="messageGroup" value="false"/>
        </c:if>

        <div class="date-divider">
                        <span class="date-text">
                            <fmt:formatDate value="${msg.sentAt}" pattern="yyyy년 MM월 dd일"/>
                        </span>
        </div>
        </c:if>

        <!-- 현재 날짜 저장 -->
        <c:set var="currentDate" value="${msgDate}"/>

        <!-- 발신자가 바뀌거나 첫 메시지인 경우 새 메시지 그룹 시작 -->
        <c:if test="${currentSender ne msg.senderId || !messageGroup}">
        <!-- 이전 메시지 그룹 닫기 -->
        <c:if test="${messageGroup}">
    </div>
    </c:if>

    <c:set var="messageType" value="${msg.senderId == userId ? 'mine' : 'other'}"/>
    <div class="message-group ${messageType}">
        <c:set var="messageGroup" value="true"/>
        <c:set var="currentSender" value="${msg.senderId}"/>
        </c:if>

        <div class="message ${msg.senderId == userId ? 'mine' : 'other'}">
            <c:if test="${msg.senderId != userId}">
                <div class="message-sender">${msg.senderId}</div>
            </c:if>
            <div class="message-content">${msg.content}</div>
            <div class="message-time ${msg.senderId == userId ? 'mine' : 'other'}">
                <fmt:formatDate value="${msg.sentAt}" pattern="HH:mm"/>
                <c:if test="${msg.senderId == userId}">
                            <span class="message-status">
                                <i class="bi bi-check2"></i>
                            </span>
                </c:if>
            </div>
        </div>
        </c:forEach>

        <!-- 마지막 메시지 그룹 닫기 -->
        <c:if test="${messageGroup}">
    </div>
    </c:if>
</div>

<!-- 메시지 입력 영역 -->
<div class="chat-input">
    <!-- 이모지 선택기 -->
    <div class="emoji-picker" id="emoji-picker">
        <div class="emoji-picker-header">
            <div class="emoji-picker-title">이모지 선택</div>
            <button class="emoji-picker-close" id="emoji-picker-close">
                <i class="bi bi-x"></i>
            </button>
        </div>
        <div class="emoji-categories">
            <button class="emoji-category active" data-category="smileys">
                <i class="bi bi-emoji-smile"></i>
            </button>
            <button class="emoji-category" data-category="people">
                <i class="bi bi-people"></i>
            </button>
            <button class="emoji-category" data-category="animals">
                <i class="bi bi-piggy-bank"></i>
            </button>
            <button class="emoji-category" data-category="food">
                <i class="bi bi-cup-hot"></i>
            </button>
            <button class="emoji-category" data-category="travel">
                <i class="bi bi-car-front"></i>
            </button>
            <button class="emoji-category" data-category="activities">
                <i class="bi bi-controller"></i>
            </button>
            <button class="emoji-category" data-category="objects">
                <i class="bi bi-lightbulb"></i>
            </button>
            <button class="emoji-category" data-category="symbols">
                <i class="bi bi-heart"></i>
            </button>
        </div>
        <div class="emoji-grid" id="emoji-grid">
            <!-- 이모지는 JavaScript로 동적 생성 -->
        </div>
    </div>

    <form id="chat-form">
        <div class="chat-input-wrapper position-relative">
            <textarea id="messageContent" class="message-input" placeholder="메시지를 입력하세요..." rows="1"
                      required></textarea>

            <div class="input-buttons position-absolute end-0 top-50 translate-middle-y d-flex me-2">
                <button type="button" class="emoji-button btn btn-sm me-1" id="emoji-button">
                    <i class="bi bi-emoji-smile"></i>
                </button>
                <button type="submit" class="send-button btn btn-sm bg-light rounded-circle" id="send-button" disabled>
                    <i class="bi bi-send-fill"></i>
                </button>
            </div>
        </div>
    </form>


    <!-- 타이핑 표시기 -->
    <div class="typing-indicator" id="typing-indicator">
        <span class="typing-text">상대방이 입력 중</span>
        <div class="typing-dots">
            <div class="typing-dot"></div>
            <div class="typing-dot"></div>
            <div class="typing-dot"></div>
        </div>
    </div>
</div>
</div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

</body>
</html>
