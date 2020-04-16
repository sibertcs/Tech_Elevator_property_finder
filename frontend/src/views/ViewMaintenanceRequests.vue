<template>
<div>
  <h1>This is all the Uncompleted Maintenance Requests</h1>
  <div class="tile is-ancestor">
<div class="tile is-4 is-vertical" v-for="request in assignedUncompletedRequests" :key="request.RequestId">
  <div class="tile">
    <div class="tile is-parent">
      <article class="tile is-child box">
    <p class="title">{{ request.propertyName}}</p>
    <p class="subtitle">Address: {{ request.streetAddress }} {{ request.city }} {{  request.state }} {{ request.zipCode }}</p>
    <div class="content">
      <p> unit #: {{ request.unitNumber }} </p>
      <p v-if="request.priority === 1"> priority level: Low</p>
      <p v-if="request.priority === 2"> priority level: Medium</p>
      <p v-if="request.priority === 3"> priority level: High</p>
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
            <br>
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
    <b-table :data="assignedCompletedRequests" :columns="columns">
    </b-table>  
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
      assignedUncompletedRequests: [],
      assignedCompletedRequests: [],
      columns: [
        {
          field: "requestId",
          label: "request id"
        },
        {
          field: "unitId",
          label: "unit id"
        },
        {
          field: "priority",
          label: "priority"
        },
        {
          field: "dateRequested",
          label: "date requested"
        }
      ]
    }
  },

methods: {
  viewAllCompletedRequests(){
    fetch('http://localhost:8080/api/maintenance/completed/' + this.user.id, {
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
      this.assignedCompletedRequests = responseData;
      
    })
    .catch(err => console.error(err));
  },

 viewAllUncompletedRequests(){
    fetch('http://localhost:8080/api/maintenance/uncompleted/' + this.user.id, {
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
      this.assignedUncompletedRequests = responseData;
      
    })
    .catch(err => console.error(err));
  },
 editRequestStatus(request){
   request.completed = request.completed === "true";
   fetch('http://localhost:8080/api/maintenance/requests', {
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
       this.viewAllCompletedRequests();
       this.viewAllUncompletedRequests();
     })
   }
   },
created(){
  this.viewAllCompletedRequests();
  this.viewAllUncompletedRequests();
}
}
</script>

<style>



</style>