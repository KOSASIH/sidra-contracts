// truffle-config.js

require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 7545,
            network_id: "*", // Match any network id
        },
        mainnet: {
            provider: () => new HDWalletProvider(process.env.PRIVATE_KEY, process.env.NETWORK_URL),
            network_id: 1, // Mainnet ID
            gas: 5500000,
            gasPrice: 20000000000, // 20 gwei
        },
        rinkeby: {
            provider: () => new HDWalletProvider(process.env.PRIVATE_KEY, process.env.NETWORK_URL),
            network_id: 4, // Rinkeby ID
            gas: 5500000,
            gasPrice: 20000000000, // 20 gwei
        },
    },

    compilers: {
        solc: {
            version: "0.8.0", // Specify the Solidity version
        },
    },
};
