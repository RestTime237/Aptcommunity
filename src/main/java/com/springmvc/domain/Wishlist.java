package com.springmvc.domain;

import java.sql.Timestamp;

public class Wishlist {
    private Long id;
    private String userId;
    private Long productId;
    private Timestamp createdAt;

    public Wishlist() {
        super();
        // TODO Auto-generated constructor stub
    }

    public Wishlist(Long id, String userId, Long productId, Timestamp createdAt) {
        super();
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }


}
