pragma solidity ^0.4.25;

import "./Table.sol";
import "./POSLib.sol";

contract POSIn {
    // using ErrCode for POSLib.ErrCode;
    // using ErrCode for POSLib.ErrCode;

    uint256 index;
    // owner of contract
    address private owner;
    // string constant "pos_in" = "pos_in";
    string constant LOC = "shanghai";

    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    event InsertEvent(int256 ret, string info);

    constructor() public {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
        index = 0;
        createTable();
    }

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    function createTable() private {
        TableFactory tf = TableFactory(0x1001);

        tf.createTable(
            "pos_in",
            LOC,
            "berth_id,index,in_time,in_time_type,in_type,plate_id,prepay_len,prepay_money,vehicle_type,in_pic_hash"
        );
    }

    function openTable() private returns (Table) {
        TableFactory tf = TableFactory(0x1001);
        Table table = tf.openTable("pos_in");
        return table;
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

    function _get(string name, string berthId) private returns (Entries) {
        Table table = openTable();
        Condition condition = table.newCondition();
        condition.EQ(name, berthId);
        return table.select(LOC, condition);
    }
    function _getByNum(string name, int256 num) private returns (Entries) {
        Table table = openTable();
        Condition condition = table.newCondition();
        condition.EQ(name, num);
        return table.select(LOC, condition);
    }

    function _insert(
        string berthId,
        string inTime,
        int256 inTimeType,
        int256 inType,
        string plateId,
        int256 prepayLen,
        int256 prepayMoney,
        int256 vehicleType,
        string inPicHash
    ) private returns (POSLib.ErrCode) {
        Table table = openTable();
        Entry entry = table.newEntry();
        entry.set("berth_id", berthId);
        entry.set("index", index);
        index++;
        entry.set("in_time", inTime);
        entry.set("in_time_type", inTimeType);
        entry.set("in_type", inType);
        entry.set("plate_id", plateId);
        entry.set("prepay_len", prepayLen);
        entry.set("prepay_money", prepayMoney);
        entry.set("vehicle_type", vehicleType);
        entry.set("in_pic_hash", inPicHash);

        if (table.insert(LOC, entry) == 1) {
            return POSLib.ErrCode.OK;
        } else {
            return POSLib.ErrCode.FAIL;
        }
    }

    function insertRecord(
        string berthId,
        string inTime,
        int256 inTimeType,
        int256 inType,
        string plateId,
        int256 prepayLen,
        int256 prepayMoney,
        int256 vehicleType,
        string inPicHash
    ) public returns (POSLib.ErrCode) {
        Entries entries = _get("berth_id", berthId);

        if (entries.size() != 0) {
            return POSLib.ErrCode.EXISTS;
        } else {
            return
                _insert(
                    berthId,
                    inTime,
                    inTimeType,
                    inType,
                    plateId,
                    prepayLen,
                    prepayMoney,
                    vehicleType,
                    inPicHash
                );
        }
    }

    function getById(string berthId)
        public
        returns (
            string,
            string,
            int256,
            int256,
            string,
            int256,
            int256,
            int256,
            string
        )
    {
        Entries entries = _get("berth_id", berthId);
        if (entries.size() != 0) {
            return ("", "", 0, 0, "", 0, 0, 0, "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                entry.getString("in_itme"),
                int256(entry.getInt("in_time_type")),
                int256(entry.getInt("in_type")),
                entry.getString("plate_id"),
                int256(entry.getInt("prepay_len")),
                int256(entry.getInt("prepay_money")),
                int256(entry.getInt("vehicle_type")),
                entry.getString("in_pic_hash")
            );
        }
    }

    function getByIndex(int256 mIndex)
        public
        returns (
            string,
            string,
            int256,
            int256,
            string,
            int256,
            int256,
            int256,
            string
        )
    {
        if( mIndex < 0 || uint256(mIndex) >  index){
            return ("", "", 0, 0, "", 0, 0, 0, "");
        }
        Entries entries = _getByNum("index", mIndex);
        if (entries.size() != 0) {
            return ("", "", 0, 0, "", 0, 0, 0, "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                entry.getString("in_itme"),
                int256(entry.getInt("in_time_type")),
                int256(entry.getInt("in_type")),
                entry.getString("plate_id"),
                int256(entry.getInt("prepay_len")),
                int256(entry.getInt("prepay_money")),
                int256(entry.getInt("vehicle_type")),
                entry.getString("in_pic_hash")
            );
        }
    }
}
