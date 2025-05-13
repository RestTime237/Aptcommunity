<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원정보 수정 - 아파트 커뮤니티</title>

    <!-- Bootstrap & jQuery -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/memberUpdate.css">

    <script src="${pageContext.request.contextPath}/resources/js/member/memberUpdate.js" defer></script>

</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="update-card">
                <!-- 회원정보 수정 헤더 -->
                <div class="update-header">
                    <div class="update-logo">
                        <i class="bi bi-person-gear"></i>
                    </div>
                    <h1>아파트 커뮤니티</h1>
                    <p>회원정보 수정</p>
                </div>

                <!-- 회원정보 수정 본문 -->
                <div class="update-body">
                    <div class="update-welcome">
                        <h2>회원정보 수정</h2>
                        <p>변경하실 정보를 입력해주세요. 변경하지 않을 항목은 기존 정보가 유지됩니다.</p>
                    </div>

                    <!-- 회원정보 수정 폼 -->
                    <form:form modelAttribute="updateMember" method="post" id="updateForm">
                        <!-- 기본 정보 섹션 -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="bi bi-person-badge"></i> 기본 정보
                            </div>

                            <!-- 이름 -->
                            <div class="mb-3">
                                <label for="username" class="form-label">이름</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-person"></i>
                                        </span>
                                    <form:input path="username" id="username" cssClass="form-control"
                                                placeholder="이름을 입력하세요"/>
                                </div>
                            </div>

                            <!-- 아이디 (읽기 전용) -->
                            <div class="mb-3">
                                <label for="userId" class="form-label">아이디</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-at"></i>
                                        </span>
                                    <form:input path="userId" id="userId" cssClass="form-control" readonly="true"/>
                                </div>
                                <div class="form-text">아이디는 변경할 수 없습니다.</div>
                            </div>

                            <!-- 별명 -->
                            <div class="mb-3">
                                <label for="nickname" class="form-label">별명</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-person-badge"></i>
                                        </span>
                                    <form:input path="nickname" id="nickname" cssClass="form-control"
                                                placeholder="커뮤니티에서 사용할 별명을 입력하세요"/>
                                </div>
                                <div class="form-text">커뮤니티 활동시 사용할 별명을 입력해주세요.</div>
                            </div>
                        </div>

                        <!-- 비밀번호 섹션 -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="bi bi-shield-lock"></i> 비밀번호 변경
                            </div>

                            <!-- 비밀번호 변경 -->
                            <div class="mb-3">
                                <label for="password" class="form-label">새 비밀번호</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-lock"></i>
                                        </span>
                                    <form:password path="password" id="password" cssClass="form-control"
                                                   placeholder="변경할 비밀번호를 입력하세요"/>
                                </div>
                                <div class="form-text">변경을 원하지 않으시면 비워두세요. 영문, 숫자, 특수문자를 조합하여 8자 이상 입력해주세요.</div>
                            </div>

                            <!-- 비밀번호 확인 -->
                            <div class="mb-3">
                                <label for="passwordCheck" class="form-label">비밀번호 확인</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-lock-fill"></i>
                                        </span>
                                    <input type="password" id="passwordCheck" class="form-control"
                                           placeholder="비밀번호를 다시 입력하세요"/>
                                </div>
                            </div>
                        </div>

                        <!-- 주소 정보 섹션 -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="bi bi-geo-alt"></i> 주소 정보
                            </div>

                            <!-- 우편번호 -->
                            <div class="mb-3">
                                <label for="postcode" class="form-label">우편번호</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-mailbox"></i>
                                        </span>
                                    <input type="text" id="postcode" class="form-control" placeholder="우편번호" readonly/>
                                    <button type="button" class="btn btn-address" onclick="execDaumPostcode()">
                                        <i class="bi bi-search me-1"></i> 우편번호 찾기
                                    </button>
                                </div>
                            </div>

                            <!-- 도로명주소 -->
                            <div class="mb-3">
                                <label for="roadAddress" class="form-label">도로명주소</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-signpost"></i>
                                        </span>
                                    <input type="text" id="roadAddress" class="form-control" placeholder="도로명주소"
                                           readonly/>
                                </div>
                            </div>

                            <!-- 지번주소 -->
                            <div class="mb-3">
                                <label for="jibunAddress" class="form-label">지번주소</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-geo"></i>
                                        </span>
                                    <input type="text" id="jibunAddress" class="form-control" placeholder="지번주소"
                                           readonly/>
                                </div>
                            </div>

                            <!-- 상세주소 -->
                            <div class="mb-3">
                                <label for="detailAddress" class="form-label">상세주소</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-house-door"></i>
                                        </span>
                                    <input type="text" id="detailAddress" class="form-control"
                                           placeholder="상세주소를 입력하세요"/>
                                </div>
                                <div class="form-text">아파트 동/호수 등 상세 주소를 입력해주세요.</div>
                            </div>

                            <!-- 숨겨진 주소 관련 정보 -->
                            <input type="hidden" name="buildingName" id="buildingName"/>
                            <input type="hidden" name="sigunguCode" id="sigunguCode"/>
                            <input type="hidden" name="roadnameCode" id="roadnameCode"/>
                            <input type="hidden" name="roadAddress" id="roadAddressHidden"/>
                        </div>

                        <!-- 버튼 영역 -->
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                            <a href="${pageContext.request.contextPath}/member/mypage" class="btn btn-cancel me-md-2">
                                <i class="bi bi-x-lg me-1"></i> 취소
                            </a>
                            <button type="button" id="check" class="btn btn-update">
                                <i class="bi bi-check-lg me-1"></i> 수정 완료
                            </button>
                        </div>
                    </form:form>
                </div>
            </div>

            <!-- 추가 정보 -->
            <div class="text-center mt-4 text-muted">
                <small>&copy; 2025 아파트 커뮤니티. All rights reserved.</small>
            </div>
        </div>
    </div>
</div>

</body>
</html>
