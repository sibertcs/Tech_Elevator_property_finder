<template>
    <div id="create-lease">
        <h1> Create a lease to assign renters to a property:</h1>
        <form>
            <div>
                <label for="propertyName">Property: </label>
                <select id="propertyName">  
                    <!-- Will pull from method to pull only the properties for current Landlord user -->
                    <option value="" disabled selected>Select a Property</option>
                    <option value="1">Lisa's Ridge</option>
                    <option value="2">The Provident</option>
                    <option value="6">2251 Washington Ave</option>
                    <option value="9">Hilltop Apartments</option>
                </select>
            </div>
            <div>
                <label for="unitNumber">Unit: </label>
                <select id="unitNumber">
                    <!-- Will pull from method to pull only the Units for the Property selected above -->
                    <option value="" disabled selected>Select a Unit Number</option>
                    <option value="2">5633C</option>
                    <option value="3">5653B</option>
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
export default {

}
</script>

<style>

</style>