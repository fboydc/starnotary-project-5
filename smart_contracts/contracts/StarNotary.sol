pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract StarNotary is ERC721 { 

    

    struct Star { 
        string name; 
        string story;
    }

    
    struct Coordinators {
        string dec;
        string mag;
        string cent;
    }

    mapping(uint256 => Star) public tokenIdToStar; 
    uint256[] public allStars;
    mapping(uint256 => uint256) public starsForSale;
    uint256[] public starsAvailable;
    mapping(uint256 => Coordinators) public tokenIdToCoordinates;
    mapping(uint256 => address) public tokenIdToOwners;

    function createStar(string _name, uint256 _tokenId, string dec, string mag, string cent, string story) public { 
        require(checkIfStarExist(dec, mag, cent));

        tokenIdToOwners[_tokenId] = msg.sender;

        Coordinators memory coords = Coordinators(dec, mag, cent);

        Star memory newStar = Star(_name, story);

        tokenIdToStar[_tokenId] = newStar;
        tokenIdToCoordinates[_tokenId] = coords;
        allStars.push(_tokenId);

        _mint(msg.sender, _tokenId);
    }

    function checkIfStarExist(string dec, string mag, string cent) private returns (bool) {
        for(uint i = 0; i < allStars.length; i++){
            uint256 next = allStars[i];
            Coordinators coords = tokenIdToCoordinates[next];
            if(equal(coords.dec, dec) && equal(coords.mag, mag) && equal(coords.cent, cent)){
                return false;
            }
        }

        return true;
    }

    function equal(string a, string b) private returns(bool) {
        if(bytes(a).length != bytes(b).length) {
            return false;
        }else {
            return keccak256(a) == keccak256(b);
        }
    }



    function putStarUpForSale(uint256 _tokenId, uint256 _price) public { 
        require(this.ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable { 
        require(starsForSale[_tokenId] > 0);
        
        uint256 starCost = starsForSale[_tokenId];
        address starOwner = this.ownerOf(_tokenId);
        require(msg.value >= starCost);

        _removeTokenFrom(starOwner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);
        
        starOwner.transfer(starCost);

        if(msg.value > starCost) { 
            msg.sender.transfer(msg.value - starCost);
        }
    }
 
    function tokenIdToStarInfo(uint _tokenId)public view returns (string name, string story, string cent, string dec, string mag) {
        Star star = tokenIdToStar[_tokenId];
        Coordinators coords = tokenIdToCoordinates[_tokenId];

        return (star.name, star.story, coords.cent, coords.dec, coords.mag);

    }

    
}