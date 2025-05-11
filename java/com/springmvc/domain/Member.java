package com.springmvc.domain;

import java.util.Date;

public class Member {
	
	
	private Long id;
	private String username;
	private String userId;
	private String password;
	private String nickname;
	private String apartmentCode;
	private String email;
	private String dong;
	private String roadAddress;
	private int role;
	private Date createdAt;
	private String profileImage;
	
	public Member(Long id, String username, String userId, String password, String nickname, String apartmentCode,
			String email, String dong, String roadAddress, int role, Date createdAt, String profileImage) {
		super();
		this.id = id;
		this.username = username;
		this.userId = userId;
		this.password = password;
		this.nickname = nickname;
		this.apartmentCode = apartmentCode;
		this.email = email;
		this.dong = dong;
		this.roadAddress = roadAddress;
		this.role = role;
		this.createdAt = createdAt;
		this.profileImage = profileImage;
	}
	public Member() {
		super();
		// TODO Auto-generated constructor stub
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getApartmentCode() {
		return apartmentCode;
	}
	public void setApartmentCode(String apartmentCode) {
		this.apartmentCode = apartmentCode;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getDong() {
		return dong;
	}
	public void setDong(String dong) {
		this.dong = dong;
	}
	public int getRole() {
		return role;
	}
	public void setRole(int role) {
		this.role = role;
	}
	public String getRoadAddress() {
		return roadAddress;
	}
	public void setRoadAddress(String roadAddress) {
		this.roadAddress = roadAddress;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Date getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	public String getProfileImage() {
		return profileImage;
	}
	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}
	@Override
	public String toString() {
		return "Member [id=" + id + ", username=" + username + ", userId=" + userId + ", password=" + password
				+ ", nickname=" + nickname + ", apartmentCode=" + apartmentCode + ", email=" + email + ", dong=" + dong
				+ ", roadAddress=" + roadAddress + ", role=" + role + ", createdAt=" + createdAt + ", profileImage="
				+ profileImage + "]";
	}
	
		
	
}
