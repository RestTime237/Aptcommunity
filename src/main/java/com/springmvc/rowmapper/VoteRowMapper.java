package com.springmvc.rowmapper;

import com.springmvc.domain.Vote;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class VoteRowMapper implements RowMapper<Vote> {
    @Override
    public Vote mapRow(ResultSet rs, int rowNum) throws SQLException {
        Vote vote = new Vote();
        vote.setVoteId(rs.getInt("id"));
        vote.setTitle(rs.getString("title"));
        vote.setContent(rs.getString("content"));
        vote.setCreatorId(rs.getString("creatorId"));
        vote.setApartmentCode(rs.getString("apartmentCode"));
        vote.setCreatedAt(rs.getTimestamp("createdAt"));
        vote.setDeadline(rs.getTimestamp("deadline").toLocalDateTime());
        return vote;
    }
}
