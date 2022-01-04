//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Wallet {

    /**
     * @dev Debug only contract balance getter function
     */
    function getWalletBalance() external view returns(uint) {
        return address(this).balance;
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