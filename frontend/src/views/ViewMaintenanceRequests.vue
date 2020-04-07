<template>
<div>
  <h1>This is all the Maintenance Requests</h1>
  <div class= "maintenace-request">
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
        <td>Assigned to: </td>
        <td>Maintenance Name!!! </td>
      </tr> 
      <tr>
        <td>Status: </td>
        <td>isCompleted?!!! </td>
      </tr> 
       <form>
      <buttton type="submit">Change status to</buttton>
      </form>
    </table>  
    
  </div>  
</div>
</template>

<script>
export default {
   name: 'view',
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