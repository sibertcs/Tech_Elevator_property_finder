<template>
    <div class="rent-cycles">
        <h1>Rent Cycles</h1>
        <div class="nav">
            <a href="#" class="back" @click="goToPaymentHistory">
                    <i class="fas fa-list-ul"></i> View Payment History
                </a>
            <a href="#" class="back" @click="goToNewPayment">
                <i class="fas fa-address-card"></i> Submit New Payment
            </a>
        </div>
        <div class="cycles">
           <b-table :data="allRentCycles" :columns="columns">
           </b-table>
           
            <!-- <table>
                <th>Start Date</th>
                <th>Due Date</th>
                <th>Balance</th>
                <th>Status</th>
                <tr v-for="cycle in allRentCycles" :key="cycle.id" :value="cycle.id">
                    <td>{{cycle.startDate}}</td>
                    <td>{{cycle.dueDate}}</td>
                    <td>{{cycle.balance}}</td>
                    <td>{{cycle.rentStatus}}</td>
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
            allRentCycles: [],
            columns: [
                {
                    field: "startDate",
                    label: "Start Date"
                },
                {
                    field: "dueDate",
                    label: "Due Date"
                },
                {
                    field: "balance",
                    label: "Balance"
                },
                {
                    field: "rentStatus",
                    label: "Rent Status"
                }
            ]
        }
    },
    methods: {
        getAllRentCycles() {
            fetch('http://localhost:8080/api/rent/lease/'+this.currentLeaseId, {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.allRentCycles = responseData; })
                    .catch(err => console.error(err));
        },
        goToPaymentHistory() {
            this.$emit("getPaymentHistory");
        },
        goToNewPayment() {
            this.$emit("newPayment");
        }
    },
    created() {
        this.getAllRentCycles();
    }
}
</script>

<style>

</style>