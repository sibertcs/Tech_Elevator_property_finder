<template>
  <div>
    <h1>Renters And Status</h1>
    <div>
        <select>
            <option> Sample unit 1 </option>
            <option> Sample unit 2 </option>
            <option> Sample unit 3 </option>
        </select>
      <table>
        <tr>
          <td></td>
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