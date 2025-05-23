package com.springmvc.repository;

import com.springmvc.domain.Schedule;
import com.springmvc.rowmapper.ScheduleRowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@Repository
public class ScheduleRepositoryImpl implements ScheduleRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public List<Schedule> getScheduleByApartment(String apartmentCode) {
        String SQL = "select * from eventschedule where apartmentCode = ? order by startDate asc";
        return jdbcTemplate.query(SQL, new ScheduleRowMapper(), apartmentCode);
    }

    @Override
    public void addEvent(Schedule schedule) {
        String SQL = "insert eventschedule(apartmentCode, title, description, startDate, endDate, category, publicFlag) values(?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(SQL, schedule.getApartmentCode(), schedule.getTitle(), schedule.getDescription(), schedule.getStartDate(), schedule.getEndDate(), schedule.getCategory(), schedule.isPublicFlag() ? 1 : 0);

    }

    @Override
    public void updateEvent(Schedule schedule) {
        String SQL = "update eventschedule set title = ?, description = ?, startDate = ?, endDate = ?, category = ?, publicFlag = ? where id = ?";
        System.out.println("변경되는 일정 id : " + schedule.getId());

        jdbcTemplate.update(SQL, schedule.getTitle(), schedule.getDescription(), schedule.getStartDate(), schedule.getEndDate(), schedule.getCategory(), schedule.isPublicFlag(), schedule.getId());

    }

    @Override
    public void deleteEvent(Long id) {
        String SQL = "delete from eventschedule where id = ?";
        jdbcTemplate.update(SQL, id);

    }

    @Override
    public void updateDate(Long id, LocalDate start, LocalDate end) {
        String SQL = "update eventschedule set startDate = ?, endDate = ? where id = ?";
        jdbcTemplate.update(SQL, Date.valueOf(start), Date.valueOf(end), id);

    }

    @Override
    public void updateEndDate(Long id, LocalDate endDate) {
        String SQL = "update eventschedule SET endDate = ? WHERE id = ?";
        jdbcTemplate.update(SQL, Date.valueOf(endDate), id);
    }


}
