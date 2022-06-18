const Web3 = require('web3');
const Provider = require('@truffle/hdwallet-provider');
const MyContract = require('./SendEtheriumTransaction/build/contracts/MyContract.json');
const address = '0xFce453aA73177E63f24530ea106ee75d478a5cb1';
const privateKey = '61f84609b0c5c7cf36f01eb84af270c109bfcdd790db99af5fc4bec2315bc313';
const infuraURL = 'https://rinkeby.infura.io/v3/c3ec14f7124940e799aa19f0a788c3c4';
const web3 = new Web3(infuraURL);
const init1 = async () => {
    
    const networkId = await web3.eth.net.getId();
    const myContract = new web3.eth.Contract(
      MyContract.abi,
      MyContract.networks[networkId].address
    );
  
    const tx = myContract.methods.setData(1);
    const gas = await tx.estimateGas({from: address});
    const gasPrice = await web3.eth.getGasPrice();
    const data = tx.encodeABI();
    const nonce = await web3.eth.getTransactionCount(address);
  
    const signedTx = await web3.eth.accounts.signTransaction(
      {
        to: myContract.options.address, 
        data,
        gas,
        gasPrice,
        nonce, 
        chainId: networkId
      },
      privateKey
    );
    console.log(`Old data value: ${await myContract.methods.data().call()}`);
    const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
    console.log(`Transaction hash: ${receipt.transactionHash}`);
    console.log(`New data value: ${await myContract.methods.data().call()}`);
  }
init1()
