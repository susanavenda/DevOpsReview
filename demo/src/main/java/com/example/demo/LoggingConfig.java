package com.example.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.FileAppender;

@Configuration
public class LoggingConfig {

    @Value("${logging.file.path:/var/log/myapp}") // Default log file path
    private String logFilePath;

    @Bean
    public Logger logger() {
        Logger logger = LoggerFactory.getLogger("com.example.demo.DemoApplication");

        // Optionally configure the log file path programmatically
        ch.qos.logback.classic.Logger logbackLogger = (ch.qos.logback.classic.Logger) logger;
        logbackLogger.addAppender(new FileAppender<ILoggingEvent>() {
            {
                setFile(logFilePath + "/myapp.log");
                setContext(logbackLogger.getLoggerContext());
                start();
            }
        });

        return logger;
    }
}