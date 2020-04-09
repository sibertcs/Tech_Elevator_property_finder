package com.techelevator.model;


import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;


import com.techelevator.Main;

import org.apache.tomcat.jni.Local;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

@Component
public class JdbcMaintenanceRequestDao implements MaintenanceRequestDao {
    
    private JdbcTemplate jdbcTemplate;

    @Autowired
    public JdbcMaintenanceRequestDao(DataSource datasource) {
        this.jdbcTemplate = new JdbcTemplate(datasource);
    }

    @Override
    public List<MaintenanceRequest> getAllRequests() {
        List<MaintenanceRequest> allRequests = new ArrayList<>();
        String requestSearchSql = "SELECT * FROM maintenance_request;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(requestSearchSql);
        while (results.next()) {
            MaintenanceRequest req = new MaintenanceRequest();
            req.setRequestId(results.getInt("request_id"));
            req.setUnitId(results.getInt("unit_id"));
            req.setRequestUserId(results.getInt("request_user_id"));
            req.setRequestDesc(results.getString("request_desc"));
            req.setPriority(results.getInt("priority"));
            req.setDateRequested(results.getDate("date_requested").toLocalDate());
            req.setAssignedUserId(results.getInt("assigned_user_id"));
            req.setCompleted(results.getBoolean("is_completed"));
            allRequests.add(req);
        }
        return allRequests;
    }

    @Override
    public void createRequest(MaintenanceRequest request) {
        String sqlInsert = "INSERT INTO maintenance_request (unit_id, request_user_id, request_desc, priority, date_requested) "
                + "VALUES (?,?,?,?,?);";
        jdbcTemplate.update(sqlInsert, request.getUnitId(), request.getRequestUserId(), request.getRequestDesc(), 
        request.getPriority(), LocalDateTime.now());
    }

    @Override
    public void updateRequest(MaintenanceRequest request){
        String sqlUpdate = "UPDATE maintenance_request SET assigned_user_id = ?, isCompleted = ?  " +
        "WHERE request_id = ?;";
        jdbcTemplate.update(sqlUpdate, request.getAssignedUserId(), request.getRequestId(), request.isCompleted());
    }
}