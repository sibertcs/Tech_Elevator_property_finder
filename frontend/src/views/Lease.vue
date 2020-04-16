<template>
  <div class="container is-fluid">
    <h1 class="title">Your Lease Details:</h1>
      <b-table
        :data="leasesForUser"
        :columns="columns">
      </b-table>
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
      columns: [
                {
                    field: 'status',
                    label: 'Lease Status',
                    width: '100',
                    searchable: true,
                },
                {
                    field: 'propertyName',
                    label: 'Property Name',
                    width: '100',
                    searchable: true,
                },
                {
                    field: 'propertyAddress',
                    label: 'Address',
                    width: '100',
                    searchable: true,
                },
                {
                    field: 'unitNumber',
                    label: 'Unit #',
                    width: '100',
                    searchable: true,
                },
                {
                    field: 'signedDate',
                    label: 'Signed On',
                    width: '100',
                    searchable: true,
                },
                {
                    field: 'rentAmount',
                    label: 'Rent/Month',
                    width: '100',
                    searchable: true,
                }
            ]
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