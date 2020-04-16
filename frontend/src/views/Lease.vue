<template>
  <div class="container is-fluid">
    <h2 class="title">Lease(s)</h2>
    <ul>
      <li v-for="lease in leasesForUser" :key="lease.leaseId">
        <p>{{lease.propertyName}} @ {{lease.propertyAddress}}</p>
        <p>Unit # {{lease.unitNumber}}</p>
        <p>{{lease.status}}: Lease #{{lease.leaseId}} was signed on {{lease.signedDate}} and the rent was ${{lease.rentAmount}}/month.</p>
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
      leasesForUser: []
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
    }
  },
  created() {
    this.getLeaseForUser(this.user.id);
  }
}

</script>

<style>

</style>