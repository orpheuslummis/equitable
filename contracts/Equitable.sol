// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "fhevm/lib/TFHE.sol";
import "hardhat/console.sol";

// We assume admin is also a player in a round.
// In this implementation, the player scores are not kept secret for lack of time.

// désolé Cédric, je n'ai pas fini le programe.

contract Equitable {
    address owner;
    bool roundStarted;

    string[] criteria;
    uint[] criteriaWeights;
    uint[] allowances;
    address[] voters;
    euint32 pointPerVoterPerCriterion = TFHE.asEuint32(100);

    mapping(address => mapping(string => mapping(address => euint32))) votes;
    mapping(address => mapping(string => bool)) hasVotedOnCriterion;
    mapping(address => uint) scores;
    mapping(address => uint) finalAllowances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier hasNotStarted() {
        require(roundStarted == false, "The round has already started");
        _;
    }

    modifier hasStarted() {
        require(roundStarted == true, "The round has not started yet");
        _;
    }

    function getRoundStarted() public view returns (bool) {
        return roundStarted;
    }

    function startRound(
        string[] calldata newCriteria,
        uint[] calldata newWeights,
        address[] calldata newVoters,
        uint[] calldata newAllowances
    ) external onlyOwner hasNotStarted {
        require(newCriteria.length == newWeights.length, "You must have the same number of criteria and weights");
        require(newVoters.length == newAllowances.length, "You must have the same number of voters and allowances");
        require(newVoters.length >= 3, "You must have at least 3 participants");
        require(newCriteria.length >= 1, "You must have at least one criterion");

        // Empty the current state arrays
        delete criteria;
        delete criteriaWeights;
        delete voters;
        delete allowances;

        // Manual copy from calldata to storage
        for (uint i = 0; i < newCriteria.length; i++) {
            criteria.push(newCriteria[i]);
        }
        for (uint i = 0; i < newWeights.length; i++) {
            criteriaWeights.push(newWeights[i]);
        }
        for (uint i = 0; i < newVoters.length; i++) {
            voters.push(newVoters[i]);
        }
        for (uint i = 0; i < newAllowances.length; i++) {
            allowances.push(newAllowances[i]);
        }
        roundStarted = true;
    }

    // A participant, for a criterion, gives a score to each other voter
    // ensure the sender is a voter
    // ensure it is called once
    // ensure that each score is between 0 and 100
    // ensure that the sender has not already voted for this criterion for this voter
    // ensure that the criterion exists
    // ensure that the criterion is not already voted for by the sender
    // ensure that the total score is 100
    function voteOnCriterion(
        address[] calldata otherVoters,
        bytes[] calldata score,
        uint criterionIndex
    ) public hasStarted {
        require(voters.length - 1 == otherVoters.length, "You must score every other voter.");
        require(score.length - 1 == otherVoters.length, "You must score every other voter.");
        require(criterionIndex < criteria.length, "Invalid criterion index.");
        require(isVoter(msg.sender), "Caller is not a voter.");
        // "You have already voted for this criterion for this voter.");
        TFHE.optReq(TFHE.le(votes[msg.sender][criteria[criterionIndex]][otherVoters[0]], TFHE.asEuint32(0)));

        euint32 totalScore = TFHE.asEuint32(0);

        for (uint i = 0; i < otherVoters.length; i++) {
            euint32 s = TFHE.asEuint32(score[i]);
            TFHE.optReq(TFHE.le(s, pointPerVoterPerCriterion)); // "Score must be between 0 and 100."
            totalScore = TFHE.add(totalScore, s);
        }

        // ensure the total score is 100
        TFHE.optReq(TFHE.eq(totalScore, pointPerVoterPerCriterion)); // "Total score must be 100."

        for (uint i = 0; i < otherVoters.length; i++) {
            euint32 s = TFHE.asEuint32(score[i]);
            votes[msg.sender][criteria[criterionIndex]][voters[i]] = s;
        }

        hasVotedOnCriterion[msg.sender][criteria[criterionIndex]] = true;
    }

    function isRoundFinished() public view returns (bool) {
        for (uint i = 0; i < voters.length; i++) {
            for (uint j = 0; j < criteria.length; j++) {
                if (!hasVotedOnCriterion[voters[i]][criteria[j]]) {
                    return false;
                }
            }
        }
        return true;
    }

    // end of round calculation
    function endRound() public hasStarted {
        // for all voters, check they have voted on all criteria
        for (uint i = 0; i < voters.length; i++) {
            for (uint j = 0; j < criteria.length; j++) {
                require(hasVotedOnCriterion[voters[i]][criteria[j]], "Not all voters have voted on all criteria.");
            }
        }

        // compute the final score for each voter (encrypted version not used in this version)
        // a linear combination of the scores for each criterion, weighted by the criterion weights
        // for (uint i = 0; i < voters.length; i++) {
        //     address v = voters[i];
        //     for (uint c = 0; c < criteria.length; c++) {
        //         string memory criterion = criteria[c];
        //         euint32 sumScore = TFHE.asEuint32(0);
        //         for (uint k = 0; k < voters.length; k++) {
        //             if (v != voters[k]) {
        //                 // ensure a voter is not voting for themselves
        //                 euint32 weight = TFHE.asEuint32(criteriaWeights[c]);
        //                 euint32 e_score = votes[voters[k]][criterion][v];
        //                 euint32 e_weighted_score = TFHE.mul(e_score, weight);
        //                 sumScore = TFHE.add(sumScore, e_weighted_score);
        //             }
        //         }
        //         scores[v] = sumScore; // The total score for a voter is the sum of weighted votes across all criteria
        //     }
        // }
        // we'd like an encrypted sort here

        // compute the final allowance for each voter
        // allowances are assigned in descending order, the voter with the highest score gets the highest allowance
        address[] memory sortedVoters = sortVotersByScore();
        for (uint i = 0; i < sortedVoters.length; i++) {
            finalAllowances[sortedVoters[i]] = allowances[i];
        }
    }

    function sortVotersByScore() internal view returns (address[] memory) {
        address[] memory sortedVoters = voters;
        for (uint i = 0; i < sortedVoters.length; i++) {
            for (uint j = i + 1; j < sortedVoters.length; j++) {
                if (scores[sortedVoters[i]] < scores[sortedVoters[j]]) {
                    address temp = sortedVoters[i];
                    sortedVoters[i] = sortedVoters[j];
                    sortedVoters[j] = temp;
                }
            }
        }
        return sortedVoters;
    }

    // A helper function to determine if an address is a voter
    function isVoter(address potentialVoter) internal view returns (bool) {
        for (uint i = 0; i < voters.length; i++) {
            if (voters[i] == potentialVoter) {
                return true;
            }
        }
        return false;
    }

    // function getFullResultAllowancesFHE(bytes32 publicKey) public view returns (bytes[] memory) {
    //     bytes[] memory results = new bytes[](voters.length);
    //     for (uint i = 0; i < voters.length; i++) {
    //         address v = voters[i];
    //         results[i] = (TFHE.reencrypt(finalAllowances[v], publicKey));
    //     }
    //     return results;
    // }

    function getResultingAllowances() public view returns (uint[] memory) {
        uint[] memory results = new uint[](voters.length);
        for (uint i = 0; i < voters.length; i++) {
            address v = voters[i];
            results[i] = finalAllowances[v];
        }
        return results;
    }
}
