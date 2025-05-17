package com.springmvc.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

@Component
public class DatabaseChecker implements CommandLineRunner {

    private final DataSource dataSource;

    public DatabaseChecker(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public void run(String... args) {
        try (Connection conn = dataSource.getConnection()) {
            System.out.println("DB 연결 성공: " + conn.getMetaData().getURL());
        } catch (SQLException e) {
            System.err.println("DB 연결 실패");
            e.printStackTrace();
        }
    }
}
