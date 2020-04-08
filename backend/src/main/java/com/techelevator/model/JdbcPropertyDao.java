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
    prop.setZipCode(results.getString("zip_code"));
    prop.setPropertyName(results.getString("property_name"));
    prop.setPhotoPath(results.getString("photo_path"));
    prop.setLocation(results.getString("location"));
    allProperties.add(prop);
}
return allProperties;
}


}