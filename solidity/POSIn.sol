pragma solidity ^0.4.24;

import "./Tablle.sol";

contract POSIn {
    // owner of contract
    address private owner;
    string constant TABLE_NAME = "pos_in";

    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
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
            "in_time",
            "in_time_type",
            "in_type",
            "plate_id",
            "prepay_len",
            "prepay_money",
            "vehicle_type"
        );
    }
    function openTable() private returns (Table){
        TableFactory tf = TableFactory(0x1001);
        Table table = tf.openTable(TABLE_NAME);
        return table;
    }
}
