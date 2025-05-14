package com.springmvc.rowmapper;

import com.springmvc.domain.VoteOption;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class VoteOptionRowMapper implements RowMapper<VoteOption> {
    @Override
    public VoteOption mapRow(ResultSet rs, int rowNum) throws SQLException {
        VoteOption option = new VoteOption();
        option.setId(rs.getInt("id"));
        option.setVoteId(rs.getInt("voteId"));
        option.setOptionText(rs.getString("optionText"));
        return option;
    }
}