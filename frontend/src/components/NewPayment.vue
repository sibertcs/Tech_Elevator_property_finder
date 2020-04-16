<template>
    <div class="new-payment">
        <div class="header">
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
            <b-field id="paymentAmount">
            <b-numberinput placeholder="Enter Amount" type="number" min="1" step="0.01"
                       data-number-to-fixed="2" v-model.number="payment.amountPaid" rounded size="is-medium"></b-numberinput>
        </b-field>
            <!-- <div class="form-input">
                <label for="paymentAmount">Amount:</label>
                <input type="number" id="paymentAmount" min="1" step="0.01"
                       data-number-to-fixed="2" v-model.number="payment.amountPaid" />
            </div> -->
            <b-button :disabled="payment.amountPaid < 1" @click="createNewPayment" type="is-danger">Submit Payment</b-button>
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
                amountPaid: 0
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

<style scoped>
#paymentAmount{
    width: 400px;
}
a {
    margin: 10px;
    padding: 10px;
}
</style>