package com.springmvc.repository;

import java.util.ArrayList;
import java.util.List;

import com.springmvc.domain.Member;


import jakarta.servlet.http.HttpSession;

public interface MemberRepository {
	
	// CREATE
	
	void addMember(Member member);
	
	// UPDATE
	
	void updateMember(Member member);
	
	void updateRole(int role, String userId);
	
	void updateProfileImage(String userId, String name);
	
	// DELETE
	
	void deleteMember(HttpSession session);
	
	public void deleteByUserId(String userId);

	
	// READ
	
	Member getByUserId(String userId);
	
	List<Member> getPagedMembers(int offset, int limit);
	
	int countAll();
	
	String getProfileImage(String userId);
	
	int getNewMemberCountWithinDays(int days);
	
	int getByUserRole(int num);
}
