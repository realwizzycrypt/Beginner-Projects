// DESCRIPTION: A simple Storage Factory contract that creates other storage contracts and interacts with them

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "https://raw.githubusercontent.com/realwizzycrypt/SimpleStorage/refs/heads/main/SimpleStorage.sol";

contract StorageFactory {

    SimpleStorage[] public listOfsimpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        listOfsimpleStorageContracts.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        listOfsimpleStorageContracts[_simpleStorageIndex].store(_newSimpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return listOfsimpleStorageContracts[_simpleStorageIndex].retrieve();
    }

    function getListOfSimpleStorageContractsSize() external view returns (uint256) {
        return listOfsimpleStorageContracts.length;
    }

}
