package com.springmvc.repository;

import com.springmvc.domain.Image;

import java.util.List;

public interface ImageRepository {
    void saveImage(Image img);

    void save(String refType, Long refId, Image img);

    List<Image> getImageByRefId(String refType, Long refId);

    void updateRefIdForRecent(String refType, Long refId);

    void deleteImage(String refType, Long refId);

    boolean hasImage(String refType, Long refId);

    String findFirstImageByRef(String refType, Long refId);

}
