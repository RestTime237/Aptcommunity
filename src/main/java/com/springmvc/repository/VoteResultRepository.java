package com.springmvc.repository;

import com.springmvc.domain.VoteResult;

public interface VoteResultRepository {
	 void saveResult(VoteResult result);
	 boolean existsByVoteIdAndUserId(int voteId, String memberId);
	// 해당 투표의 전체 투표 수
	 int countByVoteId(int voteId);

	// 특정 옵션에 대한 투표 수
	int countByOptionId(int optionId);
	
	// 해당 유저가 선택한 옵션 ID
    int findOptionIdByVoteIdAndUserId(int voteId, String userId);
}
