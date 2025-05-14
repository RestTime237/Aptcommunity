package com.springmvc.repository;

import com.springmvc.domain.Schedule;

import java.time.LocalDate;
import java.util.List;

public interface ScheduleRepository {
    List<Schedule> getScheduleByApartment(String apartmentCode);

    void addEvent(Schedule schedule);

    void updateEvent(Schedule schedule);

    void updateDate(Long id, LocalDate start, LocalDate end);

    void deleteEvent(Long id);

    void updateEndDate(Long id, LocalDate endDate);
}
