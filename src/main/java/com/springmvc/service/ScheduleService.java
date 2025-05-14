package com.springmvc.service;

import com.springmvc.domain.Schedule;

import java.time.LocalDate;
import java.util.List;

public interface ScheduleService {
    List<Schedule> getScheduleByApartment(String apartmentCode);

    void addEvent(Schedule schedule);

    void updateEvent(Schedule schedule);

    void updateDate(Long id, LocalDate start, LocalDate end);

    void deleteEvent(Long id);

    void updateEndDate(Long id, LocalDate endDate);

}
