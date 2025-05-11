package com.springmvc.repository;

import java.util.List;
import com.springmvc.domain.ChatRoom;
import com.springmvc.domain.ChatMessage;

public interface ChatRepository {
    List<ChatRoom> findRoomsByUserId(String userId);
    ChatRoom findRoomById(Long roomId);
    ChatRoom findRoomByUsers(String userA, String userB);
    Long createRoom(String userA, String userB);
    List<ChatMessage> findMessagesByRoomId(Long roomId);
    void saveMessage(ChatMessage message);
    Long getOrCreateChatRoom(String userId, String opponentId);
    List<ChatMessage> findUnreadMessages(Long roomId, String userId);
    void updateMessages(List<ChatMessage> messages);
}
