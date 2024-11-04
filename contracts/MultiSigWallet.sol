// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MultiSigWallet is Ownable {
    struct Transaction {
        address to;
        uint256 value;
        bool executed;
        uint256 confirmations;
        mapping(address => bool) isConfirmed;
    }

    address[] public owners;
    uint256 public required;
    Transaction[] public transactions;

    event TransactionSubmitted(uint256 indexed transactionId, address indexed to, uint256 value);
    event TransactionConfirmed(uint256 indexed transactionId, address indexed owner);
    event TransactionExecuted(uint256 indexed transactionId);
    event TransactionCancelled(uint256 indexed transactionId);
    
    modifier onlyOwner() {
        require(isOwner(msg.sender), "Not an owner");
        _;
    }

    modifier transactionExists(uint256 transactionId) {
        require(transactionId < transactions.length, "Transaction does not exist");
        _;
    }

    modifier notExecuted(uint256 transactionId) {
        require(!transactions[transactionId].executed, "Transaction already executed");
        _;
    }

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid required number of owners");

        owners = _owners;
        required = _required;
    }

    function isOwner(address account) public view returns (bool) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == account) {
                return true;
            }
        }
        return false;
    }

    function submitTransaction(address to, uint256 value) public onlyOwner {
        uint256 transactionId = transactions.length;
        transactions.push(Transaction({
            to: to,
            value: value,
            executed: false,
            confirmations: 0
        }));
        emit TransactionSubmitted(transactionId, to, value);
    }

    function confirmTransaction(uint256 transactionId) 
        public 
        onlyOwner 
        transactionExists(transactionId) 
        notExecuted(transactionId) 
    {
        Transaction storage txn = transactions[transactionId];
        require(!txn.isConfirmed[msg.sender], "Transaction already confirmed");

        txn.isConfirmed[msg.sender] = true;
        txn.confirmations++;

        emit TransactionConfirmed(transactionId, msg.sender);

        if (txn.confirmations >= required) {
            executeTransaction(transactionId);
        }
    }

    function executeTransaction(uint256 transactionId) 
        internal 
        transactionExists(transactionId) 
        notExecuted(transactionId) 
    {
        Transaction storage txn = transactions[transactionId];
        require(txn.confirmations >= required, "Not enough confirmations");

        txn.executed = true;
        (bool success, ) = txn.to.call{value: txn.value}("");
        require(success, "Transaction failed");

        emit TransactionExecuted(transactionId);
    }

    function cancelTransaction(uint256 transactionId) 
        public 
        onlyOwner 
        transactionExists(transactionId) 
        notExecuted(transactionId) 
    {
        Transaction storage txn = transactions[transactionId];
        require(txn.confirmations < required, "Cannot cancel executed transaction");

        delete transactions[transactionId]; // Remove the transaction from the list
        emit TransactionCancelled(transactionId);
    }

    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }

    function getTransaction(uint256 transactionId) 
        public 
        view 
        transactionExists(transactionId) 
        returns (address to, uint256 value, bool executed, uint256 confirmations) 
    {
        Transaction storage txn = transactions[transactionId];
        return (txn.to, txn.value, txn.executed, txn.confirmations);
    }

    receive() external payable {}
}
