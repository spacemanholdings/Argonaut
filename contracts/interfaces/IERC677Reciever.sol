/* This interface is from https://github.com/poanetwork/poa-bridge-contracts*/
pragma solidity ^0.4.23;

interface ERC677Receiver {
  function onTokenTransfer(address _from, uint _value, bytes _data) external returns(bool);
}
