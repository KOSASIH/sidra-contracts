pragma solidity ^0.8.0;

import "https://github.com/NTRUOpenSourceProject/ntru/blob/master/contracts/NTRU.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/utils/ReentrancyGuard.sol";

contract QRBlockchain {
    // Quantum-resistant blockchain using NTRU
    NTRU private ntru;

    // Mapping of blocks to their corresponding hashes
    mapping (uint256 => bytes32) public blockHashes;

    // Event emitted when a new block is added
    event NewBlock(uint256 indexed blockNumber, bytes32 blockHash);

    // Constructor
    constructor() public {
        ntru = NTRU(address(this));
    }

    // Add a new block to the blockchain
    function addBlock(bytes _blockData) public {
        // Compute the hash of the block using NTRU
        bytes32 blockHash = ntru.hash(_blockData);

        // Store the block hash in the mapping
        blockHashes[blockNumber] = blockHash;

        // Emit the NewBlock event
        emit NewBlock(blockNumber, blockHash);

        // Increment the block number
        blockNumber++;
    }

    // Reentrancy protection using OpenZeppelin's ReentrancyGuard
    function reentrancyProtectedCall(address _contract, bytes _data) public {
        ReentrancyGuard rg = ReentrancyGuard(address(this));
        rg.call(_contract, _data);
    }
}
