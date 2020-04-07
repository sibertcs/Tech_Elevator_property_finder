<template>
  <div>
    <h1>This is the payment page</h1>
    <div>
      <table>
        <tr>
          <td>Property ID:</td>
          <td>123!!!</td>
        </tr>
        <tr>
          <td>Amount Due:</td>
          <td>$100!!!</td>
        </tr>
        <tr>
          <td>Amount Paid:</td>
          <td>$0!!!</td>
        </tr>
        <tr>
          <td>Due Date:</td>
          <td>01/01/2020!!!</td>
        </tr>
        <tr>
          <td>Status:</td>
          <td>Unpaid!!!</td>
        </tr>
      </table>
    </div>
    <div>
     <form>
       <label for="payment">Make a Payment </label>
       <input id="payment" type="text" placeholder="$$$"/>
       <button type="submit">Submit Payment</button>
     </form>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style>

</style>