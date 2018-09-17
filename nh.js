let namehash = require('eth-ens-namehash');
let k3 = require('js-sha3').keccak_256;

let label = "bobby"
let str = label + ".identity.arg"
let labelhash = k3(label);
let nameHash = namehash.hash(str);
console.log(str, "0x"+labelhash, nameHash);
//0xba12b6b698533fad3e233b4c3cac44d47ace207d2ae2e7b608f5e6bb2f0064c2,db515ec28da84b38e033667bc0f1878b32740651,2f4bc4f8322278fb53101efeb1e008ebb80b7a24,Johnny1,jon@jon.com,0x0
