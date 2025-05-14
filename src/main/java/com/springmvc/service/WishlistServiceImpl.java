package com.springmvc.service;

import com.springmvc.domain.Product;
import com.springmvc.repository.WishlistRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WishlistServiceImpl implements wishlistService {

    @Autowired
    private WishlistRepository wishlistRepository;

    @Override
    public void addWishlist(String userId, Long productId) {
        wishlistRepository.addWishlist(userId, productId);

    }

    @Override
    public void removeWishlist(String userId, Long productId) {
        wishlistRepository.removeWishlist(userId, productId);

    }

    @Override
    public boolean isWishlisted(String userId, Long productId) {
        return wishlistRepository.isWishlisted(userId, productId);
    }

    @Override
    public List<Product> getWishlistByUser(String userId, int offset, int limit) {
        return wishlistRepository.getWishlistByUser(userId, offset, limit);
    }

    @Override
    public List<Product> getWishlistByUser(String userId) {
        return wishlistRepository.getWishlistByUser(userId);
    }

    @Override
    public void toggleWishlist(String userId, Long productId) {
        if (wishlistRepository.isWishlisted(userId, productId)) {
            wishlistRepository.removeWishlist(userId, productId);
        } else {
            wishlistRepository.addWishlist(userId, productId);
        }

    }

    @Override
    public int getWishCount(String userId) {
        return wishlistRepository.getWishCount(userId);
    }


}
