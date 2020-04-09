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
        <input type="text" v-model="currentProperty.streetAddress">
        
        <label for="name">Name (If Applicable)</label>
        <input type="text" v-model="currentProperty.propertyName">

        <label for="location">Location</label>
        <select v-model="currentProperty.location">
          <option>Downtown</option>
          <option>East Side</option>
          <option>West Side</option>
          <option>North Side</option>
          <option>NKY</option>
        </select>
        <br>
        <br>
        <label for="newUnit">Add Unit</label>
        <input type="text" placeholder="Unit #" v-model="newUnit.unitNumber">
        <input type="text" placeholder="Bed Count" v-model="newUnit.bedCount">
        <input type="text" placeholder="Bath Count" v-model="newUnit.bathCount">
        <input type="text" placeholder="Rent $" v-model="newUnit.price">
        <input type="text" placeholder="SqFt" v-model="newUnit.sqft">
        <button type="submit" @click.prevent="addUnit">Add Unit</button>

      </form>
      <form v-if="!newProperty">
        <label for="property">Select Property</label>
        <select v-model="updatePropId" @change="selectExistingProp">
          <option v-for="prop in existingProps" :key="prop.propertyId" :value="prop.propertyId">{{prop.streetAddress}}</option>
        </select>
        <br>
        <br>
        <div v-if="updatePropId !== ''">
          <label for="address">Address</label>
          <input type="text" v-model="currentProperty.streetAddress">

          <label for="name">Name (If Applicable)</label>
          <input type="text" v-model="currentProperty.propertyName">

          <label for="location">Location</label>
          <select v-model="currentProperty.location">
            <option value="Downtown">Dowtown</option>
            <option value="East Side">East Side</option>
            <option value="West Side">West Side</option>
            <option value="North Side">North Side</option>
            <option value="NKY">NKY</option>
          </select>
          <br>
          <br>
          <label for="newUnit">Add Unit</label>
          <input type="text" placeholder="Unit #" v-model="newUnit.unitNumber">
          <input type="text" placeholder="Bed Count" v-model="newUnit.bedCount">
          <input type="text" placeholder="Bath Count" v-model="newUnit.bathCount">
          <input type="text" placeholder="Rent $" v-model="newUnit.price">
          <input type="text" placeholder="SqFt" v-model="newUnit.sqFt">
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
            <td>#{{unit.unitNumber}}</td>
            <td>{{unit.bedCount}} bed</td>
            <td>{{unit.bathCount}} bath</td>
            <td>${{unit.price}}</td>
            <td>{{unit.sqFt}} sqft</td>
            <button v-if="unit.available" @click.prevent="removeUnit(unit.unitId)">Delete Unit</button>
          </tr>
        </table>
    </div>
    <button @click.prevent="submitProperty" type="submit">{{newProperty? 'Add' : 'Update'}} Property</button>  
  </div>
</template>

<script>
import auth from '../auth';

export default {
  props: {
    user: Object
  },
  data() {
    return {
      newProperty: true,
      updatePropId: '',
      currentProperty: {
        landlordId: this.user.id,
        streetAddress: '',
        city: 'Cincinnati',
        state: 'Ohio',
        zipCode: '45208',
        propertyName: '',
        photoPath: '',
        location: '',
        units: []
      },
      unitId: 1,
      newUnit: {
        unitId: this.unitId,
        unitNumber: '',
        bedCount: '',
        bathCount: '',
        price: '',
        sqFt: '',
        available: true
      },
      existingProps: {}
    }
  },
  methods: {
    selectExistingProp() {
      this.existingProps.forEach((p) => {
        if(p.propertyId == this.updatePropId) {
          this.currentProperty = p;
        }
      });
    },
    addUnit() {
      let addedUnit = Object.assign({}, this.newUnit);
      this.currentProperty.units.push(addedUnit);
      this.unitId++;
      this.newUnit.id = this.unitId;
      this.newUnit.unitNumber++;
      console.log('new unit!');
    },
    submitProperty() {
      if(this.newProperty) {
        return fetch("http://localhost:8080/api/propertiesnew", {
          method: 'POST',
          headers: {
            Authorization: 'Bearer ' + auth.getToken(),
            'Content-Type': 'application/json'
          },
          credentials: 'same-origin',
          body: JSON.stringify(this.currentProperty)
        })
          .then(() => {
            console.log('New Property and Units created!');
            this.loadProperties();
          })
      } else {
        return fetch("http://localhost:8080/api/propertiesupdate", {
          method: 'PUT',
          headers: {
            Authorization: 'Bearer ' + auth.getToken(),
            'Content-Type': 'application/json'
          },
          credentials: 'same-origin',
          body: JSON.stringify(this.currentProperty)
        })
          .then(() => {
            console.log('Updated');
            this.loadProperties();
          })
      }
    },
    removeUnit(id) {
      this.currentProperty.units = this.currentProperty.units.filter(u => {
        return u.unitId !== id;
      });
    },
    loadProperties() {
      fetch('http://localhost:8080/api/properties/' + this.user.id, {
        method: 'GET',
        headers: {
          Authorization: 'Bearer ' + auth.getToken()
        },
        credentials: 'same-origin'
      })
      .then (response => {
              if(response.ok) {
                  return response.json();
              }
          }).then(responseData => {
              this.existingProps = responseData;
          });
    }
  },
  created() {
    this.loadProperties();
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