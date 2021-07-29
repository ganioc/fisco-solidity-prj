pragma solidity >=0.4.24 <0.6.11;

import "./Table.sol";

contract TstBaseV6 {
    uint256 index;

    address private owner;

    string internal LOC;

    constructor(string loc) public {
        owner = msg.sender;
        index = 0;
        LOC = loc;
    }

    function getIndex() public view returns (uint256) {
        return index;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getLoc() public view returns (string) {
        return LOC;
    }

    function incIndex() internal {
        index++;
    }

    function getTableFactory() internal returns (TableFactory) {
        return TableFactory(0x1001);
    }

    function openTable(string tableName) internal returns (Table) {
        return getTableFactory().openTable(tableName);
    }

    function getByStr(string tableName, string val) internal returns (Entries) {
        Table table = openTable(tableName);

        Condition condition = table.newCondition();
        condition.EQ("berth_id", val);
        return table.select(tableName, condition);
    }

    function getByNum(string tableName, uint256 num)
        internal
        returns (Entries)
    {
        Table table = openTable(tableName);

        Condition condition = table.newCondition();
        condition.EQ("index", int256(num));
        return table.select(tableName, condition);
    }

    function getRecordCount(
        string tableName,
        string colTimeName,
        int256 start,
        int256 end
    ) internal returns (int256) {
        Table table = openTable(tableName);

        Condition condition = table.newCondition();
        condition.GE(colTimeName, start);
        condition.LT(colTimeName, end);
        Entries entries = table.select(tableName, condition);
        return int256(entries.size());
    }

    // colTime - name of column of time
    function getRecordBase(
        string tableName,
        int256 offset,
        int256 size,
        string colTimeName,
        int256 start,
        int256 end
    ) internal returns (Entries) {
        Table table = openTable(tableName);

        Condition condition = table.newCondition();
        condition.GE(colTimeName, start);
        condition.LT(colTimeName, end);
        condition.limit(offset, size);
        Entries entries = table.select(tableName, condition);
        return entries;
    }

    function getRecordCountByCol(
        string tableName,
        string columnName,
        string val,
        string colTimeName,
        int256 start,
        int256 end
    ) internal returns (int256) {
        Table table = openTable(tableName);

        Condition condition = table.newCondition();
        condition.EQ(columnName, val);
        condition.GE(colTimeName, start);
        condition.LT(colTimeName, end);
        Entries entries = table.select(tableName, condition);

        return int256(entries.size());
    }

    function getRecordBaseByCol(
        string tableName,
        string columnName,
        string val,
        string colTimeName,
        int256 start,
        int256 end,
        int256 offset,
        int256 size
    ) internal returns (Entries) {
        Table table = openTable(tableName);

        Condition condition = table.newCondition();
        condition.EQ(columnName, val);
        condition.GE(colTimeName, start);
        condition.LT(colTimeName, end);
        condition.limit(offset, size);
        Entries entries = table.select(tableName, condition);

        return (entries);
    }

    function uintToString(uint256 v) internal constant returns (string str) {
        uint256 maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint256 i = 0;
        while (v != 0) {
            uint256 remainder = v % 10;
            v = v / 10;
            reversed[i++] = bytes1(48 + remainder);
        }
        bytes memory s = new bytes(i + 1);

        for (uint256 j = 0; j <= i; j++) {
            s[j] = reversed[i - j];
        }

        if (i == 0) {
            s[0] = bytes1(48);
        }

        str = string(s);
    }
}
