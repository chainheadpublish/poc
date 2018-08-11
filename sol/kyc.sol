pragma solidity ^0.4.21;

contract kyc {
    bytes32[] lenders;

    constructor() public {
        // Lenders of a consortium
        lenders.push("A");
        lenders.push("B");
    }

    struct Loan {
        bytes32 loanId;
        bytes32[] lenders;
        bytes32 customerId;
        bytes32 assetId;
    }

    struct Asset {
        bytes32 assetId;
    }

    mapping (bytes32 => Loan) loans;
    mapping (bytes32 => Asset) assets;

    function newLoan(bytes32 _loanId, bytes32 _customerId, bytes32 _assetId) public payable {
        // Asset pledged
        require(assets[_assetId].assetId != _assetId, "Asset ID pledged.");
        assets[_assetId] = Asset(_assetId);
        loans[_loanId] = Loan(_loanId, lenders, _customerId, _assetId);
    }
}