<template>
    <div id="addOrUpdateLease">
        <p>You are logged in as {{user.sub}} as a {{user.rol}} and has the id of {{user.id}}.</p>
        <h1> Lease Management Console</h1>

        <h2>All Existing Leases:</h2>
        <table>
            <th>Lease #</th><th>Property</th><th>Unit</th><th>Status</th><th>Signed</th><th>Term</th><th>Rent</th><th>Renter</th>
            <tr v-for="lease in leasesForLandlord" :key="lease.leaseId" :value="lease.leaseId">
                <td>{{ lease.leaseId }}</td>
                <td>{{ lease.propertyName }}</td>
                <td>{{ lease.unitNumber }}</td>
                <td>{{ lease.status }}</td>
                <td>{{ lease.signedDate }}</td>
                <td>{{ lease.rentLength }} months</td>
                <td>${{ lease.rentAmount }}</td>
                <td>{{ `${lease.renterName} (${lease.renterEmail})` }}</td>
            </tr>
        </table>

        <h2>Options:</h2>
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
                       @click="resetLeaseValues"
                /> Update Existing Lease
            </div>
            <br/>

            <!-- Prompt for Lease when 'Updating Existing Lease' chosen above -->
            <div v-show="!newLease">
                <label for="existingLease">Lease ID: </label>
                <select id="existingLease" v-model="currentLease.leaseId" v-on:change="getCurrentLease">
                    <option value="" selected>Select a Lease ID</option>
                    <option v-for="lease in leasesForLandlord" :key="lease.leaseId" :value="lease.leaseId">
                        {{ `${lease.leaseId}: ${lease.propertyName} - ${lease.unitNumber} (${lease.status })` }}
                    </option>
                </select>
            </div>

            <!-- Prompt for Property and Unit for new leases only -->
            <div v-show="newLease">
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
                    <select id="unitNumber" v-model="currentLease.unitId">
                        <!-- shows only the Units for the Property selected above -->
                        <option value="" disabled selected>Select a Unit Number</option>
                        <option v-for="unit in getUnitsForSelectedProperty" 
                                :key="unit.unitId" 
                                :value="unit.unitId">
                            {{ unit.unitNumber }}
                        </option>
                    </select>
                </div>
            </div>

            <!-- Show remaining fields for new leases, or when an existing lease has been selected -->
            <div v-show="currentLease.unitId !== ''">
                <div>
                    <label for="renterName">Renter Name: </label>
                    <select id="renterName" v-model="currentLease.userId">
                        <!-- shows all Renter users -->
                        <option value="" disabled selected>Select a Renter Name</option>
                        <option v-for="renter in allRenters"
                                :key="renter.id"
                                :value="renter.id">
                            {{ `${renter.lastName}, ${renter.firstName} (${renter.email})` }}
                        </option>
                    </select>
                </div>
                <div>
                    <label for="signedDate">Signed Date: </label>
                    <input type="date" id="signedDate" v-model="currentLease.signedDate">
                </div>
                <div>
                    <label for="startDate">Start Date: </label>
                    <input type="date" id="startDate" v-model="currentLease.startDate">
                </div>
                <div>
                    <!-- Landlord can specify any positive integer value -->
                    <label for="leaseLength">Lease Term (Months): </label>
                    <input type="number" id="leaseLength" min="1" v-model="currentLease.rentLength">
                </div>
                <div>
                    <!-- Landlord can specify any positive dollar value -->
                    <label for="rentAmount">Rent Amount: </label>
                    <input type="number" id="rentAmount" value="0" min="0" step="0.01" 
                        data-number-to-fixed="2" class="currency" v-model="currentLease.rentAmount"/>
                </div>
                <div>
                    <!-- Landlord can specify any positive value between 1-100 -->
                    <label for="lateFee">Late Fee Percentage Rate: </label>
                    <input type="number" id="lateFee" min="0" max="100" v-model="currentLease.lateFee">
                </div>
                <div>
                    <label for="status">Lease Status: </label>
                    <select id="status" v-model="currentLease.status">
                        <option>Active</option>
                        <option>Expired</option>
                        <option>Terminated</option>
                    </select>
                </div>
            </div>
            <div v-show="isValidForm">
                <button v-show="newLease"  @click.prevent="createLease">Submit New Lease</button>
                <button v-show="!newLease" @click.prevent="updateLease">Submit Updates</button>
            </div>
        </form>

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
            currentLease: {
                leaseId: '',
                userId: '',
                unitId: '',
                signedDate: '',
                startDate: '',
                rentLength: '',
                rentAmount: '',
                lateFee: '',
                status: 'Active'
            }
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
                this.currentLease.userId != "" &&
                this.currentLease.unitId != "" &&
                this.currentLease.signedDate != "" &&
                this.currentLease.rentLength != "" &&
                this.currentLease.rentAmount != "" &&
                this.currentLease.lateFee != ""
            );
        }
    },
    methods: {
        getLeasesForLandlord() {
            fetch('http://localhost:8080/api/leases/landlord/'+this.user.id, {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.leasesForLandlord = responseData; })
                    .catch(err => console.error(err));
        },
        getPropertiesForLandlord() {
            fetch('http://localhost:8080/api/properties/landlord/'+this.user.id, {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.propertiesForLandlord = responseData; })
                    .catch(err => console.error(err));
        },
        getAllRenters() {
            fetch('http://localhost:8080/api/users/renters', {
                method: 'GET',
                headers: { Authorization: 'Bearer ' + auth.getToken() },
                credentials: 'same-origin'
            }).then (response => { if(response.ok) { return response.json(); }
                }).then(responseData => { this.allRenters = responseData; })
                    .catch(err => console.error(err));
        },
        getCurrentLease() {
            this.leasesForLandlord.forEach((lease) => {
                if (lease.leaseId === this.currentLease.leaseId) {
                    this.currentLease.userId = lease.userId;
                    this.currentLease.unitId = lease.unitId;
                    this.currentLease.signedDate = lease.signedDate;
                    this.currentLease.rentLength = lease.rentLength;
                    this.currentLease.rentAmount = lease.rentAmount;
                    this.currentLease.lateFee = lease.lateFee;
                    this.currentLease.status = lease.status;
                }
            });         
        },
        createLease() {
            console.log(JSON.stringify(this.currentLease));
            fetch('http://localhost:8080/api/leases', {
                method: 'POST',
                headers: {
                    Authorization: 'Bearer ' + auth.getToken(),
                    'Content-Type': 'application/json'
                },
                credentials: 'same-origin',
                body: JSON.stringify(this.currentLease)
            }).then(response => {
                if (response.ok) {
                    this.resetLeaseValues();
                }
            }).then(this.getLeasesForLandlord())
                .catch(err => console.error(err));
        },
        updateLease() {
            console.log(JSON.stringify(this.currentLease));
            fetch('http://localhost:8080/api/leases/'+this.currentLease.leaseId, {
                method: 'PUT',
                headers: {
                    Authorization: 'Bearer ' + auth.getToken(),
                    'Content-Type': 'application/json'
                },
                credentials: 'same-origin',
                body: JSON.stringify(this.currentLease)
            }).then(response => {
                if (response.ok) {
                    this.resetLeaseValues();
                }
            }).then(this.getLeasesForLandlord())
                .catch(err => console.error(err));
        },
        resetLeaseValues() {
            this.currentLease.userId = '';
            this.currentLease.unitId = '';
            this.currentLease.signedDate = '';
            this.currentLease.rentLength = '';
            this.currentLease.rentAmount = '';
            this.currentLease.lateFee = '';
            this.currentLease.status = 'Active';

            // pull in updates to lease table
            this.getLeasesForLandlord();
        }
    },
    created() {
        this.getLeasesForLandlord();
        this.getPropertiesForLandlord(this.user.id);
        this.getAllRenters();
    }
}
</script>

<style>

</style>