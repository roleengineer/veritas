pragma solidity >=0.4.21 <0.6.0;

import "./RoleFactory.sol";
//Think about what deployed contract use for Interface and interact with to generate new senses and change Kitties
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract RoleExtInteract is RoleFactory {

  KittyInterface kittyContract;

  modifier onlyOwnerOf(uint _roleId) {
    require(msg.sender == roleToOwner[_roleId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Role storage _role) internal {
    _role.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Role storage _role) internal view returns(bool) {
    return (_role.readyTime <= now);
  }

  function interactAndMultiply(uint _roleId, uint _targetSkill, string _species) internal onlyOwnerOf(_roleId) {
    require(msg.sender == roleToOwner[_roleId]);
    Role storage myRole = roles[_roleId];
    require(_isReady(myRole));
    _targetSkill = _targetSkill % skillModulus;
    uint newSkill = (myRole.skill + _targetSkill) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newSkill = newSkill - newSkill % 100 + 99;
    }
    _createRole("NoName", newSkill);
    _triggerCooldown(myRole);
  }

  function interactOnKitty(uint _roleId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    // And modify function call here:
    interactAndMultiply(_roleId, kittyDna, "kitty");
  }

}
