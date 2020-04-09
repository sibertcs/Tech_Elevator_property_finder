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
public class JdbcRentDao implements RentDao{

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public JdbcRentDao(DataSource datasource){
        this.jdbcTemplate = new JdbcTemplate(datasource);
    }

    @Override
    public void createRentCycle(RentCycle rentCycle){
        String sqlCreateRentCycle = "INSERT INTO rent_cycle(rentCycleId, leaseId, startDate, balance, dueDate, rentStatus)"
        + "VALUES(?,?,?,?,?,?);";
        jdbcTemplate.update(sqlCreateRentCycle, rentCycle.getId(), rentCycle.getLeaseId(), rentCycle.getStartDate(), rentCycle.getBalance(), rentCycle.getDueDate(), rentCycle.getRentStatus());

    }

    @Override
    public void createPayment(Payment payment){
        String sqlCreatePayment = "INSERT INTO payment(paymentId, rentCycleId, amountPaid, datePaid)"
        + "VALUES(?, ?, ?, ?);";
        jdbcTemplate.update(sqlCreatePayment, payment.getId(), payment.getRentCycleId(), payment.getAmountPaid(), LocalDate.now());
    }

    @Override
    public List<RentCycle> getAllRent() {
        List<RentCycle> allRent = new ArrayList<>();
        String allRentSql = "SELECT * FROM Rent_cycle;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(allRentSql);
        while (results.next()){
           RentCycle r;
           r = rentCycleResult(results);
           allRent.add(r);
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

   


    private RentCycle rentCycleResult(SqlRowSet row){
    RentCycle renCy = new RentCycle();
    renCy.setId(row.getInt("rent_cycle_id"));
    renCy.setId(row.getInt("lease_id"));
    renCy.setStartDate(row.getDate("start_date").toLocalDate());
    renCy.setBalance(row.getBigDecimal("balance"));
    renCy.setDueDate(row.getDate("due_date").toLocalDate());
    renCy.setRentStatus(row.getString("rent_status"));
    return renCy;
}
}