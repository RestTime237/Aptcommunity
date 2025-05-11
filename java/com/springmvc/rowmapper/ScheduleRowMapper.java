package com.springmvc.rowmapper;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;


import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.Schedule;

public class ScheduleRowMapper implements RowMapper<Schedule> {

    @Override
    public Schedule mapRow(ResultSet rs, int rowNum) throws SQLException {
        Schedule s = new Schedule();
        s.setId(rs.getLong("id"));
        s.setApartmentCode(rs.getString("apartmentCode"));
        s.setTitle(rs.getString("title"));
        s.setDescription(rs.getString("description"));
        
        Date start = rs.getDate("startDate");
        Date end = rs.getDate("endDate");
        
        s.setStartDate(start != null ? start.toLocalDate() : null);
        s.setEndDate(end != null ? end.toLocalDate() : null);
        
        s.setCategory(rs.getString("category"));
        s.setPublicFlag(rs.getBoolean("publicFlag"));
        return s;
    }
}

