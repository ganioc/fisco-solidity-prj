pragma solidity >=0.4.0 <=0.6.0; 
contract PiggyBank{
    address creator;
    uint deposits;
    
    constructor() public {
        creator = msg.sender;
        deposits = 0;
    }
    function deposit() public payable returns (uint){
        if(msg.value > 0)
            deposits = deposits + 1;
        return getNumberOfDeposits();
    }
    function getNumberOfDeposits() public constant returns (uint){
        return deposits;
    }
    function kill() public{
        if(msg.sender == creator){
            selfdestruct(creator);
        }
    }
}