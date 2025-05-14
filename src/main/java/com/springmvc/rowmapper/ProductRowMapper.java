package com.springmvc.rowmapper;

import com.springmvc.domain.Product;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ProductRowMapper implements RowMapper<Product> {

    @Override
    public Product mapRow(ResultSet rs, int rowNum) throws SQLException {
        Product product = new Product();

        product.setId(rs.getLong("id"));
        product.setStatus(rs.getString("status"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getLong("price"));
        product.setQuantity(rs.getLong("quantity"));
        product.setCategory(rs.getString("category"));
        product.setImage(rs.getString("image"));
        product.setUserId(rs.getString("userId"));

        if (rs.getTimestamp("createdAt") != null) {
            product.setCreatedAt(rs.getTimestamp("createdAt"));
        }

        product.setViews(rs.getInt("views"));
        return product;
    }

}
