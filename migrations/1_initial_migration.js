// migrations/1_initial_migration.js
const Migrations = artifacts.require("Migrations");

module.exports = async function (deployer, network, accounts) {
  try {
    // Set gas limit and gas price based on the environment
    const gasLimit = process.env.GAS_LIMIT || 6721975; // Default gas limit
    const gasPrice = process.env.GAS_PRICE || web3.utils.toWei('20', 'gwei'); // Default gas price

    console.log(`Deploying Migrations contract on network: ${network}`);
    console.log(`Using gas limit: ${gasLimit}`);
    console.log(`Using gas price: ${gasPrice}`);

    // Deploy the Migrations contract
    await deployer.deploy(Migrations, { gas: gasLimit, gasPrice: gasPrice });
    const migrationsInstance = await Migrations.deployed();

    console.log("Migrations contract deployed at:", migrationsInstance.address);

    // Optional: Verify the contract on Etherscan (if applicable)
    if (network === 'mainnet' || network === 'rinkeby') {
      await verifyContract(migrationsInstance.address);
    }
  } catch (error) {
    console.error("Error deploying Migrations contract:", error);
  }
};

// Function to verify the contract on Etherscan
async function verifyContract(contractAddress) {
  const { exec } = require('child_process');
  const command = `npx truffle run verify Migrations --network ${process.env.NETWORK} --contract ${contractAddress}`;

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
