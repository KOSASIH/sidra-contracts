pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

contract AdvancedTokenManagement {
    using SafeMath for uint256;

    // Mapping of token balances
    mapping (address => uint256) public balances;

    // Token metadata
    string public name = "Advanced Token";
    string public symbol = "AT";
    uint256 public totalSupply = 100000000 * (10**18); // 100 million tokens

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Constructor
    constructor() public {
        balances[msg.sender] = totalSupply;
    }

    // Transfer tokens
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_value <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Approve token spending
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Get token balance
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    // Advanced token management functions
    function mint(address _to, uint256 _value) public {
        require(msg.sender == owner, "Only the owner can mint tokens");
        balances[_to] += _value;
        totalSupply += _value;
    }

    function burn(address _from, uint256 _value) public {
        require(msg.sender == owner, "Only the owner can burn tokens");
        balances[_from] -= _value;
        totalSupply -= _value;
    }

    function freeze(address _account) public {
        require(msg.sender == owner, "Only the owner can freeze accounts");
        frozenAccounts[_account] = true;
    }

    function unfreeze(address _account) public {
        require(msg.sender == owner, "Only the owner can unfreeze accounts");
        frozenAccounts[_account] = false;
    }
}
