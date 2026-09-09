package com.campus.secondhand;

import com.campus.secondhand.auth.*;
import com.campus.secondhand.common.BusinessException;
import com.campus.secondhand.user.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.*;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

class AccountSessionTest {
    @AfterEach void cleanup() { SecurityContextHolder.clearContext(); }
    private UserRow row(String hash) { return new UserRow("101", "同学", hash, "13800000000", null, null, 0, 0, null); }
    private void authenticate(UserRow row) {
        SecurityContextHolder.getContext().setAuthentication(UsernamePasswordAuthenticationToken.authenticated(
                new AccountService.Principal(row.userId(), AccountService.credentialVersion(row)), null,
                List.of(new SimpleGrantedAuthority("ROLE_STUDENT"))));
    }
    @Test void resettingPasswordHashesItAndRevokesExistingSession() throws Exception {
        var users = mock(UserMapper.class);
        var encoder = new BCryptPasswordEncoder();
        var original = row(encoder.encode("old-password"));
        when(users.findById("101")).thenReturn(original);
        when(users.changePassword(eq("101"), eq(original.password()), any())).thenAnswer(call -> {
            String newHash = call.getArgument(2);
            assertThat(encoder.matches("new-password", newHash)).isTrue();
            when(users.findById("101")).thenReturn(row(newHash));
            return 1;
        });
        authenticate(original);
        new AccountService(users, encoder).resetPassword("101", "new-password");
        var request = new MockHttpServletRequest("GET", "/api/users/me");
        request.getSession();
        var response = new MockHttpServletResponse();
        var chain = new MockFilterChain();
        new AccountSessionFilter(users, new ObjectMapper()).doFilter(request, response, chain);
        assertThat(response.getStatus()).isEqualTo(401);
        assertThat(request.getSession(false)).isNull();
        assertThat(chain.getRequest()).isNull();
    }
    @Test void unchangedAccountKeepsItsSessionAndWrongOldPasswordCannotUpdate() throws Exception {
        var users = mock(UserMapper.class);
        var encoder = new BCryptPasswordEncoder();
        var original = row(encoder.encode("correct"));
        when(users.findById("101")).thenReturn(original);
        authenticate(original);
        var chain = new MockFilterChain();
        var request = new MockHttpServletRequest("GET", "/api/users/me");
        new AccountSessionFilter(users, new ObjectMapper()).doFilter(request, new MockHttpServletResponse(), chain);
        assertThat(chain.getRequest()).isSameAs(request);
        assertThatThrownBy(() -> new AccountService(users, encoder).changePassword("101", "wrong", "new"))
                .isInstanceOf(BusinessException.class);
        verify(users, never()).changePassword(any(), any(), any());
    }
    @Test void bannedAccountCannotLoginAndExistingSessionIsInvalidated() throws Exception {
        var users = mock(UserMapper.class);
        var encoder = new BCryptPasswordEncoder();
        var original = row(encoder.encode("correct"));
        var banned = new UserRow(original.userId(), original.userName(), original.password(), original.phone(),
                null, null, 0, 1, null);
        when(users.findByPhone(original.phone())).thenReturn(banned);
        when(users.findById(original.userId())).thenReturn(banned);
        assertThatThrownBy(() -> new AccountService(users, encoder).authenticate(original.phone(), "correct"))
                .isInstanceOf(BusinessException.class).hasMessageContaining("封禁");
        authenticate(original);
        var request = new MockHttpServletRequest("GET", "/api/users/me");
        request.getSession();
        var response = new MockHttpServletResponse();
        var chain = new MockFilterChain();
        new AccountSessionFilter(users, new ObjectMapper()).doFilter(request, response, chain);
        assertThat(response.getStatus()).isEqualTo(401);
        assertThat(request.getSession(false)).isNull();
        assertThat(chain.getRequest()).isNull();
    }
    @Test void profileSupportsAddressUpdateAndExplicitClear() {
        var users = mock(UserMapper.class);
        var encoder = new BCryptPasswordEncoder();
        when(users.findById("101")).thenReturn(new UserRow("101", "同学", "hash", "13800000000",
                null, null, 0, 0, null, "校区1栋"));
        var service = new AccountService(users, encoder);
        assertThat(service.current("101").address()).isEqualTo("校区1栋");
        service.updateProfile("101", null, null, null, "校区2栋");
        verify(users).updateProfile("101", null, null, null, "校区2栋");
        service.updateProfile("101", null, null, null, "");
        verify(users).updateProfile("101", null, null, null, "");
        service.updateProfile("101", null, null, null, null);
        verify(users, times(2)).updateProfile(any(), any(), any(), any(), any());
    }
}
