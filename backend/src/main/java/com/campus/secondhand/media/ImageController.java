package com.campus.secondhand.media;

import com.campus.secondhand.common.ApiResponse;
import java.io.IOException;
import org.springframework.core.io.Resource;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class ImageController {
    private final ImageStorage images;
    public ImageController(ImageStorage images) { this.images = images; }
    @PostMapping(value = "/api/uploads/images", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ImageStorage.UploadedImage> upload(@RequestParam("file") MultipartFile file) throws IOException {
        return ApiResponse.success(images.save(file));
    }
    @GetMapping("/api/media/{filename}")
    public ResponseEntity<Resource> read(@PathVariable String filename) {
        Resource resource = images.read(filename);
        return ResponseEntity.ok().contentType(filename.endsWith(".png") ? MediaType.IMAGE_PNG : MediaType.IMAGE_JPEG)
                .cacheControl(CacheControl.maxAge(java.time.Duration.ofDays(7)))
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline").body(resource);
    }
}
