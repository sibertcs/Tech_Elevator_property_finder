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
            <option value="1">1 Br</option>
            <option value="2">2 Br</option>
            <option value="3">3 Br</option>
            <option value="4">4 Br</option>
        </select>
        <button @click.prevent="filter" type="submit">Filter</button>
    </form>
    <div>
        <div v-for="property in shownProperties" :key="property.propertyId">
           <h3>{{property.propertyName}}</h3> 
        </div>    
    </div>    
  </div>
</template>

<script>
import propertyData from '../assets/data/properties.json';

export default {
    data() {
        return {
            shownProperties: propertyData,
            textSearch: '',
            brFilter: ''
        }
    },
    methods: {
        search() {
            console.log('searching');
            this.shownProperties = this.shownProperties.filter(p => p.propertyName.includes(this.textSearch));
        },
        filter() {
            console.log('filtering');
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
    }

}
</script>

<style>

</style>