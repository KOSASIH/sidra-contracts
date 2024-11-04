// migrations/3_deploy_multi_sig_wallet.js
const MultiSigWallet = artifacts.require("MultiSigWallet");

module.exports = async function (deployer, network, accounts) {
  try {
    // Set gas limit and gas price based on the environment
    const gasLimit = process.env.GAS_LIMIT || 6721975; // Default gas limit
    const gasPrice = process.env.GAS_PRICE || web3.utils.toWei('20', 'gwei'); // Default gas price

    console.log(`Deploying MultiSigWallet contract on network: ${network}`);
    console.log(`Using gas limit: ${gasLimit}`);
    console.log(`Using gas price: ${gasPrice}`);

    // Dynamic owner assignment from environment variables
    const owners = process.env.OWNERS ? process.env.OWNERS.split(',') : [accounts[0], accounts[1], accounts[2]];
    const requiredConfirmations = process.env.REQUIRED_CONFIRMATIONS || 2; // Default required confirmations

    console.log(`Owners assigned: ${owners.join(', ')}`);
    console.log(`Required confirmations: ${requiredConfirmations}`);

    // Deploy the MultiSigWallet contract
    await deployer.deploy(MultiSigWallet, owners, requiredConfirmations, { gas: gasLimit, gasPrice: gasPrice });
    const multiSigWalletInstance = await MultiSigWallet.deployed();

    console.log("MultiSigWallet contract deployed at:", multiSigWalletInstance.address);

    // Emit an event for tracking
    multiSigWalletInstance.LogDeployment(multiSigWalletInstance.address, owners, requiredConfirmations);

    // Optional: Verify the contract on Etherscan (if applicable)
    if (network === 'mainnet' || network === 'rinkeby') {
      await verifyContract(multiSigWalletInstance.address);
    }
  } catch (error) {
    console.error("Error deploying MultiSigWallet contract:", error);
  }
};

// Function to verify the contract on Etherscan
async function verifyContract(contractAddress) {
  const { exec } = require('child_process');
  const command = `npx truffle run verify MultiSigWallet --network ${process.env.NETWORK} --contract ${contractAddress}`;

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
