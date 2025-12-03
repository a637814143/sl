package com.eightam.lab.web;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

@RestController
@RequestMapping("/api/uploads")
@CrossOrigin
public class UploadController {

    private final Path avatarDir = Paths.get("uploads/avatars");
    private final Path assetDir = Paths.get("uploads/assets");

    public UploadController() {
        try {
            Files.createDirectories(avatarDir);
            Files.createDirectories(assetDir);
        } catch (IOException e) {
            throw new IllegalStateException("无法创建上传目录", e);
        }
    }

    @PostMapping("/avatar")
    public Map<String, String> uploadAvatar(@RequestParam("file") MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "请选择要上传的图片");
        }
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "仅支持上传图片文件");
        }
        String filename = buildFilename(file.getOriginalFilename());
        Path target = avatarDir.resolve(filename);
        try {
            Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "上传失败，请稍后再试");
        }
        String url =
                ServletUriComponentsBuilder.fromCurrentContextPath()
                        .path("/uploads/avatars/")
                        .path(filename)
                        .toUriString();
        return Map.of("url", url);
    }

    @PostMapping("/assets")
    public Map<String, String> uploadAsset(@RequestParam("file") MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "请选择要上传的素材图片");
        }
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "仅支持上传图片文件");
        }
        String filename = buildFilename(file.getOriginalFilename());
        Path target = assetDir.resolve(filename);
        try {
            Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "上传失败，请稍后再试");
        }
        String url =
                ServletUriComponentsBuilder.fromCurrentContextPath()
                        .path("/uploads/assets/")
                        .path(filename)
                        .toUriString();
        return Map.of("url", url);
    }

    private String buildFilename(String originalName) {
        String extension = "";
        if (originalName != null && originalName.contains(".")) {
            extension = originalName.substring(originalName.lastIndexOf('.'));
        }
        return UUID.randomUUID().toString().replaceAll("-", "") + extension;
    }
}
