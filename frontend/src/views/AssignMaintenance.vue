<template>
<div>

      <div class="tile is-ancestor">
        
  <div class="tile is-4 is-vertical" v-for="request in assignedUncompletedRequests" :key="request.requestId">
    <div class="tile">
    <div class="tile is-parent">
    <article class="tile is-child box">
      <p class="title">Request Id: {{ request.propertyName }}</p>
      <p class="subtitle">Unit id: {{ request.streetAddress }}</p>
      <div class="content">
        <p> unit #: {{ request.unitNumber }} </p>  
        <p>priority level: {{ request.priority }}</p>
        <p v-if="request.priority === 1"> priority level: Low</p>
      <p v-if="request.priority === 2"> priority level: Medium</p>
      <p v-if="request.priority === 3"> priority level: High</p>
        <p>{{ request.dateRequested}}</p>
        <p>{{ request.requestDesc }}</p>
      <form>
      <p>
        <label>Assign Maintenance Employee: </label>
                <select v-model="request.assignedUserId">
        <option v-for="user in allMaintenanceUsers" :key="user.id" :value="user.id">{{ user.firstName }}</option>
         </select>
      <select v-model="request.completed">
        <option value="true">Completed</option>
        <option value="false">Incomplete</option>
         </select>
         <button type="button" @click="editRequest(request)">Update</button>
      </p>
      </form>
      </div>
    </article>
  </div>
  </div>
  </div>
  </div>
   
      <b-table :data="allMaintenanceUsers" :columns="columns">
      </b-table>
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
      assignedUncompletedRequests: [],
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
     columns: [
       {
         field: "id",
         label: "employee Id"
       },
       {
         field: "firstName",
         label: "first name"
       },
       {
         field: "lastName",
         label: "last name"
       },
       {
         field: "numberOfAssignedRequests",
         label: "number of requests"
       },
       {
         field: "phoneNumber",
         label: "Phone #"
       }
     ],
      assignmentErrors: true,
    };
  },
   methods: {
      getAllUncompletedRequests(){
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
          this.assignedUncompletedRequests = responseData;
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
     this.getAllUncompletedRequests();
     this.getAllMaintenanceUsers();
   }

 }
 

</script>

<style>
.is-ancestor{
  flex-wrap: wrap;
}

</style>