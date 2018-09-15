pragma solidity ^0.4.24;

contract TransferToken{
  event TransferToOtherChain(address indexed owner, uint256 amount);
  event TransferedFromOtherChain(address indexed owner, uint256 amount);
  event BalanceOf(address owner, uint256 currAmount);
  
  mapping(address => uint256) balances;
  
  constructor() public{}
  
  function transferFromOtherChain(address receiver, uint256 amount) public{
    balances[receiver] += amount;
    emit TransferedFromOtherChain(receiver, amount);
  }
  
  function transferToOtherChain(address owner, uint256 amount) public {
    balances[owner] -= amount; 
    require(balances[msg.sender] > 0, "Not enough tokens in this account");
    
    emit TransferToOtherChain(msg.sender, amount);
  }
  
  function balanceOf(address query) public returns(uint) {
    emit BalanceOf(query, balances[query]);
    return balances[query];
  }
}
