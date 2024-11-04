// scripts/deploy.js
const { ethers, upgrades } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Deploy AccessControl contract
    const AccessControl = await ethers.getContractFactory("AccessControl");
    const accessControl = await AccessControl.deploy();
    await accessControl.deployed();
    console.log("AccessControl deployed to:", accessControl.address);

    // Deploy MultiSigWallet contract
    const MultiSigWallet = await ethers.getContractFactory("MultiSigWallet");
    const multiSigWallet = await MultiSigWallet.deploy([deployer.address], 1); // 1 confirmation required
    await multiSigWallet.deployed();
    console.log("MultiSigWallet deployed to:", multiSigWallet.address);

    // Deploy UpgradableContract using proxy
    const UpgradableContract = await ethers.getContractFactory("UpgradableContract");
    const upgradableContract = await upgrades.deployProxy(UpgradableContract, ["Initial Value"], { initializer: 'initialize' });
    await upgradableContract.deployed();
    console.log("UpgradableContract deployed to:", upgradableContract.address);

    // Deploy SidraToken contract
    const SidraToken = await ethers.getContractFactory("SidraToken");
    const sidraToken = await SidraToken.deploy();
    await sidraToken.deployed();
    console.log("SidraToken deployed to:", sidraToken.address);

    // Additional contracts can be deployed here...
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
