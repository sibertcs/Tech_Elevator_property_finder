<template>
  <div>
    <h1>this is where you add or update properties</h1>
    <p>You are logged in as {{user.sub}} as a {{user.rol}} and has the id of {{user.id}}.</p>
    <input @click="currentProperty = {
                    address: '',
                    name: '',
                    location: '',
                    units: []
                  }" 
    v-model="newProperty" type="radio" :value="true">Add New Property
    <input @click="currentProperty = {
                    address: '',
                    name: '',
                    location: '',
                    units: []
                  }" 
    v-model="newProperty" type="radio" :value="false">Update Existing Property
    <br>
    <br>
    <div>
      <form v-if="newProperty">
        <label for="address">Address</label>
        <input type="text" v-model="currentProperty.address">
        
        <label for="name">Name (If Applicable)</label>
        <input type="text" v-model="currentProperty.name">

        <label for="location">Location</label>
        <select v-model="currentProperty.location">
          <option>Dowtown</option>
          <option>East Side</option>
          <option>West Side</option>
          <option>North Side</option>
          <option>NKY</option>
        </select>
        <br>
        <br>
        <label for="newUnit">Add Unit</label>
        <input type="text" placeholder="Unit #" v-model="newUnit.number">
        <input type="text" placeholder="Bed Count" v-model="newUnit.bedCount">
        <input type="text" placeholder="Bath Count" v-model="newUnit.bathCount">
        <input type="text" placeholder="Rent $" v-model="newUnit.price">
        <input type="text" placeholder="SqFt" v-model="newUnit.sqft">
        <button type="submit" @click.prevent="addUnit">Add Unit</button>

      </form>
      <form v-if="!newProperty">
        <label for="property">Select Property</label>
        <select v-model="updatePropId" @change="existingProp">
          <option :value="'Building 1!!!'">Building 1!!!</option>
          <option :value="'Building 2!!!'">Building 2!!!</option>
          <option :value="'Building 3!!!'">Building 3!!!</option>
        </select>
        <br>
        <br>
        <div v-if="updatePropId !== ''">
          <label for="address">Address</label>
          <input type="text" v-model="currentProperty.address">

          <label for="name">Name (If Applicable)</label>
          <input type="text" v-model="currentProperty.name">

          <label for="location">Location</label>
          <select v-model="currentProperty.location">
            <option>Dowtown</option>
            <option>East Side</option>
            <option>West Side</option>
            <option>North Side</option>
            <option>NKY</option>
          </select>
          <br>
          <br>
          <label for="newUnit">Add Unit</label>
          <input type="text" placeholder="Unit #" v-model="newUnit.number">
          <input type="text" placeholder="Bed Count" v-model="newUnit.bedCount">
          <input type="text" placeholder="Bath Count" v-model="newUnit.bathCount">
          <input type="text" placeholder="Rent $" v-model="newUnit.price">
          <input type="text" placeholder="SqFt" v-model="newUnit.sqft">
          <button type="submit" @click.prevent="addUnit">Add Unit</button>
        </div>
      </form>
      <br>
      <table>
          <tr>
            <th>Unit Number</th>
            <th>Bed Count</th>
            <th>Bath Count</th>
            <th>Rent Price</th>
            <th>Square Footage</th>
          </tr>
          <tr v-for="unit in currentProperty.units" :key="unit.id">
            <td>#{{unit.number}}</td>
            <td>{{unit.bedCount}} bed</td>
            <td>{{unit.bathCount}} bath</td>
            <td>${{unit.price}}</td>
            <td>{{unit.sqft}} sqft</td>
            <button @click.prevent="removeUnit(unit.id)">Delete Unit</button>
          </tr>
        </table>
    </div>
    <button @click.prevent="submitProperty" type="submit">{{newProperty? 'Add' : 'Update'}} Property</button>  
  </div>
</template>

<script>
export default {
  props: {
    user: Object
  },
  data() {
    return {
      newProperty: true,
      updatePropId: '',
      currentProperty: {
        address: '',
        name: '',
        location: '',
        units: []
      },
      unitId: 1,
      newUnit: {
        id: this.unitId,
        number: '',
        bedCount: '',
        bathCount: '',
        price: '',
        sqft: ''
      }
    }
  },
  methods: {
    existingProp() {
      this.currentProperty = {
        address: '123 abc ave.',
        name: this.updatePropId,
        location: 'Downtown',
        units: [
          {
            id: 100,
            number: '1',
            bedCount: '2',
            bathCount: '2',
            price: '1075',
            sqft: '988'
          },
          {
            id: 101,
            number: '2',
            bedCount: '2',
            bathCount: '2',
            price: '1025',
            sqft: '1100'
          },
          {
            id: 102,
            number: '3',
            bedCount: '1',
            bathCount: '1',
            price: '750',
            sqft: '678'
          }
        ]
      }
    },
    addUnit() {
      let addedUnit = Object.assign({}, this.newUnit);
      this.currentProperty.units.push(addedUnit);
      this.unitId++;
      this.newUnit.id = this.unitId;
      this.newUnit.number++;
      console.log('new unit!');
    },
    submitProperty() {
      if(this.newProperty) {
        console.log('Send POST:' + JSON.stringify(this.currentProperty));
      } else {
        console.log('Send PUT' + JSON.stringify(this.currentProperty))
      }
    },
    removeUnit(id) {
      this.currentProperty.units = this.currentProperty.units.filter(u => {
        return u.id !== id;
      });
    }
  }
}
</script>

<style>
  table th,
  table td {
    border: 1px solid black;
    padding: 5px;
  }
</style>