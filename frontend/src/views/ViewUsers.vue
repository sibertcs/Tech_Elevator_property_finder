<template>
  <h1> this is where you view all users</h1>
</template>

<script>
import auth from '../auth';

export default {
  data() {
    return {
      users: []
    }
  },
  created() {
    fetch("http://localhost:8080/api/users", {
        method: 'GET',
          headers: {
            Authorization: 'Bearer ' + auth.getToken(),
            'Content-Type': 'application/json'
          },
          credentials: 'same-origin'
    })
    .then(response => {
      if(response.ok) {
        return response.json();
      }
    })
    .then(responseData => {
      this.users = responseData;
    })
  }
}
</script>

<style>

</style>