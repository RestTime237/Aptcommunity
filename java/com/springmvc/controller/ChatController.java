package com.springmvc.controller;

import java.sql.*;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.springmvc.domain.Member;
import com.springmvc.domain.ChatMessage;
import com.springmvc.domain.ChatRoom;
import com.springmvc.service.ChatService;
import com.springmvc.service.MemberService;

import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;




@Controller
@RequestMapping("/chat")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private MemberService memberService;
    
    @GetMapping("/rooms")
    public String getChatRooms(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        List<ChatRoom> rooms = chatService.getChatRooms(userId);
        
        Map<Long, Member> memberMap = new HashMap<Long, Member>();
        for(ChatRoom room : rooms) {
        	String opponentId = room.getUser1().equals(userId) ? room.getUser2() : room.getUser1();
        	Member opponent = memberService.getByUserId(opponentId);
        	memberMap.put(room.getId(), opponent);
        }
      
        model.addAttribute("chatRooms", rooms);
        model.addAttribute("members", memberMap);
        return "chat/rooms";
    }

    @GetMapping("/room/{roomId}")
    public String enterChatRoom(@PathVariable Long roomId, HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        
        chatService.markMessagesAsRead(roomId, userId);
        
        Member opponent = null;
        ArrayList<Member> roomMember = new ArrayList<Member>();
        roomMember.add(memberService.getByUserId(chatService.getChatRoomById(roomId).getUser1()));
        roomMember.add(memberService.getByUserId(chatService.getChatRoomById(roomId).getUser2()));
        for(int i = 0; i < roomMember.size(); i++) {
        	if(!userId.equals(roomMember.get(i).getUserId())) {
        		opponent = roomMember.get(i);
        	}
        }
        
        ChatRoom room = chatService.getChatRoomById(roomId);
        List<ChatMessage> messages = chatService.getMessagesByRoomId(roomId);

        model.addAttribute("chatRoom", room);
        model.addAttribute("messages", messages);
        model.addAttribute("userId", userId);
        model.addAttribute("opponent", opponent);
        return "chat/room";
    }
    
    @PostMapping("/createRoom")
    @ResponseBody
    public ResponseEntity<Long> createRoom(@RequestParam String user1, @RequestParam String user2) {
    	Long roomId = chatService.createRoom(user1, user2);
    	return ResponseEntity.ok(roomId);
    }

    @PostMapping("/send")
    @ResponseBody
    public void sendMessage(@RequestBody ChatMessage message) {

        chatService.sendMessage(message);
    }

    @PostMapping("/start")
    @ResponseBody
    public Long startChatAjax(@RequestParam String opponentId, HttpSession session) {
    	System.out.println("채팅시작 컨트롤러 입장 opponentId : " + opponentId);

        Member mb = (Member) session.getAttribute("mb");
        Long roomId = chatService.getOrCreateChatRoom(mb.getUserId(), opponentId);
        System.out.println("방번호 : " + roomId);

        return roomId;
    }
    
}

