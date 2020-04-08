<template>
  <div>
    <h1>Renters And Status</h1>
    <div>
      <label for="property">Property: </label>
        <select>
            <option :value="1"> Sample property 1 </option>
            <option :value="2"> Sample property 2 </option>
            <option :value="3"> Sample property 3 </option>
            <option :value="4"> Sample property 4 </option>
        </select>
        <form>
       <button type="submit" id="property">Submit Request</button>
     </form>
      <table>
        <tr><label for="propertyName">Property Name</label></tr>
          <td>
            
          </td>
      </table>
      <table>
        <tr><label for="tenants">Current Tenants</label></tr>
        <td>
          <v-for></v-for>
        </td>
      </table>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style>

</style>