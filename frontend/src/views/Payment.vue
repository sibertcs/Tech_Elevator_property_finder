<template>
  <div class="payments">
    <h1>Rent Payments</h1>
    <div class="content">
        <rent-cycles 
            v-if="!showNewPaymentForm && !showPaymentHistory"
            @getPaymentHistory="getPaymentHistory"
            @newPayment="newPayment"
        />
        <payment-history 
            v-if="!showNewPaymentForm && showPaymentHistory"
            @getRentCycles="getRentCycles"
            @newPayment="newPayment"
        />
        <new-payment 
            v-if="showNewPaymentForm && !showPaymentHistory"
            @getPaymentHistory="getPaymentHistory"
            @getRentCycles="getRentCycles"
        />
    </div>
  </div>
</template>

<script>
import PaymentHistory from "@/components/PaymentHistory.vue";
import RentCycles from "@/components/RentCycles.vue";
import NewPayment from "@/components/NewPayment.vue";

export default {
  components: {
    PaymentHistory,
    RentCycles,
    NewPayment
  },
  data() {
    return {
      showPaymentHistory: false,
      showNewPaymentForm: true,
      paymentId: 0
    };
  },
  methods: {
    newPayment() {
      this.paymentId = 0;
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
  }
};
</script>

<style>
.content {
    display: flex;
    flex-direction: column;
}
</style>