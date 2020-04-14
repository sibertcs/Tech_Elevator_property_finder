<template>
  <div id="app">
    <div id="nav">
      <b-navbar>
        <template slot="brand">
          <b-navbar-item tag="router-link" :to="{ path: '/' }">
            <!--   <img
                    src="https://raw.githubusercontent.com/buefy/buefy/dev/static/img/buefy-logo.png"
                    alt="Lightweight UI components for Vue.js based on Bulma"
            >-->
          </b-navbar-item>
        </template>
        <template slot="start">
          <b-navbar-item href="#">
            <router-link to="/">Home</router-link>
          </b-navbar-item>

          <b-navbar-item href="#">About Us</b-navbar-item>
          <div v-if="user != undefined">
            <b-navbar-dropdown label="Options" v-if="user != undefined">
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
              <router-link to="/register">
                <a class="button is-primary">
                  <strong>Sign up</strong>
                </a>
              </router-link>
              <router-link to="/login">
                <a class="button is-light">Log in</a>
              </router-link>
            </div>
          </b-navbar-item>
        </template>
      </b-navbar>
    </div>
    <router-view :user="user" @user-logout="logout" @user-login="login" />
  </div>
</template>

<script>
import auth from "./auth.js";

export default {
  name: "home",
  data() {
    return {
      user: auth.getUser()
    };
  },
  methods: {
    logout() {
      auth.logout();
    },
    login() {
      this.user = auth.getUser();
    }
  }
};
</script>

<style>
.footer {
  background-color: aqua;
}
</style>