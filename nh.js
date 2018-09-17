let namehash = require('eth-ens-namehash');
let k3 = require('js-sha3').keccak_256;

let label = "j1"
let str = label + ".identity.arg"
let labelhash = k3(label);
let nameHash = namehash.hash(str);
console.log(str, "0x"+labelhash, nameHash);
//0xba12b6b698533fad3e233b4c3cac44d47ace207d2ae2e7b608f5e6bb2f0064c2,0x3a123c8deeb8af938991a62f5d6108d64be89eb05bf46483b86fe0feeae32d24,2f4bc4f8322278fb53101efeb1e008ebb80b7a24,Johnny1,jon@jon.com,0x0
