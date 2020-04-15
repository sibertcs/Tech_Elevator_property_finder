<template>
  <div class="container is-fluid">
    <div class="content">
        <p>You are logged in as {{user.sub}} as a {{user.rol}} and has the id of {{user.id}}.</p>
        <h1 class="title">Property Management Console</h1>

        <h2 class="subtitle">Options:</h2>
        <b-field>
            <b-radio @input="currentProperty = {
                            address: '',
                            name: '',
                            location: '',
                            units: []
                        }" 
            v-model="newProperty" :native-value="true">Add New Property</b-radio>
            <b-radio @input="currentProperty = {
                            address: '',
                            name: '',
                            location: '',
                            units: []
                        }" 
            v-model="newProperty" :native-value="false">Update Existing Property</b-radio>
        </b-field>
        <br>
        <br>
        <div>
        <form v-if="newProperty">
            <div class="property">
            <b-field label-position="inside" label="Address">
                <b-input type="text" v-model="currentProperty.streetAddress"></b-input>
            </b-field>
            <b-field label-position="inside" label="Name">
                <b-input type="text" v-model="currentProperty.propertyName"></b-input>
            </b-field>
            <b-field label-position="inside" label="Location">
                <b-select v-model="currentProperty.location">
                <option>Downtown</option>
                <option>East Side</option>
                <option>West Side</option>
                <option>North Side</option>
                <option>NKY</option>
                </b-select>
            </b-field>
                <file-upload />
            </div>
            <table>
            <tr>
                <th>Unit Number</th>
                <th>Bed Count</th>
                <th>Bath Count</th>
                <th>Rent Price</th>
                <th>SqFt</th>
                <th></th>
            </tr>
            <tr v-for="unit in currentProperty.units" :key="unit.unitId">
                <td>#{{unit.unitNumber}}</td>
                <td>{{unit.bedCount}} bed</td>
                <td>{{unit.bathCount}} bath</td>
                <td>${{unit.price}}</td>
                <td>{{unit.sqFt}} sqft</td>
                <td>
                <b-button type="is-danger" v-if="unit.available" @click.prevent="removeUnit(unit.unitId)">Delete Unit</b-button>
                </td>
            </tr>
            </table>
            <b-field class="newUnit">
            <b-input type="text" placeholder="Unit #" v-model="newUnit.unitNumber"></b-input>
            <b-input type="text" placeholder="Bed Count" v-model="newUnit.bedCount"></b-input>
            <b-input type="text" placeholder="Bath Count" v-model="newUnit.bathCount"></b-input>
            <b-input type="text" placeholder="Rent $" v-model="newUnit.price"></b-input>
            <b-input type="text" placeholder="SqFt" v-model="newUnit.sqft"></b-input>
            <b-button type="submit is-success" @click.prevent="addUnit">Add Unit</b-button>
            </b-field>
        </form>
        <form v-if="!newProperty">
            <label for="property">Select Property</label>
            <select v-model="updatePropId" @change="selectExistingProp">
            <option v-for="prop in existingProps" :key="prop.propertyId" :value="prop.propertyId">{{prop.streetAddress}}</option>
            </select>
            
            <div v-if="updatePropId !== ''">
            <div class="property">
            <b-field label-position="inside" label="Address">
                <b-input type="text" v-model="currentProperty.streetAddress"></b-input>
            </b-field>
            <b-field label-position="inside" label="Name">
                <b-input type="text" v-model="currentProperty.propertyName"></b-input>
            </b-field>

            <b-field label-position="inside" label="Location">
                <b-select v-model="currentProperty.location">
                <option>Downtown</option>
                <option>East Side</option>
                <option>West Side</option>
                <option>North Side</option>
                <option>NKY</option>
                </b-select>
            </b-field>
            </div>
            <table>
                <tr>
                <th>Unit Number</th>
                <th>Bed Count</th>
                <th>Bath Count</th>
                <th>Rent Price</th>
                <th>SqFt</th>
                <th></th>
                </tr>
                <tr v-for="unit in currentProperty.units" :key="unit.unitId">
                <td>#{{unit.unitNumber}}</td>
                <td>{{unit.bedCount}} bed</td>
                <td>{{unit.bathCount}} bath</td>
                <td>${{unit.price}}</td>
                <td>{{unit.sqFt}} sqft</td>
                <td>
                <b-button type="is-danger" v-if="unit.available" @click.prevent="removeUnit(unit.unitId)">Delete Unit</b-button>
                </td>
                </tr>
            </table>
            <div class="newUnit">
                <b-field>
                <b-input type="text" placeholder="Unit #" v-model="newUnit.unitNumber"></b-input>
                <b-input type="text" placeholder="Bed Count" v-model="newUnit.bedCount"></b-input>
                <b-input type="text" placeholder="Bath Count" v-model="newUnit.bathCount"></b-input>
                <b-input type="text" placeholder="Rent $" v-model="newUnit.price"></b-input>
                <b-input type="text" placeholder="SqFt" v-model="newUnit.sqft"></b-input>
                <b-button type="submit is-success" @click.prevent="addUnit">Add Unit</b-button>
                </b-field>
            </div>
            </div>
        </form>
        <br>
        </div>
        <b-button @click.prevent="submitProperty" type="submit is-primary">{{newProperty? 'Add' : 'Update'}} Property</b-button>  
    </div>
  </div>
</template>

<script>
import auth from '../auth';
import FileUpload from '@/components/FileUpload.vue'

export default {
  props: {
    user: Object
  },
  components: {
    FileUpload
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
      newUnit: {
        unitId: 1000,
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
      this.newUnit.unitId++;
      this.newUnit.unitNumber++;
      console.log('new unit!');
    },
    submitProperty() {
      if(this.newProperty) {
        return fetch("http://localhost:8080/api/properties/new", {
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
      console.log('removing unit with id '+ id);
      this.currentProperty.units = this.currentProperty.units.filter(u => {
        return u.unitId !== id;
      });
    },
    loadProperties() {
      fetch('http://localhost:8080/api/properties/landlord/' + this.user.id, {
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
    width: 16.66%;
    border-bottom: 1px solid black;
    padding: 5px;
  }
  table {
    width: 55%;
  }
  tr:nth-child(even) {
    background-color: ghostwhite;
  }
  .property {
    width: 50%;
    display: flex;
    justify-content: space-between;
  }
  .newUnit {
    width: 52.5%;
  }
</style>