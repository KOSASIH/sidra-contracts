// scripts/interact.js
const { ethers } = require("hardhat");

async function main() {
    const [signer] = await ethers.getSigners();
    console.log("Interacting with contracts using account:", signer.address);

    // Replace with your deployed contract addresses
    const accessControlAddress = "0xYourAccessControlAddress";
    const multiSigWalletAddress = "0xYourMultiSigWalletAddress";
    const upgradableContractAddress = "0xYourUpgradableContractAddress";
    const sidraTokenAddress = "0xYourSidraTokenAddress";

    // Interact with AccessControl contract
    const AccessControl = await ethers.getContractAt("AccessControl", accessControlAddress);
    await AccessControl.grantRole(ethers.utils.id("ADMIN_ROLE"), signer.address);
    console.log("Granted ADMIN_ROLE to:", signer.address);

    // Interact with MultiSigWallet contract
    const MultiSigWallet = await ethers.getContractAt("MultiSigWallet", multiSigWalletAddress);
    const tx = await MultiSigWallet.submitTransaction(signer.address, ethers.utils.parseEther("0.1"), "0x");
    await tx.wait();
    console.log("Submitted transaction to MultiSigWallet");

    // Interact with UpgradableContract
    const UpgradableContract = await ethers.getContractAt("UpgradableContract", upgradableContractAddress);
    const currentValue = await UpgradableContract.value();
    console.log("Current value in UpgradableContract:", currentValue);

    // Interact with SidraToken contract
    const SidraToken = await ethers.getContractAt("SidraToken", sidraTokenAddress);
    await SidraToken.mint(signer.address, ethers.utils.parseEther("100"));
    console.log("Minted 100 SDR tokens to:", signer.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
