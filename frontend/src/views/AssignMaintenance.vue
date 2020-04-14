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
    <p class="card-text">{{ request.completed }}</p>

  </div>

<form>
<label>Assign Maintenance Employee: </label>
        <select v-model="request.assignedUserId">
        <option v-for="user in allMaintenanceUsers" :key="user.id" :value="user.id">{{ user.firstName }}</option>
         </select>

  <label> Change Status </label>
      <select v-model="request.completed">
        <option value="true">Completed</option>
        <option value="false">Incomplete</option>
         </select>
         <button type="button" @click="editRequest(request)">Update</button>
</form>
</div>
</div>
  <div class="numberOfAssignments">
    Employee name: number of assignments

<table class="table">
  <thead>
    <tr>
      <th scope="col">employee Id</th>
      <th>first name</th>
      <th>last name</th>
      <th scope="col">number of requests</th>
      <th scope="col">phone #</th>
    </tr>
  </thead>
  <tbody>
    <tr v-for="user in allMaintenanceUsers" :key="user.id">
      <th scope="row">{{ user.id }}</th>
      <td>{{ user.firstName }}</td>
      <td>{{ user.lastName}}
      <td>{{ user.numberOfAssignedRequests }}</td>
      <td>{{ user.phoneNumber }}</td>
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
       completed: ''
      },
      maintenanceRequest:{
       assignedUserId: '',
       completed: ''
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
        this.currentRequest.completed = maintenanceRequest.completed;

    }
  });
},
      editRequest(request) {
         request.completed = request.completed === "true";
        fetch('http://localhost:8080/api/Landlord/assignMaintenance', {
          method: 'PUT',
          headers: {
            Authorization: 'Bearer ' + auth.getToken(),
            'Content-Type': 'application/json'
          },
          credentials: 'same-origin',
          body: JSON.stringify(request)
        })
        .then(() => {
          console.log('Updated');
        })
        
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