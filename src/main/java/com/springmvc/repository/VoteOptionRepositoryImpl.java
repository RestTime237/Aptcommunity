package com.springmvc.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.VoteOption;
import com.springmvc.rowmapper.VoteOptionRowMapper;

@Repository
public class VoteOptionRepositoryImpl implements VoteOptionRepository{

	@Autowired
    private JdbcTemplate jdbcTemplate;

	@Override
	public void addOption(VoteOption option) {
		String sql = "INSERT INTO voteOption (voteId, optionText) VALUES (?, ?)";
        jdbcTemplate.update(sql, option.getVoteId(), option.getOptionText());
		
	}

	@Override
	public List<VoteOption> getOptionsByVoteId(int voteId) {
		String sql = "SELECT * FROM voteOption WHERE voteId = ?";
        return jdbcTemplate.query(sql, new VoteOptionRowMapper(), voteId);
	}
	
	
}
