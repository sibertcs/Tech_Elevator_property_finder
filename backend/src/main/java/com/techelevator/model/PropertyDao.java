package com.techelevator.model;

import java.util.List;

public interface PropertyDao {
    
public List<Property> getAllProperties();
public boolean addNewProperty(Property property);
public void addUnitsByProperty(int propertyId, List<Unit> units);

}