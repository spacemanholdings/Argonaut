pragma solidity ^0.4.24;

import "./ENS.sol";
interface FIFSRegistrar {function register(bytes32 label, address owner) external;}

//import "./Resolver.sol";

contract Circle{
  ENS ons;
  bytes32 thisNode;
  address leadLink;

  struct Role {
    string role;
    string purpose;
    mapping(bytes32 => address) domains; //maps keccak256(DOMAIN NAME) to contract address for domain
  }
  mapping(bytes32 => address) domains;  //keccak256('domainName') => domain address
  mapping(bytes32 => Role) roles;       //keccak256('roleName') => Role struct

  modifier only_owner(bytes32 label) {
    address currentOwner = ons.owner(keccak256(abi.encodePacked(thisNode, label)));
    require(currentOwner == 0 || currentOwner == msg.sender, "This address does not have ownership of that node");
    _;
  }

  event NewDomainForRole(bytes32 _roleLabel, bytes32 _domainLabel, address _domainAddress);
  event NewRoleCreated(string _role, string _purpose, address indexed _assignedTo);
  event NewLeadLink(address indexed _leadlink);

  /**
    Constructor
    param onsAddr The address of the main ONS registry
    param _rootCircleNode The node (full namehash) that is the parent org for this circle (ex. facebook.marketing.ben.arg rootCircleNode would be namehash('ben.arg') )
    param _rootBankNode The node (full namehash) where the token contract for this org is defined. Only the treasurer may be able to call transfer/cashout of token assets on behalf of this circle
    param _circleNode The node (full namehash) that this circle has ownership over. Could be circle.arg, or might be circle.circle.arg, etc
    param _leadLink The address for the lead link of this circle. Constructor will register leadlink.circle

    TODO: Replace (address) LeadLink to require an Identity
    */
  /*
  constructor(ENS onsAddr, FIFSRegistrar _ArgRegistrar, bytes32 _circleLabel, bytes32 _circleNode) public {
    ons = onsAddr;
    thisNode = _circleNode;
    leadLink = msg.sender;
    _ArgRegistrar.register(_circleLabel, address(this));
    //register(keccak256(abi.encodePacked('leadlink')), leadLink); 
  }*/
  
  constructor(bytes32 _circleLabel, bytes32 _circleNode) public {
    ons = ENS(0xeb3b8911f31372d597f32206fe731a148d57043c);
    FIFSRegistrar ArgRegistrar = FIFSRegistrar(0xa7bc4a9918ba5916f56798307bdceb38e0d84be2);
    thisNode = _circleNode;
    leadLink = msg.sender;
    ArgRegistrar.register(_circleLabel, address(this));
    ons.setResolver(_circleNode, address(this));
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
  
  //Call after transfering ownership
  function setLeadLink(address _newLead) public {
    require(leadLink == msg.sender, "You don't own this contract");
    leadLink = _newLead;
    register(keccak256(abi.encodePacked("leadlink")), _newLead);
    emit NewLeadLink(_newLead);
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
  function newRole(string _role, string _purpose, address _assignedTo) public {
    //require(leadLink == msg.sender, "You are not the lead link");
    
    bytes32 roleLabel = keccak256(bytes(_role));
    roles[roleLabel] = Role({
      role : _role,
      purpose : _purpose
    });

    // Register role.circle.org.arg
    register(roleLabel, _assignedTo);
    emit NewRoleCreated(_role, _purpose, _assignedTo);
  }
    

  function addDomainToRole(bytes32 _roleLabel, bytes32 _domainLabel, address _domainAddress) public {
    roles[_roleLabel].domains[_domainLabel] = _domainAddress; 
    address roleAddress = getSubdomainOwner(_roleLabel);
    register(_domainLabel, roleAddress);
    emit NewDomainForRole(_roleLabel, _domainLabel, _domainAddress); 
  } 

  function isDomainInRole(bytes32 _roleLabel, bytes32 _domainLabel) public view returns(bool){
    if(roles[_roleLabel].domains[_domainLabel] != 0){return true;}
    return false;
  }

  function getDomainAddress(bytes32 _domainLabel) public view returns (address domainAddress) {domainAddress = domains[_domainLabel];}

  function isCircle() external pure returns(bool){return true;} 
}
