<template>
  <div>
      <h1>This is the maintenance request page</h1>
     
    <form>
      <p>Unit: {{user.unitId}}</p>
  <!--    <label for="unit">Select Your Unit Number </label>
        <select id="unit" v-model="maintenanceRequest.unitId">
          <option value="" disabled selected>Select a Unit Number</option>
         <option v-for="unit in allUnits"
                  :key="unit.unitId"
                  :value="unit.unitId">
                  {{unit.unitNumber}}
        </option>
         </select> -->
      <label for="details">Details</label>
      <textarea id="details"  rows="3" v-model="maintenanceRequest.requestDesc"></textarea>
      <br>
      <label for="priority">Priority Level</label>
      <select id="priority" v-model="maintenanceRequest.priority">
        <option value="1">Low</option>
        <option value="2">Medium</option>
        <option value="3">High</option>
      </select>
      <button type="submit" v-bind:disabled="!isValidForm" v-on:click="createRequest">Submit Request  </button>
    </form>
  </div>
</template>

<script>
import unitData from '../assets/data/units.json'
import auth from '../auth';


export default {
  props: {
    user: Object
  },
 data (){
   return {
     allUnits: unitData,
     maintenanceRequest:{
       unitId: 8,
      requestUserId: 5,     //  this.user.id should be used. Need another method when unit API methods are made.
       requestDesc: "",
       priority: ""
    

     }
     };
   },
   methods: {
     createRequest(){
       console.log('starting post method...');
        fetch('http://localhost:8080/api/maintenance/request',{
         method: 'POST',
        headers: {
            Authorization: 'Bearer ' + auth.getToken(),
            'Content-Type': 'application/json'
          },
         body: JSON.stringify(this.maintenanceRequest)
       })
        .then(response => {
          if (response.ok) {
           console.log('maint request post method worked...YEEHAWW!');
          }
        })
        .catch(err => console.error(err));
     
     }
   },
   computed: {
    
     isValidForm(){
       return (
       this.maintenanceRequest.unitId != "" &&
       this.maintenanceRequest.requestDescription != "" &&
       this.maintenanceRequest.priority != "" 
       );
     }
   }
 };
</script>

<style>
</style>