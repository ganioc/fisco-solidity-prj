pragma solidity ^0.4.25;

import "./POSBase.sol";
import "./Table.sol";
import "./POSLib.sol";

contract POut is POSBase {
    using POSLib for POSLib.ErrCode;

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

}