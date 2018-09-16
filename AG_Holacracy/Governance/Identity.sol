pragma solidity ^0.4.24;

contract Identity {
  struct id {
    address addr;
    string name;
    string email;
    bytes32 ipfsHash;  
  }
  
  id IDENT;
  address owner;

  modifier ownerOnly(address _owner){
    require(_owner == owner, "This address doesn't own this identity");
    _;
  }

  constructor(address _addr){
    owner = msg.sender;
    IDENT.addr = _addr;
  }

  /* Get Function for Identity */
  function getAddr() public view returns (address _addr){ return IDENT.addr; }
  function getName() public view returns (string _name){ return IDENT.name; }
  function getEmail() public view returns (string _email){ return IDENT.email; }
  function getContent() public view returns (bytes32 _ipfsHash) { return IDENT.ipfsHash; }
  
  event NewOwner(address indexed _newOwner);
  event NewAddress(address indexed _newAddress);
  event NewName(string indexed _newName);
  event NewEmail(string indexed _newEmail);
  event NewContentHash(bytes32 indexed _newIpfsHash);

  function setOwner(address _newOwn) public ownerOnly(msg.sender) { owner = _newOwn; emit NewOwner(owner); }
  function setAddress(address _newAddr) public ownerOnly(msg.sender) { IDENT.addr = _newAddr; emit NewAddress(IDENT.addr); }
  function setName(string _newName) public ownerOnly(msg.sender) { IDENT.name = _newName; emit NewName(IDENT.name); }
  function setEmail(string _newName) public ownerOnly(msg.sender) { IDENT.email = _newEmail; emit NewEmail(IDENT.email); }
  function setIpfsHash(bytes32 _newIpfsHash) public ownerOnly(msg.sender) { IDENT.ipfsHash = _newIpfsHash; emit NewContentHash(IDENT.ipfsHash); }

}