package com.campus.secondhand.media;

import com.campus.secondhand.common.BusinessException;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.nio.file.*;
import java.util.UUID;
import javax.imageio.ImageIO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ImageStorage {
    private static final long MAX_BYTES = 5 * 1024 * 1024;
    private final Path directory;
    public ImageStorage(@Value("${app.upload-directory:./uploads}") String directory) {
        this.directory = Path.of(directory).toAbsolutePath().normalize();
    }

    public UploadedImage save(MultipartFile file) throws IOException {
        if (file.isEmpty() || file.getSize() > MAX_BYTES) throw invalid("图片大小需在 1 字节到 5 MB 之间");
        BufferedImage decoded;
        String format;
        try (var input = file.getInputStream(); var stream = ImageIO.createImageInputStream(input)) {
            var readers = ImageIO.getImageReaders(stream);
            if (!readers.hasNext()) throw invalid("仅支持 JPEG 和 PNG 图片");
            var reader = readers.next();
            try {
                format = reader.getFormatName().toLowerCase(java.util.Locale.ROOT);
                if (!format.equals("jpeg") && !format.equals("png")) throw invalid("仅支持 JPEG 和 PNG 图片");
                reader.setInput(stream, true, true);
                int width = reader.getWidth(0), height = reader.getHeight(0);
                if (width <= 0 || height <= 0 || width > 8000 || height > 8000 || (long) width * height > 16_000_000) {
                    throw invalid("图片尺寸过大，最多 1600 万像素且单边不超过 8000 像素");
                }
                decoded = reader.read(0);
            } finally { reader.dispose(); }
        } catch (javax.imageio.IIOException ex) { throw invalid("图片损坏或格式不受支持"); }
        String filename = UUID.randomUUID().toString().replace("-", "") + (format.equals("jpeg") ? ".jpg" : ".png");
        Files.createDirectories(directory);
        Path temporary = Files.createTempFile(directory, "upload-", ".tmp");
        Path destination = directory.resolve(filename);
        try {
            // Decode and encode again; do not publish client-supplied executable bytes or metadata.
            if (!ImageIO.write(decoded, format, temporary.toFile())) throw invalid("图片格式不受支持");
            if (Files.size(temporary) > MAX_BYTES) throw invalid("处理后的图片超过 5 MB");
            Files.move(temporary, destination);
        } finally { Files.deleteIfExists(temporary); }
        return new UploadedImage("/api/media/" + filename, decoded.getWidth(), decoded.getHeight());
    }

    public Resource read(String filename) {
        if (!filename.matches("[0-9a-f]{32}\\.(jpg|png)")) throw missing();
        Path file = directory.resolve(filename).normalize();
        if (!file.startsWith(directory) || !Files.isRegularFile(file, LinkOption.NOFOLLOW_LINKS)) throw missing();
        return new FileSystemResource(file);
    }
    private BusinessException invalid(String message) { return new BusinessException(HttpStatus.BAD_REQUEST, "INVALID_IMAGE", message); }
    private BusinessException missing() { return new BusinessException(HttpStatus.NOT_FOUND, "IMAGE_NOT_FOUND", "图片不存在"); }
    public record UploadedImage(String url, int width, int height) { }
}
