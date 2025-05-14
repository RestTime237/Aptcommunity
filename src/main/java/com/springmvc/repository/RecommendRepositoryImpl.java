package com.springmvc.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class RecommendRepositoryImpl implements RecommendRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public boolean exists(String userId, String refType, Long refId) {
        String sql = "SELECT COUNT(*) FROM recommend WHERE userId = ? AND refType = ? AND refId = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId, refType, refId);
        return count != null && count > 0;
    }

    @Override
    public void insert(String userId, String refType, Long refId) {
        String sql = "INSERT INTO recommend (userId, refType, refId) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, userId, refType, refId);

    }

    @Override
    public void delete(String userId, String refType, Long refId) {
        String sql = "DELETE FROM recommend WHERE userId = ? AND refType = ? AND refId = ?";
        jdbcTemplate.update(sql, userId, refType, refId);

    }


}
