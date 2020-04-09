package com.techelevator.model;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

@Component
public class JdbcRentDao implements RentDao{

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public JdbcRentDao(DataSource datasource){
        this.jdbcTemplate = new JdbcTemplate(datasource);
    }

    @Override
    public List<RentCycle> getAllRent() {
        List<RentCycle> allRent = new ArrayList<>();
        String allRentSql = "SELECT * FROM Rent_cycle";
        SqlRowSet results = jdbcTemplate.queryForRowSet(allRentSql);
        while (results.next()){
            RentCycle renCy = new RentCycle();
            renCy.setId(results.getInt("rent_cycle_id"));
            renCy.setId(results.getInt("lease_id"));
            renCy.setStartDate(results.getDate("start_date").toLocalDate());
            renCy.setBalance(results.getBigDecimal("balance"));
            renCy.setDueDate(results.getDate("due_date").toLocalDate());
            renCy.setRentStatus(results.getString("rent_status"));
        }
        return allRent;
    }

    @Override
    public List<Payment> getAllPayments(){
        List<Payment> allPayments = new ArrayList<>();
        String allPaymentsSql = "SELECT * FROM payment";
        SqlRowSet results = jdbcTemplate.queryForRowSet(allPaymentsSql);
        while (results.next()){
            Payment payment = new Payment();
            payment.setId(results.getInt("payment_id"));
            payment.setRentCycleId(results.getInt("rent_cycle_id"));
            payment.setAmountPaid(results.getBigDecimal("amount_paid"));
            payment.setDatePaid(results.getDate("date_paid").toLocalDate());
        }
        return allPayments;
    }

}