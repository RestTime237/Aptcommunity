package com.springmvc.controller;

import com.springmvc.domain.ChatMessage;
import com.springmvc.domain.ChatRoom;
import com.springmvc.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class ChatSocketController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private SimpMessagingTemplate messageTemplate;

    // CREATE
    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload ChatMessage message) {

        ChatRoom room = chatService.getChatRoomById(message.getRoomId());

        String receiverId = room.getUser1().equals(message.getSenderId()) ? room.getUser2() : room.getUser1();

        message.setReceiverId(receiverId);
        message.setIsRead(false);

        chatService.sendMessage(message);
        messageTemplate.convertAndSend("/topic/room." + message.getRoomId(), message);
    }

}
