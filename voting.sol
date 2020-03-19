pragma solidity >=0.4.22 <0.7.0;

contract voteing{
    mapping(bytes32 => uint) public totalVotes;
    bytes32[] candidates;
    address[] voter;
    
    constructor(bytes32 _candidate) public {
        candidates.push(_candidate);
    }
    
    function vote(bytes32 _candidate) valid(_candidate) public returns (bool){
        require(oneTimeVoteOnly(msg.sender));
        totalVotes[_candidate] += 1;
        voter.push(msg.sender);
    }
    
    modifier valid(bytes32 _candidate){
        require(verifyCandidate(_candidate));
        _;
    }
    
    function oneTimeVoteOnly(address _voter) private view returns (bool){
        if(voter.length == 0){
            return true;
        }
        for(uint i=0;i<voter.length;i++){
            if(voter[i]==_voter){
                return true;
            }
        }
        return false;
    }
    
    function verifyCandidate(bytes32 _candidate) private view returns (bool){
        for(uint i=0;i<candidates.length;i++){
            if(candidates[i]==_candidate){
                return true;
            }
        }
        return false;
    }
}