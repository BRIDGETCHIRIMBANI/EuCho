// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/EuCho.sol";

contract EuChoTest is Test {
    EuCho public euCho;

    function setUp() public {
        euCho = new EuCho();
    }

    function testSubmitSymptoms() public {
        euCho.submitSymptoms("fever, diarrhea");
        EuCho.SymptomEntry memory entry = euCho.symptomEntries(0);
        assertEq(entry.user, address(this));
        assertEq(entry.symptoms, "fever, diarrhea");
    }

    function testAddAuthorizedPersonnel() public {
        address newAdmin = address(0x123);
        euCho.addAuthorizedPersonnel(newAdmin);
        assertTrue(euCho.authorizedPersonnel(newAdmin));
    }

    function testTriggerAlert() public {
        // Add logic for testing alert triggering
    }
}
