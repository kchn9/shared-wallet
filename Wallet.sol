//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Wallet {

    address public owner; // debug only

    /**
     * @dev Sets owner address to sender address
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Debug only contract balance getter function
     */
    function getWalletBalance() external view returns(uint) {
        return address(this).balance;
    }

    /**
     * @dev Withdraws wallet funds to specified address
     * @param _to Address to receive funds
     * @param _amount Amount of funds to withdraw
     */
    function withdrawFunds(address payable _to, uint _amount) external {
        require(address(this).balance <= _amount); // validate input
        _to.transfer(_amount);
    }

    /**
     * @dev Deposit sender Ether funds in wallet
     */
    function depositFunds() payable public {
        payable(this).transfer(msg.value);
    }

    /**
     * @dev Fallback function to receive sender Ether
     */
    receive() external payable {
    }
}