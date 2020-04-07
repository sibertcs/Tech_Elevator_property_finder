package com.techelevator.model;

import java.time.LocalDate;

public class MaintenanceRequest {

    private int requestId;
    private int unitId;
    private int requestUserId;
    private String requestDesc;
    private int priority;
    private LocalDate dateRequested;
    private int assignedUserId;
    private boolean isCompleted;

    public int getRequestId() {
        return requestId;
    }

    public LocalDate getDateRequested() {
        return dateRequested;
    }

    public void setDateRequested(LocalDate dateRequested) {
        this.dateRequested = dateRequested;
    }

    public boolean isCompleted() {
        return isCompleted;
    }

    public void setCompleted(boolean isCompleted) {
        this.isCompleted = isCompleted;
    }

    public int getAssignedUserId() {
        return assignedUserId;
    }

    public void setAssignedUserId(int assignedUserId) {
        this.assignedUserId = assignedUserId;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public String getRequestDesc() {
        return requestDesc;
    }

    public void setRequestDesc(String requestDesc) {
        this.requestDesc = requestDesc;
    }

    public int getRequestUserId() {
        return requestUserId;
    }

    public void setRequestUserId(int requestUserId) {
        this.requestUserId = requestUserId;
    }

    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

}