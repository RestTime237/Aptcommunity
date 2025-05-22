package com.springmvc.controller;

import com.springmvc.domain.Member;
import com.springmvc.domain.Post;
import com.springmvc.domain.Product;
import com.springmvc.service.MemberService;
import com.springmvc.service.PostService;
import com.springmvc.service.ProductService;
import com.springmvc.service.wishlistService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.File;
import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private PostService postService;

    @Autowired
    private ProductService productService;

    @Autowired
    private wishlistService wishlistService;


    // CREATE

    @GetMapping("/register")
    public String addMemberForm(@ModelAttribute("NewMember") Member member) {
        return "member/register";
    }

    @PostMapping("/register")
    public String addMember(@ModelAttribute Member member,
                            @RequestParam("buildingName") String buildingName,
                            @RequestParam("roadAddress") String roadAddress,
                            @RequestParam("sigunguCode") String sigunguCode,
                            @RequestParam("roadnameCode") String roadnameCode,
                            Model model) {
        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl("https://apis.data.go.kr/1613000/AptListService3/getRoadnameAptList3")
                    .queryParam("serviceKey", "aXyObuGPEAQMX%2BVEblg9toTV8WnQy3bVimRyj7gcAJnGYrdc9WqQRMkB6zFM9%2FfIKgL%2FQ%2F0qYaGvamAOsyXv%2Fg%3D%3D")
                    .queryParam("roadCode", sigunguCode + roadnameCode)
                    .queryParam("pageNo", 1)
                    .queryParam("numOfRows", 100)
                    .queryParam("_type", "json")
                    .build(true)
                    .toUri();

            RestTemplate restTemplate = new RestTemplate();
            String response = restTemplate.getForObject(uri, String.class);

            JSONObject json = new JSONObject(response);
            JSONArray items = json.getJSONObject("response")
                    .getJSONObject("body")
                    .getJSONArray("items");

            String normalizedBuildingName = buildingName.replaceAll("[\\s아파트]", "");
            String normalizedRoadAddress = roadAddress.replaceAll("\\s", "");

            String matchedKaptCode = null;

            // 🔹 1차: buildingName과 kaptName 매칭
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                String kaptName = item.getString("kaptName").replaceAll("[\\s아파트]", "");

                if (kaptName.contains(normalizedBuildingName) || normalizedBuildingName.contains(kaptName)) {
                    matchedKaptCode = item.getString("kaptCode");
                    System.out.println("✅ 아파트 이름 매칭 성공: " + matchedKaptCode);
                    break;
                }
            }

            // 🔹 2차: 도로명주소 매칭
            if (matchedKaptCode == null) {
                for (int i = 0; i < items.length(); i++) {
                    JSONObject item = items.getJSONObject(i);
                    String doroJuso = item.getString("doroJuso").replaceAll("\\s", "");

                    if (doroJuso.contains(normalizedRoadAddress) || normalizedRoadAddress.contains(doroJuso)) {
                        matchedKaptCode = item.getString("kaptCode");

                        System.out.println("☑️ 주소 기반 매칭 성공: " + matchedKaptCode);
                        break;
                    }
                }
            }

            // 최종 적용
            if (matchedKaptCode != null) {
                member.setApartmentCode(matchedKaptCode);
                member.setRoadAddress(sigunguCode + roadnameCode);

            } else {
                System.out.println("❌ 아파트 코드 매칭 실패");
            }

        } catch (Exception e) {
            System.out.println("❌ API 처리 중 예외 발생");
            e.printStackTrace();
        }

        memberService.addMember(member);
        model.addAttribute("member", member);
        return "member/check";
    }


    // UPDATE

    @GetMapping("/update")
    public String updateMemberForm(HttpSession session, Model model) {
        Member mb = (Member) session.getAttribute("mb");
        model.addAttribute("updateMember", mb);
        return "member/memberUpdate";
    }

    @PostMapping("/update")
    public String updateMember(@ModelAttribute Member updateMember, HttpSession session) {
        Member update = (Member) session.getAttribute("mb");
        System.out.println("업데이트 내용물 : " + update);

        update.setUsername(isNullOrBlank(updateMember.getUsername()) ? update.getUsername() : updateMember.getUsername());
        update.setPassword(isNullOrBlank(updateMember.getPassword()) ? update.getPassword() : updateMember.getPassword());
        update.setNickname(isNullOrBlank(updateMember.getNickname()) ? update.getNickname() : updateMember.getNickname());
        update.setApartmentCode(isNullOrBlank(updateMember.getApartmentCode()) ? update.getApartmentCode() : updateMember.getApartmentCode());
        update.setDong(isNullOrBlank(updateMember.getDong()) ? update.getDong() : updateMember.getDong());

        memberService.updateMember(update);
        session.setAttribute("mb", update);
        return "";
    }

    @PostMapping("/uploadProfileImage")
    @ResponseBody
    public String uploadProfileImage(@RequestParam MultipartFile profileImage, HttpSession session, HttpServletRequest req) {
        Member mb = (Member) session.getAttribute("mb");
        if (mb == null) return "home";

        deleteProfileImage(session, req);        // 이미 등록된 프로필 이미지를 삭제

        String path = "/home/admin/uploads";        // 이미지 경로 지정
        String name = System.currentTimeMillis() + "." + profileImage.getOriginalFilename().split("\\.")[1];        // 동적 네이밍

        System.out.println(profileImage.getOriginalFilename());

        File file = new File(path, name);        // path 경로에 name 이름의 파일 생성
        try {
            profileImage.transferTo(file);        // 이미지를 파일에 삽입
            memberService.updateProfileImage(mb.getUserId(), name);        // DB에 파일 이름 등록
            mb.setProfileImage(name);        // 멤버 DTO에 파일 이름 등록
            session.setAttribute("mb", mb);        // 세션 갱신
        } catch (Exception e) {
            e.printStackTrace();
        }
        return name;
    }

    // DELETE

    @GetMapping("/delete")
    public String deleteMember(HttpSession session) {
        memberService.deleteMember(session);
        session.invalidate();
        return "redirect:/";
    }

    @PostMapping("/deleteProfileImage")
    @ResponseBody
    public void deleteProfileImage(HttpSession session, HttpServletRequest req) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null || userId.isBlank()) return;

        String filename = memberService.getProfileImage(userId);        // 저장된 프로필이미지 이름 가져오기
        if (filename != null && !filename.equals("default-profile.png")) {        // 이름이 존재하면 실행
            String path = "/home/admin/uploads";        // 이미지 경로 파악
            File file = new File(path, filename);        // path 경로에 filename 파일 생성
            if (file.exists()) {        // 파일이 존재할 경우
                file.delete();        // 파일 삭제
            }
        }

        memberService.updateProfileImage(userId, null);        // 멤버 DB 갱신 프로필 이미지 null

        ((Member) session.getAttribute("mb")).setProfileImage(null);        // 세션 갱신
    }

    // READ

    @GetMapping("/read")
    public String readMember(Model model) {
        Member member = memberService.getByUserId("sss"); // 실제 존재하는 userId로

        if (member != null) {
            System.out.println("회원 이름: " + member.getUsername());
            System.out.println("닉네임: " + member.getNickname());
        } else {
            System.out.println("해당 아이디의 회원을 찾을 수 없습니다.");
        }

        model.addAttribute("member", member);
        return "member/check";  // 또는 확인용 JSP
    }

    @GetMapping("/login")
    public String loginForm(@ModelAttribute("loginForm") Member member) {
        return "member/login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute("loginForm") Member member, Model model, HttpSession session) {
        Member mb = memberService.getByUserId(member.getUserId()); // 폼에서 입력한 아이디가 DB에 실존하는지 확인

        if (mb == null || !member.getPassword().equals(mb.getPassword())) {
            model.addAttribute("loginError", "아이디 혹은 비밀번호가 유효하지 않습니다.");
            return "member/login";
        }


        System.out.println("로그인한 멤버 : " + mb.getUserId());
        session.setAttribute("mb", mb); // 해당 멤버객체를 세션에 넣음
        session.setAttribute("userId", mb.getUserId());

        String previousUrl = (String) session.getAttribute("previousUrl");
        if (previousUrl != null) {
            session.removeAttribute("previousUrl");

            return "redirect:" + previousUrl;
        }

        return "redirect:/";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // UTILITY

    @GetMapping("/mypage")
    public String myPage(HttpSession session, Model model) {

        String userId = (String) session.getAttribute("userId");

        // 기본 게시글 1페이지 로딩
        int limit = 10;
        int offset = 0;
        List<Post> myPosts = postService.getPostByUserId(userId, offset, limit);
        List<Product> myProducts = productService.getProductByUserId(userId, offset, limit);
        int totalPages = (int) Math.ceil((double) postService.getPostCount(userId) / limit);

        int postCount = postService.getPostCount(userId);
        int productCount = productService.getProductCount(userId);
        int wishCount = wishlistService.getWishCount(userId);

        model.addAttribute("postCount", postCount);
        model.addAttribute("productCount", productCount);
        model.addAttribute("wishCount", wishCount);

        model.addAttribute("myPosts", myPosts);
        model.addAttribute("myProducts", myProducts);
        model.addAttribute("currentPostPage", 1);
        model.addAttribute("postTotalPages", totalPages);

        return "member/mypage";
    }

    @GetMapping("/mypage/posts")
    @ResponseBody
    public Map<String, Object> getMyPosts(@RequestParam(defaultValue = "1") int page, HttpSession session) {
        Member mb = (Member) session.getAttribute("mb");
        int limit = 10;
        int offset = (page - 1) * limit;

        List<Post> posts = postService.getPostByUserId(mb.getUserId(), offset, limit);
        int count = postService.getPostCount(mb.getUserId());
        int totalPages = (int) Math.ceil((double) count / limit);

        Map<String, Object> result = new HashMap<>();
        result.put("posts", posts);
        result.put("currentPage", page);
        result.put("totalPages", totalPages);
        return result;
    }

    @GetMapping("/mypage/products")
    @ResponseBody
    public Map<String, Object> getMyProducts(@RequestParam(defaultValue = "1") int page, HttpSession session) {
        Member mb = (Member) session.getAttribute("mb");
        int limit = 10;
        int offset = (page - 1) * limit;

        List<Product> products = productService.getProductByUserId(mb.getUserId(), offset, limit);
        int count = productService.getProductCount(mb.getUserId());
        int totalPages = (int) Math.ceil((double) count / limit);

        Map<String, Object> result = new HashMap<>();
        result.put("products", products);
        result.put("currentPage", page);
        result.put("totalPages", totalPages);
        return result;
    }

    @GetMapping("/mypage/wishlist")
    @ResponseBody
    public Map<String, Object> getMyWishlist(@RequestParam(defaultValue = "1") int page, HttpSession session) {
        Member mb = (Member) session.getAttribute("mb");
        int limit = 6;
        int offset = (page - 1) * limit;

        List<Product> wishlists = wishlistService.getWishlistByUser(mb.getUserId(), offset, limit);
        int count = wishlistService.getWishCount(mb.getUserId());
        int totalPages = (int) Math.ceil((double) count / limit);

        Map<String, Object> result = new HashMap<>();
        result.put("wishlist", wishlists);
        result.put("currentPage", page);
        result.put("totalPages", totalPages);
        return result;
    }

    private boolean isNullOrBlank(String str) {
        return str == null || str.isBlank();
    }
}
