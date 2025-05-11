package com.springmvc.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.Member;
import com.springmvc.rowmapper.MemberRowMapper;

import jakarta.servlet.http.HttpSession;

@Repository
public class MemberRepositoryImpl implements MemberRepository{
	
	private JdbcTemplate jdbcTemplate;
	
	
	@Autowired
	public MemberRepositoryImpl(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

	
	// CREATE
	
	@Override
	public void addMember(Member member) {
		String SQL = "insert member(username, userId, password, nickname, apartmentCode, dong, roadAddress, role) values(?, ?, ?, ?, ?, ?, ?, ?)";
		jdbcTemplate.update(SQL, member.getUsername(), member.getUserId(), member.getPassword(), member.getNickname(), member.getApartmentCode(), member.getDong(), member.getRoadAddress(), 0);
		
	}
	
	
	
	// UPDATE
	
	@Override
	public void updateMember(Member member) {
		String SQL = "update member set username = ?, password = ?, nickname = ?, apartmentCode = ?, dong = ? where userId = ? ";
		jdbcTemplate.update(SQL, member.getUsername(), member.getPassword(), member.getNickname(), member.getApartmentCode(), member.getDong(), member.getUserId());
		
	}
	
	@Override
	public void updateRole(int role, String userId) {
		String SQL = "update member set role = ? where userId = ?";
		jdbcTemplate.update(SQL, role, userId);
		
	}
	
	@Override
	public void updateProfileImage(String userId, String name) {
		String SQL = "update member set profileImage = ? where userId = ?";
		jdbcTemplate.update(SQL, name, userId);
		
	}
	
	//DELETE
	
	@Override
	public void deleteMember(HttpSession session) {
		Member mb = (Member)session.getAttribute("mb");
		String id = mb.getUserId();
		String SQL = "delete from member where userId = ?";
		jdbcTemplate.update(SQL, id);
		
	}
	
	@Override
	public void deleteByUserId(String userId) {
		String SQL = "delete from member where userId = ?";
		jdbcTemplate.update(SQL, userId);
		
	}
	
	//READ
	
	@Override
	public Member getByUserId(String userId) {
	    String SQL = "SELECT * FROM member WHERE userId = ?";
	    try {
	    	return jdbcTemplate.queryForObject(SQL, new MemberRowMapper(), userId);
	    }catch (Exception e) {}
	    	return null;

	}

	@Override
	public List<Member> getPagedMembers(int offset, int limit) {
		String SQL = "select * from member order by createdAt desc limit ? offset ?";
		return jdbcTemplate.query(SQL, new MemberRowMapper(), limit, offset);
	}

	@Override
	public int countAll() {
		String SQL = "select count(*) from member";
		return jdbcTemplate.queryForObject(SQL, Integer.class);
	}


	
	@Override
	public String getProfileImage(String userId) {
		String SQL = "select profileImage from member where userId = ?";
		return jdbcTemplate.queryForObject(SQL, String.class, userId);
	}


	
	@Override
	public int getNewMemberCountWithinDays(int days) {
		String SQL = "select count(*) from member where createdAt >= Now() - interval ? day";
		return jdbcTemplate.queryForObject(SQL, Integer.class, days);
	}


	
	@Override
	public int getByUserRole(int num) {
		String SQL = "select count(*) from member where role = ?";
		return jdbcTemplate.queryForObject(SQL, Integer.class, num);
	}




	
}
