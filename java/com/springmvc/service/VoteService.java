package com.springmvc.service;

import java.util.List;

import com.springmvc.domain.Vote;
import com.springmvc.domain.VoteOption;

public interface VoteService {

	// 전체 투표 목록
    List<Vote> getAllVotes();
    
    int getTotalVoteCount();
    
    List<Vote> getPaginationVotes(int offset, int limit);

    // 투표 등록 (옵션 포함)
    void addVoteWithOptions(Vote vote, List<String> optionTexts);

    // 특정 투표 조회
    Vote getVoteById(int voteId);

    // 해당 투표의 옵션들
    List<VoteOption> getOptionsByVoteId(int voteId);

    // 투표 제출
    void submitVote(int voteId, int optionId, String memberId);
    
    int getTotalVoteCount(int voteId);

    int getVoteCountByOptionId(int optionId);

    boolean hasUserVoted(int voteId, String userId);

    int getSelectedOptionId(int voteId, String userId);
}
