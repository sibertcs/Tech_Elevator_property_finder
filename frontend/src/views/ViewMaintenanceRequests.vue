<template>
<div>
  <h1>This is all the Maintenance Requests</h1>
  <div>Hello {{ user.sub }}</div>
  <div class="tile is-ancestor">
<div class="tile is-4 is-vertical" v-for="request in assignedRequests" :key="request.RequestId">
  <div class="tile">
    <div class="tile is-parent">
      <article class="tile is-child box">
    <p class="title"> request Id: {{ request.requestId}}</p>
    <p class="subtitle">Unit id: {{ request.unitId }}</p>
    <div class="content">
    <p class=""> priority level:{{ request.priority }}</p>
    <p class="">{{ request.dateRequested}}</p>
    <p class="">{{ request.requestDesc }}</p>
    <p class="">{{ request.isCompleted }}</p>
  
<form>
      <label for="priority"> Change Priority Level </label>
      <select id="priority" v-model="currentRequest.priority">
        <option value="1">Low</option>
        <option value="2">Medium</option>
        <option value="3">High</option>
      </select>
  <label> Change Status </label>
     <select v-model="currentRequest.isCompleted">
        <option value="true">Completed</option>
        <option value="false">Incomplete</option>
         </select>
      <button type="button" @click="editRequestStatus">Submit</button>
      </form>
      </div>
      </article>
</div>
  </div>
</div>
  </div>  
</div>
</template>

<script>

import auth from '../auth';

export default {
  props: {
    user: Object
  },
  data(){
    return {
      assignedRequests: [],
       currentRequest: {
       requestId: '',
       unitId: '',
       requestUserId: '',
       requestDesc: '',
       priority: '',
       dateRequested: '',
       assignedUserId: '',
       isCompleted: ''
     }
    }
  },

methods: {
  viewAllRequests(){
    fetch('http://localhost:8080/api/maintenance/' + this.user.id, {
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
      this.assignedRequests = responseData;
      
    })
    .catch(err => console.error(err));
  }
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
 editRequestStatus(){
   console.log(JSON.stringify(this.currentRequest));
   fetch('http://localhost:8080/api//Landlord/assignMaintenance', {
     method: 'PUT',
     headers: {
       Authorization: 'Bearer' + auth.getToken(),
       'Content-Type': 'application/json'
     },
     credentials: 'same-origin',
     body: JSON.stringify(this.currentRequest)
   }).then(response => {
     if(response.ok){
       this.resetCompleteValue();
     }
   }).then(this.viewAllRequests())
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
       this.currentRequest.isCompleted = true;

       this.viewAllRequests();
   },

created(){
  this.viewAllRequests();
}
}
</script>

<style>



</style>