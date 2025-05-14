package com.springmvc.repository;

import com.springmvc.domain.Comment;
import com.springmvc.rowmapper.CommentRowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CommentRepositoryImpl implements CommentRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void save(Comment comment) {
        String sql = "INSERT INTO comment (refType, refId, parentId, userId, content) " +
                "VALUES (?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                comment.getRefType(),
                comment.getRefId(),
                comment.getParentId(),
                comment.getUserId(),
                comment.getContent()
        );
    }

    @Override
    public List<Comment> findByRef(String refType, Long refId) {
        String sql = "SELECT * FROM comment WHERE refType = ? AND refId = ? AND isDeleted = FALSE ORDER BY createdAt ASC";
        return jdbcTemplate.query(sql, new CommentRowMapper(), refType, refId);
    }

    @Override
    public List<Comment> findReplies(Long parentId) {
        String sql = "SELECT * FROM comment WHERE parentId = ? AND isDeleted = FALSE ORDER BY createdAt ASC";
        return jdbcTemplate.query(sql, new CommentRowMapper(), parentId);
    }

    @Override
    public void update(Comment comment) {
        String sql = "UPDATE comment SET content = ?, updatedAt = CURRENT_TIMESTAMP WHERE id = ?";
        jdbcTemplate.update(sql, comment.getContent(), comment.getId());
    }

    @Override
    public void deleteComment(Long id, String refType, Long refId) {
        String sql = "UPDATE comment SET isDeleted = TRUE WHERE refType = ? and refId = ? and id = ?";
        jdbcTemplate.update(sql, refType, refId, id);
    }

    @Override
    public Comment findById(Long id) {
        String sql = "SELECT * FROM comment WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, new CommentRowMapper(), id);
    }

    @Override
    public int getReplyCount(Long commentId) {
        String sql = "SELECT COUNT(*) FROM comment WHERE parentId = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, commentId);
    }
}
