pragma solidity >=0.4.21 <0.6.0;

import "./RolesInteraction.sol";
import "./ERC721.sol";

contract RoleOwnership is RolesInteraction, ERC721 {

  mapping (uint => address) roleApprovals;

  function balanceOf(address _owner) external view returns(uint256) {
    return ownerRoleCount[_owner];
  }

  function ownerOf(uint _tokenId) external view returns(address) {
    return roleToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerRoleCount[_to] = ownerRoleCount[_to].add(1);
    ownerRoleCount[_from] = ownerRoleCount[_from].sub(1);
    roleToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint _tokenId) external payable {
    require (roleToOwner[_tokenId] == msg.sender || roleApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    roleApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

}
