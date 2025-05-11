package com.springmvc.service;

import java.util.List;

import com.springmvc.domain.Product;

public interface wishlistService {

	void addWishlist(String userId, Long productId);
    void removeWishlist(String userId, Long productId);
    boolean isWishlisted(String userId, Long productId);
    List<Product> getWishlistByUser(String userId);
    List<Product> getWishlistByUser(String userId, int offset, int limit);
    void toggleWishlist(String userId, Long productId);
    int getWishCount(String userId);
}
