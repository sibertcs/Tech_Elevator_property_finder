<template>
<div>
  <h1>This is all the Maintenance Requests</h1>
  <div>Hello {{ user.sub }}</div>
  <div class= "maintenace-request">
<div class="card border-dark mb-3" style="max-width: 18rem;" v-for="request in requests" :key="request.unitId">
  <div class="card-header"> {{ request.residentName}}</div>
  <div class="card-body text-dark">
    <h5 class="card-title">Unit id: {{ request.unitId }}</h5>
    <p class="card-text">{{ request.priorityLevel }}</p>
    <p class="card-text">{{ request.requestDate}}</p>
    <p class="card-text">{{ request.description }}</p>
    <p class="card-text">{{ request.status }}</p>
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

import maintenanceRequest from '../assets/data/maintenance.json'

export default {
  props: {
    user: Object
  },
   name: 'view',
  data(){
    return {
      requests: maintenanceRequest,
      assignedProperties: [],
      selectedEmployeeId: '',
      viewMaintenace: {
        RequestId: '',
        unitId: '',
        description: '',
        status: '',
        requestDate: '',
        priorityLevel: '',
        residentName: '',
        role: 'maintenance'
      }
    }
  },

methods: {
  getMaintenanceRequestsForEmployee(employeeId){
    this.assignedProperties = this.requests.filter((req) => req.employeeId === employeeId)
  }
},
created(){
  this.getMaintenanceRequestsForEmployee(this.user.employeeId)
}
}
</script>

<style>
.card{
  border: 1px solid black;
}

</style>