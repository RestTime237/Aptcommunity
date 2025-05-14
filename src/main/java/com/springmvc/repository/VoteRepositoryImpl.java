package com.springmvc.repository;

import com.springmvc.domain.Vote;
import com.springmvc.rowmapper.VoteRowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;

@Repository
public class VoteRepositoryImpl implements VoteRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void addVote(Vote vote) {
        String SQL = "insert vote (title, content, creatorId, apartmentCode, deadline) values(?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, vote.getTitle());
            ps.setString(2, vote.getContent());
            ps.setString(3, vote.getCreatorId());
            ps.setString(4, vote.getApartmentCode());
            ps.setTimestamp(5, Timestamp.valueOf(vote.getDeadline()));
            return ps;
        }, keyHolder);

        vote.setVoteId(keyHolder.getKey().intValue());

    }

    @Override
    public Vote getVoteById(int voteId) {
        String SQL = "select * from vote where id = ?";
        return jdbcTemplate.queryForObject(SQL, new VoteRowMapper(), voteId);
    }

    @Override
    public List<Vote> getAllVotes() {
        String SQL = "select * from vote order by createdAt desc";
        return jdbcTemplate.query(SQL, new VoteRowMapper());
    }


    @Override
    public int getTotalVoteCount() {
        String SQL = "select count(*) from vote";
        return jdbcTemplate.queryForObject(SQL, Integer.class);
    }

    @Override
    public List<Vote> getPaginationVotes(int offset, int limit) {
        String SQL = "select * from vote order by createdAt desc limit ? offset ?";
        return jdbcTemplate.query(SQL, new VoteRowMapper(), limit, offset);
    }


}
