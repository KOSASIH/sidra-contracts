// test/MultiSigWallet.test.js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MultiSigWallet", function () {
    let MultiSigWallet;
    let multiSigWallet;
    let owners;
    let addr1;
    let addr2;
    let addr3;

    beforeEach(async function () {
        [addr1, addr2, addr3] = await ethers.getSigners();
        owners = [addr1.address, addr2.address, addr3.address];
        MultiSigWallet = await ethers.getContractFactory("MultiSigWallet");
        multiSigWallet = await MultiSigWallet.deploy(owners, 2); // 2 confirmations required
        await multiSigWallet.deployed();
    });

    it("should submit a transaction", async function () {
        const tx = await multiSigWallet.submitTransaction(addr1.address, ethers.utils.parseEther("1"), "0x");
        await tx.wait();
        expect(await multiSigWallet.transactionCount()).to.equal(1);
    });

    it("should confirm a transaction", async function () {
        await multiSigWallet.submitTransaction(addr1.address, ethers.utils.parseEther("1"), "0x");
        await multiSigWallet.connect(addr1).confirmTransaction(0);
        expect(await multiSigWallet.isConfirmed(0)).to.be.true;
    });

    it("should execute a confirmed transaction", async function () {
        await multiSigWallet.submitTransaction(addr1.address, ethers.utils.parseEther("1"), "0x");
        await multiSigWallet.connect(addr1).confirmTransaction(0);
        await multiSigWallet.connect(addr2).confirmTransaction(0);
        await expect(multiSigWallet.executeTransaction(0)).to.changeEtherBalance(addr1, ethers.utils.parseEther("1"));
    });
});
