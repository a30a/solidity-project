var HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {

  networks: {
    ropsten: {
    provider: () => new HDWalletProvider("", `https://ropsten.infura.io/v3/`),
    network_id: 3,       // Ropsten's id
    gas: 5500000,        // Ropsten has a lower block limit than mainnet
    confirmations: 2,    // # of confs to wait between deployments. (default: 0)
    timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
    skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },

  },
  compilers: {
    solc: {
      version: "0.6.6",
    },
  },
};
