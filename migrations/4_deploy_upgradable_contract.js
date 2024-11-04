// migrations/4_deploy_upgradable_contract.js
const { deployProxy } = require('@openzeppelin/truffle-upgrades');
const UpgradableContract = artifacts.require("UpgradableContract");

module.exports = async function (deployer, network, accounts) {
  try {
    // Set gas limit and gas price based on the environment
    const gasLimit = process.env.GAS_LIMIT || 6721975; // Default gas limit
    const gasPrice = process.env.GAS_PRICE || web3.utils.toWei('20', 'gwei'); // Default gas price

    console.log(`Deploying UpgradableContract on network: ${network}`);
    console.log(`Using gas limit: ${gasLimit}`);
    console.log(`Using gas price: ${gasPrice}`);

    // Deploy the UpgradableContract using a proxy
    const upgradableContractInstance = await deployProxy(UpgradableContract, { deployer, initializer: 'initialize', gas: gasLimit, gasPrice: gasPrice });
    
    console.log("UpgradableContract deployed at:", upgradableContractInstance.address);

    // Emit an event for tracking
    upgradableContractInstance.LogDeployment(upgradableContractInstance.address);

    // Optional: Verify the contract on Etherscan (if applicable)
    if (network === 'mainnet' || network === 'rinkeby') {
      await verifyContract(upgradableContractInstance.address);
    }
  } catch (error) {
    console.error("Error deploying UpgradableContract:", error);
  }
};

// Function to verify the contract on Etherscan
async function verifyContract(contractAddress) {
  const { exec } = require('child_process');
  const command = `npx truffle run verify UpgradableContract --network ${process.env.NETWORK} --contract ${contractAddress}`;

  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error verifying contract: ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`Verification stderr: ${stderr}`);
      return;
    }
    console.log(`Verification stdout: ${stdout}`);
  });
  }
