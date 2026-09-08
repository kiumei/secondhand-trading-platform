package com.campus.secondhand;

import com.campus.secondhand.common.BusinessException;
import com.campus.secondhand.media.ImageStorage;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.nio.file.Path;
import javax.imageio.ImageIO;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.mock.web.MockMultipartFile;
import static org.assertj.core.api.Assertions.*;

class ImageStorageTest {
    @TempDir Path directory;
    @Test void storesValidatedImageAndIgnoresClientFilename() throws Exception {
        var bytes = new ByteArrayOutputStream();
        ImageIO.write(new BufferedImage(4, 3, BufferedImage.TYPE_INT_RGB), "png", bytes);
        var storage = new ImageStorage(directory.toString());
        var uploaded = storage.save(new MockMultipartFile("file", "../../evil.html", "text/html", bytes.toByteArray()));
        assertThat(uploaded.url()).matches("/api/media/[0-9a-f]{32}\\.png");
        assertThat(uploaded.width()).isEqualTo(4);
        var resource = storage.read(uploaded.url().substring("/api/media/".length()));
        try (var input = resource.getInputStream()) { assertThat(ImageIO.read(input).getHeight()).isEqualTo(3); }
    }
    @Test void rejectsForgedContentAndPathTraversal() {
        var storage = new ImageStorage(directory.toString());
        assertThatThrownBy(() -> storage.save(new MockMultipartFile("file", "fake.png", "image/png", "<script>bad</script>".getBytes())))
                .isInstanceOf(BusinessException.class);
        assertThatThrownBy(() -> storage.read("../secret.png")).isInstanceOf(BusinessException.class);
        assertThatThrownBy(() -> storage.save(new MockMultipartFile("file", new byte[5 * 1024 * 1024 + 1])))
                .isInstanceOf(BusinessException.class);
    }
}
