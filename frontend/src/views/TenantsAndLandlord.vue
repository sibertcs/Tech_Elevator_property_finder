<template>
  <div>
    <h1>Renters And Status</h1>
    <div>
      <label for="propertyName">Property: </label>
    <select id="propertyName" v-model="selectedPropertyId">
      <option value="" disabled selected>Select a Property</option>
            <option v-for="prop in properties" 
                            :key="prop.propertyId" 
                            :value="prop.propertyId">
                        {{ prop.propertyName }}
                    </option>
    </select>
      <table>
        <tr><label for="propertyName">Property Name</label></tr>
          <td>
            
          </td>
      </table>
      <table>
        <tr><label for="tenants">Current Tenants</label></tr>
        <td v-for="tenant in getTenantsProperty()" :key="tenant.userId">
          {{tenant.firstName}}
        </td>
        <tr>
          <td class = "" v-for="tenant in getTenantsProperty()" :key="tenant.userId">{{tenant.rentStatus}}</td> 
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import propertyData from '../assets/data/properties.json'
import unitData from '../assets/data/units.json'
import renterData from '../assets/data/renters.json'
import auth from '../auth';
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
        getPropertiesForLandlord() {
            fetch('http://localhost:8080/api/properties/landlord/' + this.user.id, {
        method: 'GET',
        headers: {
          Authorization: 'Bearer ' + auth.getToken()
        },
        credentials: 'same-origin'
      })
      .then (response => {
              if(response.ok) {
                  return response.json();
              }
          }).then(responseData => {
              this.properties = responseData;
          });
        },
    //this.allRenters.filter((tenant) => tenant.propertyId === this.selectedPropertyId);
        // getTenantsProperty() {
        //   return fetch('http://localhost8080/api/lease')
        // }
 },
   created() {
        this.getPropertiesForLandlord(this.user.sub);
    }
 }
</script>

<style>

</style>