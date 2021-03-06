pragma solidity ^0.4.24;

import "./Table.sol";
import "./TstBase.sol";
import "./POSLib.sol";

contract TstPay is TstBase {
    using POSLib for POSLib.ErrCode;
    event InsertRecordEvent(int256 ret, address account);

    string TABLE_NAME = "pos_pay";

    constructor(string loc) TstBase(loc) {
        createTable(loc);
        TABLE_NAME = loc;
    }

    function createTable(string loc) private {
        getTableFactory().createTable(
            loc,
            "berth_id",
            "index,amount,mode,parking_actual_pay_money,parking_record_id,prepay_len,should_pay_amount,zero_owe"
        );
    }

    function _insert(
        string berthId,
        int256 amount,
        int256 mode,
        int256 parkingActualPayMoney,
        string parkingRecordId,
        int256 prepayLen,
        int256 shouldPayAmount,
        int256 zeroOwe
    ) private returns (POSLib.ErrCode) {
        Table table = openTable(TABLE_NAME);
        Entry entry = table.newEntry();
        entry.set("berth_id", berthId);
        entry.set("index", index);
        incIndex();
        entry.set("amount", amount);
        entry.set("mode", mode);
        entry.set("parking_actual_pay_money", parkingActualPayMoney);
        entry.set("parking_record_id", parkingRecordId);
        entry.set("prepay_len", prepayLen);
        entry.set("should_pay_amount", shouldPayAmount);
        entry.set("zero_owe", zeroOwe);

        if (table.insert(berthId, entry) == 1) {
            emit InsertRecordEvent(int256(POSLib.ErrCode.OK), msg.sender);
            return POSLib.ErrCode.OK;
        } else {
            emit InsertRecordEvent(int256(POSLib.ErrCode.FAIL), msg.sender);
            return POSLib.ErrCode.FAIL;
        }
    }

    function insertRecord(
        string berthId,
        int256 amount,
        int256 mode,
        int256 parkingActualPayMoney,
        string parkingRecordId,
        int256 prepayLen,
        int256 shouldPayAmount,
        int256 zeroOwe
    ) public returns (POSLib.ErrCode) {
        Entries entries = getByStr(TABLE_NAME, berthId);

        if (uint256(entries.size()) != 0) {
            emit InsertRecordEvent(int256(POSLib.ErrCode.EXISTS), msg.sender);
            return POSLib.ErrCode.EXISTS;
        } else {
            return
                _insert(
                    berthId,
                    amount,
                    mode,
                    parkingActualPayMoney,
                    parkingRecordId,
                    prepayLen,
                    shouldPayAmount,
                    zeroOwe
                );
        }
    }

    function getById(string berthId)
        public
        returns (
            string,
            int256,
            int256,
            int256,
            string,
            int256,
            int256,
            int256
        )
    {
        Entries entries = getByStr(TABLE_NAME, berthId);
        if (uint256(entries.size()) == 0) {
            return ("", 0, 0, 0, "", 0, 0, 0);
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                entry.getInt("amount"),
                entry.getInt("mode"),
                entry.getInt("parking_actual_pay_money"),
                entry.getString("parking_record_id"),
                entry.getInt("prepay_len"),
                entry.getInt("should_pay_amount"),
                entry.getInt("zero_owe")
            );
        }
    }
    /*
    function getByIndex(uint256 mIndex)
        public
        returns (
            string,
            int256,
            int256,
            int256,
            string,
            int256,
            int256,
            int256
        )
    {
        if (mIndex < 0 || uint256(mIndex) >= index) {
            return ("", 0, 0, 0, "", 0, 0, 0);
        }
        Entries entries = getByNum(TABLE_NAME, "index", mIndex);

        if (entries.size() == 0) {
            return ("", 0, 0, 0, "", 0, 0, 0);
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                entry.getInt("amount"),
                entry.getInt("mode"),
                entry.getInt("parking_actual_pay_money"),
                entry.getString("parking_record_id"),
                entry.getInt("prepay_len"),
                entry.getInt("should_pay_amount"),
                entry.getInt("zero_owe")
            );
        }
    }
    */
}
