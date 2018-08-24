var Web3 = require('web3');
var fs = require('fs');
var path = require('path');
//
var ethereumHttpEndpoint = "http://52.xxx.xxx.xxxx:8545";
var accountAddr = "0xb16ee696fcc86065fdc05a36da77d67fca2df1b2";
var pwd = "Welc0me";
//
var contractHome = "/Users/nsubrahm/GitHub/poc";
var contractName = "loansyndev";
//
var abiFilePath = path.join(contractHome, 'bin', 'sol', contractName) + '.abi';
var bytecodeFilePath = path.join(contractHome, 'bin', 'sol', contractName) + '.bin';
//
var ethHttpProvider = new Web3.providers.HttpProvider(ethereumHttpEndpoint);
var web3 = new Web3(ethHttpProvider);
//
var abiFile = fs.readFileSync(abiFilePath).toString();
var abiDef = JSON.parse(abiFile);
var byteCode = fs.readFileSync(bytecodeFilePath).toString();
//
web3.personal.unlockAccount(accountAddr, pwd, 600, (err,res) => {
    if (err) {
        console.log("Unlock account error");
        console.log(err);
    } else {
        console.log("Account unlocked");
    }
});
//
var loansyndContract = web3.eth.contract(abiDef);
byteCode = "0x" + byteCode;
var deployedContract = loansyndContract.new({
    data: byteCode,
    from: accountAddr,
    gas: 900000
},
(err, res) => {
    if (err) {
        console.log(err);
        return;
    } else {
        console.log("Transaction hash : " + res.transactionHash);
        console.log("Contract address : " + res.address);
    }
}
);
