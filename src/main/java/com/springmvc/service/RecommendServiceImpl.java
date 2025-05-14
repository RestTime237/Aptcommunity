package com.springmvc.service;

import com.springmvc.repository.RecommendRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class RecommendServiceImpl implements RecommendService {

    @Autowired
    private RecommendRepository recommendRepository;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public boolean toggleRecommend(String userId, String refType, Long refId) {
        boolean alreadyExists = recommendRepository.exists(userId, refType, refId);

        if (alreadyExists) {
            recommendRepository.delete(userId, refType, refId);
            updateLikeCount(refType, refId, -1);
            return false;
        } else {
            recommendRepository.insert(userId, refType, refId);
            updateLikeCount(refType, refId, +1);
            return true;
        }

    }

    private void updateLikeCount(String refType, Long refId, int diff) {
        String tableName;
        String idColumn;

        if (refType.equals("post")) {
            tableName = "post";
            idColumn = "id";  // post 테이블의 PK 컬럼명
        } else if (refType.equals("product")) {
            tableName = "product";
            idColumn = "id"; // product 테이블의 PK 컬럼명
        } else {
            throw new IllegalArgumentException("Invalid refType: " + refType);
        }

        String sql = "UPDATE " + tableName + " SET likeCount = likeCount + ? WHERE " + idColumn + " = ?";
        jdbcTemplate.update(sql, diff, refId);
    }


}
