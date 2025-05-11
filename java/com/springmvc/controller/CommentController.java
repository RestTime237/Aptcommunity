package com.springmvc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springmvc.domain.Comment;
import com.springmvc.domain.Member;
import com.springmvc.service.CommentService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/comment")
public class CommentController {
	
	@Autowired
	private CommentService commentService;

	// 댓글 목록 조회
    @GetMapping("/list")
    public String list(@RequestParam String refType, @RequestParam Long refId, Model model, HttpSession session) {
        List<Comment> comments = commentService.getComments(refType, refId);
        System.out.println("댓글리스트 : " + comments);

        model.addAttribute("comments", comments);
        model.addAttribute("refType", refType);
        model.addAttribute("refId", refId);
        model.addAttribute("mb", session.getAttribute("mb"));
        return "comment/list"; // AJAX or include 용 뷰
    }

    // 댓글 등록
    @PostMapping("/add")
    public String addComment(@ModelAttribute Comment comment, HttpSession session) {
    	System.out.println("코멘트 에드 컨트롤러 입장");

        Member mb = (Member) session.getAttribute("mb");
        if (mb == null) {
            return "redirect:/member/login";
        }

        comment.setUserId(mb.getUserId());

        commentService.addComment(comment);

        return "redirect:/" + comment.getRefType() + "/detail?" + "id=" + comment.getRefId();
    }
    
    @PostMapping("/add-ajax")
    @ResponseBody
    public String addReplyAjax(@RequestBody Comment comment, HttpSession session) {
        Member mb = (Member) session.getAttribute("mb");
        if (mb == null) {
            return "unauthorized";
        }

        comment.setUserId(mb.getUserId());

        commentService.addComment(comment);
        return "success";
    }



    // 댓글 수정
    @PostMapping("/update")
    @ResponseBody
    public String updateComment(@ModelAttribute Comment comment, @RequestParam String refType, @RequestParam Long refId, HttpSession session) {
    	
    	Member mb = (Member) session.getAttribute("mb");
        if (mb == null) {
            return "unauthorized";
        }
        comment.setRefType(refType);
        comment.setRefId(refId);
        commentService.updateComment(comment);
        return "success";
    }

    // 댓글 삭제
    @PostMapping("/delete")
    @ResponseBody
    public String deleteComment(@RequestParam Long id, @RequestParam String refType, @RequestParam Long refId, HttpSession session) {
    	 Member mb = (Member) session.getAttribute("mb");
    	    if (mb == null) {
    	    	return "/AptCommunity/member/login";
    	    }
        commentService.deleteComment(id, refType, refId);
        return "success";
    }
}
