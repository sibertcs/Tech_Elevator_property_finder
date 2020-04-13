<template>
<div>
  <h1>this is the page to assign maintenance</h1>
  <div>Hello {{ user.sub }}</div>
  <div class= "maintenance-request-assignment">
      <div class="alert alert-success" role="alert" v-if="this.$route.query.assignment">
        This request has been successfully assigned.
      </div> 
  
<div class="card border-dark mb-3" style="max-width: 18rem;" v-for="request in allRequests" :key="request.unitId">
  <div class="card-header">Request Id: {{ request.requestId }}</div>
  <div class="card-body text-dark">
    <h5 class="card-title">Unit id: {{ request.unitId }}</h5>
    <p class="card-text">{{ request.priority }} </p>
    <p class="card-text">{{ request.dateRequested}}</p>
    <p class="card-text">{{ request.requestDesc }}</p>
    <p class="card-text">{{ request.isCompleted }}</p>
  </div>

<form>
<label>Assign Maintenance Employee: </label>
        <select v-for="user in allMaintenanceUsers" :key="user.id">
        <option>{{ user.firstName}} {{ user.lastName}} </option>
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

import auth from '../auth';

export default {
  props: {
    user: Object
  },
  name: 'assign',
  data(){
    return {
      allRequests: [],
      allMaintenanceUsers: [],
      assignMaintenace: {
        requestId: '',
        unitId: '',
        requestUserId: '',
        requestDesc: '',
        isCompleted: '',
        assignedUserId: '',
        dateRequested: '',
        priority: '',
        role: 'landlord'
      },
      assignmentErrors: true,
    };
  },
   methods: {
      getAllRequests(){
        fetch('http://localhost:8080/api/Landlord/assignMaintenance', {
          method: 'GET',
          headers: {
            Authorization: 'Bearer ' + auth.getToken()
          },
          credentials: 'same-origin'
        })
        .then(response => {
          if(response.ok){
            return response.json();
          }
        }).then(responseData => {
          this.allRequests = responseData;
        })
        .catch(err => console.error(err));
      }
   },
   getAllMaintenanceUsers(){
     fetch('http://localhost:8080/api/users/maintenance', {
       method: 'GET',
       headers: {
          Authorization: 'Bearer ' + auth.getToken()
       },
       credentials: 'same-origin'
     })
     .then(response => {
          if(response.ok){
            return response.json();
   }
     }).then(responseData => {
       this.allMaintenanceUsers =responseData;
     })
     .catch(err => console.error(err));
   },
  //   assignMaintenaceRequest( employeeId, requestId){
     
  //  },
   created(){
     this.getAllRequests();
   }

 }
 

</script>

<style>
.card{
  border: 1px solid black;
}

</style>