## Abi of TstInV3

| name         | constant | methodId   | signature                                                                    |
| :----------- | :------- | :--------- | :--------------------------------------------------------------------------- |
| getIndex     | true     | 0x81045ead | getIndex() 获取记录数量                                                      |
| getLoc       | true     | 0x88eb4628 | getLoc()                                                                     |
| getByIndex   | false    | 0x2d883a73 | getByIndex(uint256) 根据索引值 [0,n) 获取记录                                |
| getOwner     | true     | 0x893d20e8 | getOwner()                                                                   |
| insertRecord | false    | 0x7f697836 | insertRecord(string,string,int256,int256,string,int256,int256,int256,string) |
| getById      | false    | 0xf3bfddb7 | getById(string) 根据 berth_id 获取记录                                       |

## Abi of TstOutV3

| name         | constant | methodId   | signature                                        |
| :----------- | :------- | :--------- | :----------------------------------------------- |
| insertRecord | false    | 0xd7edbe68 | insertRecord(string,string,int256,string,string) |
| getIndex     | true     | 0x81045ead | getIndex()                                       |
| getLoc       | true     | 0x88eb4628 | getLoc()                                         |
| getByIndex   | false    | 0x2d883a73 | getByIndex(uint256)                              |
| getOwner     | true     | 0x893d20e8 | getOwner()                                       |
| getById      | false    | 0xf3bfddb7 | getById(string)                                  |

## Abi of TstPayV3

| name         | constant | methodId   | signature                                                             |
| :----------- | :------- | :--------- | :-------------------------------------------------------------------- |
| insertRecord | false    | 0xcb2f28d8 | insertRecord(string,int256,int256,int256,string,int256,int256,int256) |
| getIndex     | true     | 0x81045ead | getIndex()                                                            |
| getLoc       | true     | 0x88eb4628 | getLoc()                                                              |
| getByIndex   | false    | 0x2d883a73 | getByIndex(uint256)                                                   |
| getOwner     | true     | 0x893d20e8 | getOwner()                                                            |
| getById      | false    | 0xf3bfddb7 | getById(string)                                                       |
