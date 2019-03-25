pragma solidity >=0.4.21 <0.6.0;

import "./Ownable.sol";
import "./SafeMath.sol";
/// @title Contract that creates new Roles
/// @dev Think about what is will be for real implementation
contract RoleFactory is Ownable {

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    event NewRole(uint id, string name, uint skill);

    uint skillDigits = 16;
    uint skillModulus = 10 ** skillDigits;
    uint cooldownTime = 1 days;

    struct Role {
        string name;
        uint skill;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Role[] public roles;

    mapping (uint => address) public roleToOwner;
    mapping (address => uint) ownerRoleCount;

    function _createRole(string memory _name, uint _skill) internal {
        uint id = roles.push(Role(_name, _skill, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        roleToOwner[id] = msg.sender;
        ownerRoleCount[msg.sender] = ownerRoleCount[msg.sender].add(1);
        emit NewRole(id, _name, _skill);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % skillModulus;
    }

    function createRandomRole(string memory _name) public {
        require(ownerRoleCount[msg.sender] == 0);
        uint randSkill = _generateRandomDna(_name);
        _createRole(_name, randSkill);
    }

}
