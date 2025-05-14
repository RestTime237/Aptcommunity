package com.springmvc.rowmapper;

import com.springmvc.domain.ChatRoom;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ChatRoomRowMapper implements RowMapper<ChatRoom> {
    @Override
    public ChatRoom mapRow(ResultSet rs, int rowNum) throws SQLException {
        ChatRoom room = new ChatRoom();
        room.setId(rs.getLong("id"));
        room.setUser1(rs.getString("user1"));
        room.setUser2(rs.getString("user2"));
        room.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return room;
    }
}
