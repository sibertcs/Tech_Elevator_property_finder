package com.techelevator.model;

import java.math.BigDecimal;

public class Unit {

    private int unitId;
    private String unitNumber;
    private int propertyId;
    private int bedCount;
    private double bathCount;
    private BigDecimal price;
    private int sqft;
    private boolean isAvailable;

    public int getUnitId() {
        return unitId;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean isAvailable) {
        this.isAvailable = isAvailable;
    }

    public int getSqFt() {
        return sqft;
    }

    public void setSqFt(int sqft) {
        this.sqft = sqft;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public double getBathCount() {
        return bathCount;
    }
    public int getBedCount() {
        return bedCount;
    }

    public void setBedCount(int bedCount) {
        this.bedCount = bedCount;
    }
    public void setBathCount(double bathCount) {
        this.bathCount = bathCount;
    }

    public int getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(int propertyId) {
        this.propertyId = propertyId;
    }

    public String getUnitNumber() {
        return unitNumber;
    }

    public void setUnitNumber(String unitNumber) {
        this.unitNumber = unitNumber;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }


}