module.exports = function(callback) {
  web3.eth.getAccounts(
    function(err, acc){
      console.log(acc)
    });
}