<template>
  <div id="login" class="text-center">
    <form class="form-signin" @submit.prevent="login">
      <h1 class="h3 mb-3 font-weight-normal">Please Sign In</h1>
      <div class="alert alert-danger" role="alert" v-if="invalidCredentials">
        Invalid username and password!
      </div>
      <div class="alert alert-success" role="alert" v-if="this.$route.query.registration">
        Thank you for registering, please sign in.
      </div>
      
      <b-field label="Email">
      <b-input
        type="text"
        id="email"
        class="form-control"
        placeholder="Email"
        v-model="user.email"
        required
        autofocus
      /></b-field>
      <b-field label="Password">
      <b-input
        type="password"
        id="password"
        class="form-control"
        placeholder="Password"
        v-model="user.password"
        required
      />
      </b-field>
      <router-link :to="{ name: 'register' }">Need an account? </router-link>
      <b-button type="is-primary"
      native-type="submit">Sign in</b-button>
    </form>
    <br>
    <browse-properties/>
  </div>
</template>

<script>
import auth from '../auth';
import BrowseProperties from '../components/BrowseProperties';

export default {
  name: 'login',
  components: {
    BrowseProperties
  },
  data() {
    return {
      user: {
        email: '',
        password: '',
      },
      invalidCredentials: false,
    };
  },
  methods: {
    login() {
      fetch(`${process.env.VUE_APP_REMOTE_API}/login`, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(this.user),
      })
        .then((response) => {
          if (response.ok) {
            return response.text();
          } else {
            this.invalidCredentials = true;
          }
        })
        .then((token) => {
          if (token != undefined) {
            if (token.includes('"')) {
              token = token.replace(/"/g, '');
            }
            auth.saveToken(token);
            this.$emit('user-login');
            this.$router.push('/');
          }
        })
        .catch((err) => console.error(err));
    },
  },
};
</script>

<style scoped>
button {
  margin-left: 10px;
}
</style>
