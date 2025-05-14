package com.springmvc.controller;

import com.springmvc.domain.Member;
import com.springmvc.service.RecommendService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class RecommendController {

    @Autowired
    private RecommendService recommendService;

    @PostMapping("/recommend")
    @ResponseBody
    public String recommend(@RequestParam String refType, @RequestParam Long refId, HttpSession session) {
        Member mb = (Member) session.getAttribute("mb");
        System.out.println("추천 요청 사용자 : " + mb.getUserId());

        boolean liked = recommendService.toggleRecommend(mb.getUserId(), refType, refId);
        System.out.println("추천 결과: " + (liked ? "liked" : "unliked"));

        return liked ? "liked" : "unliked";
    }
}
