//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Allowable implements mechanism to control access to any countable goods by
 * 'onlyAllowed' modifier.
 */
import "./Allowable.sol";

contract Wallet is Allowable {
    /**
     * @dev Get contract balance
     */
    function getWalletBalance() external view returns(uint) {
        return address(this).balance;
    }

    /**
     * @dev Withdraws wallet funds to specified address, only allowed (owner or
     * depending on allowance mapping) users may call it
     * @param _to Address to receive funds
     * @param _amount Amount of funds to withdraw
     */
    function withdrawFunds(address payable _to, uint _amount) external onlyAllowed(_amount) {
        require(_amount <= address(this).balance, "Wallet: Not enough funds"); // validate input
        if (msg.sender != owner()) {
            reduceAllowance(_amount); // reduce allowance to avoid double-spending
        } // do not reduce allowance of owner
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