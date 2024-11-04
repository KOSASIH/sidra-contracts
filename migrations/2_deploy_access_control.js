// migrations/2_deploy_access_control.js
const AccessControl = artifacts.require("AccessControl");

module.exports = async function (deployer, network, accounts) {
  try {
    // Set gas limit and gas price based on the environment
    const gasLimit = process.env.GAS_LIMIT || 6721975; // Default gas limit
    const gasPrice = process.env.GAS_PRICE || web3.utils.toWei('20', 'gwei'); // Default gas price

    console.log(`Deploying AccessControl contract on network: ${network}`);
    console.log(`Using gas limit: ${gasLimit}`);
    console.log(`Using gas price: ${gasPrice}`);

    // Deploy the AccessControl contract
    await deployer.deploy(AccessControl, { gas: gasLimit, gasPrice: gasPrice });
    const accessControlInstance = await AccessControl.deployed();

    console.log("AccessControl contract deployed at:", accessControlInstance.address);

    // Automatically assign roles to specific addresses
    const adminAddress = accounts[0]; // The first account is the admin
    const dataRequesterAddress = accounts[1]; // Example address for data requester
    const dataValidatorAddress = accounts[2]; // Example address for data validator

    await accessControlInstance.grantRole(await accessControlInstance.DATA_REQUESTER_ROLE(), dataRequesterAddress);
    await accessControlInstance.grantRole(await accessControlInstance.DATA_VALIDATOR_ROLE(), dataValidatorAddress);
    console.log(`Roles assigned: DATA_REQUESTER to ${dataRequesterAddress}, DATA_VALIDATOR to ${dataValidatorAddress}`);

    // Optional: Verify the contract on Etherscan (if applicable)
    if (network === 'mainnet' || network === 'rinkeby') {
      await verifyContract(accessControlInstance.address);
    }
  } catch (error) {
    console.error("Error deploying AccessControl contract:", error);
  }
};

// Function to verify the contract on Etherscan
async function verifyContract(contractAddress) {
  const { exec } = require('child_process');
  const command = `npx truffle run verify AccessControl --network ${process.env.NETWORK} --contract ${contractAddress}`;

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
