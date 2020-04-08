<template>
  <div class="home">
    <h1>Home</h1> 
    <nav>
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
      <router-link :to="{name:'request'}">Maintenance Request</router-link> 
    </nav>
    <p>You are logged in as {{user.sub}} as a {{user.rol}} and has the id of {{user.id}}.</p>
    <button @click="logout">logout</button>
    <br>
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
    logout() {
      this.$emit('user-logout')
      this.$router.push('/login');
    },
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
