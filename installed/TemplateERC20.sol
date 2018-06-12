pragma solidity ^0.4.17;

import "./SafeMath.sol";

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// Dat Nguyen - 2017
// ----------------------------------------------------------------------------

contract TemplateERC20 {

    using SafeMath for uint256;

    uint8 constant private MAX_UINT8 = 2**8 - 1;

    mapping(address => uint256) public balances;

    mapping (address => mapping (address => uint256)) internal allowed;

    uint256 tokenSupply;
    string public tokenName="";
    string public tokenSymbol="";
    uint8 public tokenDecimals=MAX_UINT8;

    // ----------------------------------------------------------------------------
    //  Required functions
    // ----------------------------------------------------------------------------

    // Returns the total supply of tokens
    function totalSupply() view public returns (uint256 _totalSupply) {
        return tokenSupply;
    }

    // Returns the balance of an account with the address _owner
    function balanceOf(address _owner) view public returns (uint256 balance) {
        return balances[_owner];
    }

    // Transfers _value tokens from account with address _to from the msg.sender
    function transfer(address _to, uint256 _value) public returns (bool success) {
        assert(balances[msg.sender] >= _value);
        return _transfer(msg.sender, _to, _value);
    }

    // Transfers _value tokens from account with address _to from the account with the _from address
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        assert(balances[_from] >= _value && allowance >= _value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        return _transfer(_from, _to, _value);
    }

    // Allows _spender to withdraw from your account up to the _value amount
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Returns the amount _spender is allowed to withdraw from _owner
    function allowance(address _owner, address _spender) view public returns (uint _remaining) {
        return allowed[_owner][_spender];
    }

    // ----------------------------------------------------------------------------
    //  Optional functions
    // ----------------------------------------------------------------------------

    // Returns the number of decimal places the token uses
    function decimals() view public returns (uint8 _decimals) {
        require(tokenDecimals < MAX_UINT8);
        return tokenDecimals;
    }

    // Returns the name of the token
    function name() view public returns (string _name) {
        require(keccak256(tokenName) != keccak256(""));
        return tokenName;
    }

    // Returns the symbol of the token
    function symbol() view public returns (string _symbol) {
        require(keccak256(tokenSymbol) != keccak256(""));
        return tokenSymbol;
    }

    // ----------------------------------------------------------------------------
    //  Private functions
    // ----------------------------------------------------------------------------

    // Internal transfer function
    function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
        assert(balances[_from] >= _value);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] =  balances[_to].add(_value);

        emit Transfer(_from, _to, _value);

        return true;
    }

    // ----------------------------------------------------------------------------
    //  Events
    // ----------------------------------------------------------------------------

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // ----------------------------------------------------------------------------
    //  To be safe, reject all ETH payments
    // ----------------------------------------------------------------------------

    function () public payable {
        revert();
    }
}
