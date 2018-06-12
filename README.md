# Eth-Billboard

Smart Contract that excercises the ERC-20 token library by creating a fixed number of billboard digital asets.  Each billboard is treated as real estate that can be sold, leased, or given away.

## Prequesites

* [Truffle](http://truffleframework.com/)

* [Ganache](http://truffleframework.com/ganache/)

* [Parity](https://www.parity.io/) - (Optional)

* [Parity UI](https://github.com/paritytech/parity-ui/) - (Optional)

## Libraries

### TemplateERC20

Provides a template implementation for ERC20 which can be inherited to implement any token

### SafeMath

Provides safe functions for unsigned int

## Build / Deploy

### Local test

This project was developed using truffle.  You can build and deploy using truffle.

Build

```
truffle compile
```

Migrate
```
truffle migrate --reset
```

### Deploy on testnet

You can deploy on any testnet, but I'd recommend deploying to [Ropsten](https://ropsten.etherscan.io/).  The simplest way to deploy your code using the Parity UI.

* Download [parity](https://www.parity.io/) and [parity-ui](https://github.com/paritytech/parity-ui)

* Run parity with this command: **parity --chain ropsten** (It may take a while to download the chain, if this is your first time)

* Open the Parity UI (click Home, Parity Wallet, ACCOUNTS, Add ACCOUNT) and create a new account and save the details somwehere

* (Optional) if you want to use the sample web-app, you should create a second account as well

* Send ether from the [faucet](http://faucet.ropsten.be:3001/) to your ethereum account (This is required to deploy because it costs gas to deploy)

* Build the source using the instructions above.

* Once built, you should have a folder in the root directory called **build/contracts**.  This contains all the files you need to deploy.

* To deploy, Go to the CONTRACTS screen in the Parity UI (click Home, Parity Wallet, CONTRACTS, DEPLOY)

* Type a name and description for the contract

* For the **abi / solc combined-output** line, open your token contract .json file (e.g. SampleERC20.json) from **build/contracts**, find the **"abi": [...]** line, copy the entire contents of the brackets including the [ ] and paste in to the Parity UI line.

* For the **code** line, in your contract .json file, find the **bytecode** line, copy the long hex string (not including the parentheses) and copy the entire string in to the Parity UI line.

* Click CREATE,

* If deploying the sample Token from the Template ERC you will need to fill out 4 construct parameters: Token Name, Token Symbol, Total Supply, Decimals.  You can use any values but for decimals the recommended number is **18**

* Click Create/Deploy

* It should take a few minutes to deploy the contract and you can always check the status using [Etherscan](https://ropsten.etherscan.io/) and searching for your ethereum address.

### Deploy on main

You can use the above method to also deploy to main, but you need to change the chain from ropsten to main

## Test

There are 2 types of tests for each sample ERC Token: smart contracts and javascript.  I recommend testing using javascript as it much more usable, however a sample test
smart contract has been provided as well.

You can run the unit tests using truffle

```
truffle test
```
