package com.springmvc.domain;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class Vote {
    private int voteId;
    private String title;
    private String content;
    private String creatorId;
    private String apartmentCode;
    private Timestamp createdAt;
    private LocalDateTime deadline;
    private List<VoteOption> voteOptions;
    private int voteCount;
    private boolean alreadyVoted;
    private int selectedOption;
    private double percentage;
    private boolean isActive;
    private boolean isNewVote;
    
	public int getVoteId() {
		return voteId;
	}
	
	public void setVoteId(int voteId) {
		this.voteId = voteId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getCreatorId() {
		return creatorId;
	}
	public void setCreatorId(String creatorId) {
		this.creatorId = creatorId;
	}
	public String getApartmentCode() {
		return apartmentCode;
	}
	public void setApartmentCode(String apartmentCode) {
		this.apartmentCode = apartmentCode;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	public LocalDateTime getDeadline() {
		return deadline;
	}
	public void setDeadline(LocalDateTime deadline) {
		this.deadline = deadline;
	}

	public boolean isActive() {
		return deadline != null && deadline.isAfter(LocalDateTime.now());
	}

	public boolean isNewVote() {
		return createdAt != null && createdAt.toLocalDateTime().isAfter(LocalDateTime.now().minusDays(3));
	}

    public String getFormattedDeadline() {
    	return deadline != null ? deadline.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "";
    }

	public List<VoteOption> getVoteOptions() {
		return voteOptions;
	}

	public void setVoteOptions(List<VoteOption> voteOptions) {
		this.voteOptions = voteOptions;
	}

	public int getVoteCount() {
		return voteCount;
	}

	public void setVoteCount(int voteCount) {
		this.voteCount = voteCount;
	}

	public boolean isAlreadyVoted() {
		return alreadyVoted;
	}

	public void setAlreadyVoted(boolean alreadyVoted) {
		this.alreadyVoted = alreadyVoted;
	}

	public int getSelectedOption() {
		return selectedOption;
	}

	public void setSelectedOption(int selectedOption) {
		this.selectedOption = selectedOption;
	}

	public double getPercentage() {
		return percentage;
	}

	public void setPercentage(double percentage) {
		this.percentage = percentage;
	}

    
}
