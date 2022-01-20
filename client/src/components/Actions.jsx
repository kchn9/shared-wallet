import React, { useState } from "react";

const Actions = (props) => {
    const {web3State, receiveBalance} = props;

    const [withdrawOptions, setWithdrawOptions] = useState({
        address: null,
        amount: 0
    });

    const handleWithdrawClick = () => {
    }

    return (
        <div className="Wallet-actions">
            <h3>Actions: </h3>
            <div className="Actions-buttons">
                <button onClick={receiveBalance} id="refresh-button">Refresh balance</button>
                <div className="Buttons-inputButton">
                    <button id="withdraw-button" onClick={handleWithdrawClick}>Withdraw funds</button>
                    <div className="InputButton-inputs">
                        <label htmlFor='withdraw-address'>
                            <input id='withdraw-address'
                                onChange={(e) => {setWithdrawOptions(prev => ({ address: e.target.value, amount: prev.amount }))}}
                                placeholder="Address to withdraw funds."
                                type="text"
                            />
                        </label>
                        <label htmlFor='withdraw-amount'>
                            <input id='withdraw-amount'
                                onChange={(e) => {setWithdrawOptions(prev => ({ address: prev.address, amount: e.target.value }))}}
                                placeholder="Amount (in Wei) to withdraw."
                                type="text"
                            />
                        </label>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Actions;