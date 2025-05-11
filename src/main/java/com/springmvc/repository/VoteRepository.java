package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.Vote;

public interface VoteRepository {

	void addVote(Vote vote);
    Vote getVoteById(int voteId);
    List<Vote> getAllVotes();
    int getTotalVoteCount();
    List<Vote> getPaginationVotes(int offset, int limit);
}
