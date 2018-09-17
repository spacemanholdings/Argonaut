pragma solidity ^0.4.24;

import "./ENS.sol";
interface IdentityRegistrar {function register(bytes32 label, address owner,address identityContract) external;}

contract Identity {
  struct id {
    address addr;
    string name;
    string email;
    bytes32 ipfsHash;  
  }
  
  id IDENT;
  address owner;

  modifier ownerOnly(address _owner) {
    require(_owner == owner, "This address doesn't own this identity");
    _;
  }

  constructor(bytes32 _ownerLabel, bytes32 _ownerNode, address _newAddr, string _newName, string _newEmail, bytes32 _newIpfsHash) public{
    owner = msg.sender;
    IDENT.addr = msg.sender;
    ENS ons = ENS(0xeb3b8911f31372d597f32206fe731a148d57043c);
    IdentityRegistrar iR = IdentityRegistrar(0xdb515ec28da84b38e033667bc0f1878b32740651);
    iR.register(_ownerLabel, address(msg.sender), address(this));
    //ons.setResolver(_ownerNode, address(this));
    setInfo(_newAddr, _newName, _newEmail, _newIpfsHash);
  }

  /* Get Function for Identity */
  function getAddr() public view returns (address _addr){ return IDENT.addr; }
  function getName() public view returns (string _name){ return IDENT.name; }
  function getEmail() public view returns (string _email){ return IDENT.email; }
  function getContent() public view returns (bytes32 _ipfsHash) { return IDENT.ipfsHash; }
  function getInfo() public view returns(address _addr, string _name, string _email, bytes32 _ipfsHash) {
    _addr = IDENT.addr;
    _name = IDENT.name;
    _email = IDENT.email;
    _ipfsHash = IDENT.ipfsHash;
  }

  event NewOwner(address indexed _newOwner);
  event NewAddress(address indexed _newAddress);
  event NewName(string indexed _newName);
  event NewEmail(string indexed _newEmail);
  event NewContentHash(bytes32 indexed _newIpfsHash);

  function setOwner(address _newOwn) public ownerOnly(msg.sender) { owner = _newOwn; emit NewOwner(owner); }
  function setAddress(address _newAddr) public ownerOnly(msg.sender) { IDENT.addr = _newAddr; emit NewAddress(IDENT.addr); }
  function setName(string _newName) public ownerOnly(msg.sender) { IDENT.name = _newName; emit NewName(IDENT.name); }
  function setEmail(string _newEmail) public ownerOnly(msg.sender) { IDENT.email = _newEmail; emit NewEmail(IDENT.email); }
  function setIpfsHash(bytes32 _newIpfsHash) public ownerOnly(msg.sender) { IDENT.ipfsHash = _newIpfsHash; emit NewContentHash(IDENT.ipfsHash); }
  function setInfo(address _newAddr, string _newName, string _newEmail, bytes32 _newIpfsHash) ownerOnly(msg.sender) public {
    IDENT.addr = _newAddr; 
    emit NewAddress(IDENT.addr); 
    IDENT.name = _newName; 
    emit NewName(IDENT.name);
    IDENT.email = _newEmail;
    emit NewEmail(IDENT.email);
    IDENT.ipfsHash = _newIpfsHash;
    emit NewContentHash(IDENT.ipfsHash);
  }

  // INTERFACE FUNCTIONS
  function supportsInterface(bytes4 interfaceID) public pure returns (bool){
    return interfaceID == 0x3b3b57de;
  }
  function addr(bytes32 node) public view returns (address){
    return address(this); // so you can figure out what the dev.identity.arg address is. 
      // what this contract points to is gotten using getAddr();  
  }

}