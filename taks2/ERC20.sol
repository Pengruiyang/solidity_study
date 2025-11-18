// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
/**
balanceOf：查询账户余额。
transfer：转账。
approve 和 transferFrom：授权和代扣转账。
使用 event 记录转账和授权操作。
提供 mint 函数，允许合约所有者增发代币。
 */
contract ERC20 {
  event Transfer(address indexed from, address indexed to,uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  uint256 public totalSupply;

  string public name;
  string public symbol;
  uint8 public decimals = 6;

  address public owner;

  modifier onlyOwner(){
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }
  constructor(string memory _name, string memory _symbol){
    name = _name;
    symbol = _symbol;
    owner = msg.sender;
  }

  function transfer(address _to, uint256 _value)public returns (bool){
    require(_to != address(0), "Invalid address");
    require(_value <= balanceOf[msg.sender], "Insufficient balance");
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns(bool){
    allowance[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function transferFrom(address sender, address recipient, uint256 amount) public returns(bool){
    require(sender != address(0), "Invalid sender");
    require(recipient != address(0), "Invalid recipient");
    require(amount <= balanceOf[sender], "Insufficient balance");
    require(amount <= allowance[sender][msg.sender], "Insufficient allowance");

    transfer(sender, amount);
    allowance[sender][msg.sender] -= amount;
    return true;
  }

  function mint(address to, uint256 amount) public onlyOwner {
    require(to != address(0), "Invalid address");

    totalSupply += amount;
    balanceOf[to] += amount;
    emit Transfer(address(0), to, amount);
  }

  function burn(uint256 amount) public onlyOwner {
    require(amount <= balanceOf[msg.sender], "Insufficient balance");
    
    balanceOf[msg.sender] -= amount;
    totalSupply -= amount;
    emit Transfer(msg.sender, address(0), amount);
  }

}