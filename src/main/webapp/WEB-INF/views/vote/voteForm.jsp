<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>투표 만들기 - 아파트 커뮤니티</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">

    <style>
        /* 전체 스타일 */
        body {
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            color: #333;
            background-color: #f8f9fa;
        }

        /* 페이지 타이틀 */
        .page-title {
            font-size: 1.75rem;
            font-weight: bold;
            position: relative;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            align-items: center;
        }

        .page-title::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background-color: #0d6efd;
        }

        /* 카드 스타일 */
        .content-card {
            background-color: white;
            border-radius: 0.5rem;
            padding: 2rem;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.125);
        }

        /* 폼 스타일 */
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        .option-item {
            position: relative;
            margin-bottom: 0.75rem;
        }

        .option-remove {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #dc3545;
            background: none;
            border: none;
            font-size: 1.25rem;
            cursor: pointer;
            padding: 0;
            line-height: 1;
        }

        .option-remove:hover {
            color: #b02a37;
        }

        .add-option-btn {
            display: flex;
            align-items: center;
            background-color: #e7f1ff;
            color: #0d6efd;
            border: 1px dashed #0d6efd;
            border-radius: 0.375rem;
            padding: 0.75rem 1rem;
            width: 100%;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .add-option-btn:hover {
            background-color: #d0e4ff;
        }

        /* 버튼 스타일 */
        .btn-create {
            background-color: #0d6efd;
            color: white;
            border: none;
            padding: 0.5rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn-create:hover {
            background-color: #0a58ca;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-cancel {
            background-color: #f8f9fa;
            color: #6c757d;
            border: 1px solid #dee2e6;
            padding: 0.5rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn-cancel:hover {
            background-color: #e9ecef;
        }

        /* 도움말 텍스트 */
        .help-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 0.25rem;
        }

        /* 섹션 구분선 */
        .section-divider {
            margin: 2rem 0;
            border-top: 1px solid #e9ecef;
            position: relative;
        }

        .section-divider-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 0 1rem;
            color: #6c757d;
            font-size: 0.875rem;
        }

        /* 반응형 스타일 */
        @media (max-width: 768px) {
            .content-card {
                padding: 1.5rem;
            }
        }

        footer a {
            color: #333;
            transition: color 0.3s ease;
        }

        footer a:hover {
            color: #0D6EFD !important;
            transition: color 0.3s ease;
        }

        /* 서비스 아이콘 스타일 */
        .service-icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #e7f1ff;
            color: #0d6efd;
            border-radius: 0.5rem;
            margin: 0 auto 0.5rem;
            font-size: 1.5rem;
        }

        /* 투표 가이드 카드 */
        .guide-card {
            border: none;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .guide-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container my-5">
    <div class="page-title">
        <i class="ri-edit-line me-2 text-primary"></i>투표 만들기
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="content-card mb-4">
                <form action="/AptCommunity/vote/add" method="post" id="voteForm">
                    <div class="mb-4">
                        <label for="title" class="form-label">
                            <i class="bi bi-type-h1 me-2 text-primary"></i>투표 제목
                        </label>
                        <input type="text" class="form-control" id="title" name="title" placeholder="투표 제목을 입력하세요"
                               required>
                        <div class="help-text">명확하고 간결한 제목을 작성해주세요.</div>
                    </div>

                    <div class="mb-4">
                        <label for="content" class="form-label">
                            <i class="bi bi-text-paragraph me-2 text-primary"></i>투표 내용
                        </label>
                        <textarea class="form-control" id="content" name="content" rows="4"
                                  placeholder="투표에 대한 상세 설명을 입력하세요"></textarea>
                        <div class="help-text">투표의 목적과 배경에 대해 설명해주세요.</div>
                    </div>

                    <div class="mb-4">
                        <label for="deadline" class="form-label">
                            <i class="bi bi-calendar-event me-2 text-primary"></i>마감일
                        </label>
                        <input type="datetime-local" class="form-control" id="deadline" name="deadline" required>
                        <div class="help-text">투표가 자동으로 마감되는 날짜와 시간을 설정해주세요.</div>
                    </div>

                    <div class="section-divider">
                        <span class="section-divider-text">투표 옵션</span>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">
                            <i class="bi bi-list-check me-2 text-primary"></i>선택지
                        </label>
                        <div id="optionsContainer">
                            <div class="option-item">
                                <input type="text" class="form-control" name="optionTexts" placeholder="선택지 1" required>
                            </div>
                            <div class="option-item">
                                <input type="text" class="form-control" name="optionTexts" placeholder="선택지 2" required>
                                <button type="button" class="option-remove" onclick="removeOption(this)">
                                    <i class="bi bi-x-circle"></i>
                                </button>
                            </div>
                        </div>

                        <button type="button" class="add-option-btn mt-2" onclick="addOptionField()">
                            <i class="bi bi-plus-circle me-2"></i>선택지 추가
                        </button>
                        <div class="help-text mt-2">최소 2개 이상의 선택지를 입력해주세요.</div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">
                            <i class="bi bi-gear me-2 text-primary"></i>투표 설정
                        </label>

                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" id="anonymousVote" name="anonymousVote">
                            <label class="form-check-label" for="anonymousVote">
                                익명 투표 (투표자 정보를 공개하지 않음)
                            </label>
                        </div>

                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" id="multipleChoice" name="multipleChoice">
                            <label class="form-check-label" for="multipleChoice">
                                복수 선택 허용 (여러 선택지 선택 가능)
                            </label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="showResultBeforeEnd"
                                   name="showResultBeforeEnd">
                            <label class="form-check-label" for="showResultBeforeEnd">
                                투표 진행 중에도 결과 공개
                            </label>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between mt-5">
                        <a href="/AptCommunity/vote/list" class="btn btn-cancel">
                            <i class="bi bi-arrow-left me-1"></i>취소
                        </a>
                        <button type="submit" class="btn btn-create">
                            <i class="bi bi-check2-circle me-1"></i>투표 생성
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- 투표 가이드 -->
            <div class="content-card mb-4">
                <h5 class="mb-3"><i class="bi bi-info-circle me-2 text-primary"></i>투표 가이드</h5>
                <div class="guide-text">
                    <p>효과적인 투표를 만들기 위한 팁:</p>
                    <ul class="mb-0">
                        <li>명확하고 이해하기 쉬운 제목을 사용하세요.</li>
                        <li>투표의 목적과 배경을 상세히 설명하세요.</li>
                        <li>선택지는 구체적이고 명확하게 작성하세요.</li>
                        <li>충분한 투표 기간을 설정하여 많은 주민이 참여할 수 있게 하세요.</li>
                        <li>민감한 주제의 경우 익명 투표를 고려하세요.</li>
                    </ul>
                </div>
            </div>

            <!-- 투표 유형 예시 -->
            <div class="row">
                <div class="col-md-6 col-lg-12 mb-4">
                    <div class="card guide-card h-100 shadow-sm">
                        <div class="card-body">
                            <div class="text-center mb-3">
                                <div class="service-icon mx-auto">
                                    <i class="bi bi-building-gear"></i>
                                </div>
                            </div>
                            <h5 class="card-title text-center">시설 관련 투표</h5>
                            <p class="card-text text-muted small">아파트 시설 개선, 공용 공간 활용, 주차 시스템 변경 등에 관한 의견을 수렴합니다.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-12 mb-4">
                    <div class="card guide-card h-100 shadow-sm">
                        <div class="card-body">
                            <div class="text-center mb-3">
                                <div class="service-icon mx-auto">
                                    <i class="bi bi-calendar-event"></i>
                                </div>
                            </div>
                            <h5 class="card-title text-center">행사 관련 투표</h5>
                            <p class="card-text text-muted small">아파트 행사 일정, 프로그램 선정, 주민 참여 활동 등에 관한 의견을 수렴합니다.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>

<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 현재 날짜 기준으로 마감일 기본값 설정 (7일 후)
    document.addEventListener('DOMContentLoaded', function () {
        const now = new Date();
        now.setDate(now.getDate() + 7);

        // YYYY-MM-DDThh:mm 형식으로 변환
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');

        const defaultDeadline = `${year}-${month}-${day}T${hours}:${minutes}`;
        document.getElementById('deadline').value = defaultDeadline;
    });

    // 선택지 추가 함수
    function addOptionField() {
        const container = document.getElementById("optionsContainer");
        const optionCount = container.children.length + 1;

        const optionDiv = document.createElement("div");
        optionDiv.className = "option-item";

        const input = document.createElement("input");
        input.type = "text";
        input.className = "form-control";
        input.name = "optionTexts";
        input.placeholder = `선택지 ${optionCount}`;
        input.required = true;

        const removeBtn = document.createElement("button");
        removeBtn.type = "button";
        removeBtn.className = "option-remove";
        removeBtn.onclick = function () {
            removeOption(this);
        };
        removeBtn.innerHTML = '<i class="bi bi-x-circle"></i>';

        optionDiv.appendChild(input);
        optionDiv.appendChild(removeBtn);
        container.appendChild(optionDiv);

        // 새로 추가된 입력 필드에 포커스
        input.focus();
    }

    // 선택지 제거 함수
    function removeOption(button) {
        const optionsContainer = document.getElementById("optionsContainer");
        const optionItem = button.parentNode;

        // 최소 2개의 선택지는 유지
        if (optionsContainer.children.length > 2) {
            optionsContainer.removeChild(optionItem);

            // 선택지 번호 재정렬
            const inputs = optionsContainer.querySelectorAll('input');
            inputs.forEach((input, index) => {
                input.placeholder = `선택지 ${index + 1}`;
            });
        } else {
            alert('최소 2개의 선택지가 필요합니다.');
        }
    }

    // 폼 제출 전 유효성 검사
    document.getElementById('voteForm').addEventListener('submit', function (event) {
        const title = document.getElementById('title').value.trim();
        const deadline = document.getElementById('deadline').value;
        const options = document.querySelectorAll('input[name="optionTexts"]');

        let isValid = true;
        let emptyOptions = false;

        // 제목 검사
        if (title === '') {
            isValid = false;
            alert('투표 제목을 입력해주세요.');
        }

        // 마감일 검사
        if (deadline === '') {
            isValid = false;
            alert('마감일을 설정해주세요.');
        } else {
            const deadlineDate = new Date(deadline);
            const now = new Date();

            if (deadlineDate <= now) {
                isValid = false;
                alert('마감일은 현재 시간 이후로 설정해주세요.');
            }
        }

        // 선택지 검사
        options.forEach(option => {
            if (option.value.trim() === '') {
                emptyOptions = true;
            }
        });

        if (emptyOptions) {
            isValid = false;
            alert('모든 선택지를 입력해주세요.');
        }

        if (!isValid) {
            event.preventDefault();
        }
    });
</script>
</body>
</html>
