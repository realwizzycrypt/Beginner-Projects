// DESCRIPTION: A simple contract allows to owner to create a coin,...
// ...and send some amount of the coin to an address upon creation....
// ...Contract also allows for addresses to send coins which were...
//... sent to them by the contract owner or other addresses

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract Coin {

    address public minter;
    mapping(address => uint) public balances;

    constructor() {
        minter = msg.sender;
    }

    // Sends an amount of newly created coins to an address
    // Can only be called by the contract creator
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    // Sends an amount of existing coins
    // from any caller to an address
    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
    }
}
