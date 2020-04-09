<template>
  <div>
    <form>
        <label for="textSearch">Search by Address or Name</label>
        <input type="text" id="textSearch" v-model="textSearch">
        <button @click.prevent="search" type="submit">Search</button>
    </form>
    <br>
    <form>
        <label for="filterBr">Filter by # of Bedrooms</label>
        <select id="filterBr" v-model="brFilter">
            <option value=""></option>
            <option value="1">1 Br</option>
            <option value="2">2 Br</option>
            <option value="3">3 Br</option>
            <option value="4">4 Br</option>
        </select>
        <label for="filterRent">Filter by $ Up To:</label>
        <select id="filterBr" v-model="upperRentFilter">
            <option value=""></option>
            <option value="500">$500/month</option>
            <option value="750">$750/month</option>
            <option value="1000">$1000/month</option>
            <option value="1500">$1500/month</option>
            <option value="2000">$2000/month</option>
        </select>
        <label for="filterLocation">Filter by Location:</label>
        <select id="filterLocation" v-model="locationFilter">
            <option value=""></option>
            <option>Downtown</option>
            <option>East Side</option>
            <option>West Side</option>
            <option>North Side</option>
            <option>NKY</option>
        </select>
        <button @click.prevent="filter" type="submit">Filter</button>
    </form>
    <div>
        <div v-for="property in shownProperties" :key="property.propertyId">
           <h3>{{property.propertyName}} @ {{property.streetAddress}}</h3> 
        </div>    
    </div>    
  </div>
</template>

<script>
// import auth from '../auth';
export default {
    data() {
        return {
            allProperties: [],
            shownProperties: [],
            textSearch: '',
            brFilter: '',
            upperRentFilter: '',
            locationFilter: ''
        }
    },
    methods: {
        search() {
            console.log('searching');
            this.shownProperties = this.allProperties.filter(p => {
                let nameAndAddress = p.propertyName + p.streetAddress;
                nameAndAddress = nameAndAddress.toLowerCase();
                return nameAndAddress.includes(this.textSearch.toLowerCase())
            });
        },
        filter() {
            console.log('filtering');
            this.shownProperties = this.allProperties;
            if(this.brFilter !== '') {
                this.shownProperties = this.shownProperties.filter(p => {
                    let result = false;
                    p.units.forEach(u => {
                        if(u.bedCount == this.brFilter) {
                            result = true;
                        }
                    });
                    return result;
                });
            }
            if(this.upperRentFilter !== '') {
                this.shownProperties = this.shownProperties.filter(p => {
                    let result = false;
                    p.units.forEach(u => {
                        if(u.price <= parseInt(this.upperRentFilter)) {
                            result = true;
                        }
                    });
                    return result;
                });
            }
            if(this.locationFilter !== '') {
                this.shownProperties = this.shownProperties.filter(p => {
                    return p.location === this.locationFilter;
                });
            }
        }
    },
    created() {
        fetch('http://localhost:8080/api/properties')
        .then (response => {
            if(response.ok) {
                return response.json();
            }
        }).then(responseData => {
            this.allProperties = responseData;
            this.shownProperties = responseData;
        });
    }

}
</script>

<style>

</style>