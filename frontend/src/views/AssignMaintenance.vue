<template>
<div>
  <h1>this is the page to assign maintenance</h1>
  <div>Hello {{ user.sub }}</div>
  <div class= "maintenance-request-assignment">
      <div class="alert alert-success" role="alert" v-if="this.$route.query.assignment">
        This request has been successfully assigned.
      </div> 
  
<div class="card border-dark mb-3" style="max-width: 18rem;" v-for="request in allRequests" :key="request.requestId">
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
        <select v-model="maintenanceRequest.assignedUserId">
        <option v-for="user in allMaintenanceUsers" :key="user.id" :value="user.id">{{ user.firstName }}</option>
         </select>

  <label> Change Status </label>
      <select v-model="maintenanceRequest.isCompleted">
        <option value="true">Completed</option>
        <option value="false">Incomplete</option>
         </select>
         <button type="submit" @click="editRequest">Update</button>
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
      currentRequest: {
       requestId: '',
       unitId: '',
       requestUserId: '',
       requestDesc: '',
       priority: '',
       dateRequested: '',
       assignedUserId: '',
       isCompleted: ''
      },
      maintenanceRequest:{
       isCompleted: "",
       assignedUserId: "",
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
       this.allMaintenanceUsers = responseData;
     })
     .catch(err => console.error(err));
   },
   getCurrentRequest(){
     this.assignedRequests.forEach((maintenanceRequest) =>{
     if (maintenanceRequest.requestId == this.currentRequest.requestId){
       this.currentRequest.requestId = maintenanceRequest.requestId;
       this.currentRequest.unitId = maintenanceRequest.unitId;
       this.currentRequest.requestUserId = maintenanceRequest.requestUserId;
       this.currentRequest.requestDesc = maintenanceRequest.requestDesc;
       this.currentRequest.priority = maintenanceRequest.priority;
      this.currentRequest.dateRequested = maintenanceRequest.dateRequested;
       this.currentRequest.assignedUserId = maintenanceRequest.assignedUserId;
       this.currentRequest.isCompleted = maintenanceRequest.isCompleted;

   }
  });
},
      editRequest() {
        fetch('http://localhost:8080/api/Landlord/assignMaintenance' + this.currentRequest.requestId, {
          method: 'PUT',
          headers: {
            Authorization: 'Bearer ' + auth.getToken()
          },
          credentials: 'same-origin',
          body: JSON.stringify(this.currentRequest)
        }).then(response => {
          console.log(this.maintenanceRequest.isCompleted);
          if(response.ok){
            this.resetCompleteValue();
          }
        }).then(this.getAllRequests())
        .catch(err => console.error(err));
        
      },
      resetCompleteValue(){
  this.currentRequest.requestId = ''
     this.currentRequest.unitId = '';
       this.currentRequest.requestUserId = '';
       this.currentRequest.requestDesc = '';
       this.currentRequest.priority = '';
       this.currentRequest.dateRequested = '';
       this.currentRequest.assignedUserId = '';
       this.currentRequest.isCompleted = '';

       this.viewAllRequests();
   }
   },
   created(){
     this.getAllRequests();
     this.getAllMaintenanceUsers();
   }

 }
 

</script>

<style>
.card{
  border: 1px solid black;
}

</style>