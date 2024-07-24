pragma solidity ^0.8.0;

import "https://github.com/uport-project/uport-identity/blob/master/contracts/Identity.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/access/AccessControl.sol";

contract DIMSystem {
    // Decentralized identity management system using uPort
    Identity private identity;

    // Mapping of users to their corresponding identities
    mapping (address => Identity) public userIDs;

    // Event emitted when a new user is registered
    event NewUserRegistered(address indexed user, Identity identity);

    // Constructor
    constructor() public {
        identity = Identity(address(this));
    }

    // Register a new user
    function registerUser(address _user, string _name, string _email) public {
        // Create a new identity for the user using uPort
        Identity userIdentity = identity.createIdentity(_name, _email);

        // Store the user's identity in the mapping
        userIDs[_user] = userIdentity;

        // Emit the NewUserRegistered event
        emit NewUserRegistered(_user, userIdentity);
    }

    // Access control using OpenZeppelin's AccessControl
    function hasAccess(address _user, string _permission) public view returns (bool) {
        return userIDs[_user].hasPermission(_permission);
    }
}
