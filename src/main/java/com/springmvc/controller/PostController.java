package com.springmvc.controller;

import com.springmvc.domain.Comment;
import com.springmvc.domain.Image;
import com.springmvc.domain.Member;
import com.springmvc.domain.Post;
import com.springmvc.service.CommentService;
import com.springmvc.service.ImageService;
import com.springmvc.service.MemberService;
import com.springmvc.service.PostService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@Controller
@RequestMapping("/post")
public class PostController {

    @Autowired
    private PostService postService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private ImageService imageService;

    @Autowired
    private MemberService memberService;

    // CREATE

    @GetMapping("/add")
    public String addPostForm(@ModelAttribute("NewPost") Post post) {
        return "post/postForm";
    }

    @PostMapping("/add")
    public String addPost(@ModelAttribute("NewPost") Post post, HttpSession session) {
        Member member = (Member) session.getAttribute("mb");

        if (member == null) return "redirect:/member/login";

        post.setUserId(member.getUserId());
        post.setApartmentCode(member.getApartmentCode());
        post.setDong(member.getDong());

        postService.addPost(post);

        // 이미지 refId 연결만 하면 됨
        imageService.updateRefIdForRecent("post", post.getId());
        System.out.println("📌 이미지 refId 업데이트 실행: " + post.getId());


        return "redirect:/post/list";
    }


    // UPDATE

    @GetMapping("/update")
    public String updatePostForm(@RequestParam("id") Long id, Model model) {
        Post post = postService.getPostById(id);

        model.addAttribute("updatePost", post);
        return "post/postUpdate";
    }

    @PostMapping("/update")
    public String updatePost(@ModelAttribute("updatePost") Post post) {
        postService.updatePost(post);

        // Summernote content에서 이미지 src 추출
        List<Image> images = extractImageObjects(post.getContent());

        // refType/post + refId(postId) 기준으로 저장
        imageService.updateImageReferences("post", post.getId(), images);

        return "redirect:/post/detail?id=" + post.getId();
    }


    // DELETE

    @GetMapping("/delete")
    @ResponseBody
    public String deletePost(@RequestParam("id") Long id, HttpServletRequest req) {
        String path = "/home/admin/uploads";
        postService.deletePost(id);
        imageService.deleteImage("post", id, path);
        return "success";
    }

    // READ

    @GetMapping("/detail")
    public String readPostById(@RequestParam("id") Long id, Model model, HttpSession session) {

        Member mb = (Member) session.getAttribute("mb");
        Post post = postService.getPostById(id);

        if (post == null) {
            return "redirect:/post/list";
        }


        List<Comment> comments = commentService.getComments("post", id);
        postService.incrementViews(id);

        Member nickname = memberService.getByUserId(post.getUserId());

        int replyCount = 0;

        for (Comment comment : comments) {
            Long commentId = comment.getId();
            replyCount = commentService.getReplyCount(commentId);
            comment.setReplyCount(replyCount);
        }

        model.addAttribute("post", post);
        model.addAttribute("mb", mb);
        model.addAttribute("comments", comments);
        model.addAttribute("nickname", nickname.getNickname());

        return "post/postDetail";
    }

    @GetMapping("/list")
    public String postList(Model model) {
        List<Post> popularPosts = postService.getPopularPosts();

        Map<Long, String> thumbnailMap = new HashMap<Long, String>();
        for (Post post : popularPosts) {
            String thumbnail = imageService.findFirstImageByRef("post", post.getId());
            thumbnailMap.put(post.getId(), thumbnail);
        }

        Map<String, String> nicknameMap = new HashMap<String, String>();
        for (Post post : popularPosts) {
            String userId = post.getUserId();
            if (!nicknameMap.containsKey(userId)) {
                Member member = memberService.getByUserId(userId);
                nicknameMap.put(userId, member.getNickname());
            }
        }

        model.addAttribute("popularPosts", popularPosts);
        model.addAttribute("thumbnailMap", thumbnailMap);
        model.addAttribute("nicknameMap", nicknameMap);

        return "post/postList";
    }

    @GetMapping("/search")
    @ResponseBody
    public Map<String, Object> searchPosts(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String choice,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String sort,
            @RequestParam(defaultValue = "1") int page) {
        int limit = 10;
        int offset = (page - 1) * limit;

        List<Post> posts = postService.searchPosts(category, choice, keyword, sort, limit, offset);
        int totalCount = postService.getSearchResultCount(category, choice, keyword);
        int totalPages = (int) Math.ceil((double) totalCount / limit);

        Map<Long, Boolean> imageMap = new HashMap<>();
        for (Post post : posts) {
            boolean hasImage = imageService.hasImage("post", post.getId());
            imageMap.put(post.getId(), hasImage);
        }

        Map<String, String> nicknameMap = new HashMap<>();
        for (Post post : posts) {
            String userId = post.getUserId();
            if (!nicknameMap.containsKey(userId)) {
                Member mb = memberService.getByUserId(userId);
                nicknameMap.put(userId, mb.getNickname());
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("posts", posts);
        result.put("currentPage", page);
        result.put("totalPages", totalPages);
        result.put("imageMap", imageMap);
        result.put("nicknameMap", nicknameMap);

        return result;
    }

    // UTILITY


    private List<Image> extractImageObjects(String content) {
        List<Image> images = new ArrayList<>();
        if (content == null) return images;

        Pattern pattern = Pattern.compile("<img[^>]*src=[\"']([^\"']+)[\"'][^>]*>");
        Matcher matcher = pattern.matcher(content);
        while (matcher.find()) {
            String src = matcher.group(1);
            String saveName = src.substring(src.lastIndexOf("/") + 1);

            Image img = new Image();
            img.setFileName(saveName);
            images.add(img);
        }

        return images;
    }


}
