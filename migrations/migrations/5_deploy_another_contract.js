// migrations/5_deploy_another_contract.js
const AnotherContract = artifacts.require("AnotherContract");

module.exports = async function (deployer, network, accounts) {
  try {
    // Set gas limit and gas price based on the environment
    const gasLimit = process.env.GAS_LIMIT || 6721975; // Default gas limit
    const gasPrice = process.env.GAS_PRICE || web3.utils.toWei('20', 'gwei'); // Default gas price

    console.log(`Deploying AnotherContract on network: ${network}`);
    console.log(`Using gas limit: ${gasLimit}`);
    console.log(`Using gas price: ${gasPrice}`);

    // Dynamic constructor parameters from environment variables
    const param1 = process.env.PARAM1 || "default_value_1"; // Default value for param1
    const param2 = process.env.PARAM2 || "default_value_2"; // Default value for param2

    console.log(`Constructor parameters: param1 = ${param1}, param2 = ${param2}`);

    // Deploy the AnotherContract
    const anotherContractInstance = await deployer.deploy(AnotherContract, param1, param2, { gas: gasLimit, gasPrice: gasPrice });
    
    console.log("AnotherContract deployed at:", anotherContractInstance.address);

    // Emit an event for tracking
    anotherContractInstance.LogDeployment(anotherContractInstance.address, param1, param2);

    // Optional: Verify the contract on Etherscan (if applicable)
    if (network === 'mainnet' || network === 'rinkeby') {
      await verifyContract(anotherContractInstance.address);
    }
  } catch (error) {
    console.error("Error deploying AnotherContract:", error);
  }
};

// Function to verify the contract on Etherscan
async function verifyContract(contractAddress) {
  const { exec } = require('child_process');
  const command = `npx truffle run verify AnotherContract --network ${process.env.NETWORK} --contract ${contractAddress}`;

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
