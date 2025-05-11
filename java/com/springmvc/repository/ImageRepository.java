package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.Image;

public interface ImageRepository {
	void saveImage(Image img);
	void save(String refType, Long refId, Image img);
	List<Image> getImageByRefId(String refType, Long refId);
	void updateRefIdForRecent(String refType, Long refId);
	void deleteImage(String refType, Long refId);
	boolean hasImage(String refType, Long refId);
	String findFirstImageByRef(String refType, Long refId);

}
