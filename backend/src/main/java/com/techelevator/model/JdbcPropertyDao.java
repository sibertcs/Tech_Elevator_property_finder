package com.techelevator.model;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

@Component
public class JdbcPropertyDao implements PropertyDao {

private JdbcTemplate jdbcTemplate;

@Autowired
public JdbcPropertyDao(DataSource datasource){
    this.jdbcTemplate = new JdbcTemplate(datasource);
}

@Override
public List<Property> getAllProperties() {
    List<Property> allProperties = new ArrayList<>();
    String propertySearchSql = "SELECT * FROM property;";
    SqlRowSet results = jdbcTemplate.queryForRowSet(propertySearchSql);
    while (results.next()){
        Property prop = new Property();
        prop.setPropertyId(results.getInt("property_id"));
        prop.setLandlordId(results.getInt("landlord_id"));
        prop.setStreetAddress(results.getString("street_address"));
        prop.setCity(results.getString("city"));
        prop.setState(results.getString("state"));
        prop.setZipCode(results.getString("zip_code"));
        prop.setPropertyName(results.getString("property_name"));
        prop.setPhotoPath(results.getString("photo_path"));
        prop.setLocation(results.getString("location"));

        String unitSearchSql = "SELECT unit_id, unit_number, bed_count, bath_count, price, sq_ft, is_available " + 
                               "FROM unit WHERE property_id = ?;";
        SqlRowSet unitResults = jdbcTemplate.queryForRowSet(unitSearchSql, prop.getPropertyId());
        List<Unit> unitList = new ArrayList<>();
        while (unitResults.next()) {
            Unit currentUnit = new Unit();
            currentUnit.setUnitId(unitResults.getInt("unit_id"));
            currentUnit.setUnitNumber(unitResults.getString("unit_number"));
            currentUnit.setBedCount(unitResults.getInt("bed_count"));
            currentUnit.setBathCount(unitResults.getInt("bath_count"));
            currentUnit.setPrice(unitResults.getBigDecimal("price"));
            currentUnit.setSqFt(unitResults.getInt("sq_ft"));
            currentUnit.setAvailable(unitResults.getBoolean("is_available"));
            unitList.add(currentUnit);
        }
        prop.setUnits(unitList);
        allProperties.add(prop);
    }
    return allProperties;
}


}