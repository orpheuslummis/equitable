// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "fhevm/lib/TFHE.sol";
import "hardhat/console.sol";

contract Equitable {
    address owner;
    bool roundStarted;

    string[] criteria;
    uint[] weights;
    uint[] allowances;
    address[] voters;

    mapping(address => euint32) scores;
    mapping(address => euint32) finalAllowance;

    mapping(address => mapping(string => mapping(address => euint32))) votes;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // Check that the round has not started
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

    // Set up the criterias, allowances and participants
    function addCriterium(string memory criteriumName, uint weight) public onlyOwner hasNotStarted {
        criteria.push(criteriumName);
        weights.push(weight);
    }

    function addVoter(address newVoter) public onlyOwner hasNotStarted {
        voters.push(newVoter);
    }

    function addAllowance(uint newAllowance) public onlyOwner hasNotStarted {
        allowances.push(newAllowance);
    }

    // When the parameters are correctly set up, the owner of the contract can launch the voting session
    function startVotingRound() public onlyOwner hasNotStarted {
        require(allowances.length == voters.length, "To start the session, you need the exact same number of voters and allowances");

        console.log("Voters count: %s", voters.length);

        require(voters.length >= 3, "You must have at least 3 participants");
        require(criteria.length >= 1,"You must have at least one criterium");
        roundStarted = true;
    }
}


/*
contract Counter {
    euint32 private counter;

    function add(bytes calldata encryptedValue) public {
        euint32 value = TFHE.asEuint32(encryptedValue);
        counter = TFHE.add(counter, value);
        // counter = TFHE.add(counter, counter);
    }

    function getCounter(bytes32 publicKey) public view returns (bytes memory) {
        return TFHE.reencrypt(counter, publicKey);
    }
}
*/