pragma solidity>=0.4.24 <0.6.11;

import "./Table.sol";

contract TstBase{
    uint256 index;

    address private owner;

    string internal LOC;

    constructor(string loc ) public {
        owner = msg.sender;
        index = 0;
        LOC = loc;
    }

    function getIndex() public view returns(uint256){
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
