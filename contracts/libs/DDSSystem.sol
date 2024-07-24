pragma solidity ^0.8.0;

import "https://github.com/ipfs/ipfs/blob/master/contracts/IPFS.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/access/AccessControl.sol";

contract DDSSystem {
    // IPFS contract for decentralized data storage
    IPFS private ipfs;

    // Mapping of data IDs to their corresponding IPFS CIDs
    mapping (uint256 => string) public dataIDs;

    // Mapping of users to their corresponding data access permissions
    mapping (address => mapping (uint256 => bool)) public dataAccess;

    // Event emitted when a new data is stored
    event NewDataStored(uint256 indexed dataID, string cid);

    // Event emitted when a user's data access permission is updated
    event DataAccessUpdated(address indexed user, uint256 indexed dataID, bool access);

    // Constructor
    constructor() public {
        ipfs = IPFS(address(this));
    }

    // Store new data in IPFS and update the data IDs mapping
    function storeData(bytes _data) public returns (uint256) {
        string cid = ipfs.store(_data);
        uint256 dataID = uint256(keccak256(abi.encodePacked(cid)));
        dataIDs[dataID] = cid;
        emit NewDataStored(dataID, cid);
        return dataID;
    }

    // Update a user's data access permission
    function updateDataAccess(address _user, uint256 _dataID, bool _access) public {
        dataAccess[_user][_dataID] = _access;
        emit DataAccessUpdated(_user, _dataID, _access);
    }

    // Access control using OpenZeppelin's AccessControl
    function hasAccess(address _user, uint256 _dataID) public view returns (bool) {
        return dataAccess[_user][_dataID];
    }

    // Get the IPFS CID associated with a data ID
    function getCID(uint256 _dataID) public view returns (string) {
        return dataIDs[_dataID];
    }
}
