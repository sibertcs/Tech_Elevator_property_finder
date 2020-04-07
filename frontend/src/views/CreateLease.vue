<template>
    <div id="create-lease">
        <h1> Create a lease to assign renters to a property:</h1>
        <form>
            <div>
                <label for="propertyName">Property: </label>
                <select id="propertyName">  
                    <!-- shows only the properties for current Landlord user -->
                    <option value="" disabled selected>Select a Property</option>
                    <option v-for="prop in properties" 
                            :key="prop.propertyId" 
                            value="prop.propertyId">
                        {{ prop.propertyName }}
                    </option>
                </select>
            </div>
            <div>
                <label for="unitNumber">Unit: </label>
                <select id="unitNumber" v-model="selectedPropertyId">
                    <!-- shows only the Units for the Property selected above -->
                    <option value="" disabled selected>Select a Unit Number</option>
                    <option v-for="unit in unitsForSelectedProperty" 
                            :key="unit.unitId" 
                            value="unit.unitId">
                        {{ unit.unitNumber }}
                    </option>
                </select>
            </div>
            <div>
                <label for="renterName">Renter Name: </label>
                <select id="renterName">
                    <!-- Will pull from method that gets all Renter users and concats firstName LastName -->
                    <option value="" disabled selected>Select a Renter Name</option>
                    <option value="1">Auel, Angie</option>
                    <option value="1">Cook, Drew</option>
                    <option value="1">Fox, Becca</option>
                    <option value="1">Kenney, Zach</option>
                    <option value="1">White, Evan</option>
                </select>
            </div>
            <div>
                <label for="signedDate">Signed Date: </label>
                <input type="date" id="signedDate" value="0">
            </div>
            <div>
                <!-- Landlord can specify any positive integer value -->
                <label for="leaseLength">Lease Term (Months): </label>
                <input type="number" id="leaseLength" min="1">
            </div>
            <div>
                <!-- Landlord can specify any positive dollar value -->
                <label for="rentAmount">Rent Amount: </label>
                <input type="number" id="rentAmount" value="0" min="0" step="0.01" data-number-to-fixed="2" class="currency" />
            </div>
            <div>
                <!-- Landlord can specify any positive value between 1-100 -->
                <label for="lateFee">Late Fee Percentage Rate: </label>
                <input type="number" id="lateFee" min="0" max="100">
            </div>
            <button>Submit</button>
        </form>
    </div>
</template>

<script>
import propertyData from '../assets/data/properties.json'
import unitData from '../assets/data/units.json'

export default {
    data() {
        return {
            allProperties: propertyData,
            allUnits: unitData,
            properties: [],
            selectedPropertyId: ''
        }
    },
    computed: {
        unitsForSelectedProperty() {
            return this.allUnits.filter((unit) => unit.propertyId === this.selectedPropertyId);
        }
    },
    methods: {
        getPropertiesForLandlord(email) {
            this.properties = this.allProperties.filter((prop) => prop.landlordEmail === email);
        }
    },
    created() {
        this.getPropertiesForLandlord(this.$route.meta.user.sub);
    }
}
</script>

<style>

</style>