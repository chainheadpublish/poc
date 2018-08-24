var Web3 = require('web3');
var fs = require('fs');
var path = require('path');
//
var ethereumHttpEndpoint = "http://52.xxx.xxx.xxxx:8545";
var contractHome = "/Users/nsubrahm/GitHub/poc";
var contractName = "loansyndev";
var contractAddress = "0xadd36c62a8fe6f81f53ac8dccbfa1d659d709117";
var pwd = "Welc0me";
//
var ethHttpProvider = new Web3.providers.HttpProvider(ethereumHttpEndpoint);
var web3 = new Web3(ethHttpProvider);
//
var abiFilePath = path.join(contractHome, 'bin', 'sol', contractName) + '.abi';
var abiFile = fs.readFileSync(abiFilePath).toString();
var abiDef = JSON.parse(abiFile);
//
var loansyndContract = web3.eth.contract(abiDef);
var contractInstance = loansyndContract.at(contractAddress);
var consortiumId = "0x3300000000000000000000000000000000000000000000000000000000000000";
var lenders = [
    "0x4200000000000000000000000000000000000000000000000000000000000000",
    "0x4300000000000000000000000000000000000000000000000000000000000000",
    "0x4400000000000000000000000000000000000000000000000000000000000000"
];
var leaderId = "0x4500000000000000000000000000000000000000000000000000000000000000";
//
web3.eth.getAccounts(
    function(err,res) {
        if (err) {
            console.log('Could not get accounts');
        } else {
            var accountAddr = res[0];
            web3.personal.unlockAccount(accountAddr, pwd, 600, (err,res) => {
                if (err) {
                    console.log("Unlock account error");
                    console.log(err);
                } else {
                    console.log("Account unlocked");
                    contractInstance.newConsortium.sendTransaction(consortiumId, lenders, null,{from:accountAddr, gas:900000},
                        function (err,res) {
                            if (err) {
                                console.log(err);
                            } else {
                                console.log(res);
                            }
                        }                    
                    );
                }
            })            
        }
    }
);
