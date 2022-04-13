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
    <div style="margin: 10px" v-if="isConnectedWallet">
      <label for="isbn">ISBN:</label>
      <input id="isbn" type="text" v-model="new_book.isbn" /><br />
      <label for="author">Author:</label>
      <input type="text" id="author" v-model="new_book.author" /><br />
      <label for="title">Title</label>
      <input type="text" id="title" v-model="new_book.title" /><br />
      <button class="primaryButton" @click="addBook()">Add</button>
      <button class="primaryButton" @click="showListBook()">ShowBook</button>
    </div>
    <div v-if="isConnectedWallet &&listBook.length > 0">
      <h3>All Book Added</h3>
    </div>
  </div>
</template>

<script>
// import Greeter from "../../blockchain/artifacts/contracts/Greeter.sol/Greeter.json";
import Library from "../../blockchain/artifacts/contracts/Library.sol/Library.json";
export default {
  name: "HelloWorld",
  props: {
    msg: String,
  },
  data() {
    return {
      currentAccount: null,
      currentContract: null,
      contractAddress: "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512",
      new_book: {
        isbn: "",
        title: "",
        author: "",
      },
      isConnectedWallet: false,
      listBook: [],
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
        this.isConnectedWallet = true;
        return true;
      } catch (error) {
        console.log(error);
        return false;
      }
    },

    attachContract: async function () {
      const provider = new this.$ethers.providers.JsonRpcProvider(
        "http://127.0.0.1:7545"
      );
      const signer = provider.getSigner();
      //const network = await provider.getNetwork();
      //console.log(network);
      const abi = Library.abi;
      // The Contract object
      this.currentContract = new this.$ethers.Contract(
        this.contractAddress,
        abi,
        signer
      );
      this.isConnectedWallet = true;
      // console.log(await this.currentContract.symbol());
    },

    addBook: async function (e) {
      this.attachContract = e;
      console.log(
        "Adding Book: ",
        this.new_book.isbn,
        this.new_book.title,
        this.new_book.author
      );
      await this.currentContract.addBook(
        this.new_book.isbn,
        this.new_book.title,
        this.new_book.author
      );
    },
    
    showListBook: async function () {
      console.log("getting List Book")
      this.listBook = await this.contractAddress.getAllBook();
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
