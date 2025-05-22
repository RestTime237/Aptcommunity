package com.springmvc.controller;

import com.springmvc.domain.Image;
import com.springmvc.service.ImageService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

@Controller
public class UploadController {

    @Autowired
    private ImageService imageService;

    @PostMapping("/uploadImage")
    @ResponseBody
    public String uploadImage(@RequestParam("uploadImage") MultipartFile file, @RequestParam("refType") String refType, HttpServletRequest req) {
        System.out.println("이미지 업로드 입장 / refType = " + refType);
        String contextPath = req.getContextPath();

        String path = "/home/admin/uploads";
        String originalName = file.getOriginalFilename();
        String[] format = originalName.split("\\.");
        String newName = System.currentTimeMillis() + "." + format[1];

        try {
            File saveFile = new File(path, newName);
            file.transferTo(saveFile);
        } catch (Exception e) {
            e.printStackTrace();
        }

        Image img = new Image();
        img.setRefId(null);
        img.setFileName(newName);
        img.setRefType(refType);

        imageService.saveImage(img);

        return contextPath+"/uploads/" + newName;
    }
}
