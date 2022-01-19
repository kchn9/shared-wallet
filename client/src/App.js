import React, { useState, useEffect } from 'react';
import WalletContract from "./contracts/Wallet.json";
import getWeb3 from "./getWeb3";

import "./App.css";

const App = () => {
  const [ticker, setTicker] = useState(0);
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
    }, 1000); // refresh balance of wallet every 5 seconds
    return () => clearInterval(tickerInterval);
  })

  useEffect(() => {
      if (web3State && web3State.walletContract) receiveBalance();
  }, [web3State.walletContract])

  if (!web3State.web3) {
    return (
      <div>
        <h2>Loading...</h2>
        <i>Please, make sure your metamask account is connected.</i>
      </div>
    )
  }

  return (
    <div className='App'>
      <h1>Ethereum shared wallet client</h1>
        <div className="Wallet-info">
          <p>Wallet is connected at address: {web3State.walletContract.options.address}</p>
          <h3>Stored balance is:
          <strong> {web3State.web3.utils.fromWei(walletBalance.toString())}ETH </strong>
          </h3>
        </div>
    </div>
  )
}

export default App;

