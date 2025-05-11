let calendar;
document.addEventListener('DOMContentLoaded', function () {
    const calendarEl = document.getElementById('calendar');

    calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,listMonth'
        },
        buttonText: {
            today: '오늘',
            month: '월',
            week: '주',
            list: '목록'
        },
        dayMaxEvents: true,
        navLinks: true,

        events: function (info, successCallback, failureCallback) {
            $.ajax({
                url: '/AptCommunity/schedule/list',
                method: 'GET',
                data: {
                    start: info.startStr,
                    end: info.endStr
                },
                success: function (data) {
                    // data는 [{ id, title, start, end, ... }] 형태의 배열이어야 함
                    successCallback(data);
                    updateUpcomingEvents(data);
                },
                error: function () {
                    failureCallback();
                    // 에러 시 샘플 데이터로 대체
                    displaySampleUpcomingEvents();
                }
            });
        },

        editable: true,

        dateClick: function (info) {
            openScheduleModal({
                mode: 'add',
                start: info.dateStr
            });
        },

        eventClick: function (info) {
            openScheduleModal({
                mode: 'edit',
                id: info.event.id,
                title: info.event.title,
                description: info.event.extendedProps.description,
                start: info.event.startStr,
                end: adjustEndDate(info.event.end),
                category: info.event.extendedProps.category,
                publicFlag: info.event.extendedProps.publicFlag
            });

            console.log("📌 클릭한 이벤트 ID:", info.event.id);
        },

        eventDrop: function (info) {
            const id = info.event.id;
            const newStart = info.event.startStr;
            const newEnd = adjustEndDateBack(info.event.end);

            // 끝일 없을 경우 보정
            const payload = {
                id: parseInt(id),
                startDate: newStart,
                endDate: newEnd || newStart
            };

            $.ajax({
                url: '/AptCommunity/schedule/move',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function (res) {
                    // 성공 시 알림 표시
                    showToast('일정이 이동되었습니다.', 'success');
                },
                error: function (err) {
                    showToast('이동 실패', 'danger');
                    info.revert();
                }
            });
        },

        eventResize: function (info) {
            const id = info.event.id;
            const newEnd = adjustEndDateBack(info.event.end);

            const payload = {
                id: parseInt(id),
                endDate: newEnd
            };

            $.ajax({
                url: '/AptCommunity/schedule/resize',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function (res) {
                    showToast('일정 기간이 변경되었습니다.', 'success');
                },
                error: function (err) {
                    showToast('종료일 변경 실패', 'danger');
                    info.revert();
                }
            });
        },

        eventClassNames: function (arg) {
            console.log("📌 클래스 적용 확인:", arg.event.extendedProps.category);
            return [`category-${arg.event.extendedProps.category}`];
        },
    });

    calendar.render();

    // 플로팅 버튼 클릭 시 오늘 날짜로 일정 추가 모달 열기
    document.getElementById('quickAddEvent').addEventListener('click', function (e) {
        e.preventDefault();
        const today = new Date().toISOString().split('T')[0];
        openScheduleModal({
            mode: 'add',
            start: today
        });
    });
});

// 다가오는 일정 업데이트
function updateUpcomingEvents(events) {
    const upcomingEventsEl = document.getElementById('upcomingEvents');
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // 오늘 이후의 이벤트만 필터링하고 날짜순으로 정렬
    const futureEvents = events
        .filter(event => {
            const eventDate = new Date(event.start);
            return eventDate >= today;
        })
        .sort((a, b) => new Date(a.start) - new Date(b.start))
        .slice(0, 5); // 최대 5개만 표시

    if (futureEvents.length === 0) {
        upcomingEventsEl.innerHTML = `
    <div class="text-center text-muted py-4">
      <i class="bi bi-calendar fs-1"></i>
      <p class="mt-2">다가오는 일정이 없습니다.</p>
    </div>
  `;
        return;
    }

    let html = '<ul class="list-group list-group-flush">';

    futureEvents.forEach(event => {
        const eventDate = new Date(event.start);
        const formattedDate = `${eventDate.getFullYear()}-${String(eventDate.getMonth() + 1).padStart(2, '0')}-${String(eventDate.getDate()).padStart(2, '0')}`;

        let badgeClass = '';
        console.log('카테고리 내용물 : ', event.extendedProps.category);
        switch (event.extendedProps.category) {
            case '환경': badgeClass = 'bg-success'; break;
            case '소독': badgeClass = 'bg-danger'; break;
            case '회의': badgeClass = 'bg-primary'; break;
            default: badgeClass = 'bg-secondary';
        }

        html += `
    <li class="list-group-item d-flex align-items-center">
      <div class="me-3 text-center">
        <div class="small text-muted">${formattedDate}</div>
      </div>
      <div class="flex-grow-1">
        <div class="d-flex align-items-center">
          <span class="badge ${badgeClass} me-2">${event.extendedProps.category}</span>
          <h6 class="mb-0">${event.title}</h6>
        </div>
        ${event.extendedProps.description ? `<small class="text-muted">${event.extendedProps.description}</small>` : ''}
      </div>
    </li>
  `;
    });

    html += '</ul>';
    upcomingEventsEl.innerHTML = html;
}

// 샘플 다가오는 일정 표시 (API 호출 실패 시)
function displaySampleUpcomingEvents() {
    const upcomingEventsEl = document.getElementById('upcomingEvents');

    upcomingEventsEl.innerHTML = `
  <ul class="list-group list-group-flush">
    <li class="list-group-item d-flex align-items-center">
      <div class="me-3 text-center">
        <div class="small text-muted">2025-05-25</div>
      </div>
      <div class="flex-grow-1">
        <div class="d-flex align-items-center">
          <span class="badge bg-success me-2">환경</span>
          <h6 class="mb-0">단지 내 조경 관리</h6>
        </div>
        <small class="text-muted">아파트 정원 및 조경 관리 작업</small>
      </div>
    </li>
    <li class="list-group-item d-flex align-items-center">
      <div class="me-3 text-center">
        <div class="small text-muted">2025-05-28</div>
      </div>
      <div class="flex-grow-1">
        <div class="d-flex align-items-center">
          <span class="badge bg-danger me-2">소독</span>
          <h6 class="mb-0">정기 방역 소독</h6>
        </div>
        <small class="text-muted">전체 단지 방역 소독 실시</small>
      </div>
    </li>
    <li class="list-group-item d-flex align-items-center">
      <div class="me-3 text-center">
        <div class="small text-muted">2025-06-01</div>
      </div>
      <div class="flex-grow-1">
        <div class="d-flex align-items-center">
          <span class="badge bg-primary me-2">회의</span>
          <h6 class="mb-0">입주자 대표 회의</h6>
        </div>
        <small class="text-muted">관리비 인상 안건 논의</small>
      </div>
    </li>
  </ul>
`;
}

function openScheduleModal(data) {
    const form = document.querySelector('#scheduleForm');

    form.mode.value = data.mode;
    form.id.value = data.id || '';
    form.title.value = data.title || '';
    form.description.value = data.description || '';
    form.start.value = data.start || '';
    form.end.value = data.end || data.start || '';
    form.category.value = data.category || '환경';
    form.publicFlag.value = data.publicFlag === false ? 'false' : 'true';

    document.querySelector('#modalTitle').textContent = (data.mode === 'add') ? '일정 등록' : '일정 수정';

    // 삭제 버튼은 수정 모드에서만 표시
    document.querySelector('#deleteButton').style.display = (data.mode === 'add') ? 'none' : 'inline-block';

    const modal = new bootstrap.Modal(document.getElementById('scheduleModal'));
    modal.show();
}

$('#scheduleForm').submit(function (e) {
    e.preventDefault();

    const formData = new FormData(this);
    const raw = Object.fromEntries(formData.entries());

    console.log("raw.id =", raw.id, "→ parsed =", parseInt(raw.id));

    const json = {
        id: raw.id ? parseInt(raw.id) : null,
        title: raw.title,
        description: raw.description,
        startDate: raw.start,
        endDate: raw.end,
        category: raw.category,
        publicFlag: raw.publicFlag === "true"
    };

    $.ajax({
        url: `/AptCommunity/schedule/${raw.mode}`,
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(json),
        success: function (res) {
            showToast('일정이 저장되었습니다.', 'success');
            bootstrap.Modal.getInstance(document.getElementById('scheduleModal')).hide();
            calendar.refetchEvents();
        },
        error: function (err) {
            showToast('저장 실패', 'danger');
        }
    });
});

$("#deleteButton").click(function () {
    const id = document.querySelector('input[name="id"]').value;

    if (!id) {
        showToast('삭제할 일정의 ID가 없습니다.', 'danger');
        return;
    }

    if (!confirm("정말 삭제하시겠습니까?")) return;

    $.ajax({
        url: '/AptCommunity/schedule/delete',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ id: parseInt(id) }),
        success: function (res) {
            showToast('일정이 삭제되었습니다.', 'success');
            bootstrap.Modal.getInstance(document.getElementById('scheduleModal')).hide();
            calendar.refetchEvents();
        },
        error: function (err) {
            showToast('삭제 실패', 'danger');
        }
    });
});

function adjustEndDate(end) {
    if (!end) return null;

    const date = new Date(end); // Date 객체 생성 (브라우저 시간 기준)
    date.setDate(date.getDate() - 1); // 하루 빼기

    // 로컬 날짜로 문자열 반환 (UTC X)
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');

    return `${year}-${month}-${day}`;
}

function adjustEndDateBack(endDateObj) {
    if (!endDateObj) return null;

    const date = new Date(endDateObj);
    date.setDate(date.getDate() - 1);

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');

    return `${year}-${month}-${day}`;
}

// 토스트 알림 표시 함수
function showToast(message, type = 'primary') {
    // 기존 토스트가 있으면 제거
    const existingToast = document.querySelector('.toast-container');
    if (existingToast) {
        existingToast.remove();
    }

    // 토스트 컨테이너 생성
    const toastContainer = document.createElement('div');
    toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
    toastContainer.style.zIndex = '1050';

    // 토스트 HTML 생성
    toastContainer.innerHTML = `
  <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="toast-header bg-${type} text-white">
      <strong class="me-auto">알림</strong>
      <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
    <div class="toast-body">
      ${message}
    </div>
  </div>
`;

    // 문서에 추가
    document.body.appendChild(toastContainer);

    // 5초 후 자동으로 사라지게 설정
    setTimeout(() => {
        const toast = document.querySelector('.toast');
        if (toast) {
            const bsToast = new bootstrap.Toast(toast);
            bsToast.hide();
        }
    }, 5000);
}