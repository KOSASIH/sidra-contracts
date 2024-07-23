pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract DecentralizedFinanceProtocol {
    using SafeMath for uint256;

    // Mapping of user deposits
    mapping (address => uint256) public deposits;

    // Mapping of user borrowings
    mapping (address => uint256) public borrowings;

    // Interest rate (annual percentage rate)
    uint256 public interestRate = 5 * (10**16); // 5%

    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);

    // Deposit funds
    function deposit(uint256 _amount) public {
        deposits[msg.sender] += _amount;
        emit Deposit(msg.sender, _amount);
    }

    // Withdraw funds
    function withdraw(uint256 _amount) public {
        require(_amount <= deposits[msg.sender], "Insufficient deposit");
        deposits[msg.sender] -= _amount;
        emit Withdrawal(msg.sender, _amount);
    }

    // Borrow funds
    function borrow(uint256 _amount) public {
        require(_amount <= deposits[msg.sender], "Insufficient deposit");
        borrowings[msg.sender] += _amount;
        emit Borrow(msg.sender, _amount);
    }

    // Repay borrowed funds
    function repay(uint256 _amount) public {
        require(_amount <= borrowings[msg.sender], "Insufficient borrowing");
        borrowings[msg.sender] -= _amount;
        emit Repay(msg.sender, _amount);
    }

    // Calculate interest
    function calculateInterest(address _user) public view returns (uint256) {
        return borrowings[_user].mul(interestRate).div(100);
    }
}
