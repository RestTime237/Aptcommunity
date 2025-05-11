package com.springmvc.repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.Product;
import com.springmvc.rowmapper.ProductRowMapper;

@Repository
public class ProductRepositoryImpl implements ProductRepository{
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	
	// CREATE
	@Override
	public void addProduct(Product product) {
		String SQL = "insert product(status, name, description, price, quantity, category, image, userId) values(?, ?, ?, ?, ?, ?, ?, ?)";
		KeyHolder keyHolder = new GeneratedKeyHolder();
		jdbcTemplate.update(connection -> {
			PreparedStatement ps = connection.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
			ps.setString(1, product.getStatus());
			ps.setString(2, product.getName());
			ps.setString(3, product.getDescription());
			ps.setLong(4, product.getPrice());
			ps.setLong(5, product.getQuantity());
			ps.setString(6, product.getCategory());
			ps.setString(7, product.getImage());
			ps.setString(8, product.getUserId());
			return ps;
		}, keyHolder);
		product.setId(keyHolder.getKey().longValue());
	}
	
	// READ
	@Override
	public Product getProductById(Long id) {
		String SQL = "select * from product where id = ?";
		return jdbcTemplate.queryForObject(SQL, new ProductRowMapper(), id);
	}

	@Override
	public List<Product> getPagedProducts(int offset, int limit) {
		String SQL = "select * from product order by id desc limit ? offset ?";
		return jdbcTemplate.query(SQL, new ProductRowMapper(), limit, offset);
	}
	
	@Override
	public int countAllProducts() {
		String SQL = "select count(*) from product";
		return jdbcTemplate.queryForObject(SQL, Integer.class);
	}
	
	@Override
	public List<Product> searchProducts(String category, String status, String choice, String keyword, String sort, Long minPrice, Long maxPrice, int limit, int offset) {
		StringBuilder SQL = new StringBuilder("SELECT * FROM product WHERE 1=1");
		List<Object> params = new ArrayList<>();
		if (category != null && !category.isEmpty()) {
			SQL.append(" AND category = ?");
			params.add(category);
		}
		if (status != null && !status.isEmpty()) {
			SQL.append(" AND status = ?");
			params.add(status);
		}
		if (keyword != null && !keyword.isEmpty()) {
			if ("titleAndContent".equals(choice)) {
				SQL.append(" AND (name LIKE ? OR description LIKE ?)");
				String likeKeyword = "%" + keyword + "%";
				params.add(likeKeyword);
				params.add(likeKeyword);
			} else if ("writer".equals(choice)) {
				SQL.append(" AND userId LIKE ?");
				params.add("%" + keyword + "%");
			} else {
				SQL.append(" and (name like ? or description like ? or userId like ?)");
				String likeKeyword = "%" + keyword + "%";
				params.add(likeKeyword);
				params.add(likeKeyword);
				params.add(likeKeyword);
			}
		}
		if(minPrice != null && minPrice > 0) {
			SQL.append(" and price >= ?");
			params.add(minPrice);
		}
		if(maxPrice != null && maxPrice > 0) {
			SQL.append(" and price <= ?");
			params.add(maxPrice);
		}

		switch (sort) {
			case "popular":		// 인기순(조회수)
				SQL.append(" order by views DESC, id DESC");
				break;
			case "priceAsc":		// 가격 낮은 순
				SQL.append(" order by price ASC, id DESC");
				break;
			case "priceDesc":		// 가격 높은 순
				SQL.append(" order by price DESC, id DESC");
				break;
			case "latest":		// 최신순
			default:
				SQL.append(" order by createdAt DESC, id DESC");		// 기본값 : 최신순
		}

		SQL.append(" limit ? offset ?");

		params.add(limit);
		params.add(offset);

		return jdbcTemplate.query(SQL.toString(), params.toArray(), new ProductRowMapper());
	}
	
	@Override
	public int getSearchResultCount(String category, String status, String choice, String keyword, Long minPrice, Long maxPrice) {
		StringBuilder SQL = new StringBuilder("select count(*) from product where 1=1");
		List<Object> params = new ArrayList<>();
		if (category != null && !category.isEmpty()) {
			SQL.append(" AND category = ?");
			params.add(category);
		}
		if (status != null && !status.isEmpty()) {
			SQL.append(" AND status = ?");
			params.add(status);
		}
		if (keyword != null && !keyword.isEmpty()) {
			if ("titleAndContent".equals(choice)) {
				SQL.append(" AND (name LIKE ? OR description LIKE ?)");
				String likeKeyword = "%" + keyword + "%";
				params.add(likeKeyword);
				params.add(likeKeyword);
			} else if ("writer".equals(choice)) {
				SQL.append(" AND userId LIKE ?");
				params.add("%" + keyword + "%");
			} else {
				SQL.append(" and (name like ? or description like ? or userId like ?)");
				String likeKeyword = "%" + keyword + "%";
				params.add(likeKeyword);
				params.add(likeKeyword);
				params.add(likeKeyword);
			}
		}
		if(minPrice != null && minPrice > 0) {
			SQL.append(" and price >= ?");
			params.add(minPrice);
		}
		if(maxPrice != null && maxPrice > 0) {
			SQL.append(" and price <= ?");
			params.add(maxPrice);
		}
		return jdbcTemplate.queryForObject(SQL.toString(), params.toArray(), Integer.class);
	}
	
	@Override
	public List<Product> getProductByUserId(String userId, int offset, int limit) {
		String SQL = "select * from product where userId = ? order by createdAt desc limit ? offset ?";
		return jdbcTemplate.query(SQL, new ProductRowMapper(), userId, limit, offset);
	}
	
	@Override
	public int getProductCount(String userId) {
		String SQL = "select count(*) from product where userId = ?";
		return jdbcTemplate.queryForObject(SQL, new Object[] {userId}, Integer.class);
	}
	
	@Override
	public List<Product> findOtherProductsByUser(String userId, Long excludeProductId, int limit) {
		String SQL = "select * from product where userId = ? and id != ? order by createdAt desc limit ?";
		return jdbcTemplate.query(SQL, new ProductRowMapper(), userId, excludeProductId, limit);
	}
	
	@Override
	public List<Product> findRelatedProducts(String category, Long excludeProductId, int limit) {
		String sql = "SELECT * FROM product WHERE category = ? AND id != ? ORDER BY createdAt DESC LIMIT ?";
		return jdbcTemplate.query(sql, new ProductRowMapper(), category, excludeProductId, limit);
	}
	
	// UPDATE
	@Override
	public void updateProduct(Product product) {
		String SQL = "update product set status = ?, name = ?, description = ?, price = ?, quantity = ?, category = ?,image = ? where id = ?";
		jdbcTemplate.update(SQL, product.getStatus(), product.getName(), product.getDescription(), product.getPrice(), product.getQuantity(), product.getCategory(), product.getImage(), product.getId());
	}
	
	@Override
	public void incrementViews(Long id) {
		String SQL = "update product set views = views + 1 where id = ?";
		jdbcTemplate.update(SQL, id);
	}
	
	// DELETE
	@Override
	public void deleteProduct(Long id) {
		String SQL = "delete from product where id = ?";
		jdbcTemplate.update(SQL, id);
	}
}
