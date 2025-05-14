package com.springmvc.repository;

import com.springmvc.domain.Member;
import jakarta.servlet.http.HttpSession;

import java.util.List;

public interface MemberRepository {

    // CREATE

    void addMember(Member member);

    // UPDATE

    void updateMember(Member member);

    void updateRole(int role, String userId);

    void updateProfileImage(String userId, String name);

    // DELETE

    void deleteMember(HttpSession session);

    void deleteByUserId(String userId);


    // READ

    Member getByUserId(String userId);

    List<Member> getPagedMembers(int offset, int limit);

    int countAll();

    String getProfileImage(String userId);

    int getNewMemberCountWithinDays(int days);

    int getByUserRole(int num);
}
