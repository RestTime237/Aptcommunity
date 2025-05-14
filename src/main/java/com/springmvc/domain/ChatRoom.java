package com.springmvc.domain;

import java.sql.Timestamp;

public class ChatRoom {
    private Long id;
    private String user1;
    private String user2;
    private Timestamp updatedAt;

    // 생성자
    public ChatRoom() {
    }

    public ChatRoom(String user1, String user2, Timestamp updatedAt) {
        this.user1 = user1;
        this.user2 = user2;
        this.updatedAt = updatedAt;
    }

    // 게터/세터
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUser1() {
        return user1;
    }

    public void setUser1(String user1) {
        this.user1 = user1;
    }

    public String getUser2() {
        return user2;
    }

    public void setUser2(String user2) {
        this.user2 = user2;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
