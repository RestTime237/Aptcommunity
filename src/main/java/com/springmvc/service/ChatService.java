package com.springmvc.service;

import java.util.List;
import com.springmvc.domain.ChatMessage;
import com.springmvc.domain.ChatRoom;

public interface ChatService {
    List<ChatRoom> getChatRooms(String userId);                // 내 채팅방 목록 조회
    ChatRoom getChatRoomById(Long roomId);                     // 채팅방 단건 조회
    List<ChatMessage> getMessagesByRoomId(Long roomId);        // 특정 채팅방의 메시지 목록
    void sendMessage(ChatMessage message);                     // 메시지 전송
    Long createRoom(String userA, String userB);               // 채팅방 생성 또는 기존 방 리턴
    Long getOrCreateChatRoom(String userId, String opponentId);
    void markMessagesAsRead(Long roomId, String userId);
}
