pragma solidity ^0.4.24;

import "./ENS.sol";

contract Circle{
  ENS ons;
  bytes32 rootNode;
  
  enum Roles { leadlink, secretary, facilitator }

  modifier only_owner(bytes32 label) {
    address currentOwner = ons.owner(keccak256(abi.encodePacked(rootNode, label)));
    require(currentOwner == 0 || currentOwner == msg.sender, "This address does not have ownership of that node");
    _;
  }

  /**
    Constructor
    @param onsAddr The address of the main ONS registry
    @param _circleNode The node that this circle has ownership over. Could be circle.arg, or might be circle.circle.arg, etc
    @param _leadLink The address for the lead link of this circle. Constructor will register leadlink.circle

    TODO: Replace (address) LeadLink to require an Identity
    */
  constructor(ENS onsAddr, bytes32 _circleNode, address _leadLink) public {
    ons = onsAddr;
    rootNode = _circleNode;

    // Precomputed Keccak256 for ("leadlink")
    bytes32 leadLinkLabel = 0x868c10e50667b6f363f5d54aa63ab277e894cacf9f9b1cd2e1521cc7d835a3ed; 
    register(leadLinkLabel, _leadLink);
    // leadlink.circlepath => _leadLink address
  }

  /**
    * Register a name, or change the owner of an existing registration.
    * @param label The hash of the label to register.
    * @param owner The address of the new owner.
    */
  function register(bytes32 label, address owner) public only_owner(label) {
    ons.setSubnodeOwner(rootNode, label, owner);
  }

}
