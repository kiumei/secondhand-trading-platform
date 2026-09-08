package com.campus.secondhand.config;

import com.campus.secondhand.common.ApiResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.CsrfTokenRequestAttributeHandler;

@Configuration
public class SecurityConfig {
    @Bean
    PasswordEncoder passwordEncoder() { return new BCryptPasswordEncoder(); }

    /** 禁用框架默认账号；JSON 登录由 AccountService 查询账号并验证密码。 */
    @Bean
    UserDetailsService userDetailsService() {
        return username -> { throw new UsernameNotFoundException("不支持默认账号认证"); };
    }

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http, ObjectMapper mapper,
            org.springframework.core.env.Environment environment,
            org.springframework.beans.factory.ObjectProvider<com.campus.secondhand.user.UserMapper> users) throws Exception {
        if (environment.acceptsProfiles(org.springframework.core.env.Profiles.of("mysql"))) {
            http.addFilterBefore(new com.campus.secondhand.auth.AccountSessionFilter(users.getObject(), mapper),
                    org.springframework.security.web.csrf.CsrfFilter.class);
        }
        return http
                .formLogin(AbstractHttpConfigurer::disable)
                .httpBasic(AbstractHttpConfigurer::disable)
                .logout(logout -> logout
                        .logoutUrl("/api/auth/logout")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID")
                        .logoutSuccessHandler((request, response, authentication) -> {
                            response.setStatus(200);
                            response.setContentType("application/json;charset=UTF-8");
                            mapper.writeValue(response.getOutputStream(), ApiResponse.success(null));
                        }))
                .requestCache(AbstractHttpConfigurer::disable)
                .csrf(csrf -> csrf.csrfTokenRequestHandler(new CsrfTokenRequestAttributeHandler()))
                .authorizeHttpRequests(auth -> auth
                        .dispatcherTypeMatchers(DispatcherType.ERROR).permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/health", "/api/auth/csrf").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/media/*").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/categories", "/api/public/users/*").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/goods", "/api/goods/*", "/api/goods/*/evaluations").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/auth/register", "/api/auth/login").permitAll()
                        .requestMatchers("/api/admin/**").hasRole("ADMIN")
                        .anyRequest().authenticated())
                .exceptionHandling(errors -> errors
                        .authenticationEntryPoint((request, response, ex) ->
                                write(mapper, response, 401, "UNAUTHENTICATED", "请先登录"))
                        .accessDeniedHandler((request, response, ex) ->
                                write(mapper, response, 403, "FORBIDDEN", "无权访问或请求校验失败")))
                .build();
    }

    private void write(ObjectMapper mapper, HttpServletResponse response, int status,
            String code, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        mapper.writeValue(response.getOutputStream(), ApiResponse.error(code, message));
    }
}
