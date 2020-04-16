<template>
    <div class="payment-history">
        <div class="payment-nav">
            <a href="#" class="payment-nav-item" @click="goToRentCycles">
                <i class="fas fa-list-ul"></i> View Rent Cycles
            </a>
            <a href="#" class="payment-nav-item" @click="goToNewPayment">
                <i class="fas fa-address-card"></i> Submit New Payment
            </a>
        </div>
        <div class="payments">
        <h3>Payment History</h3>
            <b-table :data="allPayments" :columns="column">
            </b-table>
             <!-- <table>
                <th>Date Paid</th>
                <th>Amount</th>
                <tr v-for="payment in allPayments" :key="payment.id" :value="payment.id">
                    <td>{{payment.datePaid}}</td>
                    <td>{{payment.amountPaid}}</td>
                </tr> 
            </table> -->
        </div>
    </div>
</template>

<script>
import auth from '../auth';

export default {
    props: {
        currentLeaseId: Number
    },
    data() {
        return {
            allPayments: [],
            column: [
                {
                    field: "datePaid",
                    label: "Date Of Payment"
                },
                {
                    field: "amountPaid",
                    label: "Amount Paid"
                }
            ]
        }
    },
    methods: {
        getAllPayments() {
            fetch('http://localhost:8080/api/payments/lease/'+this.currentLeaseId, {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.allPayments = responseData; })
                    .catch(err => console.error(err));
        },
        goToRentCycles() {
            this.$emit("getRentCycles");
        },
        goToNewPayment() {
            this.$emit("newPayment");
        }
    },
    created() {
        this.getAllPayments();
    }

}
</script>

<style>

</style>