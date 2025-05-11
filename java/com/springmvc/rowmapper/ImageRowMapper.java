package com.springmvc.rowmapper;


import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.springmvc.domain.Image;



public class ImageRowMapper implements RowMapper<Image> {
    @Override
    public Image mapRow(ResultSet rs, int rowNum) throws SQLException {
        Image image = new Image();
        image.setId(rs.getLong("id"));
        image.setRefType(rs.getString("refType"));
        image.setRefId(rs.getLong("refId"));
        image.setFileName(rs.getString("fileName"));
        return image;
    }
}
