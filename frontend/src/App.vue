<template>
  <div id="app">
    <div id="nav">
  
      <router-link to="/">Home</router-link>
    </div>
    <router-view :user="user" @user-logout="logout" @user-login="login"/>
  </div>
</template>

<script>
import auth from './auth.js'

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
    },
    login() {
      this.user = auth.getUser();
    }
  }
}
</script>
