package com.springmvc.domain;

import java.util.Date;

public class Image {
    private Long id;               // 이미지 ID (PK)
    private String refType;       // post 또는 product
    private Long refId;           // 참조 ID (게시글 ID나 상품 ID)
    private String fileName;      // 저장된 파일명
    private Date uploadedAt;

    // 기본 생성자
    public Image() {}

    // 전체 생성자
    public Image(Long id, String refType, Long refId, String fileName, String uploadName, Date uploadedAt) {
        this.id = id;
        this.refType = refType;
        this.refId = refId;
        this.fileName = fileName;
        this.uploadedAt = uploadedAt;
    }

    // Getter/Setter
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }

    public String getRefType() {
        return refType;
    }
    public void setRefType(String refType) {
        this.refType = refType;
    }

    public Long getRefId() {
        return refId;
    }
    public void setRefId(Long refId) {
        this.refId = refId;
    }

    public String getFileName() {
        return fileName;
    }
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

	public Date getUploadDate() {
		return uploadedAt;
	}

	public void setUploadDate(Date uploadDate) {
		this.uploadedAt = uploadDate;
	}

}
