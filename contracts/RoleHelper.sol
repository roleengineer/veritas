pragma solidity >=0.4.21 <0.6.0;

import "./RoleInteract.sol";

contract RoleHelper is RoleInteract {

  uint levelUpFee = 0.001 ether;

  modifier avobeLevel(uint _level, uint _roleId) {
    require(roles[_roleId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    address _owner = owner();
    _owner.transfer(address(this).balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _roleId) external payable {
    require(msg.value == levelUpFee);
    roles[_roleId].level = roles[_roleId].level.add(1);
  }

  function changeName(uint _roleId, string _newName) external aboveLevel(20, _roleId) onlyOwnerOf(_roleId) {
    roles[_roleId].name = _newName;
  }

  function changeSkill (uint _roleId, uint _newSkill) external aboveLevel(2, _roleId) onlyOwnerOf(_roleId) {
    roles[_roleId].skill = _newSkill; //after change Skill type from uint to array change it to push new skills
  }

  function getRolesbyOwner(address _owner) external view return(uint[]) {
    uint[] memory result = new uint[](ownerRoleCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < roles.length; i++) {
      if (roleToOwner == _owner) {
        result[counter] = i;
        counter = counter.add(1);
      }
    }
    return result;
  }

}
