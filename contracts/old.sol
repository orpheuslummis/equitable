// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "fhevm/lib/TFHE.sol";
import "hardhat/console.sol";

contract Old {
    address owner;
    bool roundStarted;

    uint pointPerVoterPerCriterion = 100;
    string[] criteria;
    uint[] weights;
    uint[] allowances;
    address[] voters;


    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier hasNotStarted {
        require(roundStarted == false, "The round has already started");
        _;
    }

    function getRoundStarted() public view returns (bool) {
        return roundStarted;
    }

    function getVoters() public view returns (address[] memory) {
        return voters;
    }

    function addCriterion(string memory criterionName, uint weight) public onlyOwner hasNotStarted {
        criteria.push(criterionName);
        weights.push(weight);
    }

    function addVoter(address newVoter) public onlyOwner hasNotStarted {
        voters.push(newVoter);
    }

    function addAllowance(uint newAllowance) public onlyOwner hasNotStarted {
        allowances.push(newAllowance);
    }

    function addVoters(address[] memory newVoters) public onlyOwner hasNotStarted {
        for (uint i = 0; i < newVoters.length; i++) {
            voters.push(newVoters[i]);
        }
    }

    function addAllowances(uint[] memory newAllowances) public onlyOwner hasNotStarted {
        for (uint i = 0; i < newAllowances.length; i++) {
            allowances.push(newAllowances[i]);
        }
    }


    // When the parameters are correctly set up, the owner of the contract can launch the voting round
    function startVotingRound() public onlyOwner hasNotStarted {
        require(allowances.length == voters.length, "To start the round, you need the exact same number of voters and allowances");
        require(voters.length >= 3, "You must have at least 3 participants");
        require(criteria.length >= 1,"You must have at least one criterium");
        roundStarted = true;
    }
}