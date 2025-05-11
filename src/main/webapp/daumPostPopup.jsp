<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>주소 검색</title>
  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <style>
    body { margin: 0; }
    #wrap { width: 100%; height: 100vh; }
  </style>
</head>
<body>
  <div id="wrap"></div>

  <script>
    var wrap = document.getElementById('wrap');

    new daum.Postcode({
      oncomplete: function(data) {
        // 부모창 input에 값 전달
        opener.document.getElementById('roadAddress').value = data.roadAddress;
        opener.document.getElementById('buildingName').value = data.buildingName;
        opener.document.getElementById('sigunguCode').value = data.sigunguCode;
        opener.document.getElementById('roadnameCode').value = data.roadnameCode;

        opener.document.getElementById('dong').value = data.bcode;
        window.close(); // 이 창 닫기
      },
      width: '100%',
      height: '100%'
    }).embed(wrap); // ❗ 팝업이 아닌, 이 div에 주소창 임베드
  </script>
</body>
</html>

