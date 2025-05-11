package com.springmvc.repository;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.Product;
import com.springmvc.rowmapper.ProductRowMapper;


@Repository
public class WishlistRepositoryImpl implements WishlistRepository{
	
	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Override
	public void addWishlist(String userId, Long productId) {
		String SQL = "insert wishlist (userId, productId) values(?, ?)";
		jdbcTemplate.update(SQL, userId, productId);
		
	}

	@Override
	public void removeWishlist(String userId, Long productId) {
		String SQL = "delete from wishlist where userId = ? and productId = ?";
		jdbcTemplate.update(SQL, userId, productId);
		
	}

	@Override
	public boolean isWishlisted(String userId, Long productId) {
		String SQL = "select count(*) from wishlist where userId = ? and productId = ?";
		Integer count = jdbcTemplate.queryForObject(SQL, Integer.class, userId, productId);
		return count != null && count > 0;
	}

	@Override
	public List<Product> getWishlistByUser(String userId, int offset, int limit) {
		String SQL = "select p.* from product p join wishlist w on p.id = w.productId where w.userId = ? order by w.createdAt desc limit ? offset ? ";
		return jdbcTemplate.query(SQL, new ProductRowMapper(), userId, limit, offset);
	}
	
	@Override
	public List<Product> getWishlistByUser(String userId) {
		String SQL = "select p.* from product p join wishlist w on p.id = w.productId where w.userId = ? order by w.createdAt desc";
		return jdbcTemplate.query(SQL, new ProductRowMapper(), userId);
	}

	@Override
	public int getWishCount(String userId) {
		String SQL = "select count(*) from wishlist where userId = ?";
		return jdbcTemplate.queryForObject(SQL, new Object[] {userId}, Integer.class);
	}

	


}
