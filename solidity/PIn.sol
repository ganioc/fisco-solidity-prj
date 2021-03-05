pragma solidity ^0.4.25;

import "./POSBase.sol";
import "./Table.sol";
import "./POSLib.sol";

contract PIn is POSBase {
    using POSLib for POSLib.ErrCode;

    string constant TABLE_NAME = "pos_in";

    constructor(string loc) POSBase(loc) {
        createTable(loc);
    }

    function createTable(string loc) private {
        getTableFactory().createTable(
            TABLE_NAME,
            loc,
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
        Entries entries = getByStr(TABLE_NAME, "berth_id", berthId);

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
        Entries entries = getByStr(TABLE_NAME, "berth_id", berthId);
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
