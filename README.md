![give1](https://user-images.githubusercontent.com/68029274/233708726-c9b939e3-b2ed-4a14-b489-c29a5f675bca.PNG)
![give2](https://user-images.githubusercontent.com/68029274/233708833-6aa00087-c25c-4787-b686-216a9f56cfb4.PNG)
# Celo NFT CROWDFUNDING
This repository contains the celo NTF crowdfuning project which is a web3 project that enables people to create campaigns that different individuals can donate to in the form of an NFT. 

## 1. Tech Stack
This boilerplate uses the following tech stack:
- [React](https://reactjs.org/) - A JavaScript library for building user interfaces.
- [use-Contractkit](contractkit
) - A frontend library for interacting with the Celo blockchain.
- [Hardhat](https://hardhat.org/) - A tool for writing and deploying smart contracts.
- [Bootstrap](https://getbootstrap.com/) - A CSS framework that provides responsive, mobile-first layouts.

## 2. Quick Start

To get this project up running locally, follow these simple steps:

### 2.1 Clone the repository:

```bash
git clone https://github.com/simziky/CELO-NFT-CROWDFUNDING
```

### 2.2 Navigate to the directory:

```bash
cd CELO-NFT-CROWDFUNDING
```

### 2.3 Install the dependencies:

```bash
yarn install
```

### 2.4 Run the dapp:

```bash
yarn start
```

To properly test the dapp you will need to have a Celo wallet with testnet tokens.
This learning module [NFT Contract Development with Hardhat](https://hackmd.io/exuZTH2hTqKytn2vxgDmcg) will walk you through the process of creating a Metamask wallet and claiming Alfajores testnet tokens.


## 3. Smart-Contract Deployment

You can use your own smart contract that the dapp will interact with by following the steps below:

### 3.1 Add a new smart contract
Update the contracts/MyContract.sol file with your solidity code. 

Notice that if you change the contract and file name you will also need to update the deploy script that we will use later.

### 3.2 Compile the smart contract

```bash
npx hardhat compile
```

### 3.3 Run tests on smart contract

```bash
npx hardhat test
```

### 3.4 Update env file

- Create a file in the root directory called ".env"
- Create a key called MNEMONIC and paste in your mnemonic key. e.g

```js
MNEMONIC = "...";
```

In this case, we are using a mnemonic from an account created on Metamask. You can copy it from your Metamask account settings. An account created on the Celo extension wallet will not work.

You can find more details about the whole process in the Dacade [NFT Contract Development with Hardhat](https://hackmd.io/exuZTH2hTqKytn2vxgDmcg) learning module. It will also show you how to get testnet tokens for your account so you can deploy your smart contract in the next step.

### 3.5 Deploy the smart contract to the Celo testnet Aljafores

```bash
npx hardhat run --network alfajores scripts/deploy.js
```

This command will update the src/contract files with the deployed smart contract ABI and contract address.# CELO-NFT-CROWDFUNDING
# CELO-NFT-CROWDFUNDING
