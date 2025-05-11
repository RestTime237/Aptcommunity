package com.springmvc.rowmapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.ChatMessage;

public class ChatMessageRowMapper implements RowMapper<ChatMessage> {
    @Override
    public ChatMessage mapRow(ResultSet rs, int rowNum) throws SQLException {
        ChatMessage msg = new ChatMessage();
        msg.setId(rs.getLong("id"));
        msg.setRoomId(rs.getLong("roomId"));
        msg.setSenderId(rs.getString("senderId"));
        msg.setReceiverId(rs.getString("receiverId"));
        msg.setContent(rs.getString("content"));
        msg.setSentAt(rs.getTimestamp("sentAt"));
        msg.setIsRead(rs.getBoolean("isRead"));
        
        Timestamp ts = rs.getTimestamp("readAt");
        msg.setReadAt(ts != null ? ts.toLocalDateTime() : null);

        return msg;
    }
}
