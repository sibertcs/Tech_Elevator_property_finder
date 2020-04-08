<template>
<div>
  <h1>this is the page to assign maintenance</h1>
  <div>Hello {{ user.sub }}</div>
  <div class= "maintenance-request-assignment">
      <div class="alert alert-success" role="alert" v-if="this.$route.query.assignment">
        This request has been successfully assigned.
      </div> 
  
<div class="card border-dark mb-3" style="max-width: 18rem;" v-for="request in allRequests" :key="request.unitId">
  <div class="card-header">{{ request.residentName }}</div>
  <div class="card-body text-dark">
    <h5 class="card-title">Unit id: {{ request.unitId }}</h5>
    <p class="card-text">{{ request.priorityLevel }} </p>
    <p class="card-text">{{ request.requestDate}}</p>
    <p class="card-text">{{ request.description }}</p>
    <p class="card-text">{{ request.status }}</p>
  </div>
</div>
<form>
<label>Assign Maintenance Employee: </label>
        <select>
        <option>Employee 1!!! </option>
        <option>Employee 2!!! </option>
        <option>Employee 3!!! </option>
         </select>
         <button type="submit" >Assign</button>
</form>
<form>
  <label> Change Status </label>
      <select>
        <option>Completed</option>
        <option>In Progress</option>
        <option>Incomplete</option>
         </select>
         <button type="submit" >Update</button>
</form>
</div>
  <div class="numberOfAssignments">
    Employee name: number of assignments

<table class="table">
  <thead>
    <tr>
      <th scope="col">employee Id</th>
      <th scope="col">employee name</th>
      <th scope="col">number of requests</th>
      <th scope="col">phone?</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">employee Id</th>
      <td>employee name</td>
      <td>number of assignments</td>
      <td>phone number?</td>
    </tr>
  </tbody>
</table>

  </div>
</div>
</template>

<script>

import maintenanceRequest from '../assets/data/maintenance.json'

export default {
  props: {
    user: Object
  },
  name: 'assign',
  data(){
    return {
      allRequests: maintenanceRequest,
      assignMaintenace: {
        requestId: '',
        unitId: '',
        description: '',
        status: '',
        employeeId: '',
        requestDate: '',
        priorityLevel: '',
        residentName: '',
        role: 'landlord'
      },
      assignmentErrors: true,
    };
  },
   methods: {
      assignment(){
        console.log(JSON.stringify(this.maintenanceRequest));
    //    fetch(this.apiURL, {
    //     method: 'POST',
    //      headers: {'Content-Type': 'maintenanceRequests/json'},
    //      body: JSON.stringify(this.)
    //    })
    //    .then((response) => {
    //      if (response.ok) {
    //        this.assignmentErrors = false
    //        return (response.JSON());
    //      } else {
    //        this.assignmentErrors = true;
    //        throw 'Assignment returned: ' + response.status;
    //      }
    //    })
    //    .catch((err) => console.log(err));
    //  },
   },
  //  assignMaintenaceRequest( employeeId, requestId){
     //this is where I want to call the DAO to assign the requestID to the employee
  // }

 }
 
}
</script>

<style>
.card{
  border: 1px solid black;
}

</style>