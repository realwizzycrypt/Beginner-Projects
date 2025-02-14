pragma solidity ^0.8.26;

contract Coin {

    address public minter;
    mapping(address => uint) public balances;
