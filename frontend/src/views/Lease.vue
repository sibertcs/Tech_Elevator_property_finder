<template>
  <div>
    <h2>Lease(s)</h2>
    <ul>
      <li v-for="lease in leasesForUser" :key="lease.leaseId">
        {{lease.status}}: Lease #{{lease.leaseId}} for Unit #{{getUnitByLease(lease).unitNumber}} was signed on {{lease.signedDate}} and the rent was ${{lease.rentAmount}}/month.
      </li>
    </ul>
  </div>
</template>

<script>
import auth from '../auth';

export default {
  props: {
    user: Object
  },
  data() {
    return {
      leasesForUser: [],
      unitsForUser: []
    }
  },
  methods: {
    getLeaseForUser(id) {
      fetch("http://localhost:8080/api/leases/renter/"+id, {
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
          this.leasesForUser = responseData;
        })
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
          this.unitsForUser = responseData;
        })
    },
    getUnitByLease(lease) {
      return this.unitsForUser.find(unit => unit.unitId === lease.unitId);
    }
  },
  created() {
    this.getLeaseForUser(this.user.id);
    this.getUnitForUser(this.user.id);
  }
}
</script>

<style>

</style>