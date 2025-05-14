function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function (data) {
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById('roadAddress').value = data.roadAddress;
            document.getElementById('jibunAddress').value = data.jibunAddress;
            document.getElementById('buildingName').value = data.buildingName;
            document.getElementById('sigunguCode').value = data.sigunguCode;
            document.getElementById('roadnameCode').value = data.roadnameCode;
            document.getElementById('roadAddressHidden').value = data.roadAddress;
            document.getElementById('detailAddress').focus();
        }
    }).open();
}

document.querySelector("#check").addEventListener("click", function () {
    const pw = document.querySelector("#password").value;
    const pwCheck = document.querySelector("#passwordCheck").value;

    if (pw !== "") {
        if (pwCheck === "") {
            alert("비밀번호 확인을 입력해주세요.");
            document.querySelector("#passwordCheck").focus();
            return;
        }
        if (pw !== pwCheck) {
            alert("비밀번호가 일치하지 않습니다.");
            document.querySelector("#passwordCheck").focus();
            return;
        }
    }

    document.getElementById("updateForm").submit();
});