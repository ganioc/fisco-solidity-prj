pragma solidity ^0.4.24;

import "./Table.sol";

contract Asset{
    // event 
    event RegisterEvent(int256 ret, string account, uint256 asset_value);
    event TransferEvent(int256 ret, string from_account, string to_account, uint256 amount);

    constructor() public {
        createTable();
    }

    function createTable() private {
        TableFactory tf = TableFactory(0x1001);

        tf.createTable("t_asset", "account", "asset_value");
    }
    function openTable() private returns (Table){
        TableFactory tf = TableFactory(0x1001);
        Table table = tf.openTable("t_asset");
        return table;
    }
    // 查询资产金额
    function select(string account) public constant returns (int256, uint256){
        Table table = openTable();

        Entries entries = table.select(account, table.newCondition());

        uint256 asset_value = 0;
        if(0== uint256(entries.size())){
            return (-1, asset_value);
        }else{
            Entry entry = entries.get(0);
            return(0, uint256(entry.getInt("asset_value")));
        }
    }
    // 资产注册
    // 返回, -1 资产账户已经存在, -2 其它错误
    function register(string account, uint256 asset_value)
        public returns(int256){
            int256 ret_code = 0;
            int256 ret = 0;
            uint256 temp_asset_value = 0;

            (ret, temp_asset_value) = select(account);

            if(ret != 0){
                Table table = openTable();
                Entry entry = table.newEntry();
                entry.set("account",account);
                entry.set("asset_value", int256(asset_value));
                // 插入
                int count = table.insert(account, entry);
                if(count == 1){
                    ret_code = 0;
                }else{
                    ret_code = -2;
                }
            }else{
                // 账户已经存在
                ret_code = -1;
            }
            emit RegisterEvent(ret_code, account, asset_value);
            return ret_code;

        }
        /*
            资产转移

            0 成功
            -1 不存在
            -2 接收帐户不存在
            -3 金额不足
            -4 金额溢出
            -5 其它错误
        */
        function transfer(string from_account, string to_account, uint256 amount)
        public returns(int256){
            int ret_code = 0;
            int256 ret = 0;
            uint256 from_asset_value = 0;
            uint256 to_asset_value = 0;

            (ret, from_asset_value) = select(from_account);
            if(ret != 0){
                ret_code = -1;
                emit TransferEvent(ret_code, from_account, to_account, amount);
                return ret_code;
            }

            // 接受帐户是否存在
            (ret, to_asset_value) = select(to_account);
            if(ret != 0){
                ret_code = -2;
                emit TransferEvent(ret_code, from_account, to_account, amount);
                return ret_code;
            }

            if(from_asset_value < amount){
                ret_code = -3;
                emit TransferEvent(ret_code, from_account, to_account, amount);
                return ret_code;
            }

            if(to_asset_value + amount < to_asset_value){
                ret_code = -4;
                emit TransferEvent(ret_code, from_account, to_account, amount);
                return ret_code;
            }

            Table table = openTable();

            Entry entry0 = table.newEntry();
            entry0.set("account", from_account);
            entry0.set("asset_value", int256(from_asset_value - amount));

            // 更新转账帐户
            int count = table.update(from_account, entry0, table.newCondition());
            if(count != 1){
                ret_code = -5;
                emit TransferEvent(ret_code, from_account, to_account, amount);
                return ret_code;
            }

            Entry entry1 = table.newEntry();
            entry1.set("account", to_account);
            entry1.set("asset_value", int256(to_asset_value + amount));

            // 更新接收帐户
            table.update(to_account, entry1, table.newCondition());
            emit TransferEvent(ret_code, from_account, to_account, amount);

            return ret_code;
        }

}