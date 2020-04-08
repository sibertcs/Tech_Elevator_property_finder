package com.techelevator.model;

import java.math.BigDecimal;
import java.time.LocalDate;



public class Lease {

    private int leaseId;
    private int userId;
    private int unitId;
    private LocalDate signedDate;
    private int rentLength;
    private BigDecimal rentAmount;
    private BigDecimal lateFee;

    public int getLeaseId() {
        return leaseId;
    }

    public BigDecimal getLateFee() {
        return lateFee;
    }

    public void setLateFee(BigDecimal lateFee) {
        this.lateFee = lateFee;
    }

    public BigDecimal getRentAmount() {
        return rentAmount;
    }

    public void setRentAmount(BigDecimal rentAmount) {
        this.rentAmount = rentAmount;
    }

    public int getRentLength() {
        return rentLength;
    }

    public void setRentLength(int rentLength) {
        this.rentLength = rentLength;
    }

    public LocalDate getSignedDate() {
        return signedDate;
    }

    public void setSignedDate(LocalDate signedDate) {
        this.signedDate = signedDate;
    }

    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setLeaseId(int leaseId) {
        this.leaseId = leaseId;
    }
}