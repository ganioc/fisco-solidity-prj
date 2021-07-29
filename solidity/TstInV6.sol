pragma solidity >=0.4.24;
pragma experimental ABIEncoderV2;

/**
Change table structure, using the same key value, "table_id"

 */

import "./Table.sol";
import "./TstBaseV6.sol";
import "./POSLib.sol";

contract TstInV6 is TstBaseV6 {
    struct InRecord {
        string berth_id;
        int256 in_time;
        int256 in_time_type;
        int256 in_type;
        string plate_id;
        int256 prepay_len;
        int256 prepay_money;
        int256 vehicle_type;
        string in_pic_hash;
    }
    struct RecordStruct {
        int256 count;
        string[] lst;
    }

    using POSLib for POSLib.ErrCode;

    event InsertRecordEvent(int256 ret, address account);

    string TABLE_NAME = "pos_in";

    constructor(string loc) TstBaseV6(loc) {
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
        int256 inTime,
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
        int256 inTime,
        int256 inTimeType,
        int256 inType,
        string plateId,
        int256 prepayLen,
        int256 prepayMoney,
        int256 vehicleType,
        string inPicHash
    ) public returns (POSLib.ErrCode) {
        require(inTime > 0, "Wrong inTime");

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
            int256,
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
            return ("", 0, 0, 0, "", 0, 0, 0, "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                int256(entry.getInt("in_time")),
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
            int256,
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
            return ("", 0, 0, 0, "", 0, 0, 0, "");
        }
        Entries entries = getByNum(TABLE_NAME, mIndex);

        if (entries.size() == 0) {
            return ("", 0, 0, 0, "", 0, 0, 0, "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                int256(entry.getInt("in_time")),
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

    function getRecord(
        int256 offset,
        int256 size,
        int256 start,
        int256 end
    )
        public
        returns (
            int256,
            int256,
            int256,
            string[] memory
        )
    {
        require(
            offset >= 0 &&
                size > 0 &&
                size < 21 &&
                start > 0 &&
                end > 0 &&
                start < end
        );

        int256 count = getRecordCount(TABLE_NAME, "in_time", start, end);

        Entries entries = getRecordBase(
            TABLE_NAME,
            offset,
            size,
            "in_time",
            start,
            end
        );
        string[] memory lst = new string[](uint256(entries.size()) * 9);

        for (uint256 i = 0; i < uint256(entries.size()); i++) {
            Entry entry = entries.get(int256(i));

            lst[i * 9] = entry.getString("berth_id");
            lst[i * 9 + 1] = uintToString(uint256(entry.getInt("in_time")));
            lst[i * 9 + 2] = uintToString(
                uint256(entry.getInt("in_time_type"))
            );
            lst[i * 9 + 3] = uintToString(uint256(entry.getInt("in_type")));
            lst[i * 9 + 4] = entry.getString("plate_id");
            lst[i * 9 + 5] = uintToString(uint256(entry.getInt("prepay_len")));
            lst[i * 9 + 6] = uintToString(
                uint256(entry.getInt("prepay_money"))
            );
            lst[i * 9 + 7] = uintToString(
                uint256(entry.getInt("vehicle_type"))
            );
            lst[i * 9 + 8] = entry.getString("in_pic_hash");
        }

        return (offset, size, count, lst);
    }

    function entriesToList(Entries entries) internal returns (string[] memory) {
        string[] memory lst = new string[](uint256(entries.size()) * 9);

        for (uint256 i = 0; i < uint256(entries.size()); i++) {
            Entry entry = entries.get(int256(i));

            lst[i * 9] = entry.getString("berth_id");
            lst[i * 9 + 1] = uintToString(uint256(entry.getInt("in_time")));
            lst[i * 9 + 2] = uintToString(
                uint256(entry.getInt("in_time_type"))
            );
            lst[i * 9 + 3] = uintToString(uint256(entry.getInt("in_type")));
            lst[i * 9 + 4] = entry.getString("plate_id");
            lst[i * 9 + 5] = uintToString(uint256(entry.getInt("prepay_len")));
            lst[i * 9 + 6] = uintToString(
                uint256(entry.getInt("prepay_money"))
            );
            lst[i * 9 + 7] = uintToString(
                uint256(entry.getInt("vehicle_type"))
            );
            lst[i * 9 + 8] = entry.getString("in_pic_hash");
        }

        return lst;
    }

    function getRecordCountByPlateId(
        string plateId,
        int256 start,
        int256 end
    ) internal returns (int256) {
        return
            getRecordCountByCol(
                TABLE_NAME,
                "plate_id",
                plateId,
                "in_time",
                start,
                end
            );
    }

    function interGetRecordBaseByCol(
        string plateId,
        int256 start,
        int256 end,
        int256 offset,
        int256 size
    ) internal returns (Entries) {
        return
            getRecordBaseByCol(
                TABLE_NAME,
                "plate_id",
                plateId,
                "in_time",
                start,
                end,
                offset,
                size
            );
    }

    function interGetRecordByPlateId(
        string val,
        int256 start,
        int256 end,
        int256 offset,
        int256 size
    ) internal returns (RecordStruct memory) {
        return (
            RecordStruct(
                getRecordCountByPlateId(val, start, end),
                entriesToList(
                    interGetRecordBaseByCol(val, start, end, offset, size)
                )
            )
        );
    }

    function getRecordByPlateId(
        int256 offset,
        int256 size,
        int256 start,
        int256 end,
        string plateId
    )
        public
        returns (
            int256,
            int256,
            int256,
            string[] memory
        )
    {
        require(
            offset >= 0 &&
                size > 0 &&
                size < 21 &&
                start > 0 &&
                end > 0 &&
                start < end
        );
        RecordStruct memory data = interGetRecordByPlateId(
            plateId,
            start,
            end,
            offset,
            size
        );
        return (offset, size, data.count, data.lst);
    }
}
