// 전역 변수 선언
let stompClient = null;
let typingTimer = null;
let isTyping = false;

// 초기화 함수 정의 (JSP에서 호출됨)
function initChat(roomId, userId, partnerName) {
    $(function () {
        // 웹소켓 연결
        connect();

        // 메시지 영역 스크롤을 맨 아래로
        scrollToBottom();

        // 메시지 입력 이벤트 처리
        const messageInput = $('#messageContent');
        const sendButton = $('#send-button');

        // 입력 내용이 있을 때만 전송 버튼 활성화
        messageInput.on('input', function () {
            const content = $(this).val().trim();
            sendButton.prop('disabled', content === '');

            // 자동 높이 조절 (최대 3줄까지)
            this.style.height = 'auto';
            const newHeight = Math.min(this.scrollHeight, 100);
            this.style.height = newHeight + 'px';

            // 스크롤이 필요한 경우 스크롤바 표시 클래스 추가
            if (this.scrollHeight > 38) { // 기본 한 줄 높이보다 크면
                $(this).addClass('scrollable');
            } else {
                $(this).removeClass('scrollable');
            }

            // 타이핑 상태 전송
            if (content !== '' && !isTyping) {
                isTyping = true;
                sendTypingStatus(true);
            } else if (content === '' && isTyping) {
                isTyping = false;
                sendTypingStatus(false);
            }

            // 타이핑 타이머 재설정
            clearTimeout(typingTimer);
            typingTimer = setTimeout(function () {
                if (isTyping) {
                    isTyping = false;
                    sendTypingStatus(false);
                }
            }, 3000);
        });

        // 엔터키로 메시지 전송 (Shift+Enter는 줄바꿈)
        messageInput.keydown(function (e) {
            if (e.keyCode === 13 && !e.shiftKey) {
                e.preventDefault();
                if (!sendButton.prop('disabled')) {
                    $('#chat-form').submit();
                }
            }
        });

        // 메시지 전송 폼 제출 처리
        $('#chat-form').submit(function (e) {
            e.preventDefault();
            const content = messageInput.val().trim();

            if (!content) return;

            const msg = {
                roomId: roomId,
                senderId: userId,
                content: content
            };

            stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(msg));
            messageInput.val('');
            messageInput.trigger('input'); // 높이 리셋 및 버튼 상태 업데이트

            // 타이핑 상태 해제
            isTyping = false;
            sendTypingStatus(false);
        });
    });

    // 웹소켓 연결 함수
    function connect() {
        const socket = new SockJS('https://aptcommunity.vps.webdock.cloud/ws');
        stompClient = Stomp.over(socket);

        // 콘솔 로그 비활성화
        stompClient.debug = null;

        stompClient.connect({}, function (frame) {
            console.log('Connected: ' + frame);

            // 채팅방별 토픽 구독
            stompClient.subscribe('/topic/room.' + roomId, function (messageOutput) {
                const msg = JSON.parse(messageOutput.body);
                appendMessage(msg);
            });

            // 타이핑 상태 토픽 구독
            stompClient.subscribe('/topic/typing.' + roomId, function (typingOutput) {
                const typingData = JSON.parse(typingOutput.body);
                if (typingData.userId !== userId) {
                    showTypingIndicator(typingData.isTyping);
                }
            });
        });
    }

    // 타이핑 상태 전송 함수
    function sendTypingStatus(isTyping) {
        if (stompClient) {
            const typingStatus = {
                roomId: roomId,
                userId: userId,
                isTyping: isTyping
            };
            stompClient.send("/app/chat.typing", {}, JSON.stringify(typingStatus));
        }
    }

    // 타이핑 표시기 표시/숨김 함수
    function showTypingIndicator(show) {
        const typingIndicator = $('#typing-indicator');
        if (show) {
            typingIndicator.addClass('active');
            $('.typing-text').text(partnerName + '님이 입력 중');
        } else {
            typingIndicator.removeClass('active');
        }
    }

    // 메시지 추가 함수
    function appendMessage(msg) {
        const isMyMessage = msg.senderId === userId;
        const messageType = isMyMessage ? 'mine' : 'other';
        const now = new Date();
        const timeString = now.getHours().toString().padStart(2, '0') + ':' +
            now.getMinutes().toString().padStart(2, '0');

        // 현재 날짜 가져오기
        const today = new Date().toLocaleDateString('ko-KR', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });

        // 마지막 날짜 구분선 확인
        const lastDateDivider = $('.date-divider:last .date-text').text().trim();

        // 날짜가 바뀌었으면 새 날짜 구분선 추가 (오늘 날짜가 아직 없는 경우에만)
        if (lastDateDivider !== today) {
            $('#chat-messages').append(`
                    <div class="date-divider">
                        <span class="date-text">${today}</span>
                    </div>
                `);
        }

        // 마지막 메시지 그룹 확인
        const lastMessageGroup = $('.message-group:last');
        const lastSender = lastMessageGroup.hasClass('mine') ? userId :
            (lastMessageGroup.hasClass('other') ? partnerName : '');

        // 같은 발신자의 연속 메시지인지 확인
        if (lastSender === msg.senderId) {
            // 같은 발신자의 연속 메시지면 기존 그룹에 추가
            lastMessageGroup.append(`
                    <div class="message ${messageType}">
                        ${!isMyMessage ? '<div class="message-sender">' + msg.senderId + '</div>' : ''}
                        <div class="message-content">${msg.content}</div>
                        <div class="message-time ${messageType}">
                            ${timeString}
                            ${isMyMessage ? '<span class="message-status"><i class="bi bi-check2"></i></span>' : ''}
                        </div>
                    </div>
                `);
        } else {
            // 다른 발신자면 새 메시지 그룹 생성
            $('#chat-messages').append(`
                    <div class="message-group ${messageType}">
                        <div class="message ${messageType}">
                            ${!isMyMessage ? '<div class="message-sender">' + msg.senderId + '</div>' : ''}
                            <div class="message-content">${msg.content}</div>
                            <div class="message-time ${messageType}">
                                ${timeString}
                                ${isMyMessage ? '<span class="message-status"><i class="bi bi-check2"></i></span>' : ''}
                            </div>
                        </div>
                    </div>
                `);
        }

        // 타이핑 표시기 숨기기
        showTypingIndicator(false);

        // 스크롤을 맨 아래로
        scrollToBottom();
    }

    // 스크롤을 맨 아래로 이동하는 함수
    function scrollToBottom() {
        const chatMessages = document.getElementById('chat-messages');
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
}