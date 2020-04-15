<template>
    <div class="new-payment">
        <div class="header">
            <h2>Add Payment</h2>
            <div class="nav">
                <a href="#" class="back" @click="goToRentCycles">
                    <i class="fas fa-list-ul"></i> View Rent Cycles
                </a>
                <a href="#" class="back" @click="goToPaymentHistory">
                    <i class="fas fa-list-ul"></i> View Payment History
                </a>
            </div>
        </div>
        <div class="form">
            <b-field label="Payment">
            <b-input placeholder="Enter the amount to be paid in U.S. dollars. I.E. 375" type="number" id="paymentAmount" min="1" step="0.01"
                       data-number-to-fixed="2" v-model.number="payment.amountPaid" rounded size="is-large"></b-input>
        </b-field>
            <!-- <div class="form-input">
                <label for="paymentAmount">Amount:</label>
                <input type="number" id="paymentAmount" min="1" step="0.01"
                       data-number-to-fixed="2" v-model.number="payment.amountPaid" />
            </div> -->
            <button :disabled="payment.amountPaid < 1" @click="createNewPayment">Submit Payment</button>
        </div>
    </div>
</template>

<script>
import auth from '../auth';

export default {
    props: {
        currentLeaseId: Number,
    },
    data() {
        return {
            payment: {
                amountPaid: ''
            }
        };
    },
    methods: {
        createNewPayment() {
            this.payment.leaseId = this.currentLeaseId;
            fetch('http://localhost:8080/api/payments/', {
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
        goToRentCycles() {
            this.$emit("getRentCycles");
        },
        goToPaymentHistory() {
            this.$emit("getPaymentHistory");
        }
    }
}
</script>

<style>

</style>