
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// 一个 mapping 来记录每个捐赠者的捐赠金额。
// 一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
// 一个 withdraw 函数，允许合约所有者提取所有资金。
// 一个 getDonation 函数，允许查询某个地址的捐赠金额。
// 使用 payable 修饰符和 address.transfer 实现支付和提款。

contract BeggingContract {
  address public owner;
  event Donation(address indexed donor, uint256 amount,uint256 timestamp);
  event Withdrawal(address indexed donor, uint256 amount,uint256 timestamp);
  mapping(address => uint256)public donations;

  modifier onlyOwner(){
    require(msg.sender == owner,"only owner");
    _;
  }
  constructor(){
    owner = msg.sender;
  }
  fallback() external payable{
    donate();
  }
  receive() external payable{
    donate();
  }
  function donate()public payable{
    require(msg.value > 0,"value must be greater than 0");
    
    donations[msg.sender] += msg.value;
    emit Donation(msg.sender,msg.value,block.timestamp);
  }

  function withdraw() external payable onlyOwner{
    require(address(this).balance > 0,"contract balance is 0");
    payable(owner).transfer(address(this).balance);
    emit Withdrawal(owner,address(this).balance,block.timestamp);
  }

}