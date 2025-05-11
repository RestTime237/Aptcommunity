package com.springmvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springmvc.domain.Vote;
import com.springmvc.domain.VoteOption;
import com.springmvc.domain.VoteResult;
import com.springmvc.repository.VoteOptionRepository;
import com.springmvc.repository.VoteRepository;
import com.springmvc.repository.VoteResultRepository;

@Service
public class VoteServiceImpl implements VoteService{
	
	@Autowired
	private VoteRepository voteRepository;
	
	@Autowired
	private VoteOptionRepository voteOptionRepository;
	
	@Autowired
	private VoteResultRepository voteResultRepository;

	@Override
	public List<Vote> getAllVotes() {
		return voteRepository.getAllVotes();
	}

	@Override
	public void addVoteWithOptions(Vote vote, List<String> optionTexts) {
		voteRepository.addVote(vote);
		int voteId = vote.getVoteId();
		
		for(String optionText : optionTexts) {
			VoteOption option = new VoteOption();
			option.setVoteId(voteId);
			option.setOptionText(optionText);
			voteOptionRepository.addOption(option);
		}
		
	}

	@Override
	public Vote getVoteById(int voteId) {
		return voteRepository.getVoteById(voteId);
	}

	@Override
	public List<VoteOption> getOptionsByVoteId(int voteId) {
		return voteOptionRepository.getOptionsByVoteId(voteId);
	}

	@Override
	public void submitVote(int voteId, int optionId, String memberId) {
		VoteResult result = new VoteResult();
        result.setVoteId(voteId);
        result.setOptionId(optionId);
        result.setMemberId(memberId);
        voteResultRepository.saveResult(result);
		
	}

	
	@Override
	public int getTotalVoteCount(int voteId) {
		return voteResultRepository.countByVoteId(voteId);
	}
	
	@Override
	public int getTotalVoteCount() {
		return voteRepository.getTotalVoteCount();
	}
	

	@Override
	public int getVoteCountByOptionId(int optionId) {
		return voteResultRepository.countByOptionId(optionId);
	}

	@Override
	public boolean hasUserVoted(int voteId, String userId) {
		return voteResultRepository.existsByVoteIdAndUserId(voteId, userId);
	}
	

	@Override
	public int getSelectedOptionId(int voteId, String userId) {
		return voteResultRepository.findOptionIdByVoteIdAndUserId(voteId, userId);
	}

	@Override
	public List<Vote> getPaginationVotes(int offset, int limit) {
		return voteRepository.getPaginationVotes(offset, limit);
	}

}
