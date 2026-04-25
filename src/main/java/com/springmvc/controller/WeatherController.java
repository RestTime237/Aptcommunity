package com.springmvc.controller;

import com.springmvc.domain.Member;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class WeatherController {

    private String convertWeatherDescription(String raw) {
        switch (raw) {
            case "연무":
            case "박무":
                return "안개";
            case "튼구름":
            case "온흐림":
                return "흐림";
            case "약한 비":
                return "이슬비";
            case "맑음":
                return "맑음";
            case "비":
                return "비";
            case "눈":
                return "눈";
            default:
                return raw; // 기본은 그대로 유지
        }
    }

    @GetMapping("/weather")
    @ResponseBody
    public Map<String, Object> getWeather(@RequestParam double lat, @RequestParam double lon, HttpSession session) {
        String apiKey = ""; // 실제 키로 대체
        String url = String.format(
                "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%s&units=metric&lang=kr",
                lat, lon, apiKey
        );

        session.setAttribute("autolat", lat);
        session.setAttribute("autolng", lon);

        String loc;

        String gu1 = "";
        String dong = "";
        try {
            loc = lon + "," + lat;
            System.out.println("loc 값 : " + loc);
            String client_id = "id0d6qmb5d";
            String client_secret = "";

            String setting = loc + "&orders=legalcode%2Cadmcode%2Caddr%2Croadaddr&output=json";


            String urlstr = "https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=" + setting;

            URL url2 = new URL(urlstr);
            HttpURLConnection conn = (HttpURLConnection) url2.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("X-NCP-APIGW-API-KEY-ID", client_id);
            conn.setRequestProperty("X-NCP-APIGW-API-KEY", client_secret);
            System.out.println("응답코드 : " + conn.getResponseCode());


            InputStreamReader is = new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8);
            BufferedReader br = new BufferedReader(is);

            String sb1 = "";
            StringBuilder sb2 = new StringBuilder();
            //sb1 != null
            while ((sb1 = br.readLine()) != null) {
                sb2.append(sb1);
            }
            System.out.println("sb2 변환된 주소값 : " + sb2);

            JSONTokener tokener = new JSONTokener(sb2.toString());
            JSONObject obj = new JSONObject(tokener);
            JSONArray arr = obj.getJSONArray("results");
            JSONObject obj2 = arr.getJSONObject(0);
            JSONObject obj3 = obj2.getJSONObject("region");
            JSONObject obj4 = obj3.getJSONObject("area2");
            JSONObject obj5 = obj3.getJSONObject("area3");

            String sigungu = obj4.getString("name");
            String[] gu = sigungu.split(" ");
            gu1 = gu[1];
            dong = obj5.getString("name");

            System.out.println("한글 주소명 : " + gu1 + " " + dong);


        } catch (Exception e) {
            e.printStackTrace();
        }

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);
        Map body = response.getBody();

        Map<String, Object> result = new HashMap<>();
        result.put("city", gu1 + " " + dong);

        Map main = (Map) body.get("main");
        result.put("temp", main.get("temp"));
        result.put("feels_like", main.get("feels_like"));

        List<Map<String, Object>> weatherList = (List<Map<String, Object>>) body.get("weather");
        Map weather = weatherList.get(0);
        result.put("description", convertWeatherDescription(weather.get("description").toString()));
        result.put("icon", weather.get("icon")); // ✅ 이 줄 꼭 있어야 함!

        return result;
    }

    @GetMapping("/weatherByDong")
    @ResponseBody
    public Map<String, Object> getWeatherFromSessionDong(HttpSession session) {
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
                    .queryParam("serviceKey", "")
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

            String[] addressParts = doroJuso.split(" ");
            String cityName = (addressParts.length >= 3)
                    ? addressParts[1] + " " + addressParts[2]  // 예: "창원시 마산회원구"
                    : doroJuso; // fallback


            // 2. 도로명 주소 간소화 (길 제거, 아파트 제거 등)
            // 도로명주소 간소화 (길 제거, 아파트 제거 등)
            String simplified = doroJuso
                    .replaceAll(".*(\\s[가-힣A-Za-z0-9]+(대로|로|길)\\s?\\d+).*", "$1")
                    .replaceAll("(\\s+[가-힣]+(아파트|빌라|주택)).*", "")               // 아파트명 제거
                    .trim();

            System.out.println("🧩 간소화된 주소: " + simplified);

            // 3. 네이버 Geocoding API 호출
            String client_id = "5615p50o9n";
            String client_secret = "";
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

            session.setAttribute("lat", lat);
            session.setAttribute("lng", lon);

            System.out.println("📍 위도: " + lat + ", 경도: " + lon);

            // 4. OpenWeatherMap API 호출
            String openWeatherApiKey = "";
            String weatherUrl = String.format(
                    "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%s&units=metric&lang=kr",
                    lat, lon, openWeatherApiKey
            );

            ResponseEntity<Map> weatherRes = restTemplate.getForEntity(weatherUrl, Map.class);
            Map<String, Object> weatherBody = weatherRes.getBody();

            Map<String, Object> result = new HashMap<>();
            result.put("city", cityName);
            result.put("temp", ((Map<?, ?>) weatherBody.get("main")).get("temp"));
            result.put("feels_like", ((Map<?, ?>) weatherBody.get("main")).get("feels_like"));

            Map<?, ?> weather = ((List<Map<?, ?>>) weatherBody.get("weather")).get(0);
            result.put("description", convertWeatherDescription(weather.get("description").toString()));
            result.put("icon", weather.get("icon"));

            System.out.println("✅ 날씨 정보 조회 완료: " + result);
            return result;

        } catch (Exception e) {
            System.out.println("❌ 예외 발생");
            e.printStackTrace();
            return Map.of("error", "날씨 조회 중 오류 발생");
        }
    }


}


