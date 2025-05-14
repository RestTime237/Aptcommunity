package com.springmvc.rowmapper;

import com.springmvc.domain.Comment;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class CommentRowMapper implements RowMapper<Comment> {

    @Override
    public Comment mapRow(ResultSet rs, int rowNum) throws SQLException {
        Comment comment = new Comment();

        comment.setId(rs.getLong("id"));
        comment.setRefType(rs.getString("refType"));
        comment.setRefId(rs.getLong("refId"));
        comment.setParentId(rs.getObject("parentId") != null ? rs.getInt("parentId") : null);
        comment.setUserId(rs.getString("userId"));
        comment.setContent(rs.getString("content"));
        comment.setCreatedAt(rs.getTimestamp("createdAt"));
        comment.setUpdatedAt(rs.getTimestamp("updatedAt"));
        comment.setDeleted(rs.getBoolean("isDeleted"));

        return comment;
    }

}
