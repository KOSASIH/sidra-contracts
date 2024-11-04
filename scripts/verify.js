// scripts/verify.js
const { run, ethers } = require("hardhat");

async function main() {
    // Replace with your contract address and name
    const contractAddress = "0xYourContractAddress"; // e.g., "0x1234567890abcdef1234567890abcdef12345678"
    const contractName = "YourContractName"; // e.g., "contracts/YourContract.sol:YourContract"

    // If your contract has constructor arguments, specify them here
    const constructorArguments = [
        // e.g., "Initial Value", 42
    ];

    console.log(`Verifying contract at address: ${contractAddress}`);
    
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: constructorArguments,
        });
        console.log("Contract verified successfully!");
    } catch (error) {
        if (error.message.includes("Already Verified")) {
            console.log("Contract is already verified.");
        } else {
            console.error("Error verifying contract:", error);
        }
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("Error in script:", error);
        process.exit(1);
    });
