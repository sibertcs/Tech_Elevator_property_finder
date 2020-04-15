<template>
  <div class="home container is-fluid">
    <h1 class="title">Browse Properties</h1> 
  <!--   <nav>
      <div v-if="user.rol=== 'renter' || user.rol==='admin'">
        <router-link to="/payment">Payment</router-link>
        <br>
        <router-link to="/lease">Lease Info</router-link>
      </div>
      <div v-if="user.rol=== 'maintenance' || user.rol==='admin'">
        <router-link :to="{name:'view'}">View Maintenance Requests</router-link>
      </div>
      <div v-if="user.rol=== 'landlord' || user.rol==='admin'">
        <router-link :to="{name: 'tenants'}">View Tenants/Landlord</router-link>
        <br>
        <router-link :to="{name: 'addOrUpdateLease'}"> Add/Update Lease</router-link>
        <br>
        <router-link :to="{name: 'assignMaintenance'}"> Assign Maintenance</router-link>
        <br>
        <router-link :to="{name: 'addOrUpdate'}"> Add/Update Properties</router-link>
      </div>
      <div v-if="user.rol=== 'admin'">
        <router-link :to="{name: 'viewUsers'}"> View Users</router-link>
      </div> 
      <router-link v-if="user.rol=== 'renter'" :to="{name:'request'}">Maintenance Request</router-link> 
    </nav> -->
    <browse-properties/>
  </div>
</template>

<script>
import BrowseProperties from '../components/BrowseProperties';

export default {
  name: 'home',
  props: {
    user: Object
  },
  components: {
    BrowseProperties
  },
  data() {
    return {
    }
  },
  methods: {
    allProps() {
      return fetch('http://localhost:8080/api/properties')
        .then((response) => {
          if(response.ok) {
            console.log(JSON.stringify(response));
          }
        });
    }
  }
}
</script>
