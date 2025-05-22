// 채팅방 생성 모듈 초기화 함수
function initChatCreate(userId) {
    $(function () {
        // 채팅방 생성 폼 제출 처리
        $('#createRoomForm').submit(function (e) {
            e.preventDefault();

            const sender = userId; // JSP에서 전달받은 userId 사용
            const receiver = $('#targetUserId').val();

            if (!receiver) {
                showAlert("상대방 ID를 입력해주세요.", "warning");
                return;
            }

            if (sender === receiver) {
                showAlert("자신과는 채팅할 수 없습니다.", "warning");
                return;
            }

            // 로딩 상태 표시
            const submitBtn = $(this).find('button[type="submit"]');
            const originalText = submitBtn.html();
            submitBtn.html('<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> 생성 중...');
            submitBtn.prop('disabled', true);

            $.ajax({
                url: '/chat/createRoom',
                method: 'post',
                data: {
                    user1: sender,
                    user2: receiver
                },
                success: function (roomId) {
                    window.location.href = '/chat/room/' + roomId;
                },
                error: function (xhr) {
                    // 버튼 상태 복원
                    submitBtn.html(originalText);
                    submitBtn.prop('disabled', false);

                    // 오류 메시지 표시
                    if (xhr.status === 404) {
                        showAlert("존재하지 않는 사용자입니다.", "danger");
                    } else {
                        showAlert("채팅방 생성 중 오류가 발생했습니다.", "danger");
                    }
                }
            });
        });
    });

    // 알림 메시지 표시 함수
    function showAlert(message, type) {
        const alertHtml = `
                <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            `;

        // 기존 알림 제거 후 새 알림 추가
        $('.alert').remove();
        $('#createRoomForm').before(alertHtml);

        // 3초 후 자동으로 알림 닫기
        setTimeout(() => {
            $('.alert').alert('close');
        }, 3000);
    }
}