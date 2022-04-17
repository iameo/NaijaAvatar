// SPDX-LICENSE-Identifier: UNLICENSED

pragma solidity ^0.8.7;
pragma experimental ABIEncoderV2;

contract Quiz {

    struct Card {
        string name;
    }

    struct Avatar {
        string name;
        address own;
        uint winCount;
        uint lossCount;
        uint level;
        uint64 cooldownEndBlock;
        uint64 creationTime;
        uint16 hp;
        uint16 generation;
        bool isAlive; // avatars are alive upon birth
        Card[] card;
        // mapping (address => Card[]) df;
    }

    mapping (uint => Avatar) public pers;

    mapping (address => Avatar) addr_tar;
    mapping (address => Avatar[]) addr_tars;


    mapping (address => uint) public avatarOwnerCount;
    mapping (uint => address) public avatarToOwner;

    Avatar[] public avatars;

    address[] public userAddress;

    uint numP;


    function rePm(uint _id) public view returns (Avatar memory) {
         return pers[_id];
    }

 

    function createAvatar(string memory name_, string memory card_name) public returns (uint pID, Avatar memory, address addr) {
        
        pID = avatars.length + 1;
        
        pers[pID  - 1].name = name_;
        pers[pID - 1].own = msg.sender;
        pers[pID - 1].winCount = 0;
        pers[pID - 1].lossCount = 0;
        pers[pID - 1].hp = 100;
        pers[pID - 1].generation = 0;
        pers[pID - 1].isAlive = true;
        pers[pID - 1].creationTime = uint64(block.timestamp);
        pers[pID - 1].cooldownEndBlock = 0;
    
        pers[pID - 1].card.push(Card(card_name));

        avatars.push(pers[pID - 1]);
        avatarOwnerCount[msg.sender] = avatarOwnerCount[msg.sender] + 1;
        avatarToOwner[pID - 1] = msg.sender; 
        userAddress.push(msg.sender);
        // pID = pID + 1;

        return (pID, pers[pID], msg.sender);

    }


    function createRandomZombie(string memory _name, string memory card_name) public {
        require(avatarOwnerCount[msg.sender] == 0, "Your avatar count ought be 0 to use this function");
        createAvatar(_name, card_name);
  }

    function rt() public view returns (uint po){
        po = avatarOwnerCount[msg.sender];

        return po;
    }

    function addCardToAvatar(string memory card_name, uint index) public returns (Card[] memory) {
        require(avatarOwnerCount[msg.sender] > 0, "You have no avatars yet.");
        require(index <= avatarOwnerCount[msg.sender] - 1, "Index is greater than your avatars count");
        Avatar storage avatar = avatars[index];

        avatar.card.push(Card(card_name));
        pers[index] = avatar;
        return avatar.card;

    }

    function vaddCard(uint index) public view returns (Avatar memory) {
        // Card memory cd = Card(card_name);
        Avatar memory avatar = avatars[index];
        return avatar;

    }


    function getAvatarsByOwner(address _owner) public view returns(uint[] memory) {
        uint[] memory result = new uint[](avatarOwnerCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < avatars.length; i++) {
          if (avatarToOwner[i] == _owner) {
            result[counter] = i;
            counter++;
          }
      }
    return result;
  }

}
