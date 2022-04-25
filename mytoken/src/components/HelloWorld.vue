<template>
<div class="hello">
   <h1>Token Name</h1>
   <div v-if="tokenNames">
       <ul v-for="item in tokenNames" :key="item.id">
          <li>
               {{item.name}}
          </li>
      </ul>
    </div>
</div>
</template>
<script>
import gql from 'graphql-tag'
export default {
name: 'HelloWorld',
data () {
    return {
       // Initialize your apollo data
       tokenNames: [],
    }
},
apollo: {
    // Simple query that will update the 'hello' vue property
    tokenNames: gql`query getTokenNames{
            tokenNames{
               id,
               name
            }
         }`,
    },
}
</script>