pragma solidity ^0.4.24;

import "./ENS.sol";
import "./Resolver.sol";

contract Circle{
  ENS ons;
  bytes32 rootNode;
  bytes32 thisNode;
  bytes32 bankNode;
  
  bytes32 leadLinkLabel = 0x868c10e50667b6f363f5d54aa63ab277e894cacf9f9b1cd2e1521cc7d835a3ed; //precomputed keccak256('leadlink')

  struct Role {
    string role;
    string purpose;
    mapping(bytes32 => address) domains; //maps keccak256(DOMAIN NAME) to contract address for domain
  }


  mapping(bytes32 => address) subdomains;
  mapping(address => Role[]) members; //maps addresses to any roles they may have within the orginization


  event NewRole(string indexed memberName, bytes32 indexed memberNode, string indexed roleName);
  event CashOut(uint256 _tokensAmt, uint256 _ethToTresurer);

  modifier only_owner(bytes32 label) {
    address currentOwner = ons.owner(keccak256(abi.encodePacked(rootNode, label)));
    require(currentOwner == 0 || currentOwner == msg.sender, "This address does not have ownership of that node");
    _;
  }

  modifier isMember(address _addr) {
    require(members[_addr].length > 0, "This address does not have membership within this circle");
    _;
  }

  /**
    Constructor
    @param onsAddr The address of the main ONS registry
    @param _rootCircleNode The node (full namehash) that is the parent org for this circle (ex. facebook.marketing.ben.arg rootCircleNode would be namehash('ben.arg') )
    @param _rootBankNode The node (full namehash) where the token contract for this org is defined. Only the treasurer may be able to call transfer/cashout of token assets on behalf of this circle
    @param _circleNode The node (full namehash) that this circle has ownership over. Could be circle.arg, or might be circle.circle.arg, etc
    @param _leadLink The address for the lead link of this circle. Constructor will register leadlink.circle

    TODO: Replace (address) LeadLink to require an Identity
    */
  constructor(
    ENS onsAddr, 
    bytes32 _rootCircleNode, 
    bytes32 _rootBankNode, 
    bytes32 _circleNode, 
    address _leadLink
  ) public {
    ons = onsAddr;
    rootNode = _rootCircleNode; 
    bankNode = _rootBankNode;
    thisNode = _circleNode;

    // Precomputed Keccak256 for ("leadlink")
    register(leadLinkLabel, _leadLink);

    // Register members.circlenode and take ownership of it  
    // 0x is precomputed Keccak256 for ("members")
    // register(0xef9dd5dee115f62929cb2e75e8e4c5e964121efc81aabbd2eaf2002005ad536e, address(this));
  }

  /**
    * Register a name, or change the owner of an existing registration.
    * ONLY CALLABLE BY THIS CONTRACT. USE ACCESS PERMS WITH OTHER FUNCTIONS TO CALL THIS
    * @param label The hash of the label to register.
    * @param owner The address of the new owner.
    */
  function register(bytes32 label, address owner) private only_owner(label) {
    ons.setSubnodeOwner(thisNode, label, owner);
  }

  function getSubdomainOwner(bytes32 label) public view returns (address) {
    address owner = ons.owner(keccak256(abi.encodePacked(thisNode, label)));
    return owner;
  }

 
  /**
    @dev Lead can create and assign new roles. 
    @param _role The name of the role to be defined, ("secretary", "community_manager", etc)
    @param _purpose The purpose of the role
    @param _assignedTo the address this role is assigned to
   */
  function addRole(string _role, string _purpose, address _assignedTo) public {
    require(getSubdomainOwner(leadLinkLabel) == msg.sender, "You are not the lead link");

  }

  function isCircle() external pure returns(bool){return true;} 
  //function cashOut() {}



}
