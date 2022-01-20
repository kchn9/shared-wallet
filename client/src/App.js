import React, { useState, useEffect } from 'react';
import WalletContract from "./contracts/Wallet.json";
import getWeb3 from "./getWeb3";

import Actions from './components/Actions.jsx';

import "./App.css";


const App = () => {
  const [web3State, setWeb3State] = useState({ web3: null, accounts: null, walletContract: null });
  const [walletBalance, setWalletBalance] = useState(0);

  const receiveState = async () =>  {
    try {
      const web3 = await getWeb3();
      const accounts = await web3.eth.getAccounts();
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = WalletContract.networks[networkId];
      const walletInstance = new web3.eth.Contract(
        WalletContract.abi,
        deployedNetwork && deployedNetwork.address
      );
      setWeb3State({ web3, accounts, walletContract: walletInstance });
    } catch (error) {
      console.error(error);
    }
  }

  const receiveBalance = async () => {
    try {
      const {walletContract} = web3State;
      const balance = await walletContract.methods.getWalletBalance().call();
      setWalletBalance(balance);
    } catch (error) {
      console.error(error);
    }
  }

  useEffect(() => {
    receiveState();
  }, []);

  useEffect(() => {
    const tickerInterval = setInterval(() => {
      if (web3State && web3State.walletContract) receiveBalance();
    }, 1000); // refresh balance of wallet every 1 second
    return () => clearInterval(tickerInterval);
  })

  useEffect(() => {
      if (web3State && web3State.walletContract) receiveBalance();
  }, [web3State.walletContract])

  return (
    <div className='App'>
      <h1>Ethereum shared wallet client</h1>
        {web3State.web3 ? (
          <div className="Wallet-info">
            <p>Wallet is connected at address: {web3State.walletContract.options.address}</p>
            <h3>Stored balance is:</h3>
            <strong> {web3State.web3.utils.fromWei(walletBalance.toString())}ETH </strong>
            <p style={{fontSize: "12px", opacity: "50%", marginBottom: 0}}>(auto refreshing)</p>
          </div>
        ) : (
          <div className="Wallet-disconected">
            <h3>Loading...</h3>
            <i>Please, make sure your metamask account is connected.</i>
          </div>
        )}
        {web3State.web3 && <Actions web3State={web3State} receiveBalance={receiveBalance} />}
    </div>
  )
}

export default App;

