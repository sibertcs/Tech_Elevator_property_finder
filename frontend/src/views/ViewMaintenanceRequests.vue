<template>
<div>
  <h1>This is all the Maintenance Requests</h1>
  <div>Hello {{ user.sub }}</div>
  <div class= "maintenace-request">
<div class="card border-dark mb-3" style="max-width: 18rem;">
  <!-- do a v-for to loop through all of the requests -->
  <div class="card-header">Resident Name!!!!</div>
  <div class="card-body text-dark">
    <h5 class="card-title">Unit: Unit number!!!!</h5>
    <p class="card-text">Urgency Level!!! </p>
    <p class="card-text">Request Date: Date!!!</p>
    <p class="card-text">description: description!!!</p>
    <p class="card-text">Status: isCompleted?!!!</p>
  </div>
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
      assignedRequests: maintenanceRequest,
      assignMaintenace: {
        RequestId: '',
        unitId: '',
        description: '',
        status: '',
        employeeId: '',
        requestDate: '',
        priorityLevel: '',
        residentName: '',
        role: 'maintenance'
      }
    };
  },
  methods: {
    
   
  }

}
</script>

<style>

</style>