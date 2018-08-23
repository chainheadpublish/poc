pragma solidity ^0.4.24;

contract loansyndev {
    // Address of contract deployer
    address owner = msg.sender;
    // String identifier for a default consortium dealer
    bytes32 constant LEADER = "LEADER";

    // To be fired when inputs are not valid
    event Status (
        string msg
    );

    // Error messages
    string constant ERRMSG001 = "Only contract owner can call this function.";
    string constant ERRMSG002 = "Consortium ID exists.";
    string constant ERRMSG003 = "Consortium ID does not exist.";
    string constant ERRMSG004 = "Sender is not consortium leader.";
    string constant ERRMSG005 = "Loan ID exists.";
    string constant ERRMSG006 = "Collateral ID already pledged.";

    // A consortium with a leader and its members as lenders
    struct Consortium {
        bytes32 consortiumId;
        bytes32[] lenders;
        bytes32 leaderId;
        address consortiumLeader;
    }

    // A collateral against which a collateral is sought
    struct Collateral {
        bytes32 collateralId;
    }

    // A loan from a consortium to a customer against a collateral
    struct Loan {
        bytes32 consortiumId;
        bytes32 loanId;
        bytes32 customerId;
        bytes32 collateralId;
    }

    modifier ownerOnly {
        require (msg.sender == owner, ERRMSG001);
        _;
    }

    // All consortiums
    mapping (bytes32 => Consortium) consortiums;
    // All loans
    mapping (bytes32 => Loan) loans;
    // All collaterals
    mapping (bytes32 => Collateral) collaterals;

    // Create a new consortium of lenders with owner as leader.
    // This function can be invoked by the contract owner only; therefore, the leader ID defaults to the constant LEADER;
    function newConsortium(bytes32 _consortiumId, bytes32[] _lenders) public ownerOnly payable {
        if (consortiums[_consortiumId].consortiumId == _consortiumId) {
            emit Status(ERRMSG002);
            return;
        }
        consortiums[_consortiumId] = Consortium(_consortiumId, _lenders, LEADER, owner);
        consortiums[_consortiumId].lenders.push(LEADER);
    }

    // Create a new consortium of lenders with assigned leader.
    // This function can be invoked by anyone and therefore, requires the leaderId to be specified explicitly.
    function newConsortium(bytes32 _consortiumId, bytes32[] _lenders, bytes32 _leaderId) public payable {
        if (consortiums[_consortiumId].consortiumId == _consortiumId) {
            emit Status(ERRMSG002);
            return;
        }
        //require (consortiums[_consortiumId].consortiumId != _consortiumId, ERRMSG002);
        consortiums[_consortiumId] = Consortium(_consortiumId, _lenders, _leaderId, msg.sender);
    }

    // Return members of consortium
    function consortiumMembers(bytes32 _consortiumId) public view returns (bytes32[]) {
        // Does consortium exist?
        require (consortiums[_consortiumId].consortiumId == _consortiumId, ERRMSG003);
        // Yes; get members of consortium and return.
        bytes32[] storage members = consortiums[_consortiumId].lenders;
        return members;
    }

    // Return consortium leader
    function consortiumLeader(bytes32 _consortiumId) public view returns (bytes32) {
        // Consortium exists?
        require (consortiums[_consortiumId].consortiumId == _consortiumId, ERRMSG003);
        // Yes; get leader of consortium
        bytes32 leaderId = consortiums[_consortiumId].leaderId;
        return leaderId;
    }

    // Add new loan if collateral not already pledged.
    function newLoan(bytes32 _consortiumId, bytes32 _loanId, bytes32 _customerId, bytes32 _collateralId) public payable {
        // Consortium exists?
        if (consortiums[_consortiumId].consortiumId != _consortiumId) {
            emit Status(ERRMSG003);
            return;
        }
        // Consortium leader same as message sender?
        if (consortiums[_consortiumId].consortiumLeader != msg.sender) {
            emit Status(ERRMSG004);
            return;
        }
        // Loan ID does not exist?
        if (loans[_loanId].loanId == _loanId) {
            emit Status(ERRMSG005);
            return;
        }
        // Collateral not pledged?
        if (collaterals[_collateralId].collateralId == _collateralId) {
            emit Status(ERRMSG006);
            return;
        }
        // Add new loan
        loans[_loanId] = Loan(_consortiumId, _loanId, _customerId, _collateralId);
        // Add new collateral
        collaterals[_collateralId] = Collateral(_collateralId);
    }
}