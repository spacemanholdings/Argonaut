pragma solidity ^0.4.23;

/**
  Minting Tokens cost $
 */

interface MintableRedeemableERC677Token{
  event TokensMinted(address indexed minter, uint tokensMinted, uint weiPayed);
  event TokensRedeemed(address redeemer, uint tokensRedeemed, uint weiRecieved);
  function mint() public payable returns (bool);
  function redeem(uint256 _value) public;
  //function claimTokens(address _token, address _to) public; //maybe unncessary
}