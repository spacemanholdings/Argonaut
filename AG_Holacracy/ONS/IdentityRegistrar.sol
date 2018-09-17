pragma solidity ^0.4.24;

import "./ENS.sol";

/**
 * A registrar that allocates subdomains to the first person to claim them.
 */
contract IdentityRegistrar {
  ENS ons;
  bytes32 rootNode;
  mapping(address => bytes32) reverseLookup; // maps ADDRESS to a NODE that address controls

  modifier only_owner(bytes32 label) {
    address currentOwner = ons.owner(keccak256(abi.encodePacked(rootNode, label)));
    require(currentOwner == 0 || currentOwner == msg.sender, "This address does not have ownership of that node");
    _;
  }

  /**
    * Constructor.
    * @param onsAddr The address of the ONS registry.
    * @param node The node that this registrar administers. ('identity.arg' = 0x79eedf92cd343d47cbe41086a05ff134f66515ba8fbac0fe6489b5091c6713b6)
    */
  constructor(ENS onsAddr, bytes32 node) public {
    ons = onsAddr;
    rootNode = node;
  }

  /**
    * Register a name, or change the owner of an existing registration.
    * @param label The hash of the label to register.
    * @param owner The address of the new owner.
    */
  function register(bytes32 label, address owner, address identityContract) public only_owner(label) {
    ons.setSubnodeOwner(rootNode, label, address(this));
    bytes32 node = keccak256(abi.encodePacked(rootNode, label));
    // TODO this should check to make sure the identityContract is actually of type identityContract using supports interface function
    // Alternatively it should create the identityContract
    ons.setResolver(node, identityContract); 
    ons.setSubnodeOwner(rootNode, label, owner);
    reverseLookup[owner] = node; 
  }

  function getNode(address _query) public view returns(bytes32) {
    return reverseLookup[_query];
  }
}