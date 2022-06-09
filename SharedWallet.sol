// contracts/SharedWallet.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {
    event allowanceChanged(address indexed _changeAgent, address indexed _allowee, uint256 _oldAmount, uint256 _newAmount);

    mapping(address => uint256) public allowance;

    function addAllowance(address _alloweeToBe, uint256 _amount) public onlyOwner {
        emit allowanceChanged(msg.sender, _alloweeToBe, allowance[_alloweeToBe], _amount);
        allowance[_alloweeToBe] = _amount;
    }

    modifier ownerOrAllowed(uint256 _amount) {
        require(msg.sender == owner() ||  _amount <= allowance[msg.sender], "You are not allowed to withdraw from this account or withdrawing more than allowed");
        _;
    }

    function reduceAllowance(address _allowee, uint256 _amount) internal {
        emit allowanceChanged(msg.sender, _allowee, allowance[_allowee], allowance[_allowee] - _amount);
        allowance[_allowee] -= _amount;
    }

    function withdrawMoney(address payable _to, uint256 _amount) public ownerOrAllowed(_amount) {
        if(_to != owner())
        {
            reduceAllowance(msg.sender, _amount);
        }
        _to.transfer(_amount);
    }
    
    fallback () external payable {

    }
}