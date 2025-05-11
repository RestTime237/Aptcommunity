package com.springmvc.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.Image;
import com.springmvc.rowmapper.ImageRowMapper;


@Repository
public class ImageRepositoryImpl implements ImageRepository{
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Override
	public void saveImage(Image img) {
		String SQL = "insert image (refType, refId, fileName) values(?, ?, ?)";
		jdbcTemplate.update(SQL, img.getRefType(), img.getRefId(), img.getFileName());
	}
	
	@Override
	public void save(String refType, Long refId, Image img) {
		String SQL = "insert image (refType, refId, fileName) values(?, ?, ?)";
		jdbcTemplate.update(SQL, refType, refId, img.getFileName());
		
	}

	@Override
	public void updateRefIdForRecent(String refType, Long refId) {
		String SQL = "update image set refId = ? where refType = ? and refId is null and uploadedAt > now() - interval 10 minute";
		jdbcTemplate.update(SQL, refId, refType);
	}

	@Override
	public void deleteImage(String refType, Long refId) {
		String SQL = "delete from image where refType = ? and refId = ?";
		jdbcTemplate.update(SQL, refType, refId);
		
	}

	@Override
	public List<Image> getImageByRefId(String refType, Long refId) {
		String SQL = "select * from image where refType = ? and refId = ?";
		return jdbcTemplate.query(SQL, new ImageRowMapper(), refType, refId);
	}

	@Override
	public boolean hasImage(String refType, Long refId) {
		String SQL = "select count(*) from image where refType = ? and refId = ?";
		Integer count = jdbcTemplate.queryForObject(SQL, Integer.class, refType, refId);
		return count != null && count > 0;
	}

	
	@Override
	public String findFirstImageByRef(String refType, Long refId) {
		String SQL = "select filename from image where refType = ? and refId = ? order by id asc limit 1";
		List<String> result = jdbcTemplate.queryForList(SQL, String.class, refType, refId);
		return result.isEmpty() ? null : result.get(0);
	}

	

	


}
