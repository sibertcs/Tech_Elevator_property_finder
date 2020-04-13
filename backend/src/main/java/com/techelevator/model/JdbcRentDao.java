package com.techelevator.model;


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

    @Override //passed test sql is good
    public void createRentCycle(RentCycle rentCycle){
        String sqlCreateRentCycle = "INSERT INTO rent_cycle(lease_id, start_date, balance, due_date, rent_status) "
        + "VALUES(?,?,?,?,?);";
        jdbcTemplate.update(sqlCreateRentCycle, rentCycle.getId(), rentCycle.getLeaseId(), rentCycle.getStartDate(), rentCycle.getBalance(), rentCycle.getDueDate(), rentCycle.getRentStatus());

    }

    @Override
    public void updateRentCycle(RentCycle rentCycle){
        String sqlCreateRentCycle = "UPDATE rent_cycle SET rent_status = ? "
        + "WHERE  rent_cycle_id = ?;";
        jdbcTemplate.update(sqlCreateRentCycle, rentCycle.getRentStatus(), rentCycle.getId());

    }

    @Override //passed test sql is good
    public void createPayment(Payment payment){
        String sqlFindRentCycle = "SELECT rent_cycle_id FROM rent_cycle " +
                                  "WHERE lease_id = ? AND start_date < ? AND due_date >= ?;";
        int rentCycleId = jdbcTemplate.queryForObject(sqlFindRentCycle, Integer.class, payment.getLeaseId(), LocalDate.now(), LocalDate.now());
        payment.setRentCycleId(rentCycleId);                          
        String sqlCreatePayment = "INSERT INTO payment (rent_cycle_id, amount_paid, date_paid) "
                                + "VALUES(?, ?, ?);";
        jdbcTemplate.update(sqlCreatePayment, payment.getRentCycleId(), payment.getAmountPaid(), LocalDate.now());
    }

    @Override //passed test sql is good
    public List<RentCycle> getAllRent() {
        List<RentCycle> allRent = new ArrayList<>();
        String allRentSql = "SELECT rent_cycle_id, lease_id, start_date, balance, due_date, rent_status "
        + "FROM Rent_cycle " 
        + "WHERE rent_status = 'Unpaid' OR rent_status = 'Overdue';";
        SqlRowSet results = jdbcTemplate.queryForRowSet(allRentSql);
        while (results.next()){
           allRent.add(mapRowToRentCycle(results));
        }
        return allRent;
    }

    @Override //passed test sql is good
    public List<Payment> getAllPayments(){
        List<Payment> allPayments = new ArrayList<>();
        String allPaymentsSql = "SELECT payment_id, rent_cycle_id, amount_paid, date_paid "
        +  "FROM payment;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(allPaymentsSql);
        while (results.next()){
            allPayments.add(mapRowToPayment(results));
        }
        return allPayments;
    }


    @Override //passed test sql is good
    public RentCycle getRentByLeaseId(int leaseId){
        String sql = "SELECT rent_cycle_id, lease_id, start_date, balance, due_date, rent_status "
        + "FROM rent_cycle "
        + "WHERE lease_id = ?;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, leaseId);

        RentCycle rentCycle = new RentCycle();
        while(results.next()){
            rentCycle = mapRowToRentCycle(results);
        }
        return rentCycle;
    }

    @Override //passed test sql is good
    public List<Payment> getPaymentsByRentCycleId(int rentCycleId){
        String sql = "SELECT payment_id, rent_cycle_id, amount_paid, date_paid "
        + "FROM payment WHERE rent_cycle_id = ?;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, rentCycleId);

        List<Payment> payment = new ArrayList<>();
        while(results.next()){
            payment.add(mapRowToPayment(results));
        }
        return payment;
    }

    @Override
    public RentCycle getRentCycleById( int rentCycleId){
        String sql = "SELECT rent_cycle_id, lease_id, start_date, balance, due_date, rent_status "
        + "FROM rent_cycle WHERE rent_cycle_id = ?;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, rentCycleId);
        RentCycle rentCycle = new RentCycle();
        while(results.next()){
            rentCycle = mapRowToRentCycle(results);
        }
        return rentCycle;
    }

   private Payment mapRowToPayment(SqlRowSet row){
    Payment payment = new Payment();
    payment.setId(row.getInt("payment_id"));
    payment.setRentCycleId(row.getInt("rent_cycle_id"));
    payment.setAmountPaid(row.getBigDecimal("amount_paid"));
    payment.setDatePaid(row.getDate("date_paid").toLocalDate());
        return payment;
   }


    private RentCycle mapRowToRentCycle(SqlRowSet row){
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