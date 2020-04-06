<template>
  <div class="home">
    <h1>Home</h1>
    <nav>
      <a v-if="true">Renter: Pay Rent</a>
      <a v-if="true">Renter: Request Maintenance</a>
      <a v-if="true">Renter: Lease Info/Updates</a>
      <a v-if="true">Maintenance: View Maintenance Requests</a>
      <a v-if="true">Maintenance: Request Additional Maintenance</a>
      <a v-if="true">Landlord: View Tenants/Rent</a>
      <a v-if="true">Landlord: Assign Renter</a>
      <a v-if="true">Landlord: Assign Maintenance</a>
      <a v-if="true">Landlord: Add/Update Properties</a>
      <a v-if="true">Admin: View Users</a>
    </nav>
    <p>You must be authenticated to see this. You are logged in as {{user.sub}}.</p>
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
