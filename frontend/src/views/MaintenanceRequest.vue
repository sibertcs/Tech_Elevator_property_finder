<template>
  <div>
      <h1>This is the maintenance request page</h1>
     
    <form>
      <input type="hidden" id="unitId" name="unitId" value="unitId !!!"/>
      <label for="unit">Select Your Unit Number </label>
        <select id="unit" v-model="maintenanceRequest.unitId">
        <option>Unit 1!!! </option>
        <option>Unit 2!!! </option>
        <option>Unit 3!!! </option>
         </select>
      <label for="details">Details</label>
      <textarea id="details"  rows="3" v-model="maintenanceRequest.requestDesc"></textarea>
      <br>
      <label for="priority">Priority Level</label>
      <select id="priority" v-model="maintenanceRequest.priority">
        <option>Low</option>
        <option>Medium</option>
        <option>High</option>
      </select>
      <button type="submit" v-bind:disabled="!isValidForm" v-on:click="createRequest">Submit Request  </button>
    </form>
  </div>
</template>

<script>
export default {
 data (){
   return {
     maintenanceRequest:{
       unitId: "",
       requestDesc: "",
       priority: "",
       requestUserId: "userId !!!",

     }
     };
   },
   methods: {
     createRequest(){
       console.log('We need a post method to API here to create a maintenance request.');
  /*      fetch(this.apiURL,{
         method: 'POST',
         headers: {
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
     */
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