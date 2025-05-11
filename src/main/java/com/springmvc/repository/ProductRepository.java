package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.Product;

public interface ProductRepository {

	void addProduct(Product product);

	Product getProductById(Long id);

    void updateProduct(Product product);

    void deleteProduct(Long id);

    List<Product> getPagedProducts(int offset, int limit);

    int countAllProducts();
    
    List<Product> searchProducts(String category, String status, String choice, String keyword, String sort,  Long minPrice,  Long maxPrice, int limit, int offset);
    
    int getSearchResultCount(String category, String status, String choice, String keyword, Long minPrice, Long maxPrice);
    
    List<Product> getProductByUserId(String userId, int offset, int limit);
    
    int getProductCount(String userId);
    
    void incrementViews(Long id);

    List<Product> findOtherProductsByUser(String userId, Long excludeProductId, int limit);
    
    List<Product> findRelatedProducts(String category, Long excludeProductId, int limit);

}
