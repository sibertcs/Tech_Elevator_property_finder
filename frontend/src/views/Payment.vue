<template>
  <div class="payments">
    <h1>Rent Payments</h1>
    <div class="overview">
        <p>Balance Overdue: ${{ overdueBalance }}</p>
        <p>Current Balance: ${{ currentBalance }}</p>
    </div>
    <div class="content">
      <rent-cycles
        v-if="!showNewPaymentForm && !showPaymentHistory"
        @getPaymentHistory="getPaymentHistory"
        @newPayment="newPayment"
        :currentLeaseId="currentLeaseId"
      />
      <payment-history
        v-if="!showNewPaymentForm && showPaymentHistory"
        @getRentCycles="getRentCycles"
        @newPayment="newPayment"
        :currentLeaseId="currentLeaseId"
      />
      <new-payment
        v-if="showNewPaymentForm && !showPaymentHistory"
        @getPaymentHistory="getPaymentHistory"
        @getRentCycles="getRentCycles"
        :currentLeaseId="currentLeaseId"
      />
    </div>
  </div>
</template>

<script>
import auth from '../auth';
import PaymentHistory from "@/components/PaymentHistory.vue";
import RentCycles from "@/components/RentCycles.vue";
import NewPayment from "@/components/NewPayment.vue";

export default {
  props: {
    user: Object
  },
  components: {
    PaymentHistory,
    RentCycles,
    NewPayment
  },
  data() {
    return {
        showPaymentHistory: false,
        showNewPaymentForm: true,
        currentLeaseId: 0,
        overdueBalance: '',
        currentBalance: ''
    };
  },
  methods: {
    getCurrentLease() {
        fetch('http://localhost:8080/api/leases/active/renter/'+this.user.id, {
            method: 'GET',
            headers: { Authorization: 'Bearer ' + auth.getToken() },
            credentials: 'same-origin'
        }).then (response => { if(response.ok) { return response.json(); }
            }).then(responseData => { 
                    this.currentLeaseId = responseData.leaseId;
                    this.overdueBalance = responseData.overdueBalance;
                    fetch('http://localhost:8080/api/rent/currentlease/'+responseData.leaseId, {
                        method: 'GET',
                        headers: { Authorization: 'Bearer ' + auth.getToken() }
                    }).then (response => { if(response.ok) { return response.json(); }
                        }).then(responseData => { 
                                this.currentBalance = responseData.balance;
                            })
            })
            .catch(err => console.error(err));
    },
    newPayment() {
        this.showNewPaymentForm = true;
        this.showPaymentHistory = false;
    },
    getPaymentHistory() {
        this.showNewPaymentForm = false;
        this.showPaymentHistory = true;
    },
    getRentCycles() {
        this.showNewPaymentForm = false;
        this.showPaymentHistory = false;
    }
  },
  created() {
        this.getCurrentLease();
  }
};
</script>

<style>
.content {
  display: flex;
  flex-direction: column;
}
</style>