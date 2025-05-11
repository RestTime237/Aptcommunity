<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>우리 아파트 일정</title>

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
  
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
  
  <!-- FullCalendar & jQuery -->
  <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

  <style>
    :root {
      --primary-color: #0d6efd;
      --secondary-color: #6c757d;
      --success-color: #28a745;
      --danger-color: #dc3545;
      --warning-color: #ffc107;
      --info-color: #17a2b8;
      --light-color: #f8f9fa;
      --dark-color: #343a40;
    }
    
    body {
      background-color: #f8f9fa;
      font-family: 'Noto Sans KR', sans-serif;
      color: #333;
    }

    .page-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 2rem 1rem;
    }

    .calendar-container {
      background-color: white;
      border-radius: 1rem;
      box-shadow: 0 10px 30px rgba(0,0,0,0.08);
      overflow: hidden;
      margin-bottom: 2rem;
    }
    
    .calendar-header {
      background: linear-gradient(135deg, #0d6efd, #0a58ca);
      color: white;
      padding: 2rem;
      position: relative;
      overflow: hidden;
    }
    
    .calendar-header::before {
      content: '';
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      background: url('${pageContext.request.contextPath}/resources/images/pattern.svg');
      background-size: cover;
      opacity: 0.1;
    }
    
    .calendar-header-content {
      position: relative;
      z-index: 1;
    }
    
    .calendar-title {
      font-size: 2rem;
      font-weight: 700;
      margin-bottom: 0.5rem;
    }
    
    .calendar-subtitle {
      font-size: 1.1rem;
      opacity: 0.9;
    }

    #calendar {
      padding: 2rem;
    }
    
    /* FullCalendar Customization */
    .fc-theme-standard .fc-scrollgrid {
      border: none;
    }
    
    .fc .fc-toolbar-title {
      font-size: 1.5rem;
      font-weight: 600;
    }
    
    .fc .fc-button-primary {
      background-color: var(--primary-color);
      border-color: var(--primary-color);
      box-shadow: none;
      transition: all 0.2s ease;
    }
    
    .fc .fc-button-primary:hover {
      background-color: #0b5ed7;
      border-color: #0a58ca;
    }
    
    .fc .fc-daygrid-day-top {
      justify-content: center;
      padding-top: 0.5rem;
    }
    
    .fc .fc-daygrid-day-number {
      font-size: 1rem;
      font-weight: 500;
      color: #495057;
    }
    
    .fc .fc-col-header-cell-cushion {
      font-weight: 600;
      color: #495057;
      padding: 0.75rem 0;
    }
    
    .fc-day-today .fc-daygrid-day-number {
	  color: #007bff;
	  font-weight: bold;
	  padding-bottom: 2px;
	}

    
    .fc-event {
      border-radius: 4px;
      padding: 3px 5px;
      font-size: 0.85rem;
      border: none;
      transition: transform 0.2s ease;
    }
    
    .fc-event:hover {
      transform: translateY(-2px);
    }

    /* Category Colors */
    .fc-event.category-환경 {
      background-color: #28a745 !important;
      border-left: 4px solid #1e7e34 !important;
      color: white !important;
    }

    .fc-event.category-소독 {
      background-color: #dc3545 !important;
      border-left: 4px solid #bd2130 !important;
      color: white !important;
    }

    .fc-event.category-회의 {
      background-color: #0d6efd !important;
      border-left: 4px solid #0a58ca !important;
      color: white !important;
    }
    
    /* Category Legend */
    .category-legend {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      margin-bottom: 1.5rem;
      padding: 0 2rem;
    }
    
    .legend-item {
      display: flex;
      align-items: center;
      font-size: 0.9rem;
    }
    
    .legend-color {
      width: 16px;
      height: 16px;
      border-radius: 4px;
      margin-right: 0.5rem;
    }
    
    .legend-color.환경 {
      background-color: #28a745;
    }
    
    .legend-color.소독 {
      background-color: #dc3545;
    }
    
    .legend-color.회의 {
      background-color: #0d6efd;
    }
    
    /* Add Event Button */
    .add-event-btn {
      position: fixed;
      bottom: 2rem;
      right: 2rem;
      width: 60px;
      height: 60px;
      border-radius: 50%;
      background-color: var(--primary-color);
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
      box-shadow: 0 4px 10px rgba(13, 110, 253, 0.3);
      transition: all 0.3s ease;
      z-index: 1000;
    }
    
    .add-event-btn:hover {
      transform: scale(1.1);
      background-color: #0b5ed7;
      color: white;
    }
    
    /* Modal Customization */
    .modal-content {
      border: none;
      border-radius: 1rem;
      overflow: hidden;
    }
    
    .modal-header {
      padding: 1.5rem;
      border-bottom: none;
    }
    
    .modal-body {
      padding: 1.5rem;
    }
    
    .modal-footer {
      padding: 1.5rem;
      border-top: 1px solid rgba(0,0,0,0.05);
    }
    
    .form-label {
      font-weight: 500;
      margin-bottom: 0.5rem;
    }
    
    .form-control, .form-select {
      padding: 0.75rem 1rem;
      border-radius: 0.5rem;
      border: 1px solid rgba(0,0,0,0.1);
      transition: all 0.2s ease;
    }
    
    .form-control:focus, .form-select:focus {
      border-color: var(--primary-color);
      box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
    }
    
    .btn {
      padding: 0.75rem 1.5rem;
      border-radius: 0.5rem;
      font-weight: 500;
      transition: all 0.2s ease;
    }
    
    .btn-primary {
      background-color: var(--primary-color);
      border-color: var(--primary-color);
    }
    
    .btn-primary:hover {
      background-color: #0b5ed7;
      border-color: #0a58ca;
    }
    
    .btn-danger {
      background-color: var(--danger-color);
      border-color: var(--danger-color);
    }
    
    .btn-danger:hover {
      background-color: #c82333;
      border-color: #bd2130;
    }
    
    /* Responsive Adjustments */
    @media (max-width: 768px) {
      .calendar-header {
        padding: 1.5rem;
      }
      
      .calendar-title {
        font-size: 1.5rem;
      }
      
      .calendar-subtitle {
        font-size: 1rem;
      }
      
      #calendar {
        padding: 1rem;
      }
      
      .fc .fc-toolbar {
        flex-direction: column;
        gap: 1rem;
      }
      
      .fc .fc-toolbar-title {
        font-size: 1.2rem;
      }
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/common/header.jsp" />

  <div class="page-container">
    <div class="calendar-container">
      <div class="calendar-header">
        <div class="calendar-header-content">
          <h1 class="calendar-title">우리 아파트 일정</h1>
          <p class="calendar-subtitle">아파트 주요 행사와 일정을 확인하고 관리하세요</p>
        </div>
      </div>
      
      <div class="category-legend">
        <div class="legend-item">
          <div class="legend-color 환경"></div>
          <span>환경</span>
        </div>
        <div class="legend-item">
          <div class="legend-color 소독"></div>
          <span>소독</span>
        </div>
        <div class="legend-item">
          <div class="legend-color 회의"></div>
          <span>회의</span>
        </div>
      </div>
      
      <div id='calendar'></div>
    </div>
    
    <div class="row">
      <div class="col-md-6 mb-4">
        <div class="card h-100 shadow-sm">
          <div class="card-header bg-primary text-white">
            <h5 class="mb-0"><i class="bi bi-info-circle me-2"></i> 일정 안내</h5>
          </div>
          <div class="card-body">
            <ul class="list-group list-group-flush">
              <li class="list-group-item d-flex align-items-center">
                <i class="bi bi-check-circle-fill text-success me-2"></i>
                날짜를 클릭하여 새로운 일정을 추가할 수 있습니다.
              </li>
              <li class="list-group-item d-flex align-items-center">
                <i class="bi bi-check-circle-fill text-success me-2"></i>
                기존 일정을 클릭하여 수정하거나 삭제할 수 있습니다.
              </li>
              <li class="list-group-item d-flex align-items-center">
                <i class="bi bi-check-circle-fill text-success me-2"></i>
                일정을 드래그하여 날짜를 변경할 수 있습니다.
              </li>
              <li class="list-group-item d-flex align-items-center">
                <i class="bi bi-check-circle-fill text-success me-2"></i>
                일정의 끝을 드래그하여 기간을 조정할 수 있습니다.
              </li>
            </ul>
          </div>
        </div>
      </div>
      
      <div class="col-md-6 mb-4">
        <div class="card h-100 shadow-sm">
          <div class="card-header bg-warning text-dark">
            <h5 class="mb-0"><i class="bi bi-calendar-event me-2"></i> 다가오는 주요 일정</h5>
          </div>
          <div class="card-body">
            <div class="upcoming-events" id="upcomingEvents">
              <div class="d-flex align-items-center justify-content-center h-100">
                <div class="text-center text-muted">
                  <i class="bi bi-calendar-check fs-1"></i>
                  <p class="mt-2">다가오는 일정을 불러오는 중...</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  <!-- 모달 -->
  <div class="modal fade" id="scheduleModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <form id="scheduleForm">
          <div class="modal-header bg-primary text-white">
            <h5 class="modal-title" id="modalTitle">일정</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <input type="hidden" name="id" />
            <input type="hidden" name="mode" />

            <div class="mb-3">
              <label class="form-label">제목</label>
              <input type="text" name="title" class="form-control" required />
            </div>

            <div class="mb-3">
              <label class="form-label">설명</label>
              <textarea name="description" class="form-control" rows="3"></textarea>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label">시작일</label>
                <input type="date" name="start" class="form-control" required />
              </div>

              <div class="col-md-6 mb-3">
                <label class="form-label">종료일</label>
                <input type="date" name="end" class="form-control" required />
              </div>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label class="form-label">카테고리</label>
                <select name="category" class="form-select">
                  <option value="환경">환경</option>
                  <option value="소독">소독</option>
                  <option value="회의">회의</option>
                </select>
              </div>

              <div class="col-md-6 mb-3">
                <label class="form-label">공개여부</label>
                <select name="publicFlag" class="form-select">
                  <option value="true">공개</option>
                  <option value="false">비공개</option>
                </select>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
              <i class="bi bi-x-lg me-1"></i> 닫기
            </button>
            <button type="submit" class="btn btn-primary">
              <i class="bi bi-save me-1"></i> 저장
            </button>
            <button type="button" class="btn btn-danger" id="deleteButton">
              <i class="bi bi-trash me-1"></i> 삭제
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
  
  <!-- 플로팅 버튼 -->
  <a href="#" class="add-event-btn" id="quickAddEvent">
    <i class="bi bi-plus-lg"></i>
  </a>
  
  <jsp:include page="/WEB-INF/views/common/footer.jsp" />

  <script>
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

      dateClick: function(info) {
        openScheduleModal({
          mode: 'add',
          start: info.dateStr
        });
      },
      
      eventClick: function(info) {
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
      
      eventDrop: function(info) {
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
          success: function(res) {
            // 성공 시 알림 표시
            showToast('일정이 이동되었습니다.', 'success');
          },
          error: function(err) {
            showToast('이동 실패', 'danger');
            info.revert();
          }
        });
      },
      
      eventResize: function(info) {
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
          success: function(res) {
            showToast('일정 기간이 변경되었습니다.', 'success');
          },
          error: function(err) {
            showToast('종료일 변경 실패', 'danger');
            info.revert();
          }
        });
      },
      
      eventClassNames: function(arg) {
        console.log("📌 클래스 적용 확인:", arg.event.extendedProps.category);
        return [ `category-\${arg.event.extendedProps.category}` ]; 
      },
    });
    
    calendar.render();
    
    // 플로팅 버튼 클릭 시 오늘 날짜로 일정 추가 모달 열기
    document.getElementById('quickAddEvent').addEventListener('click', function(e) {
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
      const formattedDate = `\${eventDate.getFullYear()}-\${String(eventDate.getMonth() + 1).padStart(2, '0')}-\${String(eventDate.getDate()).padStart(2, '0')}`;
      
      let badgeClass = '';
      console.log('카테고리 내용물 : ',event.extendedProps.category);
      switch(event.extendedProps.category) {
        case '환경': badgeClass = 'bg-success'; break;
        case '소독': badgeClass = 'bg-danger'; break;
        case '회의': badgeClass = 'bg-primary'; break;
        default: badgeClass = 'bg-secondary';
      }
      
      html += `
        <li class="list-group-item d-flex align-items-center">
          <div class="me-3 text-center">
            <div class="small text-muted">\${formattedDate}</div>
          </div>
          <div class="flex-grow-1">
            <div class="d-flex align-items-center">
              <span class="badge \${badgeClass} me-2">\${event.extendedProps.category}</span>
              <h6 class="mb-0">\${event.title}</h6>
            </div>
            \${event.extendedProps.description ? `<small class="text-muted">\${event.extendedProps.description}</small>` : ''}
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
            <div class="small text-muted">2025-04-25</div>
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
            <div class="small text-muted">2025-04-28</div>
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
            <div class="small text-muted">2025-05-01</div>
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
      url: `/AptCommunity/schedule/\${raw.mode}`,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(json),
      success: function(res) {
        showToast('일정이 저장되었습니다.', 'success');
        bootstrap.Modal.getInstance(document.getElementById('scheduleModal')).hide();
        calendar.refetchEvents();
      },
      error: function(err) {
        showToast('저장 실패', 'danger');
      }
    });
  });

  $("#deleteButton").click(function() {
    const id = document.querySelector('input[name="id"]').value;
    
    if(!id) {
      showToast('삭제할 일정의 ID가 없습니다.', 'danger');
      return;
    }
    
    if(!confirm("정말 삭제하시겠습니까?")) return;
    
    $.ajax({
      url: '/AptCommunity/schedule/delete',
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({ id: parseInt(id) }),
      success: function(res) {
        showToast('일정이 삭제되었습니다.', 'success');
        bootstrap.Modal.getInstance(document.getElementById('scheduleModal')).hide();
        calendar.refetchEvents();
      },
      error: function(err) {
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
  
    return `\${year}-\${month}-\${day}`;
  }
  
  function adjustEndDateBack(endDateObj) {
    if (!endDateObj) return null;

    const date = new Date(endDateObj);
    date.setDate(date.getDate() - 1);

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');

    return `\${year}-\${month}-\${day}`;
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
        <div class="toast-header bg-\${type} text-white">
          <strong class="me-auto">알림</strong>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body">
          \${message}
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
  </script>
</body>
</html>