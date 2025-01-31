// DESCRIPTION: A simple child contract that adds 5 to a stored number of its parent contract

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "https://raw.githubusercontent.com/realwizzycrypt/SimpleStorage/refs/heads/main/SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage {
    
    function store(uint256 _newNumber) public override{
        myFavoriteNumber = _newNumber + 5;
    }

}
