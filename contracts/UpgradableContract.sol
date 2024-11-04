// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UpgradableContract {
    address public implementation;
    address public admin;

    event Upgraded(address indexed newImplementation);

    modifier onlyAdmin() {
        require(msg.sender == admin, "UpgradableContract: Caller is not the admin");
        _;
    }

    constructor(address _initialImplementation) {
        implementation = _initialImplementation;
        admin = msg.sender;
    }

    function upgradeTo(address newImplementation) external onlyAdmin {
        require(newImplementation != address(0), "UpgradableContract: New implementation is the zero address");
        implementation = newImplementation;
        emit Upgraded(newImplementation);
    }

    fallback() external {
        _delegate(implementation);
    }

    receive() external payable {
        _delegate(implementation);
    }

    function _delegate(address _implementation) internal {
        require(_implementation != address(0), "UpgradableContract: Implementation is the zero address");
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // and we allocate a memory area for the function call.
            calldatacopy(0, 0, calldatasize())
            // Call the implementation contract
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)
            // Copy the returned data
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) } // If delegatecall failed, revert
            default { return(0, returndatasize()) } // Return the data from the call
        }
    }
}
