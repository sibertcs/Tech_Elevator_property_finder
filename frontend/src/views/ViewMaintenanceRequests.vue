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
    <p> priority level:{{ request.priority }}</p>
    <p>{{ request.dateRequested}}</p>
    <p>{{ request.requestDesc }}</p>
    <p>{{ request.completed }}</p>
  
<form>
      <label for="priority"> Change Priority Level </label>
      <select id="priority" v-model="request.priority">
        <option value="1">Low</option>
        <option value="2">Medium</option>
        <option value="3">High</option>
      </select>
  <label> Change Status </label>
     <select v-model="request.completed">
        <option value="true">Completed</option>
        <option value="false">Incomplete</option>
         </select>
      <button type="button" @click="editRequestStatus(request)">Submit</button>
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
       completed: ''
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
       this.currentRequest.completed = maintenanceRequest.completed;

     }
   });
 },
 editRequestStatus(request){
   request.completed = request.completed === "true";
   fetch('http://localhost:8080/api/maintenance/requests', {
     method: 'PUT',
     headers: {
       Authorization: 'Bearer' + auth.getToken(),
       'Content-Type': 'application/json'
     },
     credentials: 'same-origin',
     body: JSON.stringify(request)
   })
   .then(() => {
       console.log('Updated');
     })
   },
 resetCompleteValue(){
  this.currentRequest.requestId = ''
     this.currentRequest.unitId = '';
       this.currentRequest.requestUserId = '';
       this.currentRequest.requestDesc = '';
       this.currentRequest.priority = '';
       this.currentRequest.dateRequested = '';
       this.currentRequest.assignedUserId = '';
       this.currentRequest.completed = true;

       this.viewAllRequests();
   },

created(){
  this.viewAllRequests();
}
}
</script>

<style>



</style>