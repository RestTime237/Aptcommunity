package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.Product;

public interface WishlistRepository {

	void addWishlist(String userId, Long productId);
    void removeWishlist(String userId, Long productId);
    boolean isWishlisted(String userId, Long productId);
    List<Product> getWishlistByUser(String userId, int offset, int limit);
    List<Product> getWishlistByUser(String userId);
    int getWishCount(String userId);
}
