pragma solidity ^0.4.24;

/**
Change table structure, using the same key value, "table_id"

 */

import "./Table.sol";
import "./TstBaseV2.sol";
import "./POSLib.sol";

contract TstInV2 is TstBaseV2 {
    using POSLib for POSLib.ErrCode;

    event InsertRecordEvent(int256 ret, address account);

    string TABLE_NAME = "pos_in";

    constructor(string loc) TstBaseV2(loc) {
        createTable(loc);
        TABLE_NAME = loc;
    }

    function createTable(string loc) private {
        getTableFactory().createTable(
            loc,
            "table_id",
            "berth_id,index,in_time,in_time_type,in_type,plate_id,prepay_len,prepay_money,vehicle_type,in_pic_hash"
        );
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
        Table table = openTable(TABLE_NAME);
        Entry entry = table.newEntry();
        entry.set("table_id", TABLE_NAME);
        entry.set("berth_id", berthId);
        entry.set("index", index);
        incIndex();
        entry.set("in_time", inTime);
        entry.set("in_time_type", inTimeType);
        entry.set("in_type", inType);
        entry.set("plate_id", plateId);
        entry.set("prepay_len", prepayLen);
        entry.set("prepay_money", prepayMoney);
        entry.set("vehicle_type", vehicleType);
        entry.set("in_pic_hash", inPicHash);

        if (table.insert(TABLE_NAME, entry) == 1) {
            emit InsertRecordEvent(int256(POSLib.ErrCode.OK), msg.sender);
            return POSLib.ErrCode.OK;
        } else {
            emit InsertRecordEvent(int256(POSLib.ErrCode.FAIL), msg.sender);
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
        Entries entries = getByStr(TABLE_NAME, berthId);

        if (index == 0 || uint256(entries.size()) == 0) {
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
        } else {
            emit InsertRecordEvent(int256(POSLib.ErrCode.EXISTS), msg.sender);
            return POSLib.ErrCode.EXISTS;
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
        Entries entries = getByStr(TABLE_NAME, berthId);
        if (entries.size() == 0) {
            return ("", "", 0, 0, "", 0, 0, 0, "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                entry.getString("in_time"),
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

    function getByIndex(uint256 mIndex)
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
        if (mIndex < 0 || uint256(mIndex) >= index) {
            return ("", "", 0, 0, "", 0, 0, 0, "");
        }
        Entries entries = getByNum(TABLE_NAME, mIndex);

        if (entries.size() == 0) {
            return ("", "", 0, 0, "", 0, 0, 0, "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                entry.getString("in_time"),
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
