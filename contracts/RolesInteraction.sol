pragma solidity >=0.4.21 <0.6.0;

contract RolesInteraction is RoleHelper {

  uint randNonce = 0;
  uint interactVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  function interact(uint _roleId, uint _targetId) external onlyOwnerOf(_roleId) {
    Role storage myRole = roles[_roleId];
    Role storage partnerRole = roles[_targetId];
    uint rand = randMod(100);
    if (rand <= interactVictoryProbability) {
      myRole.winCount = myRole.winCount.add(1);
      myRole.level = myRole.level.add(1);
      partnerRole.lossCount = partnerRole.lossCount.add(1);
      interactAndMultiply(_roleId, partnerRole.skill, "role");
    } else {
      myRole.lossCount = myRole.lossCount.add(1);
      partnerRole.winCount = partnerRole.winCount.add(1);
      _triggerCooldown(myRole);
    }
  }
}
