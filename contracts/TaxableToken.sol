pragma solidity ^0.4.24;

import "./SafeMath.sol";

contract TaxableToken {
  using SafeMath for uint256;
  // Events
  event MintTokens(address indexed Minter, uint256 Value, uint256 SenderTokens, uint256 TaxedTokens, uint256 newTotalSupply);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Redeemed(address indexed from, uint256 tokensRedeemed, uint256 weiRedeemed, uint256 newSupply);
  
  // State
  mapping (address => uint256) public balanceOf;
  /** Maintains remainder of coins that aren't enough to mint a token */
  // mapping (address => uint256) public leftOverBalance; //uncessary
  uint256 priceInWeiPerToken;
  uint256 totalSupply = 0;
  uint256 taxRate;
  address beneficiary;

  constructor(
    uint256 _weiCostPerToken,
    uint256 _taxRate,
    address _beneficiaryAddr
  ) public {
    priceInWeiPerToken = _weiCostPerToken * 1 wei;
    taxRate = _taxRate;
    beneficiary = _beneficiaryAddr;
  }

  function () public{ revert(); }

  function mintCoins() public payable{
    /** uint percentage. Adds leftover of percentage to taxes as well */
    uint256 taxInWei = (msg.value.mul(taxRate)).div(100) + (msg.value.mul(taxRate)).mod(100);
    uint256 taxedTokens = taxInWei.div(priceInWeiPerToken); // any remainder value is left in the contract bank
    if(taxedTokens < 1){revert();} // If no taxes can be payed then return all funds

    uint256 senderValue = msg.value - taxInWei;
    uint256 senderTokens = senderValue.div(priceInWeiPerToken);
    if(senderTokens < 1) {revert();} // must create atleast one token
    
    // leftOverBalance[msg.sender] = leftOverBalance[msg.sender].add(senderValue.mod(priceInWeiPerToken));
    msg.sender.transfer(senderValue.mod(priceInWeiPerToken)); // leftover Wei < 1 token's worth, return it
    totalSupply = totalSupply.add(taxedTokens.add(senderTokens)); 
    balanceOf[beneficiary] = balanceOf[beneficiary].add(taxedTokens);
    balanceOf[msg.sender] = balanceOf[msg.sender].add(senderTokens);
    
    //"Dev payed N Wei got back X Tokens and contributed Y in Taxes"
    emit MintTokens(msg.sender, msg.value, senderTokens, taxedTokens, totalSupply);
  }  

  function redeemTokens(uint256 _tokens) public {
    require(msg.sender == beneficiary); // replace with msg.sender is in approved list
    require(_tokens <= balanceOf[msg.sender]);
    
    totalSupply = totalSupply.sub(_tokens);
    balanceOf[msg.sender] = balanceOf[msg.sender].sub(_tokens);
    uint256 weiToSend = (priceInWeiPerToken.mul(_tokens));
    msg.sender.transfer( weiToSend );
    //"Beneficary SENDER redeemed TOKENS and recieved WEI. The new total supply is TOTALSUPPLY"
    emit Redeemed(msg.sender,_tokens,weiToSend, totalSupply);
  }
  function transfer(address _to, uint256 _value) public returns(bool){
    require (_value <= balanceOf[msg.sender]);
    require (_to != address(0));
    
    balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
    balanceOf[_to] = balanceOf[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function getBalanceOf(address _addr) public view returns (uint) { return balanceOf[_addr]; }

  function getTotalSupply() public view returns (uint256){
    return totalSupply;
  }
  function getCostInEth() public view returns (uint256){
    return (priceInWeiPerToken * 1 ether);
  }
  function getCostInWei() public view returns (uint256){
    return priceInWeiPerToken;
  }
}