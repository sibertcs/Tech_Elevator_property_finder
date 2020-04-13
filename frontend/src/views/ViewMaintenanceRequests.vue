<template>
<div>
  <h1>This is all the Maintenance Requests</h1>
  <div>Hello {{ user.sub }}</div>
  <div class= "maintenace-request">
<div class="card border-dark mb-3" style="max-width: 18rem;" v-for="request in assignedRequests" :key="request.RequestId">
  <div class="card-header"> request Id: {{ request.requestId}}</div>
  <div class="card-body text-dark">
    <h5 class="card-title">Unit id: {{ request.unitId }}</h5>
    <p class="card-text"> priority level:{{ request.priority }}</p>
    <p class="card-text">{{ request.dateRequested}}</p>
    <p class="card-text">{{ request.requestDesc }}</p>
    <p class="card-text">{{ request.isCompleted }}</p>
  </div>
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
      assignedRequests: []
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
created(){
  this.viewAllRequests();
}
}
</script>

<style>
.card{
  border: 1px solid black;
}

</style>