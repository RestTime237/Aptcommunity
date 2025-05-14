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
document.addEventListener('DOMContentLoaded', function () {
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
});