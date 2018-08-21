var TaxableToken = artifacts.require("./TaxableToken");

module.exports = function(deployer) {
  var weiCostPerToken = 10; // 10 Wei per Token
  var taxRate = 10; // 10% Tax Rate
  var beneficiaryAddr = "0xc5fdf4076b8f3a5357c5e395ab970b5b54098fef";
  deployer.deploy(TaxableToken, weiCostPerToken, taxRate, beneficiaryAddr, {from: "0x627306090abab3a6e1400e9345bc60c78a8bef57"});
};
