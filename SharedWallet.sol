// contracts/SharedWallet.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {

    mapping(address => uint256) public allowance;

    function addAllowance(address _who, uint256 _amount) public onlyOwner {
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint256 _amount) {
        require(msg.sender == owner() ||  _amount <= allowance[msg.sender], "You are not allowed to withdraw from this account or withdrawing more than allowed");
        _;
    }

    function reduceAllowance(address _sender, uint256 _amount) private {
        allowance[_sender] = allowance[_sender] - _amount;
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