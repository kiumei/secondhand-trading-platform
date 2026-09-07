package com.campus.secondhand.market;

import com.campus.secondhand.common.*;
import jakarta.validation.Valid;
import org.springframework.context.annotation.Profile;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import static com.campus.secondhand.market.MarketModels.*;

@RestController
@Profile("mysql")
public class CommunicationController {
    private final CommunicationService messages;
    public CommunicationController(CommunicationService messages) { this.messages = messages; }
    @PostMapping("/api/messages")
    public ApiResponse<Message> send(Authentication auth, @Valid @RequestBody MessageInput input) {
        return ApiResponse.success(messages.send(CurrentUser.id(auth), input));
    }
    @GetMapping("/api/messages")
    public ApiResponse<PageResult<Message>> list(Authentication auth, @RequestParam String peerId,
            @Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(messages.messages(CurrentUser.id(auth), peerId, page));
    }
    @PatchMapping("/api/messages/{id}/read")
    public ApiResponse<Void> read(Authentication auth, @PathVariable String id) {
        messages.read(id, CurrentUser.id(auth)); return ApiResponse.success(null);
    }
    @PostMapping("/api/reports")
    public ApiResponse<Report> report(Authentication auth, @Valid @RequestBody ReportInput input) {
        return ApiResponse.success(messages.report(CurrentUser.id(auth), input));
    }
    @GetMapping("/api/users/me/reports")
    public ApiResponse<PageResult<Report>> mine(Authentication auth, @Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(messages.reports(CurrentUser.id(auth), null, page));
    }
    @GetMapping("/api/admin/reports")
    public ApiResponse<PageResult<Report>> reports(@Valid @ModelAttribute PageQuery page,
            @RequestParam(required = false) Integer status) {
        return ApiResponse.success(messages.reports(null, status, page));
    }
    @PostMapping("/api/admin/reports/{id}/handle")
    public ApiResponse<Report> handle(@PathVariable String id, @Valid @RequestBody HandleInput input) {
        return ApiResponse.success(messages.handle(id, input.handleResult()));
    }
}
