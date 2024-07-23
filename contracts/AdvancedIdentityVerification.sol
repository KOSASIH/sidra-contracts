pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";

contract AdvancedIdentityVerification {
    using SafeMath for uint256;

    // Mapping of user identities
    mapping (address => Identity) public identities;

    // Event
    event IdentityCreated(address indexed user, string name, string email);
    event IdentityUpdated(address indexed user, string name, string email);

    // Struct to store identity information
    struct Identity {
        string name;
        string email;
        uint256 createdAt;
        uint256 updatedAt;
        bytes32[] documents; // array of document hashes
    }

    // Constructor
    constructor() public {
        // Initialize the contract owner
        owner = msg.sender;
    }

    // Create a new identity
    function createIdentity(string memory _name, string memory _email) public {
        require(!identities[msg.sender].createdAt, "Identity already exists");
        identities[msg.sender] = Identity(_name, _email, block.timestamp, block.timestamp, new bytes32[](0));
        emit IdentityCreated(msg.sender, _name, _email);
    }

    // Update an existing identity
    function updateIdentity(string memory _name, string memory _email) public {
        require(identities[msg.sender].createdAt, "Identity does not exist");
        identities[msg.sender].name = _name;
        identities[msg.sender].email = _email;
        identities[msg.sender].updatedAt = block.timestamp;
        emit IdentityUpdated(msg.sender, _name, _email);
    }

    // Add a document to an identity
    function addDocument(bytes32 _documentHash) public {
        require(identities[msg.sender].createdAt, "Identity does not exist");
        identities[msg.sender].documents.push(_documentHash);
    }

    // Verify an identity
    function verifyIdentity(address _user, string memory _name, string memory _email) public view returns (bool) {
        if (identities[_user].name == _name && identities[_user].email == _email) {
            return true;
        }
        return false;
    }
}
