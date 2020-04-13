<template>
    <div class="new-payment">
        <div class="header">
            <h2>Add Payment</h2>
            <a href="#" class="back" v-on:click="goToPaymentHistory">
                <i class="fas fa-list-ul"></i> Return to Payment History
            </a>
        </div>
        <div class="form">
            <div class="form-input">
                <label for="paymentAmount">Amount:</label>
                <input type="number" id="paymentAmount" value="0" min="0" step="0.01" 
                       data-number-to-fixed="2" class="currency" v-model="payment.amountPaid" />
            </div>
            <button v-bind:disabled="payment.amountPaid == ''" v-on:click="savePayment">Submit Payment</button>
        </div>
    </div>
</template>

<script>
import auth from '../auth';

export default {
    props: {
        paymentId: Number
    },
    data() {
        return {
            payment: {
                amountPaid: '',
                leaseId: ''
            }
        };
    },
    methods: {
        getCurrentLeaseId() {
            fetch('http://localhost:8080/api/leases/active/renter/'+this.user.id, {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.payment.leaseId = responseData.leaseId; })
                    .catch(err => console.error(err));
        },
        createNewPayment() {
            fetch('http://localhost:8080/api/payments/'+this.paymentId, {
                method: 'POST',
                headers: {
                    Authorization: 'Bearer ' + auth.getToken(),
                    'Content-Type': 'application/json'
                },
                credentials: 'same-origin',
                body: JSON.stringify(this.payment)
            }).then(response => {
                    if (response.ok) { this.goToPaymentHistory(); }
                }).catch(err => console.error(err));
        },
        goToPaymentHistory() {
            this.$emit("getPaymentHistory");
        }
    },
    created() {
        this.getCurrentLease();
    }
}
</script>

<style>

</style>