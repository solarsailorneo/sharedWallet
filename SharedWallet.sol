// contracts/SharedWallet.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract SharedWallet {

    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function withdrawMoney(address payable _to, uint256 _amount) public {
        require(owner == msg.sender, "Your wallet is not authorized to withdraw funds");
        _to.transfer(_amount);
    }
    
    fallback () external payable {

    }
}