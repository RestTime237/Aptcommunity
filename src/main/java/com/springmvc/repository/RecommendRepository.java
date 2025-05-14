package com.springmvc.repository;

public interface RecommendRepository {
    boolean exists(String userId, String refType, Long refId);

    void insert(String userId, String refType, Long refId);

    void delete(String userId, String refType, Long refId);
}
