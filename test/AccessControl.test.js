// test/AccessControl.test.js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AccessControl", function () {
    let AccessControl;
    let accessControl;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        AccessControl = await ethers.getContractFactory("AccessControl");
        accessControl = await AccessControl.deploy();
        await accessControl.deployed();
    });

    it("should grant role to an address", async function () {
        await accessControl.grantRole(ethers.utils.id("ADMIN_ROLE"), addr1.address);
        expect(await accessControl.hasRole(ethers.utils.id("ADMIN_ROLE"), addr1.address)).to.be.true;
    });

    it("should revoke role from an address", async function () {
        await accessControl.grantRole(ethers.utils.id("ADMIN_ROLE"), addr1.address);
        await accessControl.revokeRole(ethers.utils.id("ADMIN_ROLE"), addr1.address);
        expect(await accessControl.hasRole(ethers.utils.id("ADMIN_ROLE"), addr1.address)).to.be.false;
    });

    it("should only allow owner to grant roles", async function () {
        await expect(accessControl.connect(addr1).grantRole(ethers.utils.id("ADMIN_ROLE"), addr2.address)).to.be.revertedWith("AccessControl: sender must be an admin to grant");
    });

    it("should emit RoleGranted event", async function () {
        await expect(accessControl.grantRole(ethers.utils.id("ADMIN_ROLE"), addr1.address))
            .to.emit(accessControl, "RoleGranted")
            .withArgs(ethers.utils.id("ADMIN_ROLE"), addr1.address, owner.address);
    });
});
