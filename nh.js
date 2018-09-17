let namehash = require('eth-ens-namehash');
let k3 = require('js-sha3').keccak_256;

let str = "dev.identity.arg"
let labelhash = k3(str);
let nameHash = namehash.hash(str);
console.log(str, labelhash, nameHash);