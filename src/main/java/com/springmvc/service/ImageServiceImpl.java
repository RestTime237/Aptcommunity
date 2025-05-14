package com.springmvc.service;


import com.springmvc.domain.Image;
import com.springmvc.repository.ImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.List;

@Service
public class ImageServiceImpl implements ImageService {

    @Autowired
    private ImageRepository imageRepository;

    @Override
    public void saveImage(Image img) {
        imageRepository.saveImage(img);

    }

    @Override
    public void updateRefIdForRecent(String refType, Long refId) {
        imageRepository.updateRefIdForRecent(refType, refId);

    }

    @Override
    public void deleteImage(String refType, Long refId, String path) {

        List<Image> imageList = imageRepository.getImageByRefId(refType, refId);

        for (Image img : imageList) {
            File file = new File(path, img.getFileName());
            if (file.exists()) {
                if (file.delete()) {
                    System.out.println("파일 삭제 성공 " + img.getFileName());
                } else {
                    System.out.println("파일 삭제 실패 " + img.getFileName());
                }
            } else {
                System.out.println("파일이 존재하지 않음 " + img.getFileName());
            }
        }
        imageRepository.deleteImage(refType, refId);

    }

    @Override
    public List<Image> getImageByRefId(String refType, Long refId) {
        return imageRepository.getImageByRefId(refType, refId);
    }

    @Override
    public boolean hasImage(String refType, Long refId) {
        return imageRepository.hasImage(refType, refId);
    }


    @Override
    public void updateImageReferences(String refType, Long refId, List<Image> images) {
        imageRepository.deleteImage(refType, refId); // 기존 이미지 제거

        for (Image img : images) {
            imageRepository.save(refType, refId, img); // 새 이미지 등록
        }

    }


    @Override
    public String findFirstImageByRef(String refType, Long refId) {
        return imageRepository.findFirstImageByRef(refType, refId);
    }


}
