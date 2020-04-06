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
      <a>Maintenance: View Maintenance Requests</a>
      </div>
      <div v-if="user.rol=== 'landlord' || user.rol==='admin'">
      <a>Landlord: View Tenants/Rent</a>
       <a>Landlord: Assign Renter</a>
       <a>Landlord: Assign Maintenance</a>
       <a>Landlord: Add/Update Properties</a>
      </div>
        <div v-if="user.rol=== 'admin'">
      <a>Admin: View Users</a>
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
