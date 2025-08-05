package com.springmvc.repository;

import com.springmvc.domain.Vote;

import java.util.List;

public interface VoteRepository {

    void addVote(Vote vote);

    Vote getVoteById(int voteId);

    List<Vote> getAllVotes();

    int getTotalVoteCount();

    List<Vote> getPaginationVotes(int offset, int limit);

    void deleteVoteById(int voteId);
}
