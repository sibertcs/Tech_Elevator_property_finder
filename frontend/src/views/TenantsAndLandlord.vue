<template>
  <div>
    <h1>Renters And Status</h1>
    <div>
      <label for="propertyName">Property: </label>
    <select id="propertyName" v-model="selectedPropertyName">
      <option value="" disabled selected>Select a Property</option>
            <option v-for="propName in getUniquePropNames()" 
                            :key="propName" 
                            :value="propName">
                        {{propName}}
                    </option>
    </select>
      <table>
        <tr></tr>
          <td>
            
          </td>
      </table>
      <table>
        <tr>
          <th>Name</th>
          <th>Unit</th>
          <th>Rent Status</th>
          <th>Overdue Balance</th>
        </tr>
        <tr v-for="lease in getLeasesByProperty()" :key="lease.leaseId">
        <td>{{lease.renterName}}</td>
        <td>{{lease.unitNumber}}</td>
        <td>{{lease.currentRentStatus}}</td>
        <td>{{lease.overdueBalance}}</td>
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
            leases: [],
            selectedLeases: [],
            selectedPropertyName: '',
}
},
 methods: {
        getLeasesForLandlord() {
            fetch('http://localhost:8080/api/leases/landlord/' + this.user.id, {
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
              this.leases = responseData;
            });
        },
        getUniquePropNames() {
          let uniqueNames = [];
          this.leases.forEach(lease => {
            if(!uniqueNames.includes(lease.propertyName)){
              uniqueNames.push(lease.propertyName);
            }
          });
          return uniqueNames;
        },
        getLeasesByProperty() {
          return this.leases.filter(lease => {
            return lease.propertyName === this.selectedPropertyName; 
          })
        }
 },
   created() {
        this.getLeasesForLandlord(this.user.sub);
    }
 }
</script>

<style>

</style>