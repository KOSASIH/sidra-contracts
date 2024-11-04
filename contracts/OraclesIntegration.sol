// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IOracle {
    function requestData(bytes32 requestId) external;
    function getData(bytes32 requestId) external view returns (uint256);
}

contract OraclesIntegration is AccessControl {
    using SafeMath for uint256;

    bytes32 public constant DATA_REQUESTER_ROLE = keccak256("DATA_REQUESTER_ROLE");
    bytes32 public constant DATA_VALIDATOR_ROLE = keccak256("DATA_VALIDATOR_ROLE");

    struct Oracle {
        address oracleAddress;
        bool isActive;
    }

    mapping(uint256 => Oracle) public oracles;
    uint256 public oracleCount;

    struct DataRequest {
        bytes32 requestId;
        uint256 timestamp;
        uint256 value;
        bool isFulfilled;
        address oracleAddress;
    }

    mapping(bytes32 => DataRequest) public dataRequests;

    event DataRequested(bytes32 indexed requestId, address indexed oracleAddress);
    event DataReceived(bytes32 indexed requestId, uint256 value, address indexed oracleAddress);
    event OracleAdded(address indexed oracleAddress);
    event OracleRemoved(address indexed oracleAddress);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function addOracle(address oracleAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
        oracles[oracleCount] = Oracle({ oracleAddress: oracleAddress, isActive: true });
        emit OracleAdded(oracleAddress);
        oracleCount++;
    }

    function removeOracle(uint256 oracleId) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(oracleId < oracleCount, "Oracle does not exist");
        oracles[oracleId].isActive = false;
        emit OracleRemoved(oracles[oracleId].oracleAddress);
    }

    function requestData(bytes32 requestId) external onlyRole(DATA_REQUESTER_ROLE) {
        for (uint256 i = 0; i < oracleCount; i++) {
            if (oracles[i].isActive) {
                IOracle(oracles[i].oracleAddress).requestData(requestId);
                emit DataRequested(requestId, oracles[i].oracleAddress);
            }
        }
    }

    function receiveData(bytes32 requestId, uint256 value, address oracleAddress) external {
        require(isOracle(oracleAddress), "Invalid oracle");
        require(!dataRequests[requestId].isFulfilled, "Data already fulfilled");

        dataRequests[requestId] = DataRequest({
            requestId: requestId,
            timestamp: block.timestamp,
            value: value,
            isFulfilled: true,
            oracleAddress: oracleAddress
        });

        emit DataReceived(requestId, value, oracleAddress);
    }

    function getData(bytes32 requestId) external view returns (uint256) {
        require(dataRequests[requestId].isFulfilled, "Data not fulfilled");
        return dataRequests[requestId].value;
    }

    function isOracle(address oracleAddress) internal view returns (bool) {
        for (uint256 i = 0; i < oracleCount; i++) {
            if (oracles[i].oracleAddress == oracleAddress && oracles[i].isActive) {
                return true;
            }
        }
        return false;
    }

    function validateData(bytes32 requestId) external onlyRole(DATA_VALIDATOR_ROLE) {
        require(dataRequests[requestId].isFulfilled, "Data not fulfilled");
        require(block.timestamp <= dataRequests[requestId].timestamp + 1 days, "Data expired");
        // Additional validation logic can be added here
    }
}
