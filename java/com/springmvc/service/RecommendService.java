package com.springmvc.service;

public interface RecommendService {
	boolean toggleRecommend(String userId, String refType, Long refId);
}
