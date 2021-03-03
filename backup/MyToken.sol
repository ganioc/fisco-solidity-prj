pragma solidity >=0.4.0 <=0.6.0; 


contract MyToken{
    /*  array of all balances */
    mapping (address => uint256) public balanceOf;
    
    constructor(uint256 initialSupply) public {
        balanceOf[msg.sender] = initialSupply;
    }
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        return true;
    }
}