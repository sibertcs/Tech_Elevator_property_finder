<template>
  <div class="home">
    <h1>Home</h1>
    <nav>
      <div v-if="user.rol=== 'renter' || user.rol==='admin'">
      <router-link to="/payment">Payment</router-link>
      <br>
      <router-link to="/lease">Lease Info</router-link>
      </div>
      <router-link :to="{name:'request'}">Maintenance Request</router-link>

      <div v-if="user.rol=== 'maintenance' || user.rol==='admin'">
      <router-link :to="{name:'view'}">View Maintenance Requests</router-link>
      </div>
      <div v-if="user.rol=== 'landlord' || user.rol==='admin'">
      <router-link :to="{name: 'tenants'}">View Tenants/Landlord</router-link>
       <router-link :to="{name: 'createLease'}"> Create Lease</router-link>
       <router-link :to="{name: 'assignMaintenance'}"> Assign Maintenance</router-link>
       <router-link :to="{name: 'addOrUpdate'}"> Add/Update Properties</router-link>
      </div>
        <div v-if="user.rol=== 'admin'">
      <router-link :to="{name: 'viewUsers'}"> View Users</router-link>
        </div>  
    </nav>
    <p>You must be authenticated to see this. You are logged in as {{user.sub}} as a {{user.rol}}.</p>
    <button @click="logout">logout</button>
  </div>
</template>

<script>
import auth from '@/auth.js'

export default {
  name: 'home',
  data() {
    return {
      user: auth.getUser()
    }
  },
  methods: {
    logout() {
      auth.logout();
      this.$router.push('/login');
    }
  }
}
</script>
