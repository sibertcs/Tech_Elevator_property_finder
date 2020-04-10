<template>
    <div id="addOrUpdateLease">
        <h1> Create a lease to assign renters to a property:</h1>
        <p>You are logged in as {{user.sub}} as a {{user.rol}} and has the id of {{user.id}}.</p>
        <form>
            <div>
                <input type="radio"
                       name="addOrUpdate"
                       checked
                       v-model="newLease"
                       :value="true"
                       @click="resetLeaseValues"
                /> Add New Lease
                <input type="radio"
                       name="addOrUpdate"
                       v-model="newLease"
                       :value="false"
                       @click="getExistingLeases"
                /> Update Existing Lease
            </div>
            <br/>

            <div>
                <label for="propertyName">Property: </label>
                <select id="propertyName" v-model="selectedPropertyId">  
                    <!-- shows only the properties for current Landlord user -->
                    <option value="" disabled selected>Select a Property</option>
                    <option v-for="prop in propertiesForLandlord" 
                            :key="prop.propertyId" 
                            :value="prop.propertyId">
                        {{ prop.propertyName }}
                    </option>
                </select>
            </div>
            <div>
                <label for="unitNumber">Unit: </label>
                <select id="unitNumber" v-model="lease.unitId" 
                        @change="getLeasesForUnit(lease.unitId)">
                    <!-- shows only the Units for the Property selected above -->
                    <option value="" disabled selected>Select a Unit Number</option>
                    <option v-for="unit in getUnitsForSelectedProperty" 
                            :key="unit.unitId" 
                            :value="unit.unitId">
                        {{ unit.unitNumber }}
                    </option>
                </select>
            </div>

            <!-- !!!! Remaining fields will only show when a unit has been selected !!!! -->
            <div v-show="lease.unitId">
                <label for="renterName">Renter Name: </label>
                <select id="renterName" v-model="lease.userId">
                    <!-- shows all Renter users -->
                    <option value="" disabled selected>Select a Renter Name</option>
                    <option v-for="renter in allRenters"
                            :key="renter.id"
                            :value="renter.id">
                        {{ `${renter.lastName}, ${renter.firstName} (${renter.email})` }}
                    </option>
                </select>
            </div>
            <div v-show="lease.unitId">
                <label for="signedDate">Signed Date: </label>
                <input type="date" id="signedDate" value="0" v-model="lease.signedDate">
            </div>
            <div v-show="lease.unitId">
                <!-- Landlord can specify any positive integer value -->
                <label for="leaseLength">Lease Term (Months): </label>
                <input type="number" id="leaseLength" min="1" v-model="lease.rentLength">
            </div>
            <div v-show="lease.unitId">
                <!-- Landlord can specify any positive dollar value -->
                <label for="rentAmount">Rent Amount: </label>
                <input type="number" id="rentAmount" value="0" min="0" step="0.01" 
                       data-number-to-fixed="2" class="currency" v-model="lease.rentAmount"/>
            </div>
            <div v-show="lease.unitId">
                <!-- Landlord can specify any positive value between 1-100 -->
                <label for="lateFee">Late Fee Percentage Rate: </label>
                <input type="number" id="lateFee" min="0" max="100" v-model="lease.lateFee">
            </div>

            <button v-bind:disabled="!isValidForm" @click.prevent="createLease">Submit</button>

        </form>
        <div v-if="successfulPost">
            <p>Lease has been successfully created!</p>
        </div>

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
            newLease: true,
            propertiesForLandlord: [],
            selectedPropertyId: '',
            allRenters: [],
            leasesForLandlord: [],
            selectedLeaseId: '',
            lease: {
                leaseId: '',
                userId: '',
                unitId: '',
                signedDate: '',
                rentLength: '',
                rentAmount: '',
                lateFee: '',
                status: 'Active'
            },
            successfulPost: false
        }
    },
    computed: {
        getUnitsForSelectedProperty() {
            let selectedProp = {};
            this.propertiesForLandlord.forEach((property) => {
                if (property.propertyId === this.selectedPropertyId) {
                    selectedProp = property;
                }
            });
            return selectedProp.units;
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
        getPropertiesForLandlord() {
            fetch('http://localhost:8080/api/properties/'+this.user.id, {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.propertiesForLandlord = responseData; });
        },
        getAllRenters() {
            fetch('http://localhost:8080/api/renters', {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.allRenters = responseData; });
        },
        createLease() {
            console.log(JSON.stringify(this.lease));
            fetch('http://localhost:8080/api/leases', {
                method: 'POST',
                headers: {
                    Authorization: 'Bearer ' + auth.getToken(),
                    'Content-Type': 'application/json'
                },
                credentials: 'same-origin',
                body: JSON.stringify(this.lease)
            }).then(response => {
                if (response.ok) {
                    this.successfulPost = true;
                    this.resetLeaseValues();
                }
            }).catch(err => console.error(err));
        },
        resetLeaseValues() {
            this.lease.userId = '';
            this.lease.unitId = '';
            this.lease.signedDate = '';
            this.lease.rentLength = '';
            this.lease.rentAmount = '';
            this.lease.lateFee = '';
            this.lease.status = 'Active';
            this.getPropertiesForLandlord(this.user.id);
        },
        getLeasesForUnit(unitId) {
            this.resetLeaseValues();
            fetch('http://localhost:8080/api/leases/unit/'+unitId, {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.leasesForLandlord = responseData; });
        },
        getSelectedLease() {
            
        }
    },
    created() {
        this.getPropertiesForLandlord();
        this.getAllRenters();
    }
}
</script>

<style>

</style>