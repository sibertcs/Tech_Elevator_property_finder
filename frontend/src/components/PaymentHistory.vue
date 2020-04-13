<template>
  <div class="payment-history">
      <h1>Payment History</h1>
      <pre>{{ allPayments }}</pre>
  </div>
</template>

<script>
import auth from '../auth';

export default {
    data() {
        return {
            allPayments: []
        }
    },
    methods: {
        getAllPayments() {
            fetch('http://localhost:8080/api/payments', {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.allPayments = responseData; })
                    .catch(err => console.error(err));
        }
    },
    created() {
        this.getAllPayments();
    }

}
</script>

<style>

</style>