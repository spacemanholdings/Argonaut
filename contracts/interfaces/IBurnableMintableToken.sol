pragma solidity ^0.4.23;


contract IBurnableMintableERC677Token{
  function mint(address, uint256) public returns (bool);
  function burn(uint256 _value) public;
  function claimTokens(address _token, address _to) public;
}