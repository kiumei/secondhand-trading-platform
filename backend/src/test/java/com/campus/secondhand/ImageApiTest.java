package com.campus.secondhand;

import com.campus.secondhand.auth.AccountService;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.nio.file.Path;
import java.util.List;
import javax.imageio.ImageIO;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.*;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.test.context.*;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("local")
class ImageApiTest {
    @TempDir static Path directory;
    @DynamicPropertySource static void properties(DynamicPropertyRegistry registry) {
        registry.add("app.upload-directory", () -> directory.toString());
    }
    @Autowired MockMvc mvc;
    @Autowired ObjectMapper json;
    private MockMultipartFile png() throws Exception {
        var data = new ByteArrayOutputStream();
        ImageIO.write(new BufferedImage(2, 2, BufferedImage.TYPE_INT_RGB), "png", data);
        return new MockMultipartFile("file", "image.png", "image/png", data.toByteArray());
    }
    @Test void uploadRequiresLoginAndCsrfThenReturnsPublicImage() throws Exception {
        var session = new MockHttpSession();
        var tokenResult = mvc.perform(get("/api/auth/csrf").session(session)).andReturn();
        var token = json.readTree(tokenResult.getResponse().getContentAsString()).get("data");
        mvc.perform(multipart("/api/uploads/images").file(png()).session(session)
                .header(token.get("headerName").asText(), token.get("token").asText())).andExpect(status().isUnauthorized());
        var context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(UsernamePasswordAuthenticationToken.authenticated(new AccountService.Principal("101"), null,
                List.of(new SimpleGrantedAuthority("ROLE_STUDENT"))));
        session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, context);
        mvc.perform(multipart("/api/uploads/images").file(png()).session(session)).andExpect(status().isForbidden());
        var result = mvc.perform(multipart("/api/uploads/images").file(png()).session(session)
                .header(token.get("headerName").asText(), token.get("token").asText()))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.width").value(2)).andReturn();
        String url = json.readTree(result.getResponse().getContentAsString()).get("data").get("url").asText();
        mvc.perform(get(url)).andExpect(status().isOk()).andExpect(content().contentType("image/png"))
                .andExpect(header().string("X-Content-Type-Options", "nosniff"));
    }
}
