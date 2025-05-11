document.addEventListener("DOMContentLoaded", function () {
    // 옵션 선택 시 시각적 피드백
    const optionItems = document.querySelectorAll('.option-item');
    const optionRadios = document.querySelectorAll('.option-radio');

    optionRadios.forEach((radio, index) => {
        radio.addEventListener('change', function () {
            optionItems.forEach(item => item.classList.remove('selected'));
            if (this.checked) {
                optionItems[index].classList.add('selected');
            }
        });
    });
});
