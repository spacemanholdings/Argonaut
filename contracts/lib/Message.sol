/* This library is from  https://github.com/poanetwork/poa-bridge-contracts  */
pragma solidity ^0.4.20;
import "../interfaces/IBridgeValidator.sol";

library Message {
  function addressArrayContains(address[] array, address value) internal pure returns (bool){
    for (uint256 i = 0; i<array.length; i++){
      if(array[i] == value){return true;}
    }
    return false;
  }

    // layout of message :: bytes:
    // offset  0: 32 bytes :: uint256 - message length
    // offset 32: 20 bytes :: address - recipient address
    // offset 52: 32 bytes :: uint256 - value
    // offset 84: 32 bytes :: bytes32 - transaction hash
    // offset 116: 32 bytes :: uint256 - home gas price

    // bytes 1 to 32 are 0 because message length is stored as little endian.
    // mload always reads 32 bytes.
    // so we can and have to start reading recipient at offset 20 instead of 32.
    // if we were to read at 32 the address would contain part of value and be corrupted.
    // when reading from offset 20 mload will read 12 zero bytes followed
    // by the 20 recipient address bytes and correctly convert it into an address.
    // this saves some storage/gas over the alternative solution
    // which is padding address to 32 bytes and reading recipient at offset 32.
    // for more details see discussion in:
    // https://github.com/paritytech/parity-bridge/issues/61

  function parseMessage(bytes message) internal pure returns(address recipient, uint256 amount, bytes32 txHash){
    require(isMessageValid(message), "Message incorrect length");
    /* solium-disable-next-line */
    assembly{
      recipient := and(mload(add(message, 20)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
      amount := mload(add(message, 52))
      txHash := mload(add(message, 84))
    }
  }

  function isMessageValid(bytes _msg) internal pure returns (bool) {
    return _msg.length == 116;
  }

  function recoverAddressFromSignedMessage(bytes signature, bytes message) internal pure returns (address){
    require(signature.length == 65, "Incorrect signature length");
    bytes32 r; 
    bytes32 s;
    bytes1  v;
    /* solium-disable-next-line */
    assembly{
      r := mload(add(signature, 0x20))
      s := mload(add(signature, 0x40))
      v := mload(add(signature, 0x60))
    }
    return ecrecover(hashMessage(message), uint8(v), r, s);
  }

  function hashMessage(bytes message) internal pure returns (bytes32) {
    bytes memory prefix = "\x19Ethereum Signed Messasge:\n116"; //116 == message length
    return keccak256(prefix, message); 
  }

  function hasEnoughValidSignatures(
    bytes _message,
    uint8[] _vs,
    bytes32[] _rs,
    bytes32[] _ss,
    IBridgeValidator _validatorContract) internal view {
      
    require(isMessageValid(_message), "Incorrect message length");
    uint256 requiredSignatures = _validatorContract.requiredSignatures();
    require(_vs.length >= requiredSignatures, "Not enough valid signatures");
    bytes32 hash = hashMessage(_message);
    address[] memory encounteredAddresses = new address[](requiredSignatures);

    for (uint256 i = 0; i < requiredSignatures; i++) {
      address recoveredAddress = ecrecover(hash, _vs[i], _rs[i], _ss[i]);
      require(_validatorContract.isValidator(recoveredAddress), "Signature(s) don't belong to validators");
      if (addressArrayContains(encounteredAddresses, recoveredAddress)) {
        revert("Same address signed twice");
      }
      encounteredAddresses[i] = recoveredAddress;
    }
  }
}