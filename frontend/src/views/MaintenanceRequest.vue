<template>
  <div>
      <h1>This is the maintenance request page</h1>
     
    <form>
      <input type="hidden" id="unitId" name="unitId" value="unitId !!!"/>
      <label for="details">Details</label>
      <textarea id="details"  rows="3" ></textarea>
      <br>
      <label for="priority">Priority Level</label>
      <select id="priority">
        <option>Low</option>
        <option>Medium</option>
        <option>High</option>
      </select>
      <button type="submit">Submit Request </button>
    </form>
  </div>
</template>

<script>
export default {};
</script>

<style>
</style>