var TaxableToken = artifacts.require("TaxableToken")

/**
 * Deployment Params:
 *  Wei Cost    :  10
 *  Tax Rate    :  10
 *  Beneficiary :  Accounts[2] 0xc5fdf4076b8f3a5357c5e395ab970b5b54098fef
 */

contract('TaxableToken', function(accounts){
  it("should get the current tax rate"),
  it("should get the current token price"),
  it("should buy 1000 tokens. It should have 1000 - tax in it's wallet"),
  it("should be able to send tokens to another wallet"),
  it("should not be able to widraw qtum equivalent to the tokens"),
  it("should be able to widraw funds if beneficiary, lowering total token supply")
})