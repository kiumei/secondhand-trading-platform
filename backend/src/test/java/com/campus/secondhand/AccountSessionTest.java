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
    private UserRow row(String hash) { return new UserRow("101", "同学", hash, "13800000000", null, null, 0, null); }
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
        when(users.updatePassword(eq("101"), eq(original.password()), any())).thenAnswer(call -> {
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
        verify(users, never()).updatePassword(any(), any(), any());
    }
}
