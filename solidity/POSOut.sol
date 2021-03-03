pragma solidity ^0.4.24;

import "./Tablle.sol";

contract POSOut {
    function createTable() private {
        TableFactory tf = TableFactory(0x1001);

        tf.createTable("t_asset", "account", "asset_value");
    }
}
