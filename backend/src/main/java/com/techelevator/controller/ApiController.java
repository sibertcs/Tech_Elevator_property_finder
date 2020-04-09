package com.techelevator.controller;

import java.util.List;

import com.techelevator.authentication.AuthProvider;
import com.techelevator.authentication.UnauthorizedException;
import com.techelevator.model.Lease;
import com.techelevator.model.LeaseDao;
import com.techelevator.model.Payment;
import com.techelevator.model.Property;
import com.techelevator.model.PropertyDao;
import com.techelevator.model.RentCycle;
import com.techelevator.model.RentDao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

/**
 * ApiController
 */
@CrossOrigin
@RestController
@RequestMapping("/api")
public class ApiController {

    @Autowired
    private AuthProvider authProvider;

    @Autowired
    private LeaseDao leaseDao;

    private PropertyDao propertyDao;

    @Autowired
    private RentDao rentDao;

    @Autowired
	public ApiController(PropertyDao propertyDao) {
		this.propertyDao = propertyDao;
    }
    
    @RequestMapping(path = "/", method = RequestMethod.GET)
    public String authorizedOnly() throws UnauthorizedException {
        /*
        You can lock down which roles are allowed by checking
        if the current user has a role.
        
        In this example, if the user does not have the admin or user role
        we send back an unauthorized error.
        */
        if (!authProvider.userHasRole(new String[] { "admin", "renter", "maintenance", "landlord" })) {
            throw new UnauthorizedException();
        }
        return "Success";
    }
    // Property Dao Methods
    @GetMapping("/properties")
    public List<Property> getAllProperties() {
        return propertyDao.getAllProperties();
    }
    @GetMapping("/properties/{landlordId}")
    public List<Property> getLandlordsProperties(@PathVariable int landlordId) {
        return propertyDao.getPropertiesByLandlord(landlordId);
    }
    @PostMapping("/propertiesnew")
    public boolean addNewProperty(@RequestBody Property newProperty) {
        return propertyDao.addNewProperty(newProperty);
    }




    /**************** LEASE CONTROLLER METHODS ****************/

    @GetMapping("/leases")
    public List<Lease> getAllLeases() {
        return leaseDao.getAllLeases();
    }
    @GetMapping("/leases/landlord/{landlordUserId}")
    public List<Lease> getLeasesForLandlord(@PathVariable int landlordUserId) {
        return leaseDao.getLeasesForLandlord(landlordUserId);
    }
    @GetMapping("/leases/renter/{renterUserId}")
    public List<Lease> getLeasesForRenter(@PathVariable int renterUserId) {
        return leaseDao.getLeasesForRenter(renterUserId);
    }
    @GetMapping("/leases/{leaseId}")
    public Lease getLeaseById(@PathVariable int leaseId) {
        return leaseDao.getLeaseById(leaseId);
    }

    @PostMapping("/leases")
    @ResponseStatus(HttpStatus.CREATED)
    public void createNewLease(@RequestBody Lease newLease) {
        leaseDao.createLease(newLease);
    }
    @PutMapping("/leases/{leaseId}")
    public void updateLease(@PathVariable int leaseId, @RequestBody Lease updatedLease) {
        if (leaseDao.getLeaseById(leaseId) == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
        updatedLease.setLeaseId(leaseId);
        leaseDao.updateLease(updatedLease);
    }



    /**************** LEASE CONTROLLER METHODS ****************/    

    @PutMapping("/propertiesupdate")
    public boolean displayUpdateExistingProperty(@RequestBody Property updatedProperty) {
        return propertyDao.updateExistingProperty(updatedProperty);
    }


    /*******  RENT CONTROLLER METHODS ************/

    @GetMapping("/rent")
    public List<RentCycle> getAllRent(){
        return rentDao.getAllRent();
    }

    @GetMapping("/payments")
    public List<Payment> getAllPayments(){
        return rentDao.getAllPayments();
    }

    @PostMapping("/rent")
    @ResponseStatus(HttpStatus.CREATED)
    public void createRentCycle(@RequestBody RentCycle rentCycle){
        rentDao.createRentCycle(rentCycle);
    }

    @PostMapping("/payments")
    @ResponseStatus(HttpStatus.CREATED)
    public void createPayment(@RequestBody Payment payment){
        rentDao.createPayment(payment);
    }

    // @PutMapping("/rent/{rentCycleId}")
    // public void updateRentCycle(@PathVariable int rentCycleId, @RequestBody RentCycle rentCycle){
    //     if(rentDao.get)
    // }

    @GetMapping("/rent/{leaseId}")
    public RentCycle gerRentByLeaseId(@PathVariable int leaseId){
        return rentDao.getRentByLeaseId(leaseId);
    }

    @GetMapping("/payments/{rentCycleId}")
    public List<Payment> getPaymentsByRentCycleId(@PathVariable int rentCycleId){
        return rentDao.getPaymentsByRentCycleId(rentCycleId);
    }


    /******** RENT CONTROLLER METHODS **********/
}