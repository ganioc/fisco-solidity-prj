pragma solidity ^0.4.25;

library POSLib {
    enum ErrCode {
        OK, // 0
        FAIL, // 1
        EMPTY, // 2
        DBFAIL, // 3
        EXISTS // 4
    }
}
