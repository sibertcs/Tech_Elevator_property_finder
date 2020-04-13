<template>
  <div>
      <h1>This is the maintenance request page</h1>
     
    <form>
      <p>Unit: {{userUnitNumber}}</p> 
      <label for="details">Details</label>
      <textarea id="details"  rows="3" v-model="maintenanceRequest.requestDesc"></textarea>
      <br>
      <label for="priority">Priority Level</label>
      <select id="priority" v-model="maintenanceRequest.priority">
        <option value="1">Low</option>
        <option value="2">Medium</option>
        <option value="3">High</option>
      </select>
      <button type="submit" v-bind:disabled="!isValidForm" v-on:click="createRequest">Submit Request</button>
    </form>
  </div>
</template>

<script>
import auth from '../auth';


export default {
  props: {
    user: Object
  },
 data (){
   return {
     userUnitNumber: "",
     maintenanceRequest:{
       unitId: "",
      requestUserId: "",
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
     
     },
         getUnitForUser(id) {
      fetch("http://localhost:8080/api/unit/renter/"+id, {
        method: 'GET',
          headers: {
            Authorization: 'Bearer ' + auth.getToken(),
            'Content-Type': 'application/json'
          },
          credentials: 'same-origin'
      })
        .then(response => {
          if(response.ok){
            return response.json();
          }
        })
        .then(responseData => {
          this.maintenanceRequest.requestUserId = responseData[0].unitId;
          this.maintenanceRequest.unitId = responseData[0].unitId;
          this.userUnitNumber = responseData[0].unitNumber;
          console.log(responseData[0].unitId);
        })
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
   },
   created(){
     this.getUnitForUser(this.user.id);
   }
 };
</script>

<style>
</style>