pragma solidity ^0.4.24;

import "./Tablle.sol";

contract POSIn {
    // index of records

    struct InRecord {
        string berth_id;
        string in_time;
        uint256 in_time_type;
        string in_type;
        string plate_id;
        uint256 prepay_len;
        uint256 prepay_money;
        string vehicle_type;
        string in_pic_hash;
    }

    uint256 index;
    // owner of contract
    address private owner;
    string constant TABLE_NAME = "pos_in";

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
            TABLE_NAME,
            "berth_id",
            "index",
            "in_time",
            "in_time_type",
            "in_type",
            "plate_id",
            "prepay_len",
            "prepay_money",
            "vehicle_type",
            "in_pic_hash"
        );
    }

    function openTable() private returns (Table) {
        TableFactory tf = TableFactory(0x1001);
        Table table = tf.openTable(TABLE_NAME);
        return table;
    }

    function getIndex() public view returns (uint256) {
        return index;
    }

    function getOwner() public view returns (address) {
        return onwer;
    }

    function insertRecord(
        string berthId,
        string inTime,
        uint256 inTimeType,
        string inType,
        string plateId,
        uint256 prepayLen,
        uint256 prepayMoney,
        string vehicleType,
        string inPicHash
    ) public returns (int256) {
        int256 ret_code = 0;
        int256 ret = 0;
        string ret_info = "";

        Table table = openTable();

        Entries entries = table.select(berthId, table.newCondition());

        if (entries.size() != 0) {
            ret_code = -1;
            ret_info = "Already exists.";
        } else {
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

            int256 count = table.insert(berthId, entry);

            if (count == 1) {
                ret_code = 0;
            } else {
                ret_code = -2;
                ret_info = "Table insertion failed.";
            }
        }
        emit InsertEvent(ret_code, ret_info);
        return ret_code;
    }

    function getById(string berthId)
        public
        constant
        returns (int256, InRecord[])
    {
        InRecord[] records = [];

        Table table = openTable();

        Condition = table.newCondition();
        condition.EQ("berth_id", berthId);

        Entries entries = table.select("berth_id", condition);

        if (0 == uint256(entries.size())) {
            return (-1, records);
        } else {
            Entry entry = entries.get(0);

            records.push(
                InRecord({
                    berth_id: entry.getString("berth_id"),
                    in_time: entry.getString("in_itme"),
                    in_time_type: uint256(entry.getInt("in_time_type")),
                    in_type: entry.getString("in_type"),
                    plate_id: entry.getString("plate_id"),
                    prepay_len: uint256(entry.getInt("prepay_len")),
                    prepay_money: uint256(entry.getInt("prepay_money")),
                    vehicle_type: entry.getString("vehicle_type"),
                    in_pic_hash: entry.getString("in_pic_hash")
                })
            );
            return (0, records);
        }
    }

    function getByPage(uint256 page_index, uint256 page_size)
        public
        constant
        returns (
            uint256,
            uint256,
            uint256,
            InRecord[]
        )
    {
        InRecord[] records = [];
        uint256 pindex = 0;
        uint256 psize = 20;

        if (page_size < 0 || page_size > 25) {
            psize = 25;
        } else {
            psize = page_size;
        }

        if (page_index < 0) {
            pindex = 0;
        } else if (page_index >= index) {
            pindex = index - 1;
        } else {
            pindex = page_index;
        }

        Table table = openTable();

        Condition = table.newCondition();
        // condition.GE("index", pindex);
        condition.limit(pindex, psize);

        Entries entries = table.select("berth_id", condition);
        uint256 len = entries.size();

        if(0 == len){
            return(index,pindex, psize, records);
        }else{
            for(int i = 0; i< len; i++){
                Entry entry = entries.get(i);
                records.push(
                    InRecord({
                    berth_id: entry.getString("berth_id"),
                    in_time: entry.getString("in_itme"),
                    in_time_type: uint256(entry.getInt("in_time_type")),
                    in_type: entry.getString("in_type"),
                    plate_id: entry.getString("plate_id"),
                    prepay_len: uint256(entry.getInt("prepay_len")),
                    prepay_money: uint256(entry.getInt("prepay_money")),
                    vehicle_type: entry.getString("vehicle_type"),
                    in_pic_hash: entry.getString("in_pic_hash")
                    })
                );
            }
            return(index, pindex, psize, records);
        }
    }
}
