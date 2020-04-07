<template>
<div>
  <h1>this is the page to assign maintenance</h1>
  <div class= "maintenance-request-assignment">
    <form class= "assign-request">
    <table>
      <tr>
        <td>Requesting Resident: </td>
        <td> Resident Name!!!! </td>
      </tr> 
      <tr>
        <td>Unit: </td>
        <td>Unit number!!!! </td>
      </tr>  
      <tr>
        <td>Priority Level: </td>
        <td>Urgency Level!!! </td>
      </tr> 
       <tr>
        <td>Request Date: </td>
        <td>Date!!! </td>
      </tr> 
      <tr>
        <td>description: </td>
        <td>description!!! </td>
      </tr> 
      <tr>
        <td>Assigned to: </td>
        <td>Maintenance Name!!! </td>
      </tr> 
      <tr>
        <td>Status: </td>
        <td>isCompleted?!!! </td>
      </tr>
      </table>   
      
        <label>Assign Maintenance Employee: </label>
        <select>
        <option>Employee 1!!! </option>
        <option>Employee 2!!! </option>
        <option>Employee 3!!! </option>
         </select>
         <button type="submit">Assign</button>
      </form>
      <div class="alert alert-success" role="alert" v-if="this.$route.query.assignment">
        This request has been successfully assigned.
      </div>
    
  </div>  
  <div class="numberOfAssignments" >
    Employee name: number of assignments
  </div>
</div>
</template>

<script>
export default {
  name: 'assign',
  data(){
    return {
      assignMaintenace: {
        RequestId: '',
        unitId: '',
        description: '',
        status: '',
        employeeId: '',
        requestDate: '',
        priorityLevel: '',
        residentName: '',
        role: 'landlord'
      },
      assignmentErrors: false,
    };
  },
   methods: {
     assignment(){
       fetch('${process.env.VUE_APP_REMOTE_API}/assignMaintenance', {
        method: 'POST',
         headers: {
          Accept: ''
         },
         body: JSON.stringify(this.maintenanceRequest),
       })
       .then((response) => {
         if (response.ok) {
           return (response.JSON());
         } else {
           this.assignmentErrors = true;
           throw 'Assignment returned: ' + response.status;
         }
       }) 
       .then ((parsedData) => {
         if (parsedData.success) {
           this.$router.push({ path: '/AssignMaintenance', query: { registration: 'success'} });
         } else {
           this.assignmentErrors = true;
         }
       })
       .catch((err) => console.log(err));
     },
   },

 };
</script>

<style>

</style>