pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract StarNotary is ERC721 { 

    

    struct Star { 
        string name; 
        string story;
    }

    /*
    struct Coordinators {
        string dec;
        string mag;
        string cent;
    }*/

    mapping(uint256 => Star) public tokenIdToStarInfo; 
    //uint256[] public allStars;
    mapping(uint256 => uint256) public starsForSale;
   // uint256[] public starsAvailable;

    function createStar(string _name, string _story, uint256 _tokenId, string dec, string mag, string cent, string story) public { 

        Star memory newStar = Star(_name, _story);

        tokenIdToStarInfo[_tokenId] = newStar;
        //allStars.push(_tokenId);

        _mint(msg.sender, _tokenId);
    }

    function getName(uint256 _tokenId) public returns (string){
        Star memory star =  tokenIdToStarInfo[_tokenId];
        return (star.name);
    }

    /*
    function createStar(string _name, uint256 _tokenId, string dec, string mag, string cent, string story) public { 
        require(uniqueCoords(dec, mag, cent));

        Coordinators memory coords = Coordinators(dec, mag, cent);

        Star memory newStar = Star(_name, story, coords);

        tokenIdToStarInfo[_tokenId] = newStar;
        allStars.push(_tokenId);

        _mint(msg.sender, _tokenId);
    }*/

/*
    function uniqueCoords(string dec, string mag, string cent) private returns (bool) {
        for(uint i=0; i<allStars.length; i++){
            Star next = tokenIdToStarInfo[allStars[i]];
            Coordinators nextCoords = next.coords;
            if(equal(nextCoords.dec, dec) && equal(nextCoords.mag, mag) && equal(nextCoords.cent, cent)){
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
    }*/



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
}