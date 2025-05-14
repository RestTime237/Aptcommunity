package com.springmvc.repository;

import com.springmvc.domain.VoteOption;

import java.util.List;

public interface VoteOptionRepository {
    void addOption(VoteOption option);

    List<VoteOption> getOptionsByVoteId(int voteId);
}
