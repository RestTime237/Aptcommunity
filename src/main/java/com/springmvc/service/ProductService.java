package com.springmvc.service;

import com.springmvc.domain.Product;

import java.util.List;

public interface ProductService {

    // CREATE

    void addProduct(Product product);

    // UPDATE

    void updateProduct(Product product);

    // DELETE

    void deleteProduct(Long id);

    // READ

    Product getProductById(Long id);

    List<Product> getPagedProducts(int offset, int limit);

    int countAllProducts();
	
	/*
	List<Product> getProductsByCategory(String name);
	
	List<Product> searchProduct(String choice, String keyword);
	
	List<Product> getProductsByStatus(String status);
	*/

    List<Product> searchProducts(String category, String status, String choice, String keyword, String sort, Long minPrice, Long maxPrice, int limit, int offset);

    int getSearchResultCount(String category, String status, String choice, String keyword, Long minPrice, Long maxPrice);

    List<Product> getProductByUserId(String userId, int offset, int limit);

    int getProductCount(String userId);

    void incrementViews(Long id);

    List<Product> getOtherProductsByUser(String userId, Long excludeProductId, int limit);

    List<Product> getRelatedProducts(String category, Long excludeProductId, int limit);
}
