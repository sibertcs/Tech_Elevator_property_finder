<template>
  <div>
    <h1>Renters And Status</h1>
    <div>
      <label for="propertyName">Property: </label>
    <select id="propertyName" v-model="selectedPropertyId" @change="getTenantsProperty(selectedPropertyId)">
      <option value="" disabled selected>Select a Property</option>
            <option v-for="prop in allProperties" 
                            :key="prop.propertyId" 
                            :value="prop.propertyId">
                        {{ prop.propertyName }}
                    </option>
    </select>
       <button type="submit" id="property">Submit Request</button>
      <table>
        <tr><label for="propertyName">Property Name</label></tr>
          <td>
            
          </td>
      </table>
      <table>
        <tr><label for="tenants">Current Tenants</label></tr>
        <td v-for="tenant in selectedRenters" :key="tenant.userId">
          {{tenant.firstName}}
        </td>
      </table>
    </div>
  </div>
</template>

<script>
import propertyData from '../assets/data/properties.json'
import unitData from '../assets/data/units.json'
import renterData from '../assets/data/renters.json'
export default {
   props: {
    user: Object
  },
data () {
  return {
            allProperties: propertyData,
            allUnits: unitData,
            allRenters: renterData,
            selectedRenters: [],
            properties: [],
            selectedPropertyId: '',
}
},
 methods: {
        getPropertiesForLandlord(email) {
            this.properties = this.allProperties.filter((prop) => prop.landLordEmail === email);
        },
        getTenantsProperty(id) {
          this.selectedRenters = this.allRenters.filter((tenant) => tenant.propertyId === id);
        } 
 },
   created() {
        this.getPropertiesForLandlord(this.user.sub);
    }
 }
</script>

<style>

</style>