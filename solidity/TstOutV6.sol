pragma solidity ^0.4.24;

import "./Table.sol";
import "./TstBaseV6.sol";
import "./POSLib.sol";

contract TstOutV6 is TstBaseV6 {
    struct OutRecord {
        string berthId;
        int256 outTime;
        int256 shouldPayMoney;
        string id;
        string outPicHash;
    }
    using POSLib for POSLib.ErrCode;
    event InsertRecordEvent(int256 ret, address account);

    string TABLE_NAME = "pos_out";

    constructor(string loc) TstBaseV6(loc) {
        createTable(loc);
        TABLE_NAME = loc;
    }

    function createTable(string loc) private {
        getTableFactory().createTable(
            loc,
            "table_id",
            "berth_id,index,out_time,should_pay_money,id,out_pic_hash"
        );
    }

    function _insert(
        string berthId,
        int256 outTime,
        int256 shouldPayMoney,
        string id,
        string outPicHash
    ) private returns (POSLib.ErrCode) {
        Table table = openTable(TABLE_NAME);
        Entry entry = table.newEntry();
        entry.set("table_id", TABLE_NAME);
        entry.set("berth_id", berthId);
        entry.set("index", index);
        incIndex();
        entry.set("out_time", outTime);
        entry.set("should_pay_money", shouldPayMoney);
        entry.set("id", id);
        entry.set("out_pic_hash", outPicHash);

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
        int256 outTime,
        int256 shouldPayMoney,
        string id,
        string outPicHash
    ) public returns (POSLib.ErrCode) {
        require(outTime > 0);

        Entries entries = getByStr(TABLE_NAME, berthId);

        if (uint256(entries.size()) != 0) {
            emit InsertRecordEvent(int256(POSLib.ErrCode.EXISTS), msg.sender);
            return POSLib.ErrCode.EXISTS;
        } else {
            return _insert(berthId, outTime, shouldPayMoney, id, outPicHash);
        }
    }

    function getById(string berthId)
        public
        returns (
            string,
            int256,
            int256,
            string,
            string
        )
    {
        Entries entries = getByStr(TABLE_NAME, berthId);
        if (uint256(entries.size()) == 0) {
            return ("", 0, 0, "", "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                int256(entry.getInt("out_time")),
                int256(entry.getInt("should_pay_money")),
                entry.getString("id"),
                entry.getString("out_pic_hash")
            );
        }
    }

    function getByIndex(uint256 mIndex)
        public
        returns (
            string,
            int256,
            int256,
            string,
            string
        )
    {
        if (mIndex < 0 || uint256(mIndex) >= index) {
            return ("", 0, 0, "", "");
        }
        Entries entries = getByNum(TABLE_NAME, mIndex);

        if (entries.size() == 0) {
            return ("", 0, 0, "", "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                int256(entry.getInt("out_time")),
                int256(entry.getInt("should_pay_money")),
                entry.getString("id"),
                entry.getString("out_pic_hash")
            );
        }
    }
}
