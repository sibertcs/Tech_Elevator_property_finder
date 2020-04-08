<template>
    <div id="create-lease">
        <h1> Create a lease to assign renters to a property:</h1>
        <form>
            <div>
                <label for="propertyName">Property: </label>
                <select id="propertyName" v-model="selectedPropertyId">  
                    <!-- shows only the properties for current Landlord user -->
                    <option value="" disabled selected>Select a Property</option>
                    <option v-for="prop in properties" 
                            :key="prop.propertyId" 
                            :value="prop.propertyId">
                        {{ prop.propertyName }}
                    </option>
                </select>
            </div>
            <div>
                <label for="unitNumber">Unit: </label>
                <select id="unitNumber" v-model="lease.unitId">
                    <!-- shows only the Units for the Property selected above -->
                    <option value="" disabled selected>Select a Unit Number</option>
                    <option v-for="unit in unitsForSelectedProperty" 
                            :key="unit.unitId" 
                            :value="unit.unitId">
                        {{ unit.unitNumber }}
                    </option>
                </select>
            </div>
            <div>
                <label for="renterName">Renter Name: </label>
                <select id="renterName" v-model="lease.userId">
                    <!-- shows all Renter users -->
                    <option value="" disabled selected>Select a Renter Name</option>
                    <option v-for="renter in allRenters"
                            :key="renter.userId"
                            :value="renter.userId">
                        {{ `${renter.lastName}, ${renter.firstName} (${renter.email})` }}
                    </option>
                </select>
            </div>
            <div>
                <label for="signedDate">Signed Date: </label>
                <input type="date" id="signedDate" value="0" v-model="lease.signedDate">
            </div>
            <div>
                <!-- Landlord can specify any positive integer value -->
                <label for="leaseLength">Lease Term (Months): </label>
                <input type="number" id="leaseLength" min="1" v-model="lease.rentLength">
            </div>
            <div>
                <!-- Landlord can specify any positive dollar value -->
                <label for="rentAmount">Rent Amount: </label>
                <input type="number" id="rentAmount" value="0" min="0" step="0.01" 
                       data-number-to-fixed="2" class="currency" v-model="lease.rentAmount"/>
            </div>
            <div>
                <!-- Landlord can specify any positive value between 1-100 -->
                <label for="lateFee">Late Fee Percentage Rate: </label>
                <input type="number" id="lateFee" min="0" max="100" v-model="lease.lateFee">
            </div>
            <button v-bind:disabled="!isValidForm" @click.prevent="createLease">Submit</button>
        </form>
        <span v-if="successfulPost">Lease has been successfully created!</span>
    </div>
</template>

<script>
import propertyData from '../assets/data/properties.json'
import unitData from '../assets/data/units.json'
import renterData from '../assets/data/renters.json'

export default {
    data() {
        return {
            allProperties: propertyData,
            allUnits: unitData,
            allRenters: renterData,
            properties: [],
            selectedPropertyId: '',
            lease: {
                userId: '',
                unitId: '',
                signedDate: '',
                rentLength: '',
                rentAmount: '',
                lateFee: ''
            },
            successfulPost: false
        }
    },
    computed: {
        unitsForSelectedProperty() {
            return this.allUnits.filter((unit) => unit.propertyId === this.selectedPropertyId);
        },
        isValidForm() {
            return (
                this.lease.userId != "" &&
                this.lease.unitId != "" &&
                this.lease.signedDate != "" &&
                this.lease.rentLength != "" &&
                this.lease.rentAmount != "" &&
                this.lease.lateFee != ""
            );
        }
    },
    methods: {
        getPropertiesForLandlord(email) {
            this.properties = this.allProperties.filter((prop) => prop.landlordEmail === email);
        },
        createLease() {
            console.log(JSON.stringify(this.lease));
            /*  fetch(this.apiURL, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json' },
                    body: JSON.stringify(this.lease)
                })
                    .then(response => {
                        if (response.ok) {
                            this.successfulPost = true;
                            this.resetLeaseValues();
                        }
                    })
                    .catch(err => console.error(err));
             */
        },
        resetValues() {
            this.userId = '';
            this.unitId = '';
            this.signedDate = '';
            this.rentLength = '';
            this.rentAmount = '';
            this.lateFee = '';
        }
    },
    created() {
        this.getPropertiesForLandlord(this.$route.meta.user.sub);
    }
}
</script>

<style>

</style>