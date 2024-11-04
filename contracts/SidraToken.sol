// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

contract SidraToken is ERC20, AccessControl, ERC20Snapshot, ERC20Burnable, Pausable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    
    uint256 public transferFee; // Fee in basis points (1/100th of a percent)
    address public feeRecipient;

    event TransferFeeUpdated(uint256 newFee);
    event FeeRecipientUpdated(address newRecipient);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        transferFee = 0; // Default to no fee
        feeRecipient = msg.sender; // Default fee recipient is the deployer
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function burn(uint256 amount) public override onlyRole(BURNER_ROLE) {
        super.burn(amount);
    }

    function setTransferFee(uint256 _transferFee) external onlyRole(DEFAULT_ADMIN_ROLE) {
        transferFee = _transferFee;
        emit TransferFeeUpdated(_transferFee);
    }

    function setFeeRecipient(address _feeRecipient) external onlyRole(DEFAULT_ADMIN_ROLE) {
        feeRecipient = _feeRecipient;
        emit FeeRecipientUpdated(_feeRecipient);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 fee = (amount * transferFee) / 10000; // Calculate fee
        uint256 amountAfterFee = amount - fee;

        super._transfer(sender, recipient, amountAfterFee);
        if (fee > 0) {
            super._transfer(sender, feeRecipient, fee); // Transfer fee to fee recipient
        }
    }

    function snapshot() external onlyRole(DEFAULT_ADMIN_ROLE) returns (uint256) {
        return _snapshot();
    }

    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }

    // Permit function for delegated transfers (EIP-2612)
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(deadline >= block.timestamp, "SidraToken: expired deadline");
        bytes32 digest = keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR(),
            keccak256(abi.encode(
                keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                owner,
                spender,
                value,
                nonces[owner]++,
                deadline
            ))
        ));
        require(owner == ecrecover(digest, v, r, s), "SidraToken: invalid signature");
        _approve(owner, spender, value);
    }

    // Domain separator for EIP-2612
    function DOMAIN_SEPARATOR() public view returns (bytes32) {
        return keccak256(abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256(bytes(name())),
            keccak256(bytes("1")),
            block.chainid,
            address(this)
        ));
    }

    mapping (address => uint256) public nonces;
}
