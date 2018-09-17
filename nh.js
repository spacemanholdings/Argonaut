let namehash = require('eth-ens-namehash');
let k3 = require('js-sha3').keccak_256;

let label = "members"
let str = label + ".b1.arg"
let labelhash = k3(label);
let nameHash = namehash.hash(str);
console.log(str, "0x"+labelhash, nameHash);