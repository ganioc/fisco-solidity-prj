pragma solidity ^0.4.25;

// import "./POSLib.sol";
import "./Table.sol";

contract POSBase {
    uint256 index;

    // owner of contract
    address private owner;

    // name 
    string internal LOC;

    constructor(string loc)public{
        owner = msg.sender;
        index = 0;
        LOC = loc;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    function getInex() public view returns(uint256){
        return index;
    }
    function getOwner() public view returns(address){
        return owner;
    }
    function getLoc() public view returns(string){
        return LOC;
    }
    function incIndex() internal{
        index++;
    }

    function getTableFactory() internal returns(TableFactory){
        return TableFactory(0x1001);
    }
    function openTable(string tableName) internal returns (Table) {
        return getTableFactory().openTable(tableName);
    }
    function getByStr(string tableName,string column, string val) internal returns (Entries){
        Table table = openTable(tableName);

        Condition condition = table.newCondition();
        condition.EQ(column, val);
        return table.select(LOC, condition);

    }
    function getByNum(string tableName,string column, int256 num) internal returns (Entries){
        Table table = openTable(tableName);

        Condition condition = table.newCondition();
        condition.EQ(column, num);
        return table.select(LOC, condition);

    }

}