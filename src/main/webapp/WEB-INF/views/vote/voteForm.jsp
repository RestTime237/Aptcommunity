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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/vote/voteForm.css"/>
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
                <form action="${pageContext.request.contextPath}/vote/add" method="post" id="voteForm">
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
                        <a href="${pageContext.request.contextPath}/vote/list" class="btn btn-cancel">
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
<script src="${pageContext.request.contextPath}/resources/js/vote/voteForm.js"></script>
</body>
</html>
