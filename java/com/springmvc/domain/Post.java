package com.springmvc.domain;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;


public class Post {
	private Long id;
    private String title;
    private String content;
    private String category;
    private String userId;
    private String apartmentCode;
    private String dong;
    private Date createdAt;
    private String fileName;
    private List<MultipartFile> images;
    private int views;
    private int likeCount;
    
    public Post() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public Post(Long id, String title, String content, String category, String userId, String apartmentCode,
			String dong, Date createdAt, String fileName, int views, int likeCount) {
		super();
		this.id = id;
		this.title = title;
		this.content = content;
		this.category = category;
		this.userId = userId;
		this.apartmentCode = apartmentCode;
		this.dong = dong;
		this.createdAt = createdAt;
		this.fileName = fileName;
		this.images = images;
		this.views = views;
		this.likeCount = likeCount;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long postId) {
		this.id = postId;
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

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getApartmentCode() {
		return apartmentCode;
	}

	public void setApartmentCode(String apartmentCode) {
		this.apartmentCode = apartmentCode;
	}

	public String getDong() {
		return dong;
	}

	public void setDong(String dong) {
		this.dong = dong;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	@Override
	public String toString() {
		return "Post [id=" + id + ", title=" + title + ", content=" + content + ", category=" + category + ", userId="
				+ userId + ", apartmentCode=" + apartmentCode + ", dong=" + dong + ", createdAt=" + createdAt
				+ ", fileName=" + fileName + "]";
	}

	public List<MultipartFile> getImages() {
		return images;
	}

	public void setImages(List<MultipartFile> images) {
		this.images = images;
	}

	public int getViews() {
		return views;
	}

	public void setViews(int views) {
		this.views = views;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
    
    
}
