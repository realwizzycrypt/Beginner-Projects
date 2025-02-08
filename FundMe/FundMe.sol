// DESCRIPTION: A simple fund-raising smart contract that allows the public to fund the owner (with nothing less than $5)...
// ...by sending/transfering funds to the contract.
// After which only the contract owner can withdraw the received funds.

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts@1.3.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256 (price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() public view returns (uint256){
        return AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).version();
    }
}

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant minimumUsd = 5 * 1e18;

    address[] public funders;

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd, "didnt send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    receive() external payable { 
        fund(); 
    }

    fallback() external payable { 
        fund(); 
    }
}
