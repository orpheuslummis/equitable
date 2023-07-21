// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract simpleVotingContract {

    address owner;
    bool hasBegun;

    string[] criteria;
    uint[] weights;
    uint[] allowances;
    address[] voters;

    mapping(address => uint) scores; //euint
    mapping(address => uint) finalAllowance; //euint

    mapping(address => mapping(string => mapping(address => uint))) votes; // Le uint doit être un euint. 

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _; 
    }

    //Check that the campaign has not started 
    modifier hasNotStarted {
        require(hasBegun == false,"The campaign has already started");
        _;
    }

    // Set up the criterias, allowances and participants
    function addCritterium(string memory criterium, uint associatedWeight) public onlyOwner hasNotStarted {
        criteria.push(criterium);
        weights.push(associatedWeight);
    }
    function addVoter(address newVoter) public onlyOwner hasNotStarted {
        voters.push(newVoter);
    }
    function addPrice(uint newPrice) public onlyOwner hasNotStarted {
        allowances.push(newPrice);
    }
    

    // Whent the parameters are corectly set up, the owner of the contract can launch the voting session
    function startVotingSession() public onlyOwner hasNotStarted {
        require(allowances.length == voters.length,"To start the session, you need the exact same number of voters and allowances");
        require(voters.length > 2, "You must have at least 3 participants");
        require(criteria.length >= 1,"You must have at least one criterium");
        hasBegun = true;

    }

    function isVoteFinished() public view returns(bool) {
        for(uint i = 0 ; i < voters.length;i++) {
            if(voterLevelValidity(voters[i]) == false) {
                return false; 
            }
        }

        return true; 
    }

    // Check if a specific voter, for a specific criterium, has submitted a valid vote (i.e. )
    function criteriumLevelValidity(address voter, string memory criterium) public view returns(bool) {
        uint sum = 0; 

        for(uint i = 0 ; i < voters.length; i++) {
            if(voters[i] != voter) {
                sum += votes[voter][criterium][voters[i]];
            }
        }

        if(sum == 1000) {
            return true;
        } 

        return false; 
        
    }

    // Ckeck if a voter has submitted a valid vote, over all criteria
    function voterLevelValidity(address voter) public view returns(bool) {

        for(uint i = 0 ; i < criteria.length ; i++) {
            if(criteriumLevelValidity(voter,criteria[i]) == false) {
                return false; 
            }
        }

        return true; 
    }

    // One voter votes for one participant, on one criterium
        // Has to be private 
    function vote(address target, string memory criterium, uint value) public {
        require(hasBegun,"The vote has not started yet");
        votes[msg.sender][criterium][target] = value; 
    }

    function scoreComputation() public onlyOwner {
        require(isVoteFinished(),"All the voters have not submitted valid votes for all the criterias."); 

        for(uint i = 0 ; i < voters.length ; i++) {
            for(uint j = 0 ; j < criteria.length ; i++) {
                for(uint )
            }
        }
    }





}



