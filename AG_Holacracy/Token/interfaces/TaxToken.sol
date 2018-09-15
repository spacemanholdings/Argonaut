pragma solidity ^0.4.24;
//combines Burnable Token, Mintable Token 
import "../StandardToken.sol";
import "../DetailedERC20.sol";
import "./IMintableRedeemableERC667Token.sol";

import "./IERC677Reciever.sol";

contract TaxToken is 
  MintableRedeemableERC677Token,
  DetailedERC20,
  StandardToken
{
  using SafeMath for uint256;
  uint256 priceInWeiPerToken;
  uint256 taxRate;
  address beneficiary; //replace with list
  
  constructor (
    string _name,
    string _symbol, 
    uint8 _decimals,
    uint256 _priceInWeiPerToken,
    uint256 _taxRate,
    address _beneficiary) 
   DetailedERC20(_name, _symbol, _decimals) public {
    priceInWeiPerToken = _priceInWeiPerToken;
    require(_taxRate < 100, "Tax Rate cannot be greater than 100%");
    taxRate = _taxRate;
    require(_beneficiary != 0, "Beneficiary must not be blank");
    beneficiary = _beneficiary; 
  }


  function mint() public payable returns (bool){
    /** uint percentage. Adds leftover of percentage to taxes as well */
    uint256 taxInWei = (msg.value.mul(taxRate)).div(100) + (msg.value.mul(taxRate)).mod(100);
    uint256 taxedTokens = taxInWei.div(priceInWeiPerToken); // any remainder value is left in the contract bank
    if(taxedTokens < 1){revert("Not enough money provided to create even 1 tax token.");} // If no taxes can be payed then return all funds

    uint256 senderValue = msg.value - taxInWei;
    uint256 senderTokens = senderValue.div(priceInWeiPerToken);
    if(senderTokens < 1) {revert("Not enough money to mint tokens for reciever");} // must create atleast one token
    
    // leftOverBalance[msg.sender] = leftOverBalance[msg.sender].add(senderValue.mod(priceInWeiPerToken));
    msg.sender.transfer(senderValue.mod(priceInWeiPerToken)); // leftover Wei < 1 token's worth, return it
    super.totalSupply_ = super.totalSupply_.add(taxedTokens.add(senderTokens)); 
    balanceOf[beneficiary] = balanceOf[beneficiary].add(taxedTokens);
    balanceOf[msg.sender] = balanceOf[msg.sender].add(senderTokens);
    
    //"Dev minted X tokens for Y value
    emit TokensMinted(msg.sender, taxedTokens.add(senderTokens), msg.value);
  }

  function redeem(uint256 _value) public {

  }

  function claimTokens(address _token, address _to) public {

  }

  function transferAndCall(address _addr, uint _amt, bytes data) public returns (bool) {
    
  }
}