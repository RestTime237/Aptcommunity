package com.springmvc.service;

import java.time.LocalDate;
import java.util.List;

import com.springmvc.domain.Schedule;

public interface ScheduleService {
	List<Schedule> getScheduleByApartment(String apartmentCode);
	void addEvent(Schedule schedule);
	void updateEvent(Schedule schedule);
	void updateDate(Long id, LocalDate start, LocalDate end);
	void deleteEvent(Long id);
	void updateEndDate(Long id, LocalDate endDate);
	
}
