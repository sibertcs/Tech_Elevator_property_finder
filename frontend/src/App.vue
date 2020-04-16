<template>
  <div id="app">
    <div id="nav">
      <b-navbar fixed-top navbar-breakpoint="700px">
        <template slot="brand">
          <b-navbar-item tag="router-link" :to="{ path: '/' }">
     <img
                    src="@/assets/images/adobe-logo.png"
                    alt="Lightweight UI components for Vue.js based on Bulma"
            >
          </b-navbar-item>
        </template>
        <template slot="start">
          <b-navbar-item href="#">
            <router-link to="/">Home</router-link>
          </b-navbar-item>

          <b-navbar-item href="#">About Us</b-navbar-item>
          <div class=navDiv v-if="loggedIn">
            <b-navbar-dropdown :label="`${roleName} Menu`" v-if="user != undefined">
              <div v-if="user != undefined && (user.rol=== 'renter' || user.rol==='admin')">
                <b-navbar-item href="#">
                  <router-link to="/payment">Payment</router-link>
                </b-navbar-item>
                <b-navbar-item>
                  <router-link to="/lease">Lease Info</router-link>
                </b-navbar-item>
                <b-navbar-item>
                  <router-link :to="{name:'request'}">Maintenance Request</router-link>
                </b-navbar-item>
              </div>

              <div v-if="user != undefined && (user.rol=== 'landlord' || user.rol==='admin')">
                <b-navbar-item href="#">
                  <router-link :to="{name: 'tenants'}">View Tenants/Landlord</router-link>
                </b-navbar-item>
                <b-navbar-item href="#">
                  <router-link :to="{name: 'addOrUpdateLease'}">Add/Update Lease</router-link>
                </b-navbar-item>
                <b-navbar-item href="#">
                  <router-link :to="{name: 'assignMaintenance'}">Assign Maintenance</router-link>
                </b-navbar-item>
                <b-navbar-item href="#">
                  <router-link :to="{name: 'addOrUpdate'}">Add/Update Properties</router-link>
                </b-navbar-item>
              </div>
              <div v-if="user.rol=== 'maintenance' || user.rol==='admin'">
              <b-navbar-item href="#">
                <router-link :to="{name:'view'}">View Maintenance Requests</router-link>
              </b-navbar-item>
      </div>
              <div v-if="user != undefined && user.rol === 'admin'">
                <b-navbar-item href="#">
                  <router-link :to="{name: 'viewUsers'}">View Users</router-link>
                </b-navbar-item>
              </div>
            </b-navbar-dropdown>
          </div>
        </template>

        <template slot="end">
          <b-navbar-item tag="div">
            <div class="buttons">
              <router-link v-if="!loggedIn" to="/register">
                <a class="button is-primary">
                  <strong>Sign up</strong>
                </a>
              </router-link>
              <router-link v-if="!loggedIn" to="/login">
                <a class="button is-light">Log in</a>
              </router-link>
              <div id="hello" v-if="loggedIn" to="/login">Hello, {{ user.fnm }}! </div>
              <router-link v-if="loggedIn" to="/login">
                <a @click="logout" class="button is-primary">Log Out</a>
              </router-link>
            </div>
          </b-navbar-item>
        </template>
      </b-navbar>
    </div>
    <div id="loginForm">
      <router-view :user="user" @user-logout="logout" @user-login="login" />
    </div>
  </div>
  
</template>

<script>
import auth from "./auth.js";

export default {
  name: "home",
  data() {
    return {
      user: auth.getUser(),
      loggedIn: auth.getUser() != null,
      roleName: ''
    };
  },
  methods: {
    logout() {
      auth.logout();
      this.loggedIn = false;
    },
    login() {
      this.loggedIn = true;
      this.user = auth.getUser();
      this.refreshRoleName();
    },
    refreshRoleName() {
        this.roleName = this.user.rol.charAt(0).toUpperCase().concat(this.user.rol.substring(1));
    }
  },
  created() {
      this.refreshRoleName();
  }
};
</script>

<style>
.navDiv{
  margin-top: 6px;
   margin-bottom: 6px;
}
.footer {
  background-color: aqua;
}
#app {
    margin: 2%;
}
#hello {
    margin-right: 20px;
}
.navbar-item {
    font-weight: bold;
}

</style>


