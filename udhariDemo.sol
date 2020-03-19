pragma solidity >=0.4.22 <0.7.0;

contract udhariDemo{
    struct Participant{
        string name;
        address paddress;
        int balance;
    }
    struct Expense{
        string title;
        uint amount;
        address payer;
        address[] payee;
        mapping(address=>bool) validexpense;
    }
    struct Payment{
        string title;
        uint amount;
        address payer;
        address payee;
    }
    
    mapping(address=>Participant) public participants;
    mapping(address=>uint) public withdrwals;
    Expense[] public expenses;
    Payment[] public payments;
    
    constructor(string memory _name) public{
        createParticipant(_name, msg.sender);
    }
    
    function validateExpence(uint _indexExpese,bool _agree)public{
        Expense storage e = expenses[_indexExpese];
        require(e.validexpense[msg.sender]!=_agree);
        //e.validexpense[msg.sender]=_agree;
        uint numValidAgreement = getValidExpense(_indexExpese);
        if(numValidAgreement!=0){
            revertBalance(_indexExpese);
        }
        e.validexpense[msg.sender]=_agree;
        numValidAgreement = getValidExpense(_indexExpese);
        syncBalance(_indexExpese);
        
    }
    
    function revertBalance(uint _indexExpese) internal{
        calculateBalance(_indexExpese,true);
    }
    
    function syncBalance(uint _indexExpese) internal{
         calculateBalance(_indexExpese,false);
    }
    
    function calculateBalance(uint _indexExpese, bool isRevert) internal{
        uint numValidAgreement = getValidExpense(_indexExpese);
        require(numValidAgreement>0);
        Expense storage e = expenses[_indexExpese];
        int share = int(e.amount/numValidAgreement);
        int amt = int(e.amount);
        if(isRevert){
            share = -(share);
            amt = -(amt);
        }
        participants[e.payer].balance +=amt;
        for(uint i=0;i<e.payee.length;i++){
            if(e.validexpense[e.payee[i]]){
                 participants[e.payee[i]].balance -=share;
            }
        }
    }
    
    function getValidExpense(uint _indexExpese) public returns (uint){
        Expense storage e = expenses[_indexExpese];
        uint validCount = 0;
        for(uint i=0;i<e.payee.length;i++){
            if(e.validexpense[e.payee[i]] == true){
                validCount++;
            }
        }
        return validCount;
    }
    
    function withdrwal()public{
        require(withdrwals[msg.sender]>0);
        uint amount = withdrwals[msg.sender];
        withdrwals[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
    
    function createPayment(string memory _title,  address  _payee) public payable{
        require(msg.value>0);
        Payment memory p = Payment({
                    title:  _title,
                    amount :   msg.value,
                    payer:  msg.sender,
                    payee : _payee
                });
        payments.push(p);
        withdrwals[_payee] = msg.value;
    }
    
    function createExpense(string memory _title, uint _amt, address[] memory _payees) public{
        require(_amt>0 && _payees.length>0 && _payees.length<20);
        Expense memory e = Expense({
                    title:  _title,
                    amount :   _amt,
                    payer:  msg.sender,
                    payee : _payees
                });
        expenses.push(e);
    }
    
    function createParticipant(string memory _name, address _paddr) public {
        require(_paddr != participants[_paddr].paddress);
        Participant memory p = Participant({
                                    name:_name,
                                    paddress:_paddr,
                                    balance:0
                                    });
        participants[_paddr] = p;                            
        
    }
    
   
}
