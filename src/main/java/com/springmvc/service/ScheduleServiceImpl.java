package com.springmvc.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springmvc.domain.Schedule;
import com.springmvc.repository.ScheduleRepository;

@Service
public class ScheduleServiceImpl implements ScheduleService{
	
	@Autowired
	private ScheduleRepository scheduleRepository;

	@Override
	public List<Schedule> getScheduleByApartment(String apartmentCode) {
		return scheduleRepository.getScheduleByApartment(apartmentCode);
	}

	@Override
	public void addEvent(Schedule schedule) {
		scheduleRepository.addEvent(schedule);
		
	}

	@Override
	public void updateEvent(Schedule schedule) {
		scheduleRepository.updateEvent(schedule);
		
	}

	@Override
	public void deleteEvent(Long id) {
		scheduleRepository.deleteEvent(id);
		
	}

	@Override
	public void updateDate(Long id, LocalDate start, LocalDate end) {
		scheduleRepository.updateDate(id, start, end);
		
	}

	@Override
	public void updateEndDate(Long id, LocalDate endDate) {
		scheduleRepository.updateEndDate(id, endDate);
		
	}
	
}
