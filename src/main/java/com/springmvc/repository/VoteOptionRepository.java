package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.VoteOption;

public interface VoteOptionRepository {
	void addOption(VoteOption option);
	List<VoteOption> getOptionsByVoteId(int voteId);
}
