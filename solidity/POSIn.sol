pragma solidity ^0.4.25;

import "./Table.sol";

contract POSIn {
    uint256 index;
    // owner of contract
    address private owner;
    // string constant "pos_in" = "pos_in";
    string constant LOC = "shanghai";

    enum ErrCode{
        OK ,    // 0
        FAIL,   // 1
        EMPTY,  // 2
        DBFAIL, // 3
        EXISTS  // 4
    }

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

    function _get(string berthId) private returns (Entries) {
        Table table = openTable();
        Condition condition = table.newCondition();
        condition.EQ("berth_id", berthId);
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
        string inPicHash) private returns (ErrCode) {
        
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

        if(table.insert(LOC, entry) == 1){
            return ErrCode.OK;
        }else{
            return ErrCode.FAIL;
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
    ) public returns (ErrCode) {
        Entries entries = _get(berthId);

        if (entries.size() != 0) {
            return ErrCode.EXISTS;
        } else {
             return _insert(berthId, inTime, inTimeType, inType, plateId, prepayLen, prepayMoney, vehicleType, inPicHash);
        }
    }
    /*
    function getById(string berthId)
        public
        returns (
            bytes32,
            bytes32,
            uint32,
            uint32 ,
            bytes32,
            uint32,
            uint32,
            uint32,
            bytes32
        )
    {
        Table table = openTable();
        Condition condition = table.newCondition();
        // condition.EQ("berth_id", "hello");
        Entries entries = table.select(berthId, condition);

        if (0 == uint256(entries.size())) {
            return ( "", "", 0, 0, "", 0, 0, 0, "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getBytes32("berth_id")  ,
                entry.getBytes32("in_itme")  ,
                uint32(entry.getUInt("in_time_type")) ,
                uint32(entry.getUInt("in_type")),
                entry.getBytes32("plate_id"),
                uint32(entry.getUInt("prepay_len")),
                uint32(entry.getUInt("prepay_money")),
                uint32(entry.getUInt("vehicle_type")),
                entry.getBytes32("in_pic_hash")
            );
        }
    }
   
    function getByIndex(int256 id)
        public
        constant
        returns (
            bytes32,
            bytes32,
            uint32,
            uint32 ,
            bytes32,
            uint32,
            uint32,
            uint32,
            bytes32
        )
    {
        Table table = openTable();

        Condition condition = table.newCondition();
        condition.EQ("index", id);

        Entries entries = table.select("hi", condition);

        if (0 == uint256(entries.size())) {
            return ("", "", 0, 0, "", 0, 0, 0, "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getBytes32("berth_id")  ,
                entry.getBytes32("in_itme")  ,
                uint32(entry.getUInt("in_time_type")) ,
                uint32(entry.getUInt("in_type")),
                entry.getBytes32("plate_id"),
                uint32(entry.getUInt("prepay_len")),
                uint32(entry.getUInt("prepay_money")),
                uint32(entry.getUInt("vehicle_type")),
                entry.getBytes32("in_pic_hash")
            );
        }
    }
  */
}
