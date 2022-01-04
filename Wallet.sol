//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Ownable contract from OpenZeppelin is providing access mechanism where 
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions by 'onlyOwner' modifier.
 */
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Wallet is Ownable {

    /**
     * @dev Debug only contract balance getter function
     */
    function getWalletBalance() external view returns(uint) {
        return address(this).balance;
    }

    /**
     * @dev Withdraws wallet funds to specified address, only owner may call this
     * @param _to Address to receive funds
     * @param _amount Amount of funds to withdraw
     */
    function withdrawFunds(address payable _to, uint _amount) external onlyOwner {
        require(_amount <= address(this).balance); // validate input
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