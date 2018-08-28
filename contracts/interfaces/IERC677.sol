/* This interface is from https://github.com/poanetwork/poa-bridge-contracts*/
pragma solidity ^0.4.23;
import "../../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";


contract ERC677 is ERC20 {
  /**
    Adds Bytes to Transfer Event
   */
  event Transfer(address indexed from, address indexed to, uint value, bytes data);
  /**
    @dev Used to add a callback to a traditional Transfer call used for burning Tokens
   */
  function transferAndCall(address, uint, bytes) external returns (bool);
}