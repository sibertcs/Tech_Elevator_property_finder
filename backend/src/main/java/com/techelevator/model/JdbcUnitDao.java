// package com.techelevator.model;

// import java.util.List;

// import org.springframework.jdbc.core.JdbcTemplate;
// import org.springframework.jdbc.support.rowset.SqlRowSet;
// import org.springframework.stereotype.Component;

// @Component
// public class JdbcUnitDao implements UnitDao {

// private JdbcTemplate jdbcTemplate;
//     @Override
//     public List<Unit> getAllUnits() {
//         String sql = "SELECT unit_id, unit_number, property_id, bed_count, bath_count, price, sq_ft, is_available FROM unit;";
//         SqlRowSet results = jdbcTemplate.queryForRowSet(sql);
//         return;
//     }

//     @Override
//     public List<Unit> getUnitsByProperty() {
//         return null;
//     }

//     @Override
//     public List<User> getRentersByUnit() {
//         return null;
//     }
    
// }