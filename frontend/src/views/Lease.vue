<template>
  <div>
    <h1>Hello {{user.id}}</h1>
    <h1>LeaseId: {{leaseForUser.leaseId}}</h1>
    <h1>Monthly rent: {{leaseForUser.rentAmount}}</h1>
  </div>
</template>

<script>
export default {
  props: {
    user: Object
  },
  data() {
    return {
      leaseForUser: []
    }
  },
  methods: {
    getLeaseForUser(id) {
      fetch("http://localhost:8080/api/leases/landlord/"+id)
        .then(response => {
          if(response.ok){
            return response.json();
          }
        })
        .then(responseData => {
          this.leaseForUser = responseData;
        })
    }
  },
  created() {
    this.getLeaseForUser(this.user.id);
    //Get Unit for Lease
  }
}
</script>

<style>

</style>