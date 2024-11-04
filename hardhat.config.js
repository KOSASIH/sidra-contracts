// hardhat.config.js

require('dotenv').config();
require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-etherscan');

module.exports = {
    solidity: "0.8.0",
    networks: {
        hardhat: {},
        mainnet: {
            url: process.env.NETWORK_URL,
            accounts: [`0x${process.env.PRIVATE_KEY}`],
        },
        rinkeby: {
            url: process.env.NETWORK_URL,
            accounts: [`0x${process.env.PRIVATE_KEY}`],
        },
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN_API_KEY,
    },
};
