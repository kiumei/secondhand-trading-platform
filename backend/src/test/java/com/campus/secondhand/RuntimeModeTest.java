package com.campus.secondhand;

import com.campus.secondhand.config.RuntimeModeConfig;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.runner.ApplicationContextRunner;
import static org.assertj.core.api.Assertions.assertThat;

class RuntimeModeTest {
    private final ApplicationContextRunner runner = new ApplicationContextRunner()
            .withUserConfiguration(RuntimeModeConfig.class);

    @Test void localStartsWithoutDatabaseCredentials() {
        runner.withInitializer(context -> context.getEnvironment().setActiveProfiles("local"))
                .run(context -> assertThat(context).hasNotFailed());
    }

    @Test void missingModeFailsWithActionableMessage() {
        runner.withInitializer(context -> context.getEnvironment().setActiveProfiles())
                .run(context -> assertThat(context).hasFailed()
                        .getFailure().hasMessageContaining("local 或 mysql"));
    }

    @Test void conflictingModesFailBeforeDatabaseInitialization() {
        runner.withInitializer(context -> context.getEnvironment().setActiveProfiles("local", "mysql"))
                .run(context -> assertThat(context).hasFailed()
                        .getFailure().hasMessageContaining("local 或 mysql"));
    }

    @Test void mysqlRequiresCredentialsWithoutPrintingThem() {
        runner.withInitializer(context -> context.getEnvironment().setActiveProfiles("mysql"))
                .withPropertyValues("DB_URL=jdbc:mysql://localhost/course", "DB_USERNAME=test", "DB_PASSWORD=")
                .run(context -> assertThat(context).hasFailed()
                        .getFailure().hasMessageContaining("DB_PASSWORD"));
    }

    @Test void mysqlConfigurationCanBeValidatedWithoutConnecting() {
        runner.withInitializer(context -> context.getEnvironment().setActiveProfiles("mysql"))
                .withPropertyValues("DB_URL=jdbc:mysql://localhost/course", "DB_USERNAME=test", "DB_PASSWORD=test-only")
                .run(context -> assertThat(context).hasNotFailed());
    }
}
