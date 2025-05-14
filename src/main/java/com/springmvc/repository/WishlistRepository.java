package com.springmvc.repository;

import com.springmvc.domain.Product;

import java.util.List;

public interface WishlistRepository {

    void addWishlist(String userId, Long productId);

    void removeWishlist(String userId, Long productId);

    boolean isWishlisted(String userId, Long productId);

    List<Product> getWishlistByUser(String userId, int offset, int limit);

    List<Product> getWishlistByUser(String userId);

    int getWishCount(String userId);
}
