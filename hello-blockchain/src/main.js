import Vue from 'vue'
import App from './App.vue'
import ethers from "./plugins/ethers";

Vue.config.productionTip = false
Vue.use(ethers)
new Vue({
  render: h => h(App),
}).$mount('#app')
