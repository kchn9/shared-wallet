//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Ownable contract from OpenZeppelin is providing access mechanism where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions by 'onlyOwner' modifier.
 */
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Wallet is Ownable {

    mapping (address => uint) private allowance; // allowance ledger

    /**
     * @dev Get contract balance
     */
    function getWalletBalance() private view returns(uint) {
        return address(this).balance;
    }

    /**
     * @dev Allows owner or anyone with enough allowance to call specified functions
     */
    modifier onlyAllowed(uint _amount) {
        require(msg.sender == owner() || allowance[msg.sender] >= _amount, "Wallet: You are not allowed");
        _;
    }

    /**
     * @dev Sets allowance to specified amount, only owner may call it
     */
    function setAllowance(address _who, uint _allowance) public onlyOwner {
        allowance[_who] = _allowance;
    }

    /**
     * @dev Reduces allowance by specified amount
     * @param _amount Amount of ether allowance to reduce
     */
    function reduceAllowance(uint _amount) internal onlyAllowed(_amount) {
        require(_amount <= allowance[msg.sender], "Wallet: Amount to reduce allowance is higher than allowance");
        allowance[msg.sender] -= _amount;
    }

    /**
     * @dev Withdraws wallet funds to specified address, only allowed (owner or
     * depending on allowance mapping) users may call it
     * @param _to Address to receive funds
     * @param _amount Amount of funds to withdraw
     */
    function withdrawFunds(address payable _to, uint _amount) external onlyAllowed(_amount) {
        require(_amount <= address(this).balance, "Wallet: Not enough funds"); // validate input
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