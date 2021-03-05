pragma solidity ^0.4.25;

import "./POSBase.sol";
import "./Table.sol";
import "./POSLib.sol";

contract PPay is POSBase {
    using POSLib for POSLib.ErrCode;

    string constant TABLE_NAME = "pos_pay";

    constructor(string loc) POSBase(loc) {
        createTable(loc);
    }

    function createTable(string loc) private {
        getTableFactory().createTable(
            TABLE_NAME,
            loc,
            "berth_id,index,amount,mode,parking_actual_pay_money,parking_record_id,prepay_len,should_pay_amount,zero_owe"
        );
    }

}