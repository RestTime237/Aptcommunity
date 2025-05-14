package com.springmvc.service;

import com.springmvc.domain.ChatMessage;
import com.springmvc.domain.ChatRoom;
import com.springmvc.repository.ChatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    private ChatRepository chatRepository;


    @Override
    public List<ChatRoom> getChatRooms(String userId) {
        return chatRepository.findRoomsByUserId(userId);
    }

    @Override
    public ChatRoom getChatRoomById(Long roomId) {
        return chatRepository.findRoomById(roomId);
    }

    @Override
    public List<ChatMessage> getMessagesByRoomId(Long roomId) {
        return chatRepository.findMessagesByRoomId(roomId);
    }

    @Override
    public void sendMessage(ChatMessage message) {
        chatRepository.saveMessage(message);
    }

    @Override
    public Long createRoom(String userA, String userB) {
        ChatRoom existing = chatRepository.findRoomByUsers(userA, userB);
        if (existing != null) {
            return existing.getId();
        }
        return chatRepository.createRoom(userA, userB);
    }


    @Override
    public Long getOrCreateChatRoom(String userId, String opponentId) {
        Long roomId = chatRepository.getOrCreateChatRoom(userId, opponentId);
        if (roomId != null) return roomId;
        return chatRepository.createRoom(userId, opponentId);
    }


    @Override
    public void markMessagesAsRead(Long roomId, String userId) {
        List<ChatMessage> unreadMessages = chatRepository.findUnreadMessages(roomId, userId);

        for (ChatMessage msg : unreadMessages) {
            msg.setIsRead(true);
            msg.setReadAt(LocalDateTime.now());
        }
        chatRepository.updateMessages(unreadMessages);
    }
}
