package com.techelevator.model;

import java.util.List;

public interface RentDao {

    public List<RentCycle> getAllRent();
    public List<Payment> getAllPayments();
    public void createRentCycle(RentCycle rentCycle);
    public void updateRentCycle(RentCycle rentCycle);
    public void createPayment(Payment payment);
    public RentCycle getRentByLeaseId(int leaseId);
    public List<Payment> getPaymentsByRentCycleId(int rentCycleId);
}