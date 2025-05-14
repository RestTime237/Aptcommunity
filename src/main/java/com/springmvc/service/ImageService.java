package com.springmvc.service;

import com.springmvc.domain.Image;

import java.util.List;

public interface ImageService {
    void saveImage(Image img);

    List<Image> getImageByRefId(String refType, Long refId);

    void updateRefIdForRecent(String refType, Long refId);

    void updateImageReferences(String refType, Long refId, List<Image> images);

    void deleteImage(String refType, Long id, String path);

    boolean hasImage(String refType, Long refId);

    String findFirstImageByRef(String refType, Long refId);
}
