package com.techelevator.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface LeaseDao {

    public List<Lease> getAllLeases();
    
    public List<Lease> getLeasesForLandlord(int landlordUserId);
    
    public List<Lease> getLeasesForRenter(int renterUserId);

    public Lease getLeaseById(int leaseId);

    public void createLease(int userId, int unitId, LocalDate signedDate, int rentLength, BigDecimal rentAmount, BigDecimal lateFee, String status);
    
	public void updateLease(Lease lease);
    
}