import VueApollo from 'vue-apollo'
import ApolloClient from 'apollo-boost'
import Vue from 'vue'
import App from './App.vue'

Vue.use(VueApollo)

const apolloClient = new ApolloClient({
// You should use an absolute URL here
   uri: 'http://localhost:8000/subgraphs/name/mit'
})
const apolloProvider = new VueApollo({
    defaultClient: apolloClient,
})

new Vue({
   // router,
   apolloProvider,
   render: h => h(App),
}).$mount('#app')
