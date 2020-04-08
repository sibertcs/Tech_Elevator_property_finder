package com.techelevator.controller;

import java.util.List;

import com.techelevator.authentication.AuthProvider;
import com.techelevator.authentication.UnauthorizedException;
import com.techelevator.model.Property;
import com.techelevator.model.PropertyDao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

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
    private PropertyDao propertyDao;

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

    @GetMapping("/properties")
    public List<Property> getAllProperties() {
        return propertyDao.getAllProperties();
    }
}