pragma solidity ^0.4.21;

contract loansynd {
    address owner = msg.sender;
    bytes32 constant LEADER = "LEADER";

    struct Consortium {
        bytes32 consortiumId;
        bytes32[] lenders;
        bytes32 leaderId;
        address consortiumLeader;
    }

    struct Loan {
        bytes32 consortiumId;
        bytes32 loanId;
        bytes32 customerId;
        bytes32 collateralId;
    }

    struct Collateral {
        bytes32 collateralId;
    }

    modifier ownerOnly {
        require (msg.sender == owner, "Only owner can call this function.");
        _;
    }

    // All consortiums
    mapping (bytes32 => Consortium) consortiums;
    // All loans
    mapping (bytes32 => Loan) loans;
    // All collaterals
    mapping (bytes32 => Collateral) collaterals;

    // Create a new consortium of lenders with owner as leader.
    // NOTE: the leader ID is assumed to be in the array of lenders
    function newConsortium(bytes32 _consortiumId, bytes32[] _lenders) public ownerOnly payable {
        require (consortiums[_consortiumId].consortiumId != _consortiumId, "Consortium ID already exists.");
        consortiums[_consortiumId].consortiumId = _consortiumId;
        consortiums[_consortiumId].lenders = _lenders;
        consortiums[_consortiumId].lenders.push(LEADER);
        consortiums[_consortiumId].leaderId = LEADER;
        consortiums[_consortiumId].consortiumLeader = owner;
    }

    // Create a new consortium of lenders with assigned leader.
    // NOTE: the leader ID is assumed to be in the array of lenders
    function newConsortium(bytes32 _consortiumId, bytes32[] _lenders, bytes32 _leaderId) public payable {
        require (consortiums[_consortiumId].consortiumId != _consortiumId, "Consortium ID already exists.");
        consortiums[_consortiumId].consortiumId = _consortiumId;
        consortiums[_consortiumId].lenders = _lenders;
        consortiums[_consortiumId].leaderId = _leaderId;
        consortiums[_consortiumId].consortiumLeader = msg.sender;
    }

    // Return members of consortium
    function consortiumMembers(bytes32 _consortiumId) public view returns (bytes32[]) {
        require (consortiums[_consortiumId].consortiumId == _consortiumId, "Consortium ID does not exist.");
        bytes32[] storage members = consortiums[_consortiumId].lenders;
        return members;
    }

    // Return consortium leader
    function consortiumLeader(bytes32 _consortiumId) public view returns (bytes32) {
        require (consortiums[_consortiumId].consortiumId == _consortiumId, "Consortium ID does not exist.");
        bytes32 leaderId = consortiums[_consortiumId].leaderId;
        return leaderId;
    }

    // Add new loan if collateral not already pledged.
    function newLoan(bytes32 _consortiumId, bytes32 _loanId, bytes32 _customerId, bytes32 _collateralId) public payable {
        require (consortiums[_consortiumId].consortiumId == _consortiumId, "Consortium ID does not exist.");
        require (consortiums[_consortiumId].consortiumLeader == msg.sender, "Sender is not consortium leader");
        require (loans[_loanId].loanId != _loanId, "Loan ID already exists.");
        require (collaterals[_collateralId].collateralId != _collateralId, "Collateral already pledged.");
        //
        loans[_loanId] = Loan(_consortiumId, _loanId, _customerId, _collateralId);
        collaterals[_collateralId] = Collateral(_collateralId);
    }
}