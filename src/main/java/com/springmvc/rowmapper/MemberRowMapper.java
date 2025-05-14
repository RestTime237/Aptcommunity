package com.springmvc.rowmapper;

import com.springmvc.domain.Member;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class MemberRowMapper implements RowMapper<Member> {

    @Override
    public Member mapRow(ResultSet rs, int rowNum) throws SQLException {
        Member member = new Member();
        member.setId(rs.getLong("id"));
        member.setUsername(rs.getString("username"));
        member.setUserId(rs.getString("userId"));
        member.setPassword(rs.getString("password"));
        member.setNickname(rs.getString("nickname"));
        member.setApartmentCode(rs.getString("apartmentCode"));
        member.setDong(rs.getString("dong"));
        member.setRoadAddress(rs.getString("roadAddress"));
        member.setRole(rs.getInt("role"));
        member.setCreatedAt(rs.getTimestamp("createdAt"));
        member.setProfileImage(rs.getString("profileImage"));
        return member;
    }


}
