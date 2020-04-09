package com.techelevator.model;

import java.util.List;

public interface RentDao {

    public List<RentCycle> getAllRent();
    public List<Payment> getAllPayments();

}