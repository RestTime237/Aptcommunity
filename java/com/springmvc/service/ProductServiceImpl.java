package com.springmvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springmvc.domain.Product;
import com.springmvc.repository.ProductRepository;


@Service
public class ProductServiceImpl implements ProductService{

	@Autowired
	private ProductRepository productRepository;

	
	// CREATE
	
	@Override
	public void addProduct(Product product) {
		productRepository.addProduct(product);
		
	}
	
	// UPDATE
	
	@Override
	public void updateProduct(Product product) {
		productRepository.updateProduct(product);
		
	}
	
	// DELETE
	
	@Override
	public void deleteProduct(Long id) {
		productRepository.deleteProduct(id);
		
	}
	
	// READ

	@Override
	public Product getProductById(Long id) {
		return productRepository.getProductById(id);
	}

	@Override
	public List<Product> getPagedProducts(int offset, int limit) {
		return productRepository.getPagedProducts(offset, limit);
	}

	@Override
	public int countAllProducts() {
		return productRepository.countAllProducts();
	}

	@Override
	public List<Product> searchProducts(String category, String status, String choice, String keyword, String sort, Long minPrice,
			Long maxPrice, int limit, int offset) {
		return productRepository.searchProducts(category, status, choice, keyword, sort, minPrice, maxPrice, limit, offset);
	}

	@Override
	public int getSearchResultCount(String category, String status, String choice, String keyword, Long minPrice, Long maxPrice) {
		return productRepository.getSearchResultCount(category, status, choice, keyword, minPrice, maxPrice);
	}

	@Override
	public List<Product> getProductByUserId(String userId, int offset, int limit) {
		return productRepository.getProductByUserId(userId, offset, limit);
	}

	@Override
	public int getProductCount(String userId) {
		return productRepository.getProductCount(userId);
	}

	
	@Override
	public void incrementViews(Long id) {
		productRepository.incrementViews(id);
		
	}

	public List<Product> getOtherProductsByUser(String userId, Long excludeProductId, int limit) {
	    return productRepository.findOtherProductsByUser(userId, excludeProductId, limit);
	}

	public List<Product> getRelatedProducts(String category, Long excludeProductId, int limit) {
	    return productRepository.findRelatedProducts(category, excludeProductId, limit);
	}

}
