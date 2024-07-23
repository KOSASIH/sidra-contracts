pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";

contract SidraIdentity {
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
    }

    // Constructor
    constructor() public {
        // Initialize the contract owner
        owner = msg.sender;
    }

    // Create a new identity
    function createIdentity(string memory _name, string memory _email) public {
        require(!identities[msg.sender].createdAt, "Identity already exists");
        identities[msg.sender] = Identity(_name, _email, block.timestamp, block.timestamp);
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

    // Get an identity
    function getIdentity(address _user) public view returns (Identity memory) {
        return identities[_user];
    }
}
