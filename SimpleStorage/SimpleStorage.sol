// DESCRIPTION: A simple solidity smart contract to store favorite numbers

// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract SimpleStorage{

    uint256 myFavoriteNumber; // 0

    struct Person{
        uint256 favoriteNumber;
        string name;
    } 

    Person[] public listOfPeople;

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    } 

    function retrieve() public view returns (uint256){
         return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push( Person(_favoriteNumber, _name) );
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

}
  
