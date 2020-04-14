<template>
    <div id="addOrUpdateLease" class="container is-fluid">
        <p>You are logged in as {{user.sub}} as a {{user.rol}} and has the id of {{user.id}}.</p>
        <h1> Lease Management Console</h1>

        <h2>All Existing Leases:</h2>
        <b-table
            :data="leasesForLandlord"
            :columns="columns">
        </b-table>
        <br/>
        <br/>

        <form>
            <section>
                <b-field horizontal label="Options">
                    <b-radio name="addOrUpdate"
                        checked
                        v-model="newLease"
                        :native-value="true"
                        @input="resetLeaseValues">
                        Add New Lease
                    </b-radio>
                    <b-radio name="addOrUpdate"
                        v-model="newLease"
                        :native-value="false"
                        @input="resetLeaseValues">
                        Update Existing Lease
                    </b-radio>
                </b-field>
            </section>
            <br/>

            <!-- Prompt for Lease when 'Updating Existing Lease' chosen above -->
            <div v-show="!newLease">
                <b-field horizontal label="Lease ID">
                    <b-select v-model="currentLease.leaseId" @input="getCurrentLease" placeholder="Select a Lease">
                        <option v-for="lease in leasesForLandlord" :key="lease.leaseId" :value="lease.leaseId">
                            {{ `${lease.leaseId}: ${lease.propertyName} - ${lease.unitNumber} (${lease.status })` }}
                        </option>
                    </b-select>
                </b-field>
            </div>

            <!-- Prompt for Property and Unit for new leases only -->
            <div v-show="newLease">
                <div>
                    <b-field horizontal label="Property">
                        <b-select v-model="selectedPropertyId" placeholder="Select a Property">
                        <!-- shows only the properties for current Landlord user -->
                            <option v-for="prop in propertiesForLandlord" 
                                    :key="prop.propertyId" 
                                    :value="prop.propertyId">
                                {{ prop.propertyName }}
                            </option>
                        </b-select>
                    </b-field>
                </div>
                <div>
                    <b-field horizontal label="Unit">
                        <b-select v-model="currentLease.unitId" placeholder="Select a Unit Number">
                        <!-- shows only the Units for the Property selected above -->
                            <option v-for="unit in getUnitsForSelectedProperty" 
                                    :key="unit.unitId" 
                                    :value="unit.unitId">
                                {{ unit.unitNumber }}
                            </option>
                        </b-select>
                    </b-field>
                </div>
            </div>

            <!-- Show remaining fields for new leases, or when an existing lease has been selected -->
            <div v-show="currentLease.unitId !== ''">
                <div>
                    <b-field horizontal label="Renter Name">
                        <b-select v-model="currentLease.userId" placeholder="Select a Renter" icon="account">
                        <!-- shows all Renter users -->
                            <option v-for="renter in allRenters"
                                    :key="renter.id"
                                    :value="renter.id">
                                {{ `${renter.lastName}, ${renter.firstName} (${renter.email})` }}
                            </option>
                        </b-select>
                    </b-field>
                </div>
                <div>
                    <b-field horizontal label="Signed Date">
                        <b-datepicker
                            v-model="currentLease.signedDate"
                            placeholder="Type or select a date..."
                            icon="calendar-today"
                            editable
                            >
                        </b-datepicker>
                    </b-field>
                </div>
                <div v-show="newLease">
                    <b-field horizontal label="Start Date">
                        <b-datepicker
                            v-model="currentLease.startDate"
                            placeholder="Type or select a date..."
                            icon="calendar-today"
                            editable
                            >
                        </b-datepicker>
                    </b-field>
                </div>
                <div>
                    <!-- Landlord can specify any positive integer value -->
                    <b-field horizontal label="Lease Term (Months)">
                        <b-numberinput min="1" v-model="currentLease.rentLength" controls-position="compact">
                        </b-numberinput>
                    </b-field>
                </div>
                <div>
                    <!-- Landlord can specify any positive dollar value -->
                    <b-field horizontal label="Rent Amount">
                        <b-numberinput min="0" v-model="currentLease.rentAmount" controls-position="compact">
                        </b-numberinput>
                    </b-field>
                </div>
                <div>
                    <!-- Landlord can specify any positive value between 1-100 -->
                    <b-field horizontal label="Late Fee %">
                        <b-numberinput min="0" max="100" v-model="currentLease.lateFee" controls-position="compact">
                        </b-numberinput>
                    </b-field>
                </div>
                <div>
                    <b-field horizontal label="Lease Status">
                        <b-select v-model="currentLease.status" placeholder="Select a name">
                            <option>Active</option>
                            <option>Expired</option>
                            <option>Terminated</option>
                        </b-select>
                    </b-field>
                </div>
            </div>
            <div v-show="isValidForm">
                <b-field horizontal label="">
                    <b-button type="is-primary" v-show="newLease"  @click.prevent="createLease">Submit New Lease</b-button>
                    <b-button type="is-primary" v-show="!newLease" @click.prevent="updateLease">Submit Updates</b-button>
                </b-field>
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
                leaseId: 0,
                userId: 0,
                unitId: '',
                signedDate: new Date(),
                startDate: new Date(),
                rentLength: 1,
                rentAmount: 0,
                lateFee: 0,
                status: 'Active'
            },
            columns: [
                {
                    field: 'leaseId',
                    label: 'Lease #',
                    width: '100',
                    numeric: true,
                    searchable: true,
                },
                {
                    field: 'propertyName',
                    label: 'Property',
                    searchable: true,
                },
                {
                    field: 'unitNumber',
                    label: 'Unit',
                    width: '100',
                    searchable: true,
                },
                {
                    field: 'status',
                    label: 'Status',
                    width: '100',
                    searchable: true,
                },
                {
                    field: 'signedDate',
                    label: 'Signed',
                    width: '150',
                    searchable: true,
                },
                {
                    field: 'rentLength',
                    label: 'Term',
                    width: '100',
                    numeric: true,
                },
                {
                    field: 'rentAmount',
                    label: 'Rent',
                    numeric: true,
                },
                {
                    field: 'renterName',
                    label: 'Renter Name',
                    searchable: true,
                },
                {
                    field: 'renterEmail',
                    label: 'Renter Email',
                }
            ]
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
                    this.currentLease.signedDate = new Date(lease.signedDate);
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
b-datepicker {
    width: 300px;
}

</style>