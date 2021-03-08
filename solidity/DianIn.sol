pragma solidity>=0.4.24 <0.6.11;

import "./POSLib.sol";
import "./POSBase.sol";

contract DianIn is POSBase {
    using POSLib for POSLib.ErrCode;

    string constant TABLE_NAME = "pos_in";

    constructor(string loc) POSBase(loc) public{
        createTable(loc);
    }
    function createTable(string loc) private {
        getTableFactory().createTable(
            TABLE_NAME,
            loc,
            "berth_id,index"
        );
    }

}