pragma solidity ^0.4.25;

import "./POSBase.sol";
import "./Table.sol";
import "./POSLib.sol";

contract POut is POSBase {
    using POSLib for POSLib.ErrCode;
    event InsertRecordEvent(int256 ret, address account);

    string constant TABLE_NAME = "pos_out";

    constructor(string loc) POSBase(loc) {
        createTable(loc);
    }

    function createTable(string loc) private {
        getTableFactory().createTable(
            TABLE_NAME,
            loc,
            "berth_id,index,out_time,should_pay_money,id,out_pic_hash"
        );
    }

    function _insert(
        string berthId,
        string outTime,
        int256 shouldPayMoney,
        string id,
        string outPicHash
    ) private returns (POSLib.ErrCode) {
        Table table = openTable(TABLE_NAME);
        Entry entry = table.newEntry();
        entry.set("berth_id", berthId);
        entry.set("index", index);
        incIndex();
        entry.set("out_time", outTime);
        entry.set("should_pay_money", shouldPayMoney);
        entry.set("id", id);
        entry.set("out_pic_hash", outPicHash);

        if (table.insert(LOC, entry) == 1) {
             emit InsertRecordEvent(int256(POSLib.ErrCode.OK), msg.sender);
            return POSLib.ErrCode.OK;
        } else {
            emit InsertRecordEvent(int256(POSLib.ErrCode.FAIL), msg.sender);
            return POSLib.ErrCode.FAIL;
        }
    }

    function insertRecord(
        string berthId,
        string outTime,
        int256 shouldPayMoney,
        string id,
        string outPicHash
    ) public returns (POSLib.ErrCode) {
        Entries entries = getByStr(TABLE_NAME, "berth_id", berthId);

        if (entries.size() != 0) {
            emit InsertRecordEvent(int256(POSLib.ErrCode.EXISTS), msg.sender);
            return POSLib.ErrCode.EXISTS;
        } else {
            return
                _insert(
                    berthId,
                    outTime,
                    shouldPayMoney,
                    id,
                    outPicHash
                );
        }
    }

    function getById(string berthId)
        public
        returns (
            string,
            string,
            int256,
            string,
            string
        )
    {
        Entries entries = getByStr(TABLE_NAME, "berth_id", berthId);
        if (entries.size() != 0) {
            return ("", "", 0, "", "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                entry.getString("out_itme"),
                int256(entry.getInt("should_pay_money")),
                entry.getString("id"),
                entry.getString("out_pic_hash")
            );
        }
    }

    function getByIndex(int256 mIndex)
        public
        returns (
            string,
            string,
            int256,
            string,
            string
        )
    {
        if (mIndex < 0 || uint256(mIndex) >= index) {
            return ("", "", 0,  "", "");
        }
        Entries entries = getByNum(TABLE_NAME, "index", mIndex);
        if (entries.size() != 0) {
            return ("", "", 0, "", "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                entry.getString("out_itme"),
                int256(entry.getInt("should_pay_money")),
                entry.getString("id"),
                entry.getString("out_pic_hash")
            );
        }
    }
}
