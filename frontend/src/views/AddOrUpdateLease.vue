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
                       @click="resetValues"
                /> Add New Lease
                <input type="radio"
                       name="addOrUpdate"
                       v-model="newLease"
                       :value="false"
                       @click="getExistingLeases"
                /> Update Existing Lease
            </div>
            <br/>
            <!-- !!!! shows only when user selected 'Update Existing Lease' above !!!! -->
            <div v-show="!newLease">
                <label for="leaseSelection">Existing Leases: </label>
                <select id="leaseSelection" v-model="selectedLeaseId" @change="getSelectedLease">  
                    <!-- shows only the leases for current Landlord user -->
                    <option value="" disabled selected>Select a Lease</option>
                    <option v-for="lease in leasesForLandlord" 
                            :key="lease.leaseId" 
                            :value="lease.leaseId">
                        {{ `${lease.propertyName} - Unit ${lease.unitNumber}` }}
                    </option>
                </select>
            </div>

            <!-- !!!! shows only when user selected 'Add New Lease' above !!!! -->
            <div v-show="newLease">
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
            <div v-show="newLease">
                <label for="unitNumber">Unit: </label>
                <select id="unitNumber" v-model="lease.unitId">
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
                            :key="renter.userId"
                            :value="renter.userId">
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

import renterData from '../assets/data/renters.json'
import leaseData from '../assets/data/leases.json'

export default {
    props: {
        user: Object
    },
    data() {
        return {
            allRenters: renterData,
            allLeases: leaseData,
            newLease: true,
            propertiesForLandlord: [],
            selectedPropertyId: '',
            leasesForLandlord: [],
            selectedLeaseId: '',
            lease: {
                leaseId: '',
                userId: '',
                unitId: '',
                unitNumber: '',
                signedDate: '',
                rentLength: '',
                rentAmount: '',
                lateFee: ''
            },
            successfulPost: false,
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
        getPropertiesForLandlord(id) {
            fetch('http://localhost:8080/api/properties/'+id, {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.propertiesForLandlord = responseData; });
        },
        createLease() {
            console.log(JSON.stringify(this.lease));
            this.successfulPost = true;
            this.resetValues();
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
            this.lease.userId = '';
            this.lease.unitId = '';
            this.lease.signedDate = '';
            this.lease.rentLength = '';
            this.lease.rentAmount = '';
            this.lease.lateFee = '';
        },
        getExistingLeases() {
            this.resetValues();
            this.leasesForLandlord = this.allLeases.filter((lease) => lease.landlordEmail === this.user.sub);
        },
        getSelectedLease() {
        /*
            let selectedLease = this.leasesForLandlord.filter((lease) => lease.id === this.selectedLeaseId)[0];
            this.lease.userId = selectedLease.userId;
            this.lease.unitId = selectedLease.unitId;
            this.lease.signedDate = selectedLease.signedDate;
            this.lease.rentLength = selectedLease.rentLength;
            this.lease.rentAmount = selectedLease.rentAmount;
            this.lease.lateFee = selectedLease.lateFee;
        */
            this.lease.userId = '1';
            this.lease.unitId = '1';
            this.lease.signedDate = '2020-04-07';
            this.lease.rentLength = '6';
            this.lease.rentAmount = '1000';
            this.lease.lateFee = '5';
        }
    },
    created() {
        this.getPropertiesForLandlord(this.user.id);
    }
}
</script>

<style>

</style>