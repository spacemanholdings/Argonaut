import { QtumRPC, Contract } from 'qtumjs';
const BN = require('bn.js');

// These are the RPC objects used to interact with the chains running on those ports. 
// Simply change URL or port to point to different chains, the 'qtum:test' being the RPC username and password respectively
let main_rpc = new QtumRPC('http://qtum:test@localhost:9888');
let govr_rpc = new QtumRPC('http://qtum:test@localhost:8888');
// Token Contracts
let main_token = new Contract(main_rpc, {
  abi: require("./assets/TransferToken.json"),
  address: "550be2d431a0969eb8e7304e254804c0612098cd"
});

let govr_token = new Contract(govr_rpc, {
  abi: require("./assets/TransferToken.json"),
  address: "dd8b13bdadf05bfc4f2b2acfdeae0fb8510ac68b" //don't use 0x
});

// Log Emitters
let main_logEmitter = main_token.logEmitter({minconf: 1});
let govr_logEmitter = govr_token.logEmitter({minconf: 1});

//  MAIN CHAIN \\
main_logEmitter.on("TransferToOtherChain", (event) => {
  //console.log("Transfer from Main Chain to Governance Chain Initated", event.event);
  // TX to Mint Coins on New Chain
  let amt = new BN(event.event.amount);
  main_rpc.fromHexAddress(event.event.owner).then((owner) => {
    console.log("Account( %s ) is moving ( %d ) tokens to Governance Chain", owner,amt);
    console.log("Owner Hex: ", event.event.owner);
    govr_token.send("transferFromOtherChain", [event.event.owner, amt]).then((result) => {
      console.log(result);
      console.log("You should see a Govr Transfered From Event if everything happened as it was supposed to");
    });
  }); 
  // Generate a block
});

main_logEmitter.on("TransferedFromOtherChain", (event) => {
  console.log("Main Chain Other Event");
  console.log(event.event);
});

// GOVERNANCE CHAIN \\
govr_logEmitter.on("TransferToOtherChain", (event) => {
  console.log("Transfer from Governance Chain to Main Chain Initated", event.event);

  // TX to Mint Coins on New Chain
  // Generate a block
});
govr_logEmitter.on("TransferedFromOtherChain", (event) => {
  console.log("Governance Chain Other Event");
  console.log(event.event);
});