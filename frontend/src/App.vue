<template>
        <div id="app">
    <div id="nav">
     <b-navbar>
        <template slot="brand">
            <b-navbar-item tag="router-link" :to="{ path: '/' }">
              <!--   <img
                    src="https://raw.githubusercontent.com/buefy/buefy/dev/static/img/buefy-logo.png"
                    alt="Lightweight UI components for Vue.js based on Bulma"
                > -->
            </b-navbar-item>
        </template>
        <template slot="start">
 
  
      
   
            <b-navbar-item href="#">
           <router-link to="/">Home</router-link>

            </b-navbar-item>
            <b-navbar-item href="#">
              About Us
            </b-navbar-item>
            <b-navbar-dropdown label="Options">
                <b-navbar-item href="#">
                    About
                </b-navbar-item>
                <b-navbar-item href="#">
                    Contact
                </b-navbar-item>
            </b-navbar-dropdown>
        </template>

        <template slot="end">
            <b-navbar-item tag="div">
                <div class="buttons">
                    <a class="button is-primary">
                        <strong>Sign up</strong>
                    </a>
                    <a class="button is-light">
                        Log in
                    </a>
                </div>
            </b-navbar-item>
        </template>

    </b-navbar> 
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

<style>
.footer {
background-color: aqua;
}
</style>