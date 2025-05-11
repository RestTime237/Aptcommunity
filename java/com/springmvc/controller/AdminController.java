package com.springmvc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springmvc.domain.Member;
import com.springmvc.service.MemberService;
import com.springmvc.service.PostService;
import com.springmvc.service.ProductService;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private PostService postService;
	
	@Autowired
	private ProductService productService;

	@GetMapping("/dashboard")
	public String dashboard(Model model) {
		model.addAttribute("memberCount", memberService.countAll());
		model.addAttribute("postCount", postService.countAllposts());
		model.addAttribute("productCount", productService.countAllProducts());
		
		return "admin/dashboard";
	}

	@GetMapping("/members")
	public String listMembers(@RequestParam(defaultValue = "1") int page, Model model) {
		
		int limit = 10;
		int offset = (page - 1) * limit;
		
		List<Member> memberList = memberService.getPagedMembers(offset, limit);
		int totalCount = memberService.countAll();
		int recentCount = memberService.getNewMemberCountWithinDays(30); 
		int totalPages = (int) Math.ceil((double) totalCount / limit);
		int adminCount = memberService.getByUserRole(3);
		
		model.addAttribute("members", memberList);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("recentCount", recentCount);
		model.addAttribute("adminCount", adminCount);
		
		return "admin/memberList";
	}
	
	@GetMapping("/members/{userId}")
	@ResponseBody
	public Member getMemberDetail(@PathVariable String userId) {
		System.out.println("getMemberDetail 메서드 입장");
		Member member = memberService.getByUserId(userId);
		System.out.println("전달받은 userId 값 : "+userId);

		if(member == null) System.out.println("member 널 발생 " + member);

		return member;
	}
	
	@PutMapping("/members/{userId}")
	@ResponseBody
	public String updateMember(@PathVariable String userId, @RequestBody Member member) {
		System.out.println("수정 요청 받은 userId : " + userId);
		System.out.println("수정할 데이터 : " + member.toString());

		memberService.updateMember(member);

		return "success";
	}
	
	
	@DeleteMapping("/members/{userId}")
	@ResponseBody
	public String deleteMember(@PathVariable String userId) {
		System.out.println("멤버 삭제 컨트롤러 입장");
		System.out.println("삭제 대상 : " +userId);


		memberService.deleteByUserId(userId);
		return "success";
	}
	
	@PostMapping("/updateRole")
	@ResponseBody
	public String updateRole(@RequestParam int role, @RequestParam String userId) {
		memberService.updateRole(role, userId);
		return "success";
	}
}
