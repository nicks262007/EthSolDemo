pragma solidity >=0.4.22 <0.7.0;


contract Hospital{
	struct Room{
    	//complete the struct
    	bytes32 roomName;
    	string patientName;
    	bool isVacate;
	}
	Room[] public rooms;
    
	constructor (bytes32[] memory _names) public{
    	for(uint i=0;i<_names.length;i++){
    	    rooms.push(Room({
    	        roomName:_names[i],
    	        patientName:"none",
    	        isVacate:true
    	    }));
    	}      	 
    	}
	function assignRoom(bytes32 roomName, string memory patientName) public returns(string memory){
    	for(uint i=0;i<rooms.length;i++){
    	    if(rooms[i].roomName==roomName){
    	        if(rooms[i].isVacate==false){
    	            return "room occupied.";
    	        }else{
    	        rooms[i].patientName = patientName;
    	        rooms[i].isVacate = false;
    	        return "assigned.";
    	        }
    	    }
    	}
           	 	
    	}
    }