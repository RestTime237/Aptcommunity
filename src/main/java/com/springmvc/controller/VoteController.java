package com.springmvc.controller;

import com.springmvc.domain.Member;
import com.springmvc.domain.Vote;
import com.springmvc.domain.VoteOption;
import com.springmvc.service.VoteService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/vote")
public class VoteController {

    @Autowired
    private VoteService voteService;

    // CREATE
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("vote", new Vote());
        return "vote/voteForm";
    }

    @PostMapping("/add")
    public String addVote(@ModelAttribute Vote vote, @RequestParam("optionTexts") List<String> optionTexts,
                          HttpSession session) {
        Member loginUser = (Member) session.getAttribute("mb");
        vote.setCreatorId(loginUser.getUserId());
        vote.setApartmentCode(loginUser.getApartmentCode());
        voteService.addVoteWithOptions(vote, optionTexts);
        return "redirect:/vote/list";
    }

    // READ
    @GetMapping("/list")
    public String listVotes(@RequestParam(defaultValue = "1") int page, Model model, HttpSession session) {
        Member mb = (Member) session.getAttribute("mb");

        int limit = 10;
        int offset = (page - 1) * limit;

        List<Vote> voteList = voteService.getPaginationVotes(offset, limit);
        int totalCount = voteService.getTotalVoteCount();

        int totalPages = (int) Math.ceil((double) totalCount / limit);

        model.addAttribute("voteList", voteList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("mb", mb);

        return "vote/voteList";
    }

    @GetMapping("/detail")
    public String viewVote(@RequestParam("voteId") int voteId, Model model, HttpSession session) {
        // 투표 정보 조회
        Vote vote = voteService.getVoteById(voteId);

        // 투표 옵션 조회
        List<VoteOption> options = voteService.getOptionsByVoteId(voteId);
        System.out.println("voteId: " + voteId);
        System.out.println("옵션 개수: " + options.size());

        // 전체 투표수
        int totalVoteCount = voteService.getTotalVoteCount(voteId);

        for (VoteOption option : options) {
            int count = voteService.getVoteCountByOptionId(option.getId());
            option.setVoteCount(count);
            option.setPercentage(totalVoteCount == 0 ? 0 : (int) Math.round(count * 100.0 / totalVoteCount));
        }

        // 5. 사용자 투표 여부 확인
        String userId = (String) session.getAttribute("userId");
        boolean alreadyVoted = voteService.hasUserVoted(voteId, userId);
        int selectedOptionId = alreadyVoted
                ? voteService.getSelectedOptionId(voteId, userId)
                : -1;

        vote.setVoteOptions(options);
        vote.setVoteCount(totalVoteCount);

        model.addAttribute("vote", vote);
        model.addAttribute("voteOptions", options);
        model.addAttribute("alreadyVoted", alreadyVoted);
        model.addAttribute("selectedOptionId", selectedOptionId);
        model.addAttribute("totalVoteCount", totalVoteCount);
        model.addAttribute("userId", userId);

        return "vote/voteDetail";
    }

    // UPDATE
    @PostMapping("/submit")
    public String submitVote(@RequestParam("voteId") int voteId,
                             @RequestParam("optionId") int optionId,
                             HttpSession session) {
        Member user = (Member) session.getAttribute("mb");
        voteService.submitVote(voteId, optionId, user.getUserId());
        return "redirect:/vote/detail?voteId=" + voteId;
    }

    @PostMapping("/delete")
    public String deleteVote(@RequestParam("voteId") int voteId, HttpSession session) {
        System.out.println("투표 삭제 컨트롤러 " + voteId);
        Member mb = (Member) session.getAttribute("mb");
        if (mb != null) {
            voteService.deleteVoteById(voteId);
        } else {
            return "redirect:member/login";
        }

        return "redirect:/vote/list";
    }
}
