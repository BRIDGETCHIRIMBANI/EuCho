// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EuCho {
    address public admin;

    struct SymptomEntry {
        address user;
        string symptoms;
        uint256 timestamp;
    }

    SymptomEntry[] public symptomEntries;
    mapping(address => bool) public authorizedPersonnel;

    event SymptomsSubmitted(address indexed user, string symptoms, uint256 timestamp);
    event AuthorizedPersonnelAdded(address indexed account);
    event AuthorizedPersonnelRemoved(address indexed account);
    event AlertTriggered(address indexed user, string message);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedPersonnel[msg.sender], "You are not authorized to perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addAuthorizedPersonnel(address account) public onlyAdmin {
        authorizedPersonnel[account] = true;
        emit AuthorizedPersonnelAdded(account);
    }

    function removeAuthorizedPersonnel(address account) public onlyAdmin {
        authorizedPersonnel[account] = false;
        emit AuthorizedPersonnelRemoved(account);
    }

    function submitSymptoms(string memory symptoms) public {
        symptomEntries.push(SymptomEntry({
            user: msg.sender,
            symptoms: symptoms,
            timestamp: block.timestamp
        }));
        emit SymptomsSubmitted(msg.sender, symptoms, block.timestamp);

        // Check ML model prediction off-chain and trigger alert if necessary
        bool mlPrediction = checkMLPrediction(symptoms); // Placeholder for ML prediction
        if (mlPrediction) {
            triggerAlert(msg.sender, "You might be at risk of cholera, please visit a nearby clinic for assistance");
        }
    }

    function getSymptoms(uint256 index) public view onlyAuthorized returns (SymptomEntry memory) {
        return symptomEntries[index];
    }

    function getSymptomsCount() public view onlyAuthorized returns (uint256) {
        return symptomEntries.length;
    }

    function triggerAlert(address user, string memory message) internal {
        emit AlertTriggered(user, message);
    }

    // Placeholder for ML prediction function
    function checkMLPrediction(string memory symptoms) internal pure returns (bool) {
        // Implement your ML model check here
        // For now, let's assume it always returns true
        return true;
    }
}