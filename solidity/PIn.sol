pragma solidity ^0.4.25;

import "./POSBase.sol";
import "./Table.sol";

contract PIn is POSBase{
    string constant TABLE_NAME = "pos_in";

    constructor(string loc) POSBase(loc){
        createTable(loc);
    }
    function createTable(string loc) private{
        getTableFactory().createTable(
            TABLE_NAME, 
            loc, 
            "berth_id,index,in_time,in_time_type,in_type,plate_id,prepay_len,prepay_money,vehicle_type,in_pic_hash");
    }
}
