# Introduction

A simple PoC for loan syndication. The scope of this PoC is defined as:

> Loan syndication between a consortium of banks to put the underlying collateral on block-chain to share that information between the consortium to avoid frauds. Leverage the smart contracts to build this prototype.

## Background

Loan syndication is defined at [Investopedia](https://www.investopedia.com/terms/l/loansyndication.asp) as follows:

>Loan syndication is the process of involving a group of lenders to fund various portions of a loan for a single borrower. Loan syndication most often occurs when a borrower requires an amount too large for a single lender to provide or when the loan is outside the scope of a lender's risk exposure levels. Thus, multiple lenders form a syndicate to provide the borrower with the requested capital.

In this PoC, we show how, a given collateral is not pledged multiple times within a consortium of lenders or even across consortia.

## Decentralized consensus

The problem of _consensus_ has the following characteristics:

- Two or more parties.
- Parameter of interest.
- Central custodian of the value of the parameter of interest.
- Consensus _enforced_ by the custodian.

With _decentralized consensus_, the characteristics can be redefined as:

- Two or more parties.
- Parameter of interest.
- Network of peers store the value of parameter of interest.
- Consensus arrived via algorithms executed on nodes of a network.

Therefore, we re-write the scope of PoC in terms of decentralized consensus as follows:

- Parties: banks of a consortium and loan applicant.
- Parameter of interest: collateral identifier.
- Value of parameter of interest: collateral pledged for a loan in the past.
- Consensus: Proof of Authority consensus.

## Solution

This PoC is developed with Ethereum technologies and the various components are called out as follows.

### Infra-structure

For a quick demonstration of the Smart Contract in action, the infra-structure is limited to nodes running on a local laptop. Then, the same infra-structure is migrated to the cloud for a more robust environment.

### Consensus algorithm

The chosen algorithm is Proof of Authority (PoA). With this algorithm ....

### Metamask

A Chrome or a Firefox extension to integrated with decentralized applications from the browser directly. [Metamask](https://metamask.io/)

## Microsoft VS Code

An editor to develop Smart Contracts in Solidity programming language.

### Remix IDE

A browser based Integrated Development Environment (IDE) to deploy contracts in a simulated environment. [Remix](http://remix.ethereum.org)

### Terminal

A terminal prompt to run the Javascript console to browse the blockchain. [Javascript-API](https://github.com/ethereum/wiki/wiki/JavaScript-API)

## Demo walk-through - local

In this demo, we create two folders and run Ethereum client from these folders to indicate two organisations that are required to approve a transaction before they are committed to a block.

The following steps will be explained:

- Set-up and start Ethereum network
- Smart code contract walk-through in VS Code.
- Install Metamask extension.
- Deploy contract with Remix IDE.
- Invoke functions of contract with Remix IDE.
- Show in console various block numbers, transaction hashes appearing in Remix IDE.

## Set-up and start Ethereum network

### Install `ethereum`

- Install `ethereum` on a Mac laptop as follows. Instructions for other operating systems can be found [here](https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum).

```bash
brew tap ethereum/ethereum
brew install ethereum
```

### Initial set-up

We create two folders that serve as two nodes in an Ethereum network.

```bash
mkdir poc
cd poc
mkdir node1
mkdir node2
```

### Create accounts for sealing transactions

Run the following commands to set-up accounts that will be needed to seal the transactions. These commands will prompt for passwords; enter them and make a note of it. These commands will also show the created address; note them and save them for later use.

```bash
geth --datadir node1/ account new
geth --datadir node2/ account new
```

The created account can be seen in the `node1/keystore` and `node2/keystore` folders where the address appears as the suffix in the file name.

We will save the passwords (e.g. `Welc0me`) in a text file to save copy-paste effort later.

```bash
echo 'Welc0me' > node1/passsword.txt
echo 'Welc0me' > node2/passsword.txt
```

### Create genesis file

To create genesis file, we launch the `puppeth` program to help us simplify the process. Follow the prompts below to generate the genesis file `genesis.json`.

```bash
Please specify a network name to administer (no spaces, please)
> poc
What would you like to do? (default = stats)
 1. Show network stats
 2. Configure new genesis
 3. Track new remote server
 4. Deploy network components
> 2

Which consensus engine to use? (default = clique)
 1. Ethash - proof-of-work
 2. Clique - proof-of-authority
> 2

How many seconds should blocks take? (default = 15)
> 10

Which accounts are allowed to seal? (mandatory at least one)
> 0x  _enter address generated for node1_
> 0x  _enter address generated for node2_
> 0x

Specify your chain/network ID if you want an explicit one (default = random)
> 2525

What would you like to do? (default = stats)
 1. Show network stats
 2. Manage existing genesis
 3. Track new remote server
 4. Deploy network components
> 2

1. Modify existing fork rules
 2. Export genesis configuration
> 2

Which file to save the genesis into? (default = devnet.json)
> genesis.json
INFO [01-23|15:16:17] Exported existing genesis block

What would you like to do? (default = stats)
 1. Show network stats
 2. Manage existing genesis
 3. Track new remote server
 4. Deploy network components
> ^C // ctrl+C to quit puppeth
```

### Initialize Ethereum with the genesis file

```bash
geth --datadir node1/ init genesis.json
geth --datadir node2/ init genesis.json
```

### Create a boot node and start

A boot node helps nodes discover other nodes in the network. To start this boot node, first we generate a key with the command as shown below.

```bash
bootnode -genkey boot.key
```

Then, we launch the boot node as follows:

```bash
bootnode -nodekey boot.key -verbosity 9 -addr :30310
```

The verbosity level of `9` helps us see the nodes discover each other. The look-up port for boot node is set to `30310` and will be set-up when launching individual nodes. As a result of running this command, the following output is seen:

```bash
INFO [02-07|22:44:09] UDP listener up                          self=enode://c4a1a1f85f4c0c87e8c17a5e73421a2fe675d9d9d810ef3787b6c5cb4068159873f024c0c88df815c12bd55e28ef5c473f18af7696dd51d9b2af7f172c08063@[::]:30310
```

### Launch nodes

To launch the nodes, we consider the following:

- Reference to boot node as launched in previous step.
- Port number for communication with other nodes.
- RPC port for interaction with Metamask.
- Type of API to be exposed on the RPC port.
- Network identifier that was set with `puppeth`.
- Unlock account, with the password in a specified file and start mining.

Note that, the port numbers are set differently for both nodes as they are running locally on a laptop.

#### Node1

```bash
geth --datadir node1/ --syncmode 'full' --port 30311 --rpc --rpcaddr 'localhost' --rpcport 8501 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --bootnodes 'enode://c4a1a1f85f4c0c87e8c17a5e73421a2fe675d9d9d810ef3787b6c5cb4068159873f024c0c88df815c12bd55e28ef5c473f18af7696dd51d9b2af7f172c08063f@127.0.0.1:30310' --networkid 2525 --gasprice '1' -unlock 'address generated for node1' --password node1/password.txt --mine
```

#### Node2

```bash
geth --datadir node2/ --syncmode 'full' --port 30312 --rpc --rpcaddr 'localhost' --rpcport 8502 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --bootnodes 'enode://c4a1a1f85f4c0c87e8c17a5e73421a2fe675d9d9d810ef3787b6c5cb4068159873f024c0c88df815c12bd55e28ef5c473f18af7696dd51d9b2af7f172c08063f@127.0.0.1:30310' --networkid 2525 --gasprice '1' -unlock 'address generated for node1' --password node2/password.txt --mine
```

## Smart Contract walk-through in VS Code

This section will describe the Smart Contract `loansynd.sol` developed for this PoC.

## Install Metamask extension

- Install Metamask extension for Chrome from [here](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn)
- Install Metamask extension for Firefox from [here](https://addons.mozilla.org/en-US/firefox/addon/ether-metamask/)

Configure Metamask to use the RPC end-point of one of the nodes launched in previous step e.g. `http://localhost:8501`.

## Deploy contract with Remix IDE

- Launch Remix IDE with http://remix.ethereum.org/
- Delete the default contract code file (`ballot.sol` and `ballot_test.sol`) that appears.
- Click on plus icon to add a new contract file `loansynd.sol`.
- Copy-paste the code in the contract file into the IDE.
- On the _Run_ tab, ensure that _Environment_ is set to _Injected Web3_.
- On the _Compile_ tab, click on _Start to compile_ button. There maybe a few warnings; ignore them for now.
- On the _Run_ tab,
  - Note the account number currently visible in the drop-down.
  - Click on _Deploy_ button to deploy the contract to our network.

## Invoke functions of contract with Remix IDE

- Create a new consortium without leader
- Apply new loan with the above consortium and a collateral
- Apply new loan with the above consortium and same collateral
- Create a new consortium with leader
- Apply new loan with the above consortium and same collateral