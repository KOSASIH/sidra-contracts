// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    struct RoleData {
        mapping(address => bool) members;
        bytes32 adminRole;
        bool isRevocable;
    }

    mapping(bytes32 => RoleData) private _roles;
    mapping(address => mapping(bytes32 => uint256)) private _revocationTimelock;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    modifier onlyRole(bytes32 role) {
        require(hasRole(role, msg.sender), "AccessControl: Access denied");
        _;
    }

    modifier onlyAdmin(bytes32 role) {
        require(hasRole(getRoleAdmin(role), msg.sender), "AccessControl: Must be an admin to perform this action");
        _;
    }

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function _setupRole(bytes32 role, address account) internal {
        _grantRole(role, account);
    }

    function grantRole(bytes32 role, address account) public onlyAdmin(role) {
        _grantRole(role, account);
    }

    function revokeRole(bytes32 role, address account) public onlyAdmin(role) {
        require(_roles[role].isRevocable, "AccessControl: Role is not revocable");
        _revocationTimelock[account][role] = block.timestamp + 1 days; // 1-day timelock
        emit RoleRevoked(role, account, msg.sender);
    }

    function executeRevocation(address account, bytes32 role) public {
        require(block.timestamp >= _revocationTimelock[account][role], "AccessControl: Timelock not expired");
        delete _revocationTimelock[account][role];
        _roles[role].members[account] = false;
    }

    function _grantRole(bytes32 role, address account) internal {
        require(!hasRole(role, account), "AccessControl: Account already has role");
        _roles[role].members[account] = true;
        emit RoleGranted(role, account, msg.sender);
    }

    function setRoleAdmin(bytes32 role, bytes32 adminRole) public onlyAdmin(role) {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members[account];
    }

    function getRoleAdmin(bytes32 role) public view returns (bytes32) {
        return _roles[role].adminRole;
    }

    function isRoleRevocable(bytes32 role) public view returns (bool) {
        return _roles[role].isRevocable;
    }

    function setRoleRevocable(bytes32 role, bool revocable) public onlyAdmin(role) {
        _roles[role].isRevocable = revocable;
    }

    function getRolesOfAccount(address account) public view returns (bytes32[] memory) {
        uint256 roleCount = 0;
        for (uint256 i = 0; i < 256; i++) {
            bytes32 role = bytes32(i);
            if (hasRole(role, account)) {
                roleCount++;
            }
        }

        bytes32[] memory roles = new bytes32[](roleCount);
        uint256 index = 0;
        for (uint256 i = 0; i < 256; i++) {
            bytes32 role = bytes32(i);
            if (hasRole(role, account)) {
                roles[index] = role;
                index++;
            }
        }
        return roles;
    }
}
