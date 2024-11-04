// test/SidraToken.test.js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SidraToken", function () {
    let SidraToken;
    let sidraToken;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        SidraToken = await ethers.getContractFactory("SidraToken");
        sidraToken = await SidraToken.deploy();
        await sidraToken.deployed();
    });

    it("should have the correct name and symbol", async function () {
        expect(await sidraToken.name()).to.equal("Sidra Token");
        expect(await sidraToken.symbol()).to.equal("SDR");
    });

    it("should mint tokens to an address", async function () {
        await sidraToken.mint(addr1.address, ethers.utils.parseEther("100"));
        expect(await sidraToken.balanceOf(addr1.address)).to.equal(ethers.utils.parseEther("100"));
    });

    it("should burn tokens from an address", async function () {
        await sidraToken.mint(addr1.address, ethers.utils.parseEther("100"));
        await sidraToken.burn(addr1.address, ethers.utils.parseEther("50"));
        expect(await sidraToken.balanceOf(addr1.address)).to.equal(ethers.utils.parseEther("50"));
    });
});
