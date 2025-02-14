// DESCRIPTION: A simple voting contract with user ability to vote and delegate votes... 
// ...to other eligible voters - voters who have been given the right to vote.

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.24;
 
contract Ballot {

    // Tnis represents a single voter.
    struct Voter {
        uint weight; // weight is accumulated by delegation and right to vote
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
    }

    // This is a type for a single proposal or candidate.
    struct Proposal {
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // An array of `Proposal` structs.
    Proposal[] public proposals;
