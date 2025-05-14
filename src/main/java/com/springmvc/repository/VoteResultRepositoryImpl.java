package com.springmvc.repository;

import com.springmvc.domain.VoteResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class VoteResultRepositoryImpl implements VoteResultRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void saveResult(VoteResult result) {
        String sql = "INSERT INTO voteResult (voteId, optionId, memberId) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, result.getVoteId(), result.getOptionId(), result.getMemberId());
    }

    @Override
    public boolean existsByVoteIdAndUserId(int voteId, String memberId) {
        String sql = "SELECT COUNT(*) FROM voteResult WHERE voteId = ? AND memberId = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, voteId, memberId);
        return count != null && count > 0;
    }

    @Override
    public int countByVoteId(int voteId) {
        String sql = "SELECT COUNT(*) FROM voteResult WHERE voteId = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, voteId);
    }

    @Override
    public int countByOptionId(int optionId) {
        String sql = "SELECT COUNT(*) FROM voteResult WHERE optionId = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, optionId);
    }

    @Override
    public int findOptionIdByVoteIdAndUserId(int voteId, String userId) {
        String sql = "SELECT optionId FROM voteResult WHERE voteId = ? AND memberId = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, voteId, userId);
    }


}
