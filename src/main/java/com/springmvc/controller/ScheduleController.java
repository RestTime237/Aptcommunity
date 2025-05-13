package com.springmvc.controller;

import com.springmvc.domain.Member;
import com.springmvc.domain.Schedule;
import com.springmvc.service.ScheduleService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/schedule")
public class ScheduleController {

    @Autowired
    private ScheduleService scheduleService;

    @GetMapping("/list")
    @ResponseBody
    public List<Map<String, Object>> getEventList(HttpSession session) {
        String apartmentCode = ((Member)session.getAttribute("mb")).getApartmentCode();

        List<Schedule> schedules = scheduleService.getScheduleByApartment(apartmentCode);
        List<Map<String, Object>> result = new ArrayList<>();

        for (Schedule s : schedules) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", s.getId());
            map.put("title", s.getTitle());
            map.put("start", s.getStartDate().toString());

            map.put("end", s.getEndDate().plusDays(1).toString());
            map.put("category", s.getCategory());
            map.put("description", s.getDescription());
            map.put("publicFlag", s.isPublicFlag());
            result.add(map);
        }

        return result;
    }
    
    @PostMapping("/add")
    @ResponseBody
    public String addEvent(@RequestBody Schedule schedule, HttpSession session) {

    	Member mb = (Member) session.getAttribute("mb");
    	schedule.setApartmentCode(mb.getApartmentCode());
    	
    	scheduleService.addEvent(schedule);
    	return "success";
    }
    
    @PostMapping("/edit")
    @ResponseBody
    public String updateEvent(@RequestBody Schedule schedule, HttpSession session) {

    	Member mb = (Member) session.getAttribute("mb");
    	schedule.setApartmentCode(mb.getApartmentCode());
    	
    	System.out.println("컨트롤러에서 전달받은 id 값 : " + schedule.getId());

    	
    	scheduleService.updateEvent(schedule);
    	return "success";
    }
    
    @PostMapping("/delete")
    @ResponseBody
    public String deleteEvent(@RequestBody Map<String, Object> data) {
    	Long id = ((Number) data.get("id")).longValue();
    	scheduleService.deleteEvent(id);
    	return "success";
    }
    
    @PostMapping("/move")
    @ResponseBody
    public String moveSchedule(@RequestBody Schedule schedule) {
    	scheduleService.updateDate(schedule.getId(), schedule.getStartDate(), schedule.getEndDate());
    	return "success";
    }
    
    @PostMapping("/resize")
    @ResponseBody
    public String resizeSchedule(@RequestBody Map<String, Object> data) {
        Long id = ((Number) data.get("id")).longValue();
        LocalDate end = LocalDate.parse((String) data.get("endDate"));

        scheduleService.updateEndDate(id, end.minusDays(1));
        return "success";
    }

    
    @GetMapping("/calendar")
    public String viewCalendarPage() {
    	return "calendar";
    }
}
