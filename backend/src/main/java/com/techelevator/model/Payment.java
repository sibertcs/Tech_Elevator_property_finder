package com.techelevator.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Payment {
    private int id;
    private int rentCycleId;
    private BigDecimal amountPaid;
    private LocalDate datePaid;

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public int getRentCycleId() {
        return rentCycleId;
    }
    public void setRentCycleId(int rentCycleId) {
        this.rentCycleId = rentCycleId;
    }
    public BigDecimal getAmountPaid() {
        return amountPaid;
    }

    public void setAmountPaid(BigDecimal amountPaid) {
        this.amountPaid = amountPaid;
    }
    public LocalDate getDatePaid() {
        return datePaid;
    }
    public void setDatePaid(LocalDate datePaid) {
        this.datePaid = datePaid;
    }  
}