package com.springmvc.service;

import com.springmvc.domain.Member;
import com.springmvc.repository.MemberRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberRepository memberRepository;

    // CREATE

    @Override
    public void addMember(Member member) {
        memberRepository.addMember(member);

    }

    // UPDATE

    @Override
    public void updateMember(Member member) {
        memberRepository.updateMember(member);

    }


    @Override
    public void updateRole(int role, String userId) {
        memberRepository.updateRole(role, userId);

    }

    @Override
    public void updateProfileImage(String userId, String name) {
        memberRepository.updateProfileImage(userId, name);

    }

    // DELETE

    @Override
    public void deleteMember(HttpSession session) {
        memberRepository.deleteMember(session);

    }

    @Override
    public void deleteByUserId(String userId) {
        memberRepository.deleteByUserId(userId);
    }

    // READ

    @Override
    public Member getByUserId(String userId) {
        Member userById = memberRepository.getByUserId(userId);
        return userById;
    }

    @Override
    public List<Member> getPagedMembers(int offset, int limit) {
        return memberRepository.getPagedMembers(offset, limit);
    }

    @Override
    public int countAll() {
        return memberRepository.countAll();
    }


    @Override
    public String getProfileImage(String userId) {
        return memberRepository.getProfileImage(userId);
    }


    @Override
    public int getNewMemberCountWithinDays(int days) {
        return memberRepository.getNewMemberCountWithinDays(days);
    }


    @Override
    public int getByUserRole(int num) {
        return memberRepository.getByUserRole(num);
    }


}
