package com.springmvc.rowmapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.Post;

public class PostRowMapper implements RowMapper<Post>{

	@Override
	public Post mapRow(ResultSet rs, int rowNum) throws SQLException {
		Post post = new Post();
		post.setId(rs.getLong("id"));
		post.setTitle(rs.getString("title"));
        post.setContent(rs.getString("content"));
        post.setCategory(rs.getString("category"));
        post.setUserId(rs.getString("userId"));
        post.setApartmentCode(rs.getString("apartmentCode"));
        post.setDong(rs.getString("dong"));
        post.setCreatedAt(rs.getTimestamp("createdAt"));
        post.setFileName(rs.getString("fileName"));
        post.setViews(rs.getInt("views"));
        post.setLikeCount(rs.getInt("likeCount"));
        return post;
	}

}
