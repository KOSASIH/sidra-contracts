// test/OraclesIntegration.test.js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("OraclesIntegration", function () {
    let OraclesIntegration;
    let oraclesIntegration;
    let addr1;

    beforeEach(async function () {
        [addr1] = await ethers.getSigners();
        OraclesIntegration = await ethers.getContractFactory("OraclesIntegration");
        oraclesIntegration = await OraclesIntegration.deploy();
        await oraclesIntegration.deployed();
    });

    it("should request data from an oracle", async function () {
        await oraclesIntegration.requestData("0x...", "0x...");
        expect(await oraclesIntegration.dataRequested()).to.be.true;
    });

    it("should receive data from an oracle", async function () {
        await oraclesIntegration.requestData("0x...", "0x...");
        await oraclesIntegration.receiveData("0x...", "0x...");
        expect(await oraclesIntegration.dataReceived()).to.be.true;
    });
});
