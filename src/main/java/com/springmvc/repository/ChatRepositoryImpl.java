package com.springmvc.repository;

import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.springmvc.domain.ChatRoom;
import com.springmvc.domain.ChatMessage;
import com.springmvc.rowmapper.ChatRoomRowMapper;
import com.springmvc.rowmapper.ChatMessageRowMapper;

@Repository
public class ChatRepositoryImpl implements ChatRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public List<ChatRoom> findRoomsByUserId(String userId) {
        String sql = "SELECT * FROM chatRoom WHERE user1 = ? OR user2 = ?";
        return jdbcTemplate.query(sql, new ChatRoomRowMapper(), userId, userId);
    }

    @Override
    public ChatRoom findRoomById(Long roomId) {
        String sql = "SELECT * FROM chatRoom WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, new ChatRoomRowMapper(), roomId);
    }

    @Override
    public ChatRoom findRoomByUsers(String user1, String user2) {
        String sql = "SELECT * FROM chatRoom WHERE (user1 = ? AND user2 = ?) OR (user1 = ? AND user2 = ?)";
        List<ChatRoom> rooms = jdbcTemplate.query(sql, new ChatRoomRowMapper(), user1, user2, user2, user1);
        return rooms.isEmpty() ? null : rooms.get(0);
    }

    @Override
    public Long createRoom(String user1, String user2) {
        String sql = "INSERT INTO chatRoom (user1, user2) VALUES (?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id"});
            ps.setString(1, user1);
            ps.setString(2, user2);
            return ps;
        }, keyHolder);

        return keyHolder.getKey().longValue();
    }

    @Override
    public List<ChatMessage> findMessagesByRoomId(Long roomId) {
        String sql = "SELECT * FROM chatMessage WHERE roomId = ? ORDER BY sentAt ASC";
        return jdbcTemplate.query(sql, new ChatMessageRowMapper(), roomId);
    }

    @Override
    public void saveMessage(ChatMessage message) {
        String sql = "INSERT INTO chatMessage (roomId, senderId, receiverId, content, sentAt, isRead) VALUES (?, ?, ?, ?, Now(), ?)";
        jdbcTemplate.update(sql,
            message.getRoomId(),
            message.getSenderId(),
            message.getReceiverId(),
            message.getContent(),
            message.getIsRead()
        );
        
        String updateRoom = "update chatRoom set updatedAt = Now() where id = ?";
        jdbcTemplate.update(updateRoom, message.getRoomId());
    }

	
    @Override
	public Long getOrCreateChatRoom(String userId, String opponentId) {
		String SQL = "select * from chatRoom " + "where (user1 = ? and user2 = ?) or (user1 = ? and user2 = ?)";
		
		List<Long> result = jdbcTemplate.query(SQL, 
		        (rs, rowNum) -> rs.getLong("id"),
		        userId, opponentId, opponentId, userId
		    );
		
		return result.isEmpty() ? null : result.get(0);
	}

	
    @Override
	public List<ChatMessage> findUnreadMessages(Long roomId, String userId) {
		String SQL = "select * from chatMessage where roomid = ? and receiverId = ? and isRead = false";
		return jdbcTemplate.query(SQL, new ChatMessageRowMapper(), roomId, userId);
	}

	@Override
	public void updateMessages(List<ChatMessage> messages) {
		String SQL = "update chatMessage set isRead = true, readAt = ? where id = ?";
		for(ChatMessage msg : messages) {
			jdbcTemplate.update(SQL, Timestamp.valueOf(msg.getReadAt()), msg.getId());
		}
		
	}


}
