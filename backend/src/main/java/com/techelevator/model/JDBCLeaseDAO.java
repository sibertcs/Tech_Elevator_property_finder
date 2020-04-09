package com.techelevator.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

@Component
class JdbcLeaseDao implements LeaseDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public JdbcLeaseDao(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    private Lease mapRowToLease (SqlRowSet row) {
        Lease newLease = new Lease();

        newLease.setLeaseId(row.getInt("lease_id"));                       // int
        newLease.setUserId(row.getInt("user_id"));                         // int
        newLease.setUnitId(row.getInt("unit_id"));                         // int
        newLease.setSignedDate(row.getDate("signed_date").toLocalDate());  // LocalDate
        newLease.setRentLength(row.getInt("rent_length"));                 // int
        newLease.setRentAmount(row.getBigDecimal("rent_amount"));          // BigDecimal
        newLease.setLateFee(row.getBigDecimal("late_fee"));                // BigDecimal
        newLease.setStatus(row.getString("status"));                       // String
        return newLease;
    }

    @Override
    public List<Lease> getAllLeases() {
        String sql = "SELECT lease_id, user_id, unit_id, signed_date, rent_length, rent_amount, late_fee, status "
        + "FROM lease;";
        SqlRowSet rows = jdbcTemplate.queryForRowSet(sql);
        
        List<Lease> allLeases = new ArrayList<Lease>();
        while (rows.next()) {
            allLeases.add(mapRowToLease(rows));
        }
        return allLeases;
    }
    
    @Override
    public List<Lease> getLeasesForLandlord(int landlordUserId) {
        String sql = "SELECT lease_id, lease.user_id, lease.unit_id, signed_date, rent_length, rent_amount, late_fee, status "
        + "FROM lease "
        + "JOIN unit ON lease.unit_id = unit.unit_id "
        + "JOIN property ON unit.property_id = property.property_id "
        + "WHERE property.landlord_id = ?;";
        SqlRowSet rows = jdbcTemplate.queryForRowSet(sql, landlordUserId);
        
        List<Lease> landlordLeases = new ArrayList<Lease>();
        while (rows.next()) {
            landlordLeases.add(mapRowToLease(rows));
        }
        return landlordLeases;
    }
    
    @Override
    public List<Lease> getLeasesForRenter(int renterUserId) {
        String sql = "SELECT lease_id, user_id, unit_id, signed_date, rent_length, rent_amount, late_fee, status "
        + "FROM lease "
        + "WHERE user_id = ?;";
        SqlRowSet rows = jdbcTemplate.queryForRowSet(sql, renterUserId);
        
        List<Lease> renterLeases = new ArrayList<Lease>();
        while (rows.next()) {
            renterLeases.add(mapRowToLease(rows));
        }
        return renterLeases;
    }
    
    @Override
    public Lease getLeaseById(int leaseId) {
        String sql = "SELECT lease_id, user_id, unit_id, signed_date, rent_length, rent_amount, late_fee, status "
                    + "FROM lease "
                    + "WHERE lease_id = ?;";
        SqlRowSet rows = jdbcTemplate.queryForRowSet(sql, leaseId);

        Lease newLease = new Lease();
        while (rows.next()) {
            newLease = mapRowToLease(rows);
        }
        return newLease;
    }
    
    @Override
    public void createLease(Lease newLease) {
        String sql = "INSERT INTO lease (user_id, unit_id, signed_date, rent_length, rent_amount, late_fee, status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?) RETURNING lease_id;";
        jdbcTemplate.update(sql, newLease.getUserId(), 
                                    newLease.getUnitId(), 
                                    newLease.getSignedDate(),
                                    newLease.getRentLength(),
                                    newLease.getRentAmount(),
                                    newLease.getLateFee(),
                                    newLease.getStatus());
        // Update unit 'is_available' to false
        sql = "UPDATE unit SET is_available = false WHERE unit_id = ?;";
        jdbcTemplate.update(sql, newLease.getUnitId());
    }
    
    @Override
    public void updateLease(Lease lease) {
        String sql = "UPDATE lease SET user_id = ?, unit_id = ?, signed_date = ?, rent_length = ?, rent_amount = ?, late_fee = ?, status = ? "
                    + "WHERE lease_id = ?;";
        jdbcTemplate.update(sql, lease.getUserId(), 
                                lease.getUnitId(), 
                                lease.getSignedDate(),
                                lease.getRentLength(),
                                lease.getRentAmount(),
                                lease.getLateFee(),
                                lease.getStatus(),
                                lease.getLeaseId());
    }

}