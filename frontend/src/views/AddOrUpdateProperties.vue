<template>
  <div>
    <h1>this is where you add or update properties</h1>
    <input v-model="newProperty" type="radio" :value="true">Add New Property
    <input v-model="newProperty" type="radio" :value="false">Update Existing Property

    <div>
      <form v-if="newProperty">
        <label for="address">Address</label>
        <input type="text">

        <label for="name">Name (If Applicable)</label>
        <input type="text">

        <label for="location">Name (If Applicable)</label>
        <select>
          <option>Dowtown</option>
          <option>East Side</option>
          <option>West Side</option>
          <option>North Side</option>
          <option>NKY</option>
        </select>
        <br>
        <label for="newUnit">Add Unit</label>
        <input type="text" placeholder="Unit #">
        <input type="text" placeholder="Bed Count">
        <input type="text" placeholder="Bath Count">
        <input type="text" placeholder="Rent $">
        <input type="text" placeholder="SqFt">

      </form>
      <form v-if="!newProperty">
        <label for="property">Select Property</label>
        <select v-model="updatePropId">
          <option :value="1">Building 1!!!</option>
          <option :value="2">Building 2!!!</option>
          <option :value="3">Building 3!!!</option>
        </select>
        <div v-if="updatePropId !== ''">
          <label for="address">Address</label>
          <input type="text">

          <label for="name">Name (If Applicable)</label>
          <input type="text">

          <label for="location">Name (If Applicable)</label>
          <select>
            <option>Dowtown</option>
            <option>East Side</option>
            <option>West Side</option>
            <option>North Side</option>
            <option>NKY</option>
          </select>
        </div>
      </form>
      <table>
          <tr>
            <th>Unit #</th>
            <th>Bed Count</th>
            <th>Bath Count</th>
            <th>Rent Price</th>
            <th>SqFt</th>
          </tr>
          <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
          </tr>
        </table>
    </div>

  </div>
</template>

<script>
export default {
  data() {
    return {
      newProperty: true,
      updatePropId: '',
      currentProperty: {
        address: '',
        name: '',
        location: '',
        units: [
          {
            number: '',
            bedCount: '',
            bathCount: '',
            price: '',
            sqft: '',
            quantity: ''
          }
        ]
      }
    }
  }
}
</script>

<style>

</style>