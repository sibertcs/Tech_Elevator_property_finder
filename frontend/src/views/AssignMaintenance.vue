<template>
<div>

  <div>Hello {{ user.sub }}</div>

      <div class="tile is-ancestor">
        
  <div class="tile is-4 is-vertical" v-for="request in allRequests" :key="request.requestId">
    <div class="tile">
    <div class="tile is-parent">
    <article class="tile is-child box">
      <p class="title">Request Id: {{ request.requestId }}</p>
      <p class="subtitle">Unit id: {{ request.unitId }}</p>
      <div class="content">
      <p>{{ request.priority }}</p>
      <p>{{ request.dateRequested}}</p>
      <p>{{ request.requestDesc }}</p>
      <p>{{ request.completed }}</p>
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
          this.assignToast();
          console.log('Updated');
        })
        
      },
       assignToast(){
      this.$buefy.toast.open({
        message: 'Maintenance Request Updated',
        type: 'is-success'})
     }
   },
   created(){
     this.getAllRequests();
     this.getAllMaintenanceUsers();
   }

 }
 

</script>

<style>
.is-ancestor{
  flex-wrap: wrap;
}

</style>