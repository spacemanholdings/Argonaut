/* This interface is from https://github.com/poanetwork/poa-bridge-contracts*/
pragma solidity ^0.4.20;

interface IBridgeValidator {
  /**
    @dev This function checks if the given address is part of the whitelisted validators list
    @param _validator address of the validator to be checked   
   */
  function isValidator(address _validator) external view returns(bool);

  /**
    @dev This returns the number of required signatures to validate a transaction
   */
  function requiredSignatures() external view returns (uint256);

  /**
    @dev Returns the owner of the contract
   */
  function owner() external view returns(address);

}
