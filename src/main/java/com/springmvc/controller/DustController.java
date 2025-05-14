package com.springmvc.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.springmvc.domain.Member;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.locationtech.proj4j.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@Controller
public class DustController {

    // READ
    @GetMapping("/dust")
    @ResponseBody
    public Map<String, Object> getDustByLocation(@RequestParam double tmX, @RequestParam double tmY) throws IOException {
        String stationName = findNearestStation(tmX, tmY);
        if (stationName == null) {
            return Map.of("error", "측정소를 찾을 수 없습니다.");
        }

        Map<String, Object> dustInfo = getDustValue(stationName);
        dustInfo.put("stationName", stationName);
        return dustInfo;
    }

    @GetMapping("/dustByDong")
    @ResponseBody
    public Map<String, Object> getDustByDong(HttpSession session) {
        Member mb = (Member) session.getAttribute("mb");
        if (mb == null || mb.getRoadAddress() == null) {
            System.out.println("❌ 세션에서 Member 정보 없음 또는 roadAddress가 null");
            return Map.of("error", "회원 정보가 없습니다");
        }

        try {
            String roadCode = mb.getRoadAddress();
            System.out.println("🔍 저장된 roadCode: " + roadCode);

            // 1. 공공데이터 API로 도로명 주소 조회
            URI uri = UriComponentsBuilder
                    .fromHttpUrl("https://apis.data.go.kr/1613000/AptListService3/getRoadnameAptList3")
                    .queryParam("serviceKey", "aXyObuGPEAQMX%2BVEblg9toTV8WnQy3bVimRyj7gcAJnGYrdc9WqQRMkB6zFM9%2FfIKgL%2FQ%2F0qYaGvamAOsyXv%2Fg%3D%3D")
                    .queryParam("roadCode", roadCode)
                    .queryParam("pageNo", 1)
                    .queryParam("numOfRows", 100)
                    .queryParam("_type", "json")
                    .build(true)
                    .toUri();

            RestTemplate restTemplate = new RestTemplate();
            String response = restTemplate.getForObject(uri, String.class);
            JSONArray items = new JSONObject(response)
                    .getJSONObject("response")
                    .getJSONObject("body")
                    .getJSONArray("items");

            if (items.isEmpty()) {
                System.out.println("❌ 도로명주소 정보 없음");
                return Map.of("error", "도로명 주소 정보를 찾을 수 없습니다.");
            }

            String doroJuso = items.getJSONObject(0).getString("doroJuso");
            System.out.println("🏠 전체 도로명주소: " + doroJuso);

            // 2. 도로명 주소 간소화 (길 제거, 아파트 제거 등)
            // 도로명주소 간소화 (길 제거, 아파트 제거 등)
            String simplified = doroJuso
                    .replaceAll(".*(\\s[가-힣A-Za-z0-9]+(대로|로|길)\\s?\\d+).*", "$1")
                    .replaceAll("(\\s+[가-힣]+(아파트|빌라|주택)).*", "")               // 아파트명 제거
                    .trim();

            System.out.println("🧩 간소화된 주소: " + simplified);

            // 3. 네이버 Geocoding API 호출
            String client_id = "5615p50o9n";
            String client_secret = "XUo0bC0zrJd0jGpKHaCaHBNLIuJw53y2d50Y1mkB";
            String encodedAddr = URLEncoder.encode(simplified, StandardCharsets.UTF_8);
            String urlStr = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=" + encodedAddr;
            System.out.println("📡 네이버 요청 URL: " + urlStr);

            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("X-NCP-APIGW-API-KEY-ID", client_id);
            conn.setRequestProperty("X-NCP-APIGW-API-KEY", client_secret);

            int responseCode = conn.getResponseCode();
            System.out.println("📨 응답 코드: " + responseCode);

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            conn.disconnect();

            System.out.println("📥 네이버 응답 본문: " + sb);

            JSONObject obj = new JSONObject(new JSONTokener(sb.toString()));
            JSONArray addrArray = obj.getJSONArray("addresses");

            if (addrArray.isEmpty()) {
                System.out.println("❌ 주소 결과 없음");
                return Map.of("error", "주소 결과 없음");
            }

            JSONObject first = addrArray.length() > 1 ? addrArray.getJSONObject(1) : addrArray.getJSONObject(0);
            double lon = Double.parseDouble(first.getString("x"));
            double lat = Double.parseDouble(first.getString("y"));

            System.out.println("📍 위도: " + lat + ", 경도: " + lon);

            ProjCoordinate tmCoord = convertWGS84ToTM(lon, lat);

            double tmX = tmCoord.x;
            double tmY = tmCoord.y;

            String stationName = findNearestStation(tmX, tmY);
            if (stationName == null) {
                return Map.of("error", "측정소를 찾을 수 없습니다.");
            }

            Map<String, Object> dustInfo = getDustValue(stationName);
            dustInfo.put("stationName", stationName);
            return dustInfo;
        } catch (Exception e) {
        }


        return null;
    }

    private String findNearestStation(double tmX, double tmY) throws IOException {
        String serviceKey = "aXyObuGPEAQMX%2BVEblg9toTV8WnQy3bVimRyj7gcAJnGYrdc9WqQRMkB6zFM9%2FfIKgL%2FQ%2F0qYaGvamAOsyXv%2Fg%3D%3D";
        String url = "http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getNearbyMsrstnList"
                + "?tmX=" + tmX
                + "&tmY=" + tmY
                + "&returnType=json"
                + "&serviceKey=" + serviceKey;

        // JSON 파싱 예시
        JsonNode root = new ObjectMapper().readTree(new URL(url));
        JsonNode items = root.path("response").path("body").path("items");
        if (items.isArray() && items.size() > 0) {
            return items.get(0).path("stationName").asText(); // 가장 가까운 측정소
        }
        return null;
    }

    private Map<String, Object> getDustValue(String stationName) throws IOException {
        String serviceKey = "aXyObuGPEAQMX%2BVEblg9toTV8WnQy3bVimRyj7gcAJnGYrdc9WqQRMkB6zFM9%2FfIKgL%2FQ%2F0qYaGvamAOsyXv%2Fg%3D%3D";
        String url = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty"
                + "?stationName=" + URLEncoder.encode(stationName, StandardCharsets.UTF_8)
                + "&dataTerm=DAILY&pageNo=1&numOfRows=1&ver=1.3&returnType=json"
                + "&serviceKey=" + serviceKey;

        JsonNode root = new ObjectMapper().readTree(new URL(url));
        JsonNode item = root.path("response").path("body").path("items").get(0);

        Map<String, Object> result = new HashMap<>();
        result.put("pm10Value", item.path("pm10Value").asText());  // 미세먼지
        result.put("pm25Value", item.path("pm25Value").asText());  // 초미세먼지
        result.put("dataTime", item.path("dataTime").asText());    // 측정시간
        return result;
    }


    // TM좌표 구하는 함수
    private ProjCoordinate convertWGS84ToTM(double lon, double lat) {
        CRSFactory crsFactory = new CRSFactory();
        CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();

        CoordinateReferenceSystem wgs84 = crsFactory.createFromName("EPSG:4326");
        CoordinateReferenceSystem tm5179 = crsFactory.createFromParameters("EPSG:5179",
                "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 "
                        + "+x_0=1000000 +y_0=2000000 +ellps=GRS80 +units=m +no_defs");

        CoordinateTransform transform = ctFactory.createTransform(wgs84, tm5179);

        ProjCoordinate srcCoord = new ProjCoordinate(lon, lat);
        ProjCoordinate dstCoord = new ProjCoordinate();

        transform.transform(srcCoord, dstCoord);

        return dstCoord;
    }


}
