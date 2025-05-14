package com.springmvc.rowmapper;

import com.springmvc.domain.VoteResult;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class VoteResultRowMapper implements RowMapper<VoteResult> {
    @Override
    public VoteResult mapRow(ResultSet rs, int rowNum) throws SQLException {
        VoteResult result = new VoteResult();
        result.setResultId(rs.getInt("resultId"));
        result.setVoteId(rs.getInt("voteId"));
        result.setOptionId(rs.getInt("optionId"));
        result.setMemberId(rs.getString("memberId"));
        result.setVotedAt(rs.getTimestamp("votedAt"));
        return result;
    }
}