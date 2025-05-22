package com.springmvc.controller;

import com.springmvc.domain.Member;
import com.springmvc.domain.Post;
import com.springmvc.domain.Product;
import com.springmvc.service.ImageService;
import com.springmvc.service.MemberService;
import com.springmvc.service.PostService;
import com.springmvc.service.ProductService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class HomeController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private PostService postService;

    @Autowired
    private ProductService productService;

    @Autowired
    private ImageService imageService;

    @GetMapping("/")
    public String home(Model model, HttpServletRequest req) {

        List<Post> recentPosts = postService.getPagedPosts(0, 5);
        List<Post> popularPosts = postService.getPopularPosts();
        List<Product> recentProducts = productService.getPagedProducts(0, 5);

        Map<String, String> nicknameMap = new HashMap<String, String>();
        for (Post post : popularPosts) {
            String userId = post.getUserId();
            if (!nicknameMap.containsKey(userId)) {
                Member member = memberService.getByUserId(userId);
                nicknameMap.put(userId, member.getNickname());
            }
        }

        // 최신 게시글 작성자
        for (Post post : recentPosts) {
            String userId = post.getUserId();
            if (!nicknameMap.containsKey(userId)) {
                Member member = memberService.getByUserId(userId);
                nicknameMap.put(userId, member.getNickname());
            }
        }

        // 최신 판매글 작성자
        for (Product product : recentProducts) {
            String userId = product.getUserId();
            if (!nicknameMap.containsKey(userId)) {
                Member member = memberService.getByUserId(userId);
                nicknameMap.put(userId, member.getNickname());
            }
        }

        Map<Long, String> thumbnailMap = new HashMap<Long, String>();
        for (Post post : popularPosts) {
            String thumbnail = imageService.findFirstImageByRef("post", post.getId());
            thumbnailMap.put(post.getId(), thumbnail);
        }

        model.addAttribute("recentPosts", recentPosts);
        model.addAttribute("popularPosts", popularPosts);
        model.addAttribute("recentProducts", recentProducts);
        model.addAttribute("nicknameMap", nicknameMap);
        model.addAttribute("thumbnailMap", thumbnailMap);

        return "home";
    }
}
