package com.techelevator.model;

import java.util.List;

public interface MaintenanceRequestDao {

public List<MaintenanceRequest> getAllRequests();
public void createRequest (MaintenanceRequest request);
public void updateRequest(MaintenanceRequest request);

}