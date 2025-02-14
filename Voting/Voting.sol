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

    /// Create a new ballot to choose one of proposalNames`.
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // For each of the provided proposal names,
        // create a new proposal object and add it
        // to the end of the array.
        for (uint i = 0; i < proposalNames.length; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // Deploy the contract with the proposal names...
    // ... for example
    // ["0x50726f706f73616c410000000000000000000000000000000000000000000000", "0x50726f706f73616c420000000000000000000000000000000000000000000000"]


    // Give `multiple voters in an array` the right to vote on this ballot.
    // May only be called by `chairperson`.
    function giveRightToVote(address[] memory votersArray) external {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );

        for (uint i = 0; i < votersArray.length; i++) {
            address voter = votersArray[i];
            require(
                !voters[voter].voted,
                "The voter already voted."
            );
            require(voters[votersArray[i]].weight == 0);
            voters[votersArray[i]].weight = 1;
        }
        
    }

    /// Delegate your vote to the voter `to`.
    function delegate(address to) external {
        // assigns reference
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote");
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }

        Voter storage delegate_ = voters[to];

        // Voters cannot delegate to accounts that cannot vote.
        require(delegate_.weight >= 1);

        // Since `sender` is a reference, this
        // modifies `voters[msg.sender]`.
        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to their weight.
            delegate_.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal proposals[proposal].name`.
    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// Compute the winning proposal taking all
    /// previous votes into account.
    function winningProposals() public view
            returns (uint[] memory winningProposals_)
    {
        uint winningVoteCount = 0;
        uint numWinners = 0;

        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
            }
        }

        // Collect all proposals with the highest vote count
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount == winningVoteCount) {
                numWinners++;
            }
        }

        // Initialize the array of winning proposals
        winningProposals_ = new uint[](numWinners);
        uint index = 0;

            // Populate the array
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount == winningVoteCount) {
                winningProposals_[index] = p;
                index++;
            }
        }

    }

    // Calls winningProposal() function to get the index
    // of the winner contained in the proposals array and then
    // returns the name of the winner
    function winnerName() external view
            returns (bytes32[] memory winnerNames_)
    {
        uint[] memory winners = winningProposals();
        winnerNames_ = new bytes32[](winners.length);
        for (uint i = 0; i < winners.length; i++) {
            winnerNames_[i] = proposals[winners[i]].name;
        }
    }

}


