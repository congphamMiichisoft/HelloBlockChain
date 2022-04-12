<template>
  <div>
    <h3>Connect Wallet</h3>
    <div v-if="!currentAccount">
      <button class="primaryButton" @click="connectWallet">
        Connect Wallet
      </button>
    </div>

    <div v-if="!currentContract">
      <button class="primaryButton" @click="attachContract">
        Attach Contract
      </button>
    </div>
  </div>
</template>

<script>
import Greeter from "../../blockchain/artifacts/contracts/Greeter.sol/Greeter.json";
export default {
  name: "HelloWorld",
  props: {
    msg: String,
  },
  data() {
    return {
      currentAccount: null,
      currentContract: null,
      contractAddress: "0x830E14385f55Ca0c36BA9c16141E248CC73443f5",
    };
  },
  mounted() {
    this.checkConnectedWalletExist();
  },
  methods: {
    checkConnectedWalletExist: async function () {
      try {
        const { ethereum } = window;
        if (!ethereum) {
          alert("Make sure you have metamask!");
          return false;
        } else {
          console.log("We have the ethereum object", ethereum);
        }
        const accounts = await ethereum.request({ method: "eth_accounts" });
        if (accounts.length !== 0) {
          const account = accounts[0];
          console.log("Found an authorized account:", account);
          this.currentAccount = account;
          return true;
        } else {
          console.log("No authorized account found");
          return false;
        }
      } catch (error) {
        console.log(error);
        return false;
      }
    },

    connectWallet: async function () {
      try {
        const { ethereum } = window;
        if (!ethereum) {
          alert("Get MetaMask!");
          return;
        }
        const accounts = await ethereum.request({
          method: "eth_requestAccounts",
        });
        console.log("Connected", accounts[0]);
        this.currentAccount = accounts[0];
      } catch (error) {
        console.log(error);
      }
    },

    attachContract: async function () {
      const provider = new this.$ethers.providers.JsonRpcProvider(
        "http://127.0.0.1:7545"
      );
      const signer = provider.getSigner();
      //const network = await provider.getNetwork();
      //console.log(network);
      const abi = Greeter.abi;
      // The Contract object
      this.currentContract = new this.$ethers.Contract(
        this.contractAddress,
        abi,
        signer
      );
      // console.log(await this.currentContract.symbol());
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
