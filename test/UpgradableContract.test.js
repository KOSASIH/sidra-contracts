// test/UpgradableContract.test.js
const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("UpgradableContract", function () {
    let UpgradableContract;
    let upgradableContract;

    beforeEach(async function () {
        UpgradableContract = await ethers.getContractFactory("UpgradableContract");
        upgradableContract = await upgrades.deployProxy(UpgradableContract, ["Initial Value"], { initializer: 'initialize' });
        await upgradableContract.deployed();
    });

    it("should return the initial value", async function () {
        expect(await upgradableContract.value()).to.equal("Initial Value");
    });

    it("should upgrade the contract", async function () {
        const UpgradableContractV2 = await ethers.getContractFactory("UpgradableContractV2");
        const upgraded = await upgrades.upgradeProxy (upgradableContract.address, UpgradableContractV2);
        expect(await upgraded.value()).to.equal("Upgraded Value");
    });
});
