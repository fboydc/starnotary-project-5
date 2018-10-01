pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

/************************************************************************************************
Name: StarNotary
Parent Class: ERC721 - provided from Open Zeppelin
Structs: 
Star, Coordinators
Instance Variable:
tokenIdToStar - <Star mapping> - Stores all our star structs
allStars - array <uint256> - contains all the ids to our stars. We can use it to traverse our stars in tokenIdToStars
starsForSale - <uint256 mapping> - Stores our stars set for sale, set as a [star id] => [star price] basis.
starsAvailable - array <uint256> - contains all the ids to our stars set for sale. We can use it to traverse our stars in starsForSale.
tokenIdToCoordinates - <Coordinators mapping> - Stores the coordinates for each star.
tokenIdToOwners - <uint256 mapping> - Stores the owner of each star.
Description: 
Star Notary allows users to create, buy, and sell stars in the ethereum blockchain. This contract
servers as a unique source of truth for star buyers. 
************************************************************************************************/
contract StarNotary is ERC721 { 

    
    /**************************************************
    Name: Star
    Type: Struct
    Instance Variables:
    name - <String> - The name of the star
    story - <String> - a unique story of the star
    ****************************************************/
    struct Star { 
        string name; 
        string story;
    }

    /**************************************************
    Name: Coordinators
    Type: Struct
    Instance Variables:
    dec - <String> - The decimation coordinate
    mag - <String> - The magnitude of the star
    cent - <String> - the right ascension value of the star.
    ****************************************************/
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


    /***********************************************************************************
    Name: createStar
    Type: Method
    Parameters: string, uint256, string, string, string, string
    Returns: nothing
    Description:
    checks if a star with given coordinates exists (with the helper function createStar), 
    adds the caller address to the tokenIdToOwners as a new entry, creates a new star and 
    coordinates, and adds it to its respective mappings. Each star info and coordinates will
    map to the tokenId passed.
    ***********************************************************************************/
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

    /***********************************************************************************
    Name: checkIfStarExist
    Type: Method
    Parameters: string, string, string
    Returns: bool
    Description:
    Helper method for createStar function. Will check if a star with given coordinates
    exist.
    ***********************************************************************************/
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

    /***********************************************************************************
    Name: equal
    Type: Method
    Parameters: string, string
    Returns: bool
    Description:
    Compares two strings for equality.
    ***********************************************************************************/
    function equal(string a, string b) private returns(bool) {
        if(bytes(a).length != bytes(b).length) {
            return false;
        }else {
            return keccak256(a) == keccak256(b);
        }
    }


    /***********************************************************************************
    Name: putStarUpForSale
    Type: Method
    Parameters: uint256, uint256
    Returns: nothing
    Description:
    Sets the specified star by _tokenId for sale with the specified price.
    ***********************************************************************************/
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public { 
        require(this.ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;
    }


    /***********************************************************************************
    Name: buyStar
    Type: Method
    Parameters: uint256
    Returns: nothing
    Description:
    Checks if the specified star is in the starsForSale array, and checks the correct wei value
    as proposed by the caller. If both of this conditions are met, the star is no longer set for
    sale, the token is now transfered to the caller and an ether transfer is executed to the
    ex owner. If any change is needed from the transaction, change ether is send back to the 
    caller.
    ***********************************************************************************/
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
    
    /***********************************************************************************
    Name: tokenIdToStarInfo
    Type: Method
    Parameters: uint256
    Returns: string, string, string, string, string
    Description:
    Retrieves the star information (name, story, cent, dec, mag) for the specified star ID.
    ***********************************************************************************/
    function tokenIdToStarInfo(uint _tokenId)public view returns (string name, string story, string cent, string dec, string mag) {
        Star star = tokenIdToStar[_tokenId];
        Coordinators coords = tokenIdToCoordinates[_tokenId];

        return (star.name, star.story, coords.cent, coords.dec, coords.mag);

    }

    /***********************************************************************************
    Name: allStarsLength
    Type: Method
    Parameters: none
    Returns: uint256
    Description:
    Returns the length of the allStars array.
    ***********************************************************************************/
    function allStarsLength()public view returns(uint256){
        return allStars.length;
    }

    
}