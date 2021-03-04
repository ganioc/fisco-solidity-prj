pragma solidity ^0.4.25;

import "./Table.sol";

contract POSIn {
    uint256 index;
    // owner of contract
    address private owner;
    // string constant "pos_in" = "pos_in";

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
            "berth_id",
            "index,in_time,in_time_type,in_type,plate_id,prepay_len,prepay_money,vehicle_type,in_pic_hash"
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

    function insertRecord(
        string berthId,
        string inTime,
        uint256 inTimeType,
        uint256 inType,
        string plateId,
        uint256 prepayLen,
        uint256 prepayMoney,
        uint256 vehicleType,
        string inPicHash
    ) public returns (int256) {

        Table table = openTable();
        // Condition condition = table.newCondition();
        Entries entries = table.select(berthId, table.newCondition());

        if (entries.size() != 0) {
            return -1;
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
                return 0;
            } else {
                return -2;
            }
        }
    }
 
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
   /*
    function getByIndex(uint256 id)
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

        Entries entries = table.select("berth_id", condition);

        if (0 == uint256(entries.size())) {
            return ("", "", 0, "", "", 0, 0, "", "");
        } else {
            Entry entry = entries.get(0);
            return (
                entry.getString("berth_id"),
                entry.getString("in_itme"),
                uint256(entry.getInt("in_time_type")),
                entry.getString("in_type"),
                entry.getString("plate_id"),
                uint256(entry.getInt("prepay_len")),
                uint256(entry.getInt("prepay_money")),
                entry.getString("vehicle_type"),
                entry.getString("in_pic_hash")
            );
        }
    }
    */
}
