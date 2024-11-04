// scripts/fetch.js
const { ethers } = require("hardhat");

async function main() {
    // Replace with your contract address and name
    const contractAddress = "0xYourContractAddress"; // e.g., "0x1234567890abcdef1234567890abcdef12345678"
    const contractName = "YourContractName"; // e.g., "contracts/YourContract.sol:YourContract"

    // Create an instance of the contract
    const contract = await ethers.getContractAt(contractName, contractAddress);

    // Fetch data from the contract
    try {
        // Example of fetching a public variable
        const publicVariable = await contract.publicVariable(); // Replace with your contract's public variable
        console.log("Public Variable:", publicVariable.toString());

        // Example of calling a function that returns a value
        const value = await contract.yourFunction(); // Replace with your contract's function
        console.log("Value from yourFunction:", value.toString());

        // Example of fetching an array or mapping
        const itemCount = await contract.itemCount(); // Replace with your contract's method to get item count
        console.log("Item Count:", itemCount.toString());

        for (let i = 0; i < itemCount; i++) {
            const item = await contract.items(i); // Replace with your contract's method to get items
            console.log(`Item ${i}:`, item);
        }

    } catch (error) {
        console.error("Error fetching data from contract:", error);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("Error in script:", error);
        process.exit(1);
    });
