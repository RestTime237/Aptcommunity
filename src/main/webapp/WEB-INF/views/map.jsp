<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주변 편의시설 지도 - 아파트 커뮤니티</title>
    
    <!-- 카카오 지도 API (services 포함) -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3fde33eeecb036bdaafd2b1ac89866e0&libraries=services"></script>
    
    <!-- Bootstrap & jQuery -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <style>
        /* 공통 스타일 */
        body {
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            color: #333;
            background-color: #f8f9fa;
        }
        
        /* 페이지 타이틀 */
        .page-title {
            position: relative;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e9ecef;
        }
        
        .page-title::after {
            content: "";
            position: absolute;
            bottom: -1px;
            left: 0;
            width: 80px;
            height: 3px;
            background-color: #0d6efd;
        }
        
        /* 카드 스타일 */
        .content-card {
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            background-color: #fff;
            overflow: hidden;
            margin-bottom: 2rem;
            padding: 1.5rem;
        }
        
        /* 지도 컨테이너 */
        .map-container {
            position: relative;
            margin-bottom: 1.5rem;
        }
        
        #map {
            width: 100%;
            height: 500px;
            border-radius: 0.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 1;
            overflow: hidden;
        }
        
        /* 지도 컨트롤 */
        .map-controls {
            position: absolute;
            top: 1rem;
            right: 1rem;
            z-index: 2;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .map-control-btn {
            background-color: white;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: all 0.2s;
        }
        
        .map-control-btn:hover {
            background-color: #f8f9fa;
        }
        
        /* 검색 영역 */
        .search-area {
            margin-bottom: 1.5rem;
        }
        
        .search-input {
            border-radius: 0.5rem;
            border: 1px solid #dee2e6;
            padding: 0.75rem 1rem;
            transition: all 0.2s;
        }
        
        .search-input:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        
        /* 빠른 검색 버튼 */
        .quick-search-area {
            margin-bottom: 1.5rem;
        }
        
        .quick-search {
            border-radius: 0.5rem;
            padding: 0.75rem 1.25rem;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
            font-weight: 500;
            transition: all 0.2s;
            border-color: #dee2e6;
        }
        
        .quick-search:hover {
            background-color: #e7f1ff;
            border-color: #0d6efd;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        .quick-search.active {
            background-color: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }
        
        /* 검색 결과 */
        .search-results {
            max-height: 300px;
            overflow-y: auto;
            border-radius: 0.5rem;
            border: 1px solid #dee2e6;
        }
        
        .result-item {
            padding: 1rem;
            border-bottom: 1px solid #dee2e6;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .result-item:last-child {
            border-bottom: none;
        }
        
        .result-item:hover {
            background-color: #f8f9fa;
        }
        
        .result-name {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        
        .result-address {
            font-size: 0.875rem;
            color: #6c757d;
        }
        
        .result-distance {
            font-size: 0.75rem;
            color: #0d6efd;
            font-weight: 600;
        }
        
        /* 버튼 스타일 */
        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
            border-radius: 0.5rem;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .btn-primary:hover {
            background-color: #0b5ed7;
            border-color: #0b5ed7;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        /* 반응형 조정 */
        @media (max-width: 768px) {
            .quick-search {
                width: calc(50% - 0.5rem);
                margin-right: 0.5rem;
                margin-bottom: 0.5rem;
                padding: 0.5rem 0.75rem;
            }
            
            #map {
                height: 400px;
            }
        }
        
        @media (max-width: 576px) {
            .quick-search {
                width: 100%;
                margin-right: 0;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <div class="container my-5">
        <!-- 페이지 타이틀 -->
        <div class="page-title">
            <h2 class="d-flex align-items-center">
                <i class="bi bi-geo-alt-fill me-2 text-primary"></i>
                주변 편의시설 지도
            </h2>
            <p class="text-muted">우리 아파트 주변의 다양한 편의시설을 확인하세요.</p>
        </div>
        
        <!-- 지도 영역 -->
        <div class="content-card">
            <div class="map-container">
                <div id="map"></div>
                <div class="map-controls">
                    <button class="map-control-btn" id="zoomIn" title="확대">
                        <i class="bi bi-plus"></i>
                    </button>
                    <button class="map-control-btn" id="zoomOut" title="축소">
                        <i class="bi bi-dash"></i>
                    </button>
                    <button class="map-control-btn" id="resetMap" title="초기 위치로">
                        <i class="bi bi-house"></i>
                    </button>
                </div>
            </div>
            
            <!-- 빠른 검색 버튼 -->
            <div class="quick-search-area">
                <h5 class="mb-3">
                    <i class="bi bi-lightning-charge-fill text-primary me-2"></i>
                    빠른 검색
                </h5>
                <div class="d-flex flex-wrap">
                    <button type="button" class="btn quick-search" data-query="편의점">
                        <i class="bi bi-shop me-1"></i> 편의점
                    </button>
                    <button type="button" class="btn quick-search" data-query="카페">
                        <i class="bi bi-cup-hot me-1"></i> 카페
                    </button>
                    <button type="button" class="btn quick-search" data-query="식당">
                        <i class="bi bi-egg-fried me-1"></i> 식당
                    </button>
                    <button type="button" class="btn quick-search" data-query="약국">
                        <i class="bi bi-capsule me-1"></i> 약국
                    </button>
                    <button type="button" class="btn quick-search" data-query="은행">
                        <i class="bi bi-bank me-1"></i> 은행
                    </button>
                    <button type="button" class="btn quick-search" data-query="병원">
                        <i class="bi bi-hospital me-1"></i> 병원
                    </button>
                    <button type="button" class="btn quick-search" data-query="마트">
                        <i class="bi bi-cart me-1"></i> 마트
                    </button>
                    <button type="button" class="btn quick-search" data-query="주유소">
                        <i class="bi bi-fuel-pump me-1"></i> 주유소
                    </button>
                </div>
            </div>
            
            <!-- 검색 영역 -->
            <div class="search-area">
                <h5 class="mb-3">
                    <i class="bi bi-search text-primary me-2"></i>
                    장소 검색
                </h5>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" id="searchKeyword" class="form-control search-input" placeholder="찾고 싶은 장소를 입력하세요 (예: 스타벅스, 이마트)">
                    <button onclick="searchPlace()" class="btn btn-primary">
                        검색
                    </button>
                </div>
                <div class="form-text text-muted mt-1">
                    <i class="bi bi-info-circle me-1"></i>
                    아파트 주변 1km 이내의 시설만 검색됩니다.
                </div>
            </div>
            
            <!-- 검색 결과 (기본적으로 숨김) -->
            <div id="searchResults" class="search-results mt-3" style="display: none;">
                <!-- 검색 결과가 여기에 동적으로 추가됩니다 -->
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
    	let currentInfoWindow = null;
    
        // 위도/경도 정보 가져오기
        const lat = parseFloat("${lat}");
        const lng = parseFloat("${lng}");
        
        console.log("lat:", lat, "lng:", lng);
        
        // 지도 초기화
        const mapContainer = document.getElementById('map');
        const mapOption = {
            center: new kakao.maps.LatLng(lat, lng),
            level: 4
        };
        
        const map = new kakao.maps.Map(mapContainer, mapOption);
        
        // 마커 배열 (검색 시 이전 마커 제거를 위함)
        let markers = [];
        
        // 현재 위치 마커 (아파트 위치)
        const myMarker = new kakao.maps.Marker({
            map,
            position: new kakao.maps.LatLng(lat, lng),
            title: "우리 동네",
            image: new kakao.maps.MarkerImage(
                "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png",
                new kakao.maps.Size(24, 35)
            )
        });
        
        const myInfo = new kakao.maps.InfoWindow({
            content: '<div style="padding:8px;font-size:14px;font-weight:bold;">우리 동네</div>'
        });
        myInfo.open(map, myMarker);
        
        // 장소 검색 객체 생성
        const ps = new kakao.maps.services.Places();
        
        // 초기 검색 (스타벅스)
        //searchPlaceWithKeyword("스타벅스");
        
        // 장소 검색 함수
        function searchPlace() {
            const keyword = document.getElementById("searchKeyword").value.trim();
            
            if (!keyword) {
                alert("검색어를 입력하세요");
                return;
            }
            
            searchPlaceWithKeyword(keyword);
        }
        
        // 키워드로 장소 검색 실행
        function searchPlaceWithKeyword(keyword) {
            // 이전 마커 제거
            removeAllMarkers();
            
            // 검색 결과 영역 초기화
            const resultsContainer = document.getElementById("searchResults");
            resultsContainer.innerHTML = "";
            resultsContainer.style.display = "none";
            
            // 활성화된 빠른 검색 버튼 스타일 제거
            document.querySelectorAll(".quick-search").forEach(btn => {
                if (btn.dataset.query === keyword) {
                    btn.classList.add("active");
                } else {
                    btn.classList.remove("active");
                }
            });
            
            // 검색 실행
            ps.keywordSearch(keyword, (result, status) => {
                if (status === kakao.maps.services.Status.OK) {
                    // 검색 결과가 있을 경우
                    resultsContainer.style.display = "block";
                    
                    // 결과 정렬 (거리순)
                    result.sort((a, b) => {
                        const distA = getDistance(lat, lng, a.y, a.x);
                        const distB = getDistance(lat, lng, b.y, b.x);
                        return distA - distB;
                    });
                    
                    // 마커 생성 및 결과 목록 생성
                    result.forEach((place, index) => {
                        // 마커 생성
                        const marker = new kakao.maps.Marker({
                            map: map,
                            position: new kakao.maps.LatLng(place.y, place.x),
                            title: place.place_name
                        });
                        
                        markers.push(marker);
                        
                        // 인포윈도우 생성
                        const infowindow = new kakao.maps.InfoWindow({
                            content: `
                                <div style="padding:8px;font-size:14px;width:200px;">
                                    <div style="font-weight:bold;margin-bottom:4px;">\${place.place_name}</div>
                                    <div style="font-size:12px;color:#666;">\${place.address_name}</div>
                                    <div style="font-size:12px;color:#0d6efd;margin-top:4px;">
                                        \${place.phone ? '📞 ' + place.phone : ''}
                                    </div>
                                </div>
                            `
                        });
                        
                        // 마커 클릭 이벤트
                        kakao.maps.event.addListener(marker, 'click', () => {
                            // 이전에 열린 인포윈도우 닫기
                            closeAllInfoWindows();
                            
                            // 새 인포윈도우 열기
                            infowindow.open(map, marker);
                            
                            // 현재 열린 인포윈도우 저장
                            currentInfoWindow = infowindow;
                        });
                        
                        // 거리 계산
                        const distance = getDistance(lat, lng, place.y, place.x);
                        const distanceText = formatDistanceText(distance);
                        
                        // 검색 결과 아이템 생성
                        const resultItem = document.createElement("div");
                        resultItem.className = "result-item";
                        resultItem.innerHTML = `
                            <div class="result-name">\${place.place_name}</div>
                            <div class="result-address">\${place.address_name}</div>
                            <div class="d-flex justify-content-between align-items-center mt-1">
                                <div class="result-distance">
                                    <i class="bi bi-geo-alt me-1"></i> \${distanceText}
                                </div>
                                <div>
                                    ${place.phone ? '<span class="text-muted"><i class="bi bi-telephone me-1"></i>' + place.phone + '</span>' : ''}
                                </div>
                            </div>
                        `;
                        
                        // 결과 아이템 클릭 이벤트
                        resultItem.addEventListener("click", () => {
                            // 지도 중심 이동
                            map.setCenter(new kakao.maps.LatLng(place.y, place.x));
                            
                            // 인포윈도우 열기
                            closeAllInfoWindows();
                            infowindow.open(map, marker);
                            currentInfoWindow = infowindow;
                        });
                        
                        // 결과 목록에 추가
                        resultsContainer.appendChild(resultItem);
                    });
                    
                    // 첫 번째 결과로 지도 중심 이동
                    if (result.length > 0) {
                        const first = result[0];
                        map.setCenter(new kakao.maps.LatLng(first.y, first.x));
                    }
                } else {
                    // 검색 결과가 없을 경우
                    resultsContainer.style.display = "block";
                    resultsContainer.innerHTML = `
                        <div class="p-4 text-center">
                            <i class="bi bi-search fs-1 text-muted mb-3 d-block"></i>
                            <p class="text-muted">검색 결과가 없습니다.</p>
                        </div>
                    `;
                }
            }, {
                location: new kakao.maps.LatLng(lat, lng),
                radius: 1000 // 1km 반경
            });
        }
        
        // 모든 마커 제거
        function removeAllMarkers() {
            for (let i = 0; i < markers.length; i++) {
                markers[i].setMap(null);
            }
            markers = [];
            
            // 열린 인포윈도우 닫기
            closeAllInfoWindows();
        }

        
        // 모든 인포윈도우 닫기
        function closeAllInfoWindows() {
            if (currentInfoWindow) {
                currentInfoWindow.close();
            }
        }
        
        // 두 지점 간의 거리 계산 (하버사인 공식)
        function getDistance(lat1, lon1, lat2, lon2) {
            const R = 6371; // 지구 반경 (km)
            const dLat = deg2rad(lat2 - lat1);
            const dLon = deg2rad(lon2 - lon1);
            const a = 
                Math.sin(dLat/2) * Math.sin(dLat/2) +
                Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
                Math.sin(dLon/2) * Math.sin(dLon/2); 
            const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
            const distance = R * c; // 킬로미터 단위 거리
            return distance;
        }
        
        // 각도를 라디안으로 변환
        function deg2rad(deg) {
            return deg * (Math.PI/180);
        }
        
        // 거리 포맷팅 (JavaScript 함수)
        function formatDistanceText(distance) {
            if (distance < 1) {
                return Math.round(distance * 1000) + "m";
            } else {
                return distance.toFixed(1) + "km";
            }
        }
        
        // 빠른 검색 버튼 이벤트
        document.querySelectorAll(".quick-search").forEach(button => {
            button.addEventListener("click", function() {
                const keyword = this.dataset.query;
                document.querySelector("#searchKeyword").value = keyword;
                searchPlaceWithKeyword(keyword);
            });
        });
        
        // 지도 컨트롤 이벤트
        document.getElementById("zoomIn").addEventListener("click", function() {
            map.setLevel(map.getLevel() - 1);
        });
        
        document.getElementById("zoomOut").addEventListener("click", function() {
            map.setLevel(map.getLevel() + 1);
        });
        
        document.getElementById("resetMap").addEventListener("click", function() {
            map.setCenter(new kakao.maps.LatLng(lat, lng));
            map.setLevel(4);
        });
        
        // 검색창 엔터키 이벤트
        document.getElementById("searchKeyword").addEventListener("keypress", function(e) {
            if (e.key === "Enter") {
                searchPlace();
            }
        });
    </script>
</body>
</html>