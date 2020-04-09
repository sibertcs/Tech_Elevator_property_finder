package com.techelevator.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.apache.tomcat.jni.Local;

public interface RentDao {

    public List<RentCycle> getAllRent();
    public List<Payment> getAllPayments();
    public void createRentCycle(RentCycle rentCycle);
    public void createPayment(Payment payment);
}